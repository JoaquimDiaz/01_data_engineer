CREATE TABLE client (
    customer_id CHAR(100) NOT NULL,
    date_inscription DATE NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE employe (
    id_employe CHAR(250) NOT NULL,
    employe CHAR(100) NOT NULL,
    prenom CHAR(100) NOT NULL,
    nom CHAR(100) NOT NULL,
    date_debut DATE NOT NULL,
    hash_mdp CHAR(250) NOT NULL,
    mail CHAR(100) NOT NULL,
    PRIMARY KEY (id_employe)
);

CREATE TABLE produit (
    ean CHAR(100) NOT NULL,
    categorie CHAR(100),
    rayon CHAR(100),
    libelle_produit CHAR(250) NOT NULL,
    prix FLOAT NOT NULL,
    PRIMARY KEY (ean)
);

CREATE TABLE calendrier (
    date DATE NOT NULL,
    annee INT NOT NULL,
    mois INT NOT NULL,
    jour INT NOT NULL,
    mois_nom CHAR(100) NOT NULL,
    annee_mois DATE NOT NULL,
    jour_semaine INT NOT NULL,
    trimestre CHAR(50) NOT NULL,
    PRIMARY KEY (date)
);

CREATE TABLE vente (
    id_bdd CHAR(250) NOT NULL,
    customer_id CHAR(100) NOT NULL,
    id_employe CHAR(250) NOT NULL,
    ean CHAR(100) NOT NULL,
    date_achat DATE NOT NULL,
    id_ticket CHAR(100) NOT NULL,
    PRIMARY KEY (id_bdd),
    FOREIGN KEY (customer_id) REFERENCES client(customer_id),
    FOREIGN KEY (id_employe) REFERENCES employe(id_employe),
    FOREIGN KEY (ean) REFERENCES produit(ean),
    FOREIGN KEY (date_achat) REFERENCES calendrier(date)
);
