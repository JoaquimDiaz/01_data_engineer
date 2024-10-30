SELECT
    ROUND(SUM(p.prix),2) AS ca_total
FROM
    vente v
JOIN
    produit p ON v.ean = p.ean
JOIN
    logs l ON v.id_bdd = l.id_ligne 
    AND champs = 'ID ticket' 
    AND l.date = '2024-08-15';