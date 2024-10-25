-- Les 20 communes avec le plus de transactions pour 1000 habitants pour les communes
-- qui dépassent les 10 000 habitants

SELECT
    c.nom_commune,
    ROUND((COUNT(v.id_vente) / c.pop_totale) * 1000, 2) AS nb_transactions_1000_habitants
FROM 
    vente v
JOIN    
    bien b ON v.id_bien = b.id_bien
JOIN
    commune c ON b.id_code_depcommune = c.id_code_depcommune
WHERE
    c.pop_totale >= 10000
GROUP BY 
    c.nom_commune
ORDER BY
    nb_transactions_1000_habitants DESC
LIMIT 20;


