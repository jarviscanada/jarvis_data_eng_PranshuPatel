-- Show table schema 
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'retail'
ORDER BY ordinal_position;

-- Q1: Show first 10 rows

SELECT * FROM retail r 
LIMIT 10;

-- Q2: Check # of records

SELECT COUNT(*) from retail r 

-- Q3: number of clients (e.g. unique client ID)

SELECT 
COUNT(DISTINCT r.customer_id)
FROM retail r 
WHERE r.customer_id IS NOT NULL;

--Q4: invoice date range (e.g. max/min dates)

SELECT MAX(r.invoice_date) as Max, MIN(r.invoice_date) as Min
FROM retail r;

--Q5: number of SKU/merchants (e.g. unique stock code)

SELECT 
COUNT(DISTINCT r.stock_code)
FROM retail r 
WHERE r.stock_code is not null;

-- Q6: Average invoice amount excluding negative invoices

SELECT
  AVG(invoice_total) AS avg
FROM (
  SELECT
    invoice_no,
    SUM(quantity * unit_price) AS invoice_total
  FROM retail r 
  GROUP BY invoice_no
  HAVING SUM(quantity * unit_price) > 0
) invoice_totals;

-- Q7: Calculate total revenue
SELECT
  SUM(unit_price * quantity) AS sum
FROM public.retail;

-- Q8: Total revenue by YYYYMM
SELECT
  (EXTRACT(YEAR FROM invoice_date)::int * 100
   + EXTRACT(MONTH FROM invoice_date)::int) AS yyyymm,
  SUM(unit_price * quantity) AS sum
FROM public.retail
GROUP BY yyyymm
ORDER BY yyyymm;














