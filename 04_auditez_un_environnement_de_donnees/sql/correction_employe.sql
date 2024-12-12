--Ajout de la colonne date_fin quand un employe quitte l'entreprise.
ALTER TABLE employe
ADD 
    date_fin DATE DEFAULT NULL
    status CHAR(20) NOT NULL DEFAULT 'actif';

--Ajout d'une contrainte qui vérifie que la date de fin est bien null ou superieur à la date
--de début pour éviter les incohérences.
ALTER TABLE employe
ADD CONSTRAINT check_status
CHECK (
    (status = 'actif' AND date_fin IS NULL)
    OR
    (status = 'inactif' AND date_fin > date_debut)
)

--Quand un employe quitte l'entreprise
UPDATE employe
SET  = 'inactif', date_fin = '2024-01-01'
WHERE employee_id = <employe_id>;

--Supprimer les données des employés qui ont quittés l'entreprise il y a plus d'un an
DELETE FROM employe
WHERE status = 'inactive' AND termination_date < NOW() - INTERVAL 1 YEAR;
