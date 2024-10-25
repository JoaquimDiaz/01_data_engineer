-- Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59, 69.

WITH avg_prices AS (
    SELECT 
        c.code_dep, 
        c.nom_commune, 
        ROUND(AVG(v.valeur_fonciere)) AS avg_prix
    FROM 
        vente v
    JOIN    
        bien b ON v.id_bien = b.id_bien
    JOIN
        commune c ON b.id_code_depcommune = c.id_code_depcommune
    WHERE   
        c.code_dep IN (6, 13, 33, 59, 69)
    GROUP BY 
        c.nom_commune, c.code_dep
),
classement_communes AS (
    SELECT
        code_dep,
        nom_commune,
        avg_prix,
        RANK() OVER (PARTITION BY code_dep ORDER BY avg_prix DESC) AS classement
    FROM avg_prices
)
SELECT 
    code_dep, 
    nom_commune, 
    avg_prix
FROM 
    classement_communes
WHERE
    classement <= 3
ORDER BY
    avg_prix DESC;




