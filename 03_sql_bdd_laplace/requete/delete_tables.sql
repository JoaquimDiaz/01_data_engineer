-- Supprime le contenue des tables
DELETE FROM vente;
DELETE FROM bien;
DELETE FROM commune;
DELETE FROM region;

-- Verifie la suppression des tables
SELECT * FROM vente LIMIT 10;
SELECT * FROM bien LIMIT 10;
SELECT * FROM commune LIMIT 10;
SELECT * FROM region LIMIT 10;