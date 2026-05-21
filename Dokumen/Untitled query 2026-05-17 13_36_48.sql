-- Membuat tabel ringkasan transaksi customer
CREATE OR REPLACE TABLE `rakaminkfanalytics-496209.PerformanceAnalytics.customer_transaction_summary` AS

SELECT
    customer_name,

    -- Total transaksi masing-masing customer
    COUNT(transaction_id) AS transaction_per_customer

FROM `rakaminkfanalytics-496209.PerformanceAnalytics.analysis_table`

GROUP BY customer_name

-- Mengurutkan dari transaksi terbanyak
ORDER BY transaction_per_customer DESC