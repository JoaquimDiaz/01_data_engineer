SELECT DISTINCT
    v.id_bdd,
    v.customer_id,
    v.id_employe,
    v.ean,
    v.date_achat,
    v.id_ticket,
    p.libelle_produit,
    c.date_inscription
FROM
    vente v
JOIN
    produit p ON v.ean = p.ean
JOIN
    client c ON v.customer_id = c.customer_id
JOIN
    logs l ON v.id_bdd = l.id_ligne AND detail = 't_3839'
LIMIT 30;