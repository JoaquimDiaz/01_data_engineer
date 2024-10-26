-- Le classement des régions par rapport au prix au mètre carré des appartement de plus de 4 pièces.

SELECT 
    r.nom_region, 
    ROUND(AVG(v.valeur_fonciere/b.surface_totale)) AS avg_prix_m2
FROM 
    vente v
JOIN 
    bien b ON v.id_bien = b.id_bien
JOIN 
    commune c ON b.id_code_depcommune = c.id_code_depcommune
JOIN 
    region r ON c.id_reg = r.id_reg
WHERE 
    b.type_local = 'Appartement'
AND 
    b.nb_pieces > 4
GROUP BY 
    r.nom_region
ORDER BY 
    avg_prix_m2 DESC;