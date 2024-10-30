SELECT
    e.id_employe,
    e.employe,
    ROUND(SUM(p.prix),2) AS 'CA'
FROM
    employe e
JOIN
     vente v ON  e.id_employe = v.id_employe
JOIN
    produit p ON v.ean = p.ean
GROUP BY
    e.id_employe
ORDER BY
    CA DESC
LIMIT 20;