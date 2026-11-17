#!/usr/bin/env python3
"""Reproduce synthetic portfolio exhibits with only Python's standard library.
Run: python3 reproduce.py  (files are read relative to this script).
No network, credentials, real customer data, or persistent database required.
"""
import csv
import json
import sqlite3
from datetime import datetime, timedelta
from pathlib import Path

HERE = Path(__file__).resolve().parent


def read_csv(name):
    with (HERE / name).open(newline='', encoding='utf-8') as handle:
        return list(csv.DictReader(handle))


def query(db, name):
    return dict(db.execute((HERE / name).read_text(encoding='utf-8')).fetchone())


def funnel():
    db = sqlite3.connect(':memory:')
    db.row_factory = sqlite3.Row
    db.executescript('CREATE TABLE users(user_id TEXT PRIMARY KEY, signup_at TEXT);'
                     'CREATE TABLE events(user_id TEXT, event TEXT, event_at TEXT);')
    for group in read_csv('funnel-cohorts.csv'):
        signup = datetime.fromisoformat(group['signup_at'])
        for index in range(int(group['users'])):
            user_id = f"{group['cohort']}-{index}"
            db.execute('INSERT INTO users VALUES (?,?)', (user_id, str(signup)))
            for event, column in [('profile', 'profile_hours'), ('booking', 'booking_hours'), ('completion', 'completion_hours')]:
                if group[column]:
                    at = str(signup + timedelta(hours=int(group[column])))
                    db.execute('INSERT INTO events VALUES (?,?,?)', (user_id, event, at))
                    if event == 'profile' and group['repeat_profile'] == '1':
                        db.execute('INSERT INTO events VALUES (?,?,?)', (user_id, event, at))
    result = query(db, 'funnel.sql')
    assert list(result.values()) == [2000, 1340, 820, 620], result
    # Seven immature signups, repeated profiles, late events and out-of-order
    # bookings are deliberately present; they must not inflate the funnel.
    assert db.execute('SELECT COUNT(*) FROM users').fetchone()[0] == 2007
    db.close()
    return result


def migration():
    db = sqlite3.connect(':memory:')
    db.row_factory = sqlite3.Row
    db.executescript('CREATE TABLE source(source_id TEXT PRIMARY KEY, disposition TEXT, consent TEXT);'
                    'CREATE TABLE mapping(source_id TEXT PRIMARY KEY, target_id TEXT UNIQUE);'
                    'CREATE TABLE staging(source_id TEXT PRIMARY KEY, target_id TEXT UNIQUE, consent TEXT);')
    for group in read_csv('crm-batch.csv'):
        for index in range(int(group['rows'])):
            source_id = f"{group['group']}-{index}"
            target_id = f"target-{source_id}"
            db.execute('INSERT INTO source VALUES (?,?,?)', (source_id, group['disposition'], group['source_consent']))
            if group['disposition'] == 'staged':
                db.execute('INSERT INTO mapping VALUES (?,?)', (source_id, target_id))
                staged_target = f'wrong-{source_id}' if group['wrong_target'] == '1' else target_id
                db.execute('INSERT INTO staging VALUES (?,?,?)', (source_id, staged_target, group['staged_consent']))
    before = query(db, 'migration-qa.sql')
    assert [before[k] for k in ['submitted', 'staged_rows', 'duplicate_hold', 'unmatched_hold']] == [12400, 12180, 150, 70]
    assert before['reconciliation_delta'] == 0
    assert before['consent_mismatches'] == before['mapping_mismatches'] == 12
    assert before['release_gate'].startswith('BLOCK')
    # Null/missing fields must fail too; SQL NULL comparisons cannot silently
    # turn an unknown consent or target into a successful release check.
    db.execute('SAVEPOINT edge_checks')
    db.execute("UPDATE staging SET consent = NULL, target_id = NULL WHERE source_id = 'clean_staging-0'")
    missing = query(db, 'migration-qa.sql')
    assert missing['consent_mismatches'] == missing['mapping_mismatches'] == 13
    assert missing['release_gate'].startswith('BLOCK')
    db.execute('ROLLBACK TO edge_checks')
    db.execute('RELEASE edge_checks')
    # Controlled demo correction: rebuild mapped values from source-of-truth
    # records, then rerun the same gate. This is not permission to release real data.
    db.execute('UPDATE staging SET target_id = (SELECT target_id FROM mapping m WHERE m.source_id=staging.source_id), '
               'consent = (SELECT consent FROM source s WHERE s.source_id=staging.source_id)')
    after = query(db, 'migration-qa.sql')
    assert after['consent_mismatches'] == after['mapping_mismatches'] == 0
    assert after['release_gate'].startswith('PASS')
    assert after['duplicate_hold'] + after['unmatched_hold'] == 220
    db.close()
    return {'before_correction': before, 'after_demo_correction': after}


if __name__ == '__main__':
    print(json.dumps({'synthetic_example': True, 'funnel': funnel(), 'crm_qa': migration()}, indent=2))
