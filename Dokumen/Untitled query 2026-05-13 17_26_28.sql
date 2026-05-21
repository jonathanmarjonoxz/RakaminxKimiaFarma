-- Membuat tabel analisis Kimia Farma
CREATE OR REPLACE TABLE `rakaminkfanalytics-496209.PerformanceAnalytics.analysis_table` AS

-- ==========================================
-- Keterangan Alias Tabel
-- ft : kf_final_transaction
-- p  : kf_product
-- kc : kf_kantor_cabang
-- ==========================================

-- CTE
WITH base_table AS (
    SELECT
        ft.transaction_id,
        ft.date,
        ft.branch_id,
        kc.branch_name,
        kc.kota,
        kc.provinsi,
        kc.rating AS rating_cabang,
        ft.customer_name,
        ft.product_id,
        p.product_name,
        ft.price AS actual_price,
        ft.discount_percentage,

        -- Menentukan persentase gross laba berdasarkan harga obat
        CASE
            WHEN ft.price <= 50000 THEN 0.10
            WHEN ft.price <= 100000 THEN 0.15
            WHEN ft.price <= 300000 THEN 0.20
            WHEN ft.price <= 500000 THEN 0.25
            ELSE 0.30
        END AS persentase_gross_laba,

        ft.rating AS rating_transaksi

    FROM `rakaminkfanalytics-496209.PerformanceAnalytics.kf_final_transaction` ft

    LEFT JOIN `rakaminkfanalytics-496209.PerformanceAnalytics.kf_product` p
        ON ft.product_id = p.product_id

    LEFT JOIN `rakaminkfanalytics-496209.PerformanceAnalytics.kf_kantor_cabang` kc
        ON ft.branch_id = kc.branch_id
)

-- Membentuk tabel analisis akhir
SELECT
    * EXCEPT(rating_transaksi),

    -- Perhitungan harga setelah diskon
    actual_price - (actual_price * discount_percentage) AS nett_sales,

    -- Perhitungan keuntungan bersih Kimia Farma
    (actual_price - (actual_price * discount_percentage))
    * persentase_gross_laba AS nett_profit,

    -- Rating transaksi diletakkan di kolom terakhir
    rating_transaksi

FROM base_table;