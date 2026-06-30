SELECT
  provider,
  model,
  AVG(latency_ms) AS avg_latency_ms,
  MAX(latency_ms) AS max_latency_ms,
  MIN(latency_ms) AS min_latency_ms
FROM `${project_id}.${dataset_id}.ai_usage`
GROUP BY provider, model
ORDER BY avg_latency_ms DESC;