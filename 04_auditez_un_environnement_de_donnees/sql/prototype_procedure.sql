DELIMITER //

DROP PROCEDURE IF EXISTS InsertVente;

CREATE PROCEDURE InsertVente(
    IN ticket_id VARCHAR(255),
    IN vente_values TEXT
)
BEGIN
    DECLARE error_message TEXT;

    -- Block qui permet de 'CATCH' les erreurs
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        
        -- Récupère le message d'erreur
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        
        -- Annule les insertions dans la BDD
        ROLLBACK;

        -- Insère une ligne dans transaction_log avec le message d'erreur
        INSERT INTO transaction_log (id_ticket, status, message_erreur)
        VALUES (ticket_id, 'FAILURE', error_message);

        -- COMMIT du message d'erreur dans la base
        COMMIT;

    END; -- Fin du block de gestion d'erreur

    START TRANSACTION; -- Initiation de la transaction

    -- Création d'une insertion dynamique
    BEGIN
        SET @sql = CONCAT(
            'INSERT INTO vente (id_bdd, customer_id, id_employe, ean, date_achat, id_ticket) VALUES ',
            vente_values
        );

        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        -- Insertion du succès dans la base transaction_log sans message d'erreur
        INSERT INTO transaction_log (id_ticket, status, message_erreur)
        VALUES (ticket_id, 'SUCCESS', NULL);

        COMMIT; -- CCMMIT tous les changement
        -- Si une erreur survient avant ce commit aucune des inscriptions ne sera conservé
    END;
        
END //

DELIMITER ;
