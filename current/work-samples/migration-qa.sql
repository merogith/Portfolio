-- SQLite. Every source row must have exactly one mutually exclusive outcome.
-- Holds are excluded from staging and must not reach reporting.
WITH checks AS (
 SELECT
   (SELECT COUNT(*) FROM source) AS submitted,
   (SELECT COUNT(*) FROM source WHERE disposition = 'staged') AS staged_outcomes,
   (SELECT COUNT(*) FROM staging) AS staged_rows,
   (SELECT COUNT(*) FROM source WHERE disposition = 'duplicate_hold') AS duplicate_hold,
   (SELECT COUNT(*) FROM source WHERE disposition = 'unmatched_hold') AS unmatched_hold,
   (SELECT COUNT(*) FROM staging t JOIN source s USING(source_id)
     WHERE s.consent IS NOT t.consent OR s.consent IS NULL
       OR s.consent NOT IN ('granted', 'denied')) AS consent_mismatches,
   (SELECT COUNT(*) FROM staging t LEFT JOIN mapping m USING(source_id)
     WHERE m.target_id IS NULL OR m.target_id IS NOT t.target_id) AS mapping_mismatches,
   (SELECT COUNT(*) FROM staging t LEFT JOIN source s USING(source_id)
     WHERE s.source_id IS NULL OR s.disposition <> 'staged') AS ineligible_staged,
   (SELECT COUNT(*) FROM source s LEFT JOIN staging t USING(source_id)
     WHERE s.disposition = 'staged' AND t.source_id IS NULL) AS missing_staged
)
SELECT *,
  submitted - staged_rows - duplicate_hold - unmatched_hold AS reconciliation_delta,
  CASE WHEN submitted = staged_rows + duplicate_hold + unmatched_hold
    AND staged_outcomes = staged_rows AND consent_mismatches = 0
    AND mapping_mismatches = 0 AND ineligible_staged = 0 AND missing_staged = 0
  THEN 'PASS: staged rows only; holds stay excluded'
  ELSE 'BLOCK: do not release staging to reporting' END AS release_gate
FROM checks;
