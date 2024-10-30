SELECT 'client' AS nom_table, COUNT(*) AS nb_lignes FROM client
UNION ALL
SELECT 'vente', COUNT(*) FROM vente
UNION ALL
SELECT 'employe', COUNT(*) FROM employe
UNION ALL 
SELECT 'produit', COUNT(*) FROM produit
UNION ALL
SELECT 'calendrier', COUNT(*) FROM calendrier;