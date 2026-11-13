SELECT
    s.s_suppkey                             AS supplier_key,
    s.s_name                                AS supplier_name,
    s.s_nationkey                           AS nation_key,
    s.s_acctbal                             AS account_balance,
    COUNT(DISTINCT l.l_orderkey)            AS total_orders,
    COUNT(l.l_linenumber)                   AS total_line_items,
    COALESCE(SUM(l.l_quantity), 0)          AS total_quantity,
    COALESCE(SUM(l.l_extendedprice * (1 - l.l_discount)), 0) AS total_revenue,
    AVG(l.l_discount)                       AS avg_discount
FROM {{ source('tpch', 'supplier') }} s
LEFT JOIN {{ source('tpch', 'lineitem') }} l ON s.s_suppkey = l.l_suppkey
GROUP BY 1, 2, 3, 4
