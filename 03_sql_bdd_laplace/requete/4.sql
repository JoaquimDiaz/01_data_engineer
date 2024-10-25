-- Liste des 10 départements où le prix au mètre carré est le plus élevé.

SELECT 
    c.code_dep, AVG(v.valeur_fonciere / b.surface_totale) AS 'avg_prix_m2'
FROM 
    vente v
JOIN 
    bien b ON v.id_bien = b.id_bien
JOIN 
    commune c ON b.id_code_depcommune = c.id_code_depcommune
GROUP BY 
    c.code_dep
ORDER BY 
    avg_prix_m2 DESC
LIMIT 10;