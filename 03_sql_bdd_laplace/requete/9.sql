-- Liste des communes ayant eu au moins 50 ventes au 1er trimestre.

SELECT 
    c.nom_commune,
    COUNT(v.id_vente) AS nb_ventes
FROM 
    vente v
JOIN 
    bien b ON v.id_bien = b.id_bien
JOIN 
    commune c ON b.id_code_depcommune = c.id_code_depcommune
WHERE 
    v.date_vente BETWEEN '2020-01-01' AND '2020-03-30'
GROUP BY 
    c.nom_commune
HAVING 
    nb_ventes >= 50
ORDER BY 
    nb_ventes DESC;