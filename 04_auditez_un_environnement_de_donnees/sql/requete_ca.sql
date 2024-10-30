SELECT 
    v.date_achat,
    ROUND(SUM(p.prix),2) AS 'chiffre_affaire'
FROM
    vente v
JOIN
    produit p ON v.ean = p.ean
GROUP BY 
    v.date_achat;
