-- Taux d'évolution du nombre de ventes entre le premier et le second trimestre 2020

WITH 
trimestre1 AS (
  SELECT 
      COUNT(v.id_bien) AS ventes_trimestre1
  FROM 
      vente v
  WHERE 
      date_vente BETWEEN '2020-01-01' AND '2020-03-31'
),
trimestre2 AS (
  SELECT 
      COUNT(v.id_bien) AS ventes_trimestre2
  FROM 
      vente v
  WHERE 
      date_vente BETWEEN '2020-04-01' AND '2020-06-30'
)
SELECT
  t1.ventes_trimestre1,
  t2.ventes_trimestre2,
  ROUND(((t2.ventes_trimestre2 - t1.ventes_trimestre1) * 100.00 / t1.ventes_trimestre1), 2) AS taux_evolution
FROM 
  trimestre1 t1, 
  trimestre2 t2;




