create or replace table `rakamin-kf-analytics-503411.kimia_farma.analysis_table` as

select
  ft.transaction_id,
  ft.date,
  extract (year from ft.date) as year,

  ft.branch_id,
  kc.branch_name,
  kc.branch_category,
  kc.kota,
  kc.provinsi,

  ft.product_id,
  p.product_name,
  p.product_category,

  ft.customer_name,

  ft.price,
  ft.discount_percentage,

  -- Net Sales
  (ft.price - (ft.price * ft.discount_percentage)) as nett_sales,

  -- Persentase Gross Profit
  case
    when ft.price <= 50000 then 0.10
    when ft.price > 50000 and ft.price <= 100000 then 0.15
    when ft.price > 100000 and ft.price <= 300000 then 0.20
    when ft.price > 300000 and ft.price <= 500000 then 0.25
    when ft.price > 500000 then 0.30
  end as persentase_gross_laba,

  -- Net Profit
  (
    (ft.price - (ft.price * ft.discount_percentage))
    *
    case
    when ft.price <= 50000 then 0.10
    when ft.price > 50000 and ft.price <= 100000 then 0.15
    when ft.price > 100000 and ft.price <= 300000 then 0.20
    when ft.price > 300000 and ft.price <= 500000 then 0.25
    when ft.price > 500000 then 0.30
    end
  ) as nett_profit,

  ft.rating as rating_transaksi,
  kc.rating as rating_cabang,

  inv.opname_stock

from
`rakamin-kf-analytics-503411.kimia_farma.final transaction` ft

left join
`rakamin-kf-analytics-503411.kimia_farma.kantor cabang` kc
on ft.branch_id = kc.branch_id

left join
`rakamin-kf-analytics-503411.kimia_farma.product` p
on ft.product_id = p.product_id

left join
`rakamin-kf-analytics-503411.kimia_farma.inventory` inv
on ft.branch_id = inv.branch_id
and ft.product_id = inv.product_id;
