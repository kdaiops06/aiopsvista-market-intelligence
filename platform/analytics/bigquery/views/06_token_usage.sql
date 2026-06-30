SELECT
  DATE(event_timestamp) AS usage_date,
  SUM(input_tokens) AS input_tokens,
  SUM(output_tokens) AS output_tokens,
  SUM(total_tokens) AS total_tokens
FROM `${project_id}.${dataset_id}.ai_usage`
GROUP BY usage_date
ORDER BY usage_date DESC;