CREATE DATABASE IF NOT EXISTS db_prototype;

USE db_prototype;

SELECT 'Création des tables' AS 'Msg';

SOURCE prototype_create.sql;

SELECT 'Chargement des données' AS 'Msg';

SOURCE prototype_load.sql;

SELECT 'Création des procédures' AS 'Msg';

SOURCE prototype_procedure.sql;

-- SHOW WARNINGS LIMIT 1;

SELECT 'Création des triggers' AS 'Msg';

SOURCE prototype_trigger.sql;

SOURCE prototype_count_all.sql;

