CREATE TABLE logs (
    id_user CHAR(200) NOT NULL,
    date DATE NOT NULL,
    action CHAR(10) NOT NULL,
    table_insert CHAR(50) NOT NULL,
    id_ligne CHAR(50) NOT NULL,
    champs CHAR(50),
    detail CHAR(200),
    PRIMARY KEY (id_user, date, action, table_insert, id_ligne, champs, detail)
);

LOAD DATA LOCAL INFILE '../data/logs.csv'
INTO TABLE logs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_user, date, action, table_insert, id_ligne, champs, detail);