SELECT
    v.id_user,
    v.date,
    v.action,
    v.table_insert,
    v.id_ligne,
    v.champs,
    v.
FROM
    vente v
JOIN
    produit p ON v.ean = p.ean
JOIN
    logs l ON v.ean = l.id_ligne 
    AND l.champs = 'prix'
    AND l.detail LIKE '2024%';
