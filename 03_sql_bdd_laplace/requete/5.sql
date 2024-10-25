-- Prix moyen du mètre carré d'une maison en île-de-france.

SELECT 
    ROUND(AVG(v.valeur_fonciere / b.surface_totale),2) AS 'avg_prix_m2_idf'
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
    r.nom_region = 'Ile-de-France';