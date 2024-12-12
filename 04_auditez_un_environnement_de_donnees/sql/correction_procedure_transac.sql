DELIMITER //

CREATE PROCEDURE InsertVente(
    IN ticket_id VARCHAR(255),
    IN vente_values TEXT
)
BEGIN
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE error_message VARCHAR(255);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET error_occurred = TRUE;
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
    END;

    START TRANSACTION;

    -- Dynamic Insert
    SET @sql = CONCAT(
        'INSERT INTO vente (id_bdd, customer_id, id_employe, ean, date_achat, id_ticket) VALUES ',
        vente_values
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Check if any error occurred
    IF error_occurred THEN
        -- Log error and rollback
        INSERT INTO transaction_log (id_ticket, status, message_erreur)
        VALUES (ticket_id, 'FAILURE', error_message);
        ROLLBACK;
    ELSE
        -- Log success and commit
        INSERT INTO transaction_log (id_ticket, status)
        VALUES (ticket_id, 'SUCCESS');
        COMMIT;
    END IF;
END //

DELIMITER ;