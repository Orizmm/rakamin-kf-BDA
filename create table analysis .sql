CREATE OR REPLACE TABLE `kfanalytics1.kimia_farma.kf_analysis` AS
WITH gross_laba AS (
  SELECT 
    product_id,
    price,
    CASE
      WHEN price <= 50000 THEN 0.10
      WHEN price > 50000 AND price <= 100000 THEN 0.15
      WHEN price > 100000 AND price <= 300000 THEN 0.20
      WHEN price > 300000 AND price <= 500000 THEN 0.25
      WHEN price > 500000 THEN 0.30
    END AS persentase_gross_laba
  FROM `kfanalytics1.kimia_farma.kf_product`
)
SELECT 
  ft.transaction_id,
  ft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating as rating_cabang,
  ft.customer_name,
  p.product_id,
  p.product_name,
  ft.price  as actual_price,
  ft.discount_percentage,
  gl.persentase_gross_laba,
  ft.price * (1 - ft.discount_percentage) as nett_sales,
  ft.price * (1 - ft.discount_percentage) * gl.persentase_gross_laba as nett_profit,
  ft.rating as rating_transaksi
FROM `kfanalytics1.kimia_farma.kf_final_transaction` ft
LEFT JOIN `kfanalytics1.kimia_farma.kf_kantor_cabang` kc
  ON ft.branch_id = kc.branch_id
LEFT JOIN `kfanalytics1.kimia_farma.kf_product` p
  ON ft.product_id = p.product_id
LEFT JOIN gross_laba gl
  ON ft.product_id = gl.product_id
ORDER BY nett_profit ASC;