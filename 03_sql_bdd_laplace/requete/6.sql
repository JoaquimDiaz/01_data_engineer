-- Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés.

SELECT 
    b.id_bien,
    v.valeur_fonciere,
    r.nom_region,
    b.surface_totale
FROM 
    vente v
JOIN 
    bien b ON v.id_bien = b.id_bien
JOIN 
    commune c ON b.id_code_depcommune = c.id_code_depcommune
JOIN 
    region r ON c.id_reg = r.id_reg
ORDER BY 
    v.valeur_fonciere DESC
LIMIT 10;