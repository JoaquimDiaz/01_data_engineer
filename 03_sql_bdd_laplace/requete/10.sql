-- Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces

WITH table_prix AS (
    SELECT
        (SELECT ROUND(AVG(v.valeur_fonciere / b.surface_totale), 2)
         FROM vente v
         JOIN bien b ON v.id_bien = b.id_bien
         WHERE b.type_local = 'Appartement' AND b.nb_pieces = 2) AS prix_m2_t2,

        (SELECT ROUND(AVG(v.valeur_fonciere / b.surface_totale), 2)
         FROM vente v
         JOIN bien b ON v.id_bien = b.id_bien
         WHERE b.type_local = 'Appartement' AND b.nb_pieces = 3) AS prix_m2_t3
)
SELECT 
    prix_m2_t2,
    prix_m2_t3,
    ROUND((prix_m2_t3 - prix_m2_t2) * 100 / prix_m2_t2, 2) AS pct_diff
FROM 
    table_prix;
