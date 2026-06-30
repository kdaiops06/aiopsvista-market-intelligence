SELECT
  status,
  COUNT(*) AS total_requests
FROM `${project_id}.${dataset_id}.ai_usage`
WHERE status <> 'success'
GROUP BY status
ORDER BY total_requests DESC;