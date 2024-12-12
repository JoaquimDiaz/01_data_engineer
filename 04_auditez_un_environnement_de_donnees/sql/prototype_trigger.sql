DELIMITER //

CREATE TRIGGER log_price_update
AFTER UPDATE ON produit
FOR EACH ROW
BEGIN
    IF NEW.prix != OLD.prix AND NEW.prix > 0 THEN
        INSERT INTO logs (action, table_insert, id_ligne, champs, detail)
        VALUES ('UPDATE', 'produit', OLD.ean, 'prix', CONCAT('New price: ', NEW.prix, ', Old price: ', OLD.prix));
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER log_vente_insert
AFTER INSERT ON vente
FOR EACH ROW
BEGIN
    INSERT INTO logs (action, table_insert, id_ligne, champs, detail)
    VALUES ('INSERT', 'vente', NEW.id_bdd, 'customer_id', NEW.customer_id);
    
    INSERT INTO logs (action, table_insert, id_ligne, champs, detail)
    VALUES ('INSERT', 'vente', NEW.id_bdd, 'date', NEW.date_achat);
    
    INSERT INTO logs (action, table_insert, id_ligne, champs, detail)
    VALUES ('INSERT', 'vente', NEW.id_bdd, 'ean', NEW.ean);
    
    INSERT INTO logs (action, table_insert, id_ligne, champs, detail)
    VALUES ('INSERT', 'vente', NEW.id_bdd, 'id_ticket', NEW.id_ticket);
    
    INSERT INTO logs (action, table_insert, id_ligne, champs, detail)
    VALUES ('INSERT', 'vente', NEW.id_bdd, 'id_employe', NEW.id_employe); 
END //

DELIMITER ;




