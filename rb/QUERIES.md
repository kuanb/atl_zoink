# Queries

```` sql
-- what is the status of data transformation processes?
SELECT
  count(DISTINCT id) AS file_count
  ,count(DISTINCT CASE WHEN parsed = TRUE THEN id END) AS parsed_file_count

  ,round(
    count(DISTINCT CASE WHEN parsed = TRUE THEN id END)
    * 1.00 -- hack for pg decimal division
    / count(DISTINCT id)
  ,4) AS file_parsing_progress

  ,sum(row_count) AS row_count
  ,sum(CASE WHEN parsed = TRUE THEN row_count ELSE 0 END) AS parsed_row_count

  ,round(
    sum(CASE WHEN parsed = TRUE THEN row_count ELSE 0 END)
    * 1.00 -- hack for pg decimal division
    / sum(row_count)
  ,4) AS row_parsing_progress
FROM atlanta_data_files;
````

=>

file_count | parsed_file_count | file_parsing_progress | row_count | parsed_row_count | row_parsing_progress
--- | --- | --- | --- | --- | ---
193 | 54 | 0.2798 | 7083498 | 2217136 | 0.313

```` sql
-- which violations have been cited the most?
SELECT
  v.id
  ,v.guid
  ,v.description
  ,count(DISTINCT c.id) AS citation_count
FROM violations v
JOIN citations c ON c.violation_id = v.id
GROUP BY 1,2,3
ORDER BY citation_count DESC
LIMIT 50;
````

=> ?
