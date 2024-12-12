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
    customer_id VARCHAR(100) NOT NULL,
    id_employe VARCHAR(100) NOT NULL,
    ean VARCHAR(100) NOT NULL,
    date_achat DATE NOT NULL,
    id_ticket VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_bdd),
    FOREIGN KEY (customer_id) REFERENCES client(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (id_employe) REFERENCES employe(id_employe) ON DELETE SET NULL,
    FOREIGN KEY (ean) REFERENCES produit(ean) ON DELETE SET NULL,
    FOREIGN KEY (date_achat) REFERENCES calendrier(date) ON DELETE SET NULL

);
