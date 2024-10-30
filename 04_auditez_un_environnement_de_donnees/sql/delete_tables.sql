-- Supprime le contenu des tables
DELETE FROM vente;
DELETE FROM client;
DELETE FROM employe;
DELETE FROM produit;
DELETE FROM calendrier;

-- Vérifie la suppression des tables
SELECT * FROM vente LIMIT 10;
SELECT * FROM client LIMIT 10;
SELECT * FROM employe LIMIT 10;
SELECT * FROM produit LIMIT 10;
SELECT * FROM calendrier LIMIT 10;
