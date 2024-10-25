-- Nombre total d'appartements vendus au 1er semestre 2020

SELECT 
    COUNT(v.id_bien) AS 'Nb_ventes'
FROM 
    vente v
WHERE 
    date_vente BETWEEN '2020-01-01' AND '2020-06-30';