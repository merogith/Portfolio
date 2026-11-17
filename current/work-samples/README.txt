SYNTHETIC ANALYTICS EXHIBITS — Meric Erler

These are compact, fictional fixtures that reproduce the numbers on the portfolio
work-samples page. They are not employer data, historical results or evidence of
an experiment's uplift. No network, account or external package is needed.

Unzip this folder, open a terminal there and run:
  python3 reproduce.py
On Windows with Python installed, use:
  py reproduce.py

Python uses standard-library sqlite3 to expand compact cohort/batch CSV files
into individual rows in an in-memory database, then runs the included SQL.
Files are resolved relative to the script, so it also runs from another folder.

FUNNEL
Snapshot: 2026-01-15 00:00 UTC. Only signups observed for at least seven days
enter the denominator. Each next stage must be at or after the prior stage and
strictly before signup + seven days. Repeated events count once. The fixture
includes seven immature signups, repeated profiles, late events, and bookings
before profile completion so you can inspect the exclusions.
Expected: 2,000 signups; 1,340 profiles; 820 bookings; 620 completions.
This is descriptive funnel logic, not an experiment result.

CRM QA
Expected: 12,400 source rows = 12,180 staged + 150 duplicate holds + 70 unmatched
holds. Reconciliation alone passes despite twelve deliberately wrong target-ID
mappings and consent values. The release gate blocks these staged rows.
The script then applies a controlled, in-memory correction from source records
and reruns the same gate: zero mismatches; 220 held rows remain excluded.
Primary/unique keys enforce one source row and at most one staging outcome;
the SQL also checks eligibility, missing rows and reconciliation. In real work,
a correction requires agreed ownership and source-of-truth verification.

The script asserts all displayed expected totals and exits with a traceback if
one changes. The printed before/after gate is the reproducible output. Editing
fixtures intentionally requires updating those expectations when appropriate.
