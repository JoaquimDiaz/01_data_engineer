CREATE TABLE client (
    customer_id VARCHAR(100) NOT NULL,
    date_inscription DATE NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE employe (
    id_employe VARCHAR(100),
    employe VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE DEFAULT NULL,
    status CHAR(10) NOT NULL DEFAULT 'actif',
    hash_mdp VARCHAR(100) NOT NULL,
    mail VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (id_employe)
);

CREATE TABLE produit (
    ean VARCHAR(100),
    categorie VARCHAR(100) NOT NULL,
    rayon VARCHAR(100) NOT NULL,
    libelle_produit VARCHAR(250) NOT NULL,
    prix DECIMAL(10, 2) NOT NULL CHECK (prix > 0),
    PRIMARY KEY(ean)
);

CREATE TABLE calendrier (
    date DATE NOT NULL,
    annee INT NOT NULL,
    mois INT NOT NULL,
    jour INT NOT NULL,
    mois_nom VARCHAR(100) NOT NULL,
    annee_mois VARCHAR(100) NOT NULL,
    jour_semaine INT NOT NULL,
    trimestre VARCHAR(50) NOT NULL,
    PRIMARY KEY (date)
);

CREATE TABLE vente (
    id_bdd VARCHAR(100) NOT NULL,
    customer_id VARCHAR(100),
    id_employe VARCHAR(100),
    ean VARCHAR(100),
    date_achat DATE,
    id_ticket VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_bdd),
    FOREIGN KEY (customer_id) REFERENCES client(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (id_employe) REFERENCES employe(id_employe) ON DELETE SET NULL,
    FOREIGN KEY (ean) REFERENCES produit(ean) ON DELETE SET NULL,
    FOREIGN KEY (date_achat) REFERENCES calendrier(date) ON DELETE SET NULL

);

CREATE TABLE logs (
    id_user CHAR(200) DEFAULT '08c8b678f8e6f0caz05880ef4ebba10az',
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action CHAR(10) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    table_insert CHAR(50) NOT NULL,
    id_ligne CHAR(50) NOT NULL,
    champs CHAR(50),
    detail CHAR(200)
    );

CREATE TABLE transaction_log (
    id_ticket CHAR(100) NOT NULL, 
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status CHAR(10) NOT NULL CHECK (status IN ('SUCCESS', 'FAILURE')), -- SUCCESS ou FAILURE
    message_erreur VARCHAR(255),
    PRIMARY KEY (id_ticket, timestamp)
);


ALTER TABLE employe
ADD CONSTRAINT check_status
CHECK (
    (status = 'actif' AND date_fin IS NULL)
    OR
    (status = 'inactif' AND date_fin > date_debut)
)

