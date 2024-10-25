CREATE TABLE region (
    id_reg INT PRIMARY KEY NOT NULL,
    nom_region VARCHAR(50) NOT NULL,
    nom_regroupement VARCHAR(50) NOT NULL
);

CREATE TABLE commune (
    id_code_depcommune VARCHAR(50) PRIMARY KEY NOT NULL,
    id_reg INT NOT NULL,
    code_dep VARCHAR(50) NOT NULL,
    code_commune VARCHAR(50) NOT NULL,
    pop_totale INT,
    nom_commune VARCHAR(100),
    FOREIGN KEY (id_reg) REFERENCES region(id_reg)
);

CREATE TABLE bien (
    id_bien VARCHAR(255) PRIMARY KEY NOT NULL,
    no_voie INT,
    btq VARCHAR(20),
    type_voie VARCHAR(20),
    nom_voie VARCHAR(100) NOT NULL,
    type_local VARCHAR(50),
    nb_pieces INT NOT NULL,
    surface_carrez FLOAT,
    surface_totale FLOAT,
    id_code_depcommune VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_code_depcommune) REFERENCES commune(id_code_depcommune)
);

CREATE TABLE vente (
    id_vente VARCHAR(255) PRIMARY KEY NOT NULL,
    id_bien VARCHAR(255) NOT NULL,
    date_vente date NOT NULL,
    valeur_fonciere INT NOT NULL,
    nom_acquereur VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_bien) REFERENCES bien(id_bien)
    );