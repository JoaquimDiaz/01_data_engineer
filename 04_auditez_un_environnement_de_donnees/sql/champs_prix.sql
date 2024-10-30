SELECT
    ROUND(SUM(p.prix), 2) AS total_ca
FROM
    vente v
JOIN
    produit p ON v.ean = p.ean
JOIN
    logs l ON v.ean = l.id_ligne AND l.champs = 'prix';
