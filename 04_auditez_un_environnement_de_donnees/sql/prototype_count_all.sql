SELECT 'vente' AS 'table', COUNT(*) AS 'count' FROM vente

UNION ALL

SELECT 'produit', COUNT(*) FROM produit

UNION ALL

SELECT 'employe', COUNT(*) FROM employe

UNION ALL

SELECT 'client', COUNT(*) FROM client

UNION ALL

SELECT 'calendrier', COUNT(*) FROM calendrier

UNION ALL

SELECT 'logs', COUNT(*) FROM logs

UNION ALL 

SELECT 'transaction_log', COUNT(*) FROM transaction_log;