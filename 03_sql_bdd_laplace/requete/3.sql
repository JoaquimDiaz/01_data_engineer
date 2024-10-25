-- Proportion des ventes d'appartements par le nombre de pieces

SELECT 
    b.nb_pieces,
    COUNT(v.id_vente) / (
        SELECT 
            COUNT(v.id_vente) 
        FROM 
            vente v 
        JOIN 
            bien b ON v.id_bien = b.id_bien
        WHERE 
            b.type_local = 'Appartement'
    ) AS 'Proportion'
FROM 
    vente v
JOIN 
    bien b ON v.id_bien = b.id_bien
WHERE 
    b.type_local = 'Appartement'
GROUP BY 
    b.nb_pieces;
