-- Le nombre de ventes d'appartement par région pour le 1er semestre 2020

SELECT 
    r.nom_region AS 'region', 
    COUNT(DISTINCT(v.id_bien)) AS 'Nb_ventes'
FROM 
    vente v
JOIN 
    bien b ON v.id_bien = b.id_bien
JOIN 
    commune c ON b.id_code_depcommune = c.id_code_depcommune
JOIN    
    region r ON c.id_reg = r.id_reg
WHERE 
    v.date_vente BETWEEN '2020-01-01' AND '2020-06-30'
AND 
    b.type_local = 'Appartement'
GROUP BY 
    r.nom_region
ORDER BY 
    Nb_ventes DESC;