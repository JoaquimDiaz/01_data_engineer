# Maintenez et documentez un système de stockage des données sécurisé et performant

## Contexte

* Entreprise : **DataSoluTech**
    * Fournisseur de services informatiques pour les entreprises
    * Aide les entreprises à trouver des solutions pour gérer leurs données éfficacement

* Stagiaire Data Engineer

* Mission importante, client important.
  
* Mission : transférer des données médicales sur une base mongodb et étudier les services AWS

    * Problèmes de scalabilité : Le client rencontre des problème de scalabilité **horizontale**.
      * L'augmentation du nombre d'utilisateurs de la base peut-être compliqué pour les base de données sql classique.
      * MongoDB est la solution proposé par l'entreprise, **POURQUOI???**
      * (............)

    * Migration sur le cloud : **POURQUOI???**
    * (...)

## Détail de la mission

### 1. Automatisation :

* La migration des données doit être automatisé via un script python.
* Créer deux conteneur Docker
  * Un pour le script python
  * Un pour la base de donnée MongoDB
* Créer des rôle utilisateurs pour la base de donnée
  * Administrateur, developpeur, simple consulteur...
  * Justifier les rôles
* Versionner le script sur github
  * README détaillé
  * Schéma de la base
  * Description des rôles

### 2. Services AWS :

* Préparer un plan pour le développement de la solution sur AWS
* Parler des services de AWS : S3, EC2, DocumentDB, RDS pour MongoDB

### 3. Présentation PowerPoint :

#### 1. Détail du contexte

(...)

#### 2. Description de la démarche technique

(...)

#### 3. Présentation des services AWS

(...)

#### 4. Justification des choix

 * **Sharding**: helps scalling horizontaly
   * Data is distributed into servers(shard) that hold a subset of the data. All shards makout the entire database.
   * Adding more shards add more volume and workload




