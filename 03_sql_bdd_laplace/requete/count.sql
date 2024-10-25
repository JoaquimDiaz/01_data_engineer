SELECT 'bien' AS nom_table, COUNT(*) AS nb_lignes FROM bien
UNION ALL
SELECT 'vente', COUNT(*) FROM vente
UNION ALL
SELECT 'commune', COUNT(*) FROM commune
UNION ALL
SELECT 'region', COUNT(*) FROM region;
