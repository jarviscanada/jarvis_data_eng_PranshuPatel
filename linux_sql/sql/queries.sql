-- queries.sql
-- Solutions for SQL practice tasks

-- ------------------------------------------------------------
-- Helper: round timestamp down to nearest 5-minute bucket
-- (keeps the bucket start time like 15:00, 15:05, 15:10 ...)
-- ------------------------------------------------------------

\c host_agent

CREATE OR REPLACE FUNCTION public.round5(ts timestamp)
RETURNS timestamp AS $$
BEGIN
  RETURN date_trunc('hour', ts)
         + (date_part('minute', ts)::int / 5) * interval '5 min';
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 1) Group hosts by hardware info
--    Group by cpu_number and sort by total_mem desc within each group
-- Output: cpu_number, host_id, total_mem
-- ============================================================
SELECT
  cpu_number,
  id AS host_id,
  total_mem
FROM public.host_info
ORDER BY cpu_number, total_mem DESC;

-- (Optional window-function version if you want ranking inside each cpu group)
-- SELECT cpu_number, id AS host_id, total_mem,
--        row_number() OVER (PARTITION BY cpu_number ORDER BY total_mem DESC) AS mem_rank
-- FROM public.host_info
-- ORDER BY cpu_number, mem_rank;


-- ============================================================
-- 2) Average memory usage
--    Avg used memory % over 5-min interval for each host
--    used_mem% = (total_mem - memory_free) / total_mem * 100
-- Output: host_id, hostname, timestamp, avg_used_mem_percentage
-- ============================================================
SELECT
  hu.host_id,
  hi.hostname,
  public.round5(hu."timestamp") AS "timestamp",
  ROUND(AVG( ( (hi.total_mem - hu.memory_free)::numeric / hi.total_mem ) * 100 ), 2)
    AS avg_used_mem_percentage
FROM public.host_usage hu
JOIN public.host_info hi
  ON hu.host_id = hi.id
GROUP BY
  hu.host_id,
  hi.hostname,
  public.round5(hu."timestamp")
ORDER BY
  hu.host_id,
  "timestamp";


-- ============================================================
-- 3) Detect host failure
--    Failure rule: less than 3 data points within any 5-min interval
-- Output example: host_id, ts, num_data_points (and hostname is useful)
-- ============================================================
SELECT
  hu.host_id,
  hi.hostname,
  public.round5(hu."timestamp") AS ts,
  COUNT(*) AS num_data_points
FROM public.host_usage hu
JOIN public.host_info hi
  ON hu.host_id = hi.id
GROUP BY
  hu.host_id,
  hi.hostname,
  public.round5(hu."timestamp")
HAVING COUNT(*) < 3
ORDER BY
  hu.host_id,
  ts;

