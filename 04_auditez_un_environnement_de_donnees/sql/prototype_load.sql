-- Load data into client table
LOAD DATA LOCAL INFILE '../data/client.csv'
INTO TABLE client
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, date_inscription);

SHOW WARNINGS LIMIT 5;

-- Load data into employe table
LOAD DATA LOCAL INFILE '../data/employe.csv'
INTO TABLE employe
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_employe, employe, prenom, nom, date_debut, hash_mdp, mail);

SHOW WARNINGS LIMIT 5;

-- Load data into produit table
LOAD DATA LOCAL INFILE '../data/produit.csv'
INTO TABLE produit
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ean, categorie, rayon, libelle_produit, prix);

SHOW WARNINGS LIMIT 5;

-- Load data into calendrier table
LOAD DATA LOCAL INFILE '../data/calendrier.csv'
INTO TABLE calendrier
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, annee, mois, jour, mois_nom, annee_mois, jour_semaine, trimestre);

SHOW WARNINGS LIMIT 5;

-- Verify loaded data
SELECT * FROM client LIMIT 3;
SELECT * FROM employe LIMIT 3;
SELECT * FROM produit LIMIT 3;
SELECT * FROM calendrier LIMIT 3;
SELECT * FROM vente LIMIT 3;
