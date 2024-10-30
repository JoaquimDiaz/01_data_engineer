SELECT
    v.customer_id AS 'client',
    ROUND(SUM(p.prix),2) AS 'CA'
FROM
    vente v
JOIN
    produit p ON v.ean = p.ean
GROUP BY
    client
ORDER BY
    CA DESC
LIMIT 10;