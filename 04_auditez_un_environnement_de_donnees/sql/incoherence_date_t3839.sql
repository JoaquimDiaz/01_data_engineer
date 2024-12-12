SELECT
    l.date AS 'date_insertion',
    COUNT(*) AS 'nb_articles'
FROM
    vente v
JOIN
    logs l ON v.id_bdd = l.id_ligne
    AND l.detail = 't_3839'
WHERE
    v.id_ticket = 't_3839'
GROUP BY 
    l.date;    