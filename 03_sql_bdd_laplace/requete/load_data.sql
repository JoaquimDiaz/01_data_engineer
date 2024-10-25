LOAD DATA LOCAL INFILE './data_clean/region.csv'
INTO TABLE region
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_reg, nom_region, nom_regroupement);

SHOW WARNINGS LIMIT 5;

LOAD DATA LOCAL INFILE './data_clean/commune.csv'
INTO TABLE commune
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_code_depcommune, id_reg,code_dep, code_commune, pop_totale, nom_commune);

SHOW WARNINGS LIMIT 5;

LOAD DATA LOCAL INFILE './data_clean/bien.csv'
INTO TABLE bien
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_bien, no_voie, btq, type_voie, nom_voie, type_local, nb_pieces, surface_carrez, surface_totale, id_code_depcommune);

SHOW WARNINGS LIMIT 5;

LOAD DATA LOCAL INFILE './data_clean/vente.csv'
INTO TABLE vente
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_vente,id_bien,date_vente,valeur_fonciere,nom_acquereur);

SHOW WARNINGS LIMIT 5;

SELECT * FROM region LIMIT 10;
SELECT * FROM commune LIMIT 10;
SELECT * FROM bien LIMIT 10;
SELECT * FROM vente LIMIT 10;