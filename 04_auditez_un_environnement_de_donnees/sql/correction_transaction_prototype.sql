-- Exemple de transaction pour la commande t_2828
START TRANSACTION;

-- Si une erreur occure, l'inscrit dans la table de transaction
DECLARE message_erreur VARCHAR(255);
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    
    GET DIAGNOSTICS CONDITION 1 message_erreur = MESSAGE_TEXT;
    INSERT INTO transaction_log (id_ticket, status, message_erreur)
    VALUES ('t_2828', 'FAILURE', message_erreur);

    -- Annule les changements en cas d'erreur
    ROLLBACK;
END;

INSERT INTO vente (id_bdd, customer_id, id_employe, ean, date_achat, id_ticket) 
VALUES 
    ('0EKV6VK8PCBWUEH2OGM10APVCJ5WHVTW6XX', 'CUST-21XPJKDCSBFY', 'f21c1650dd9340170266d47ec34eb6e8', '8998736834828', '2024-08-14', 't_2828'),
    ('4BWAJHUJ8WEGA23LFBXXR1RVEB93N50RDS6', 'CUST-21XPJKDCSBFY', 'f21c1650dd9340170266d47ec34eb6e8', '3358444045030', '2024-08-14', 't_2828'),
    ('5S9H90GUD1F7QI1EGTMAVE6MX3XHRK46QZP', 'CUST-21XPJKDCSBFY', 'f21c1650dd9340170266d47ec34eb6e8', '2104210480498', '2024-08-14', 't_2828'),
    ('C2JMJ5LLP8881EL38K5BH308R3LT8NV3V4Q', 'CUST-21XPJKDCSBFY', 'f21c1650dd9340170266d47ec34eb6e8', '56039744942',   '2024-08-14', 't_2828'),
    ('EZ2WK5L80ZBQG85GEQTDJJRTLMQSFXUJCL0', 'CUST-21XPJKDCSBFY', 'f21c1650dd9340170266d47ec34eb6e8', '6893328192259', '2024-08-14', 't_2828'),
    ('WB1XYBFOU8PQ0KKDPEN1X9UHL5KYSZG93BS', 'CUST-21XPJKDCSBFY', 'f21c1650dd9340170266d47ec34eb6e8', '1746719907623', '2024-08-14', 't_2828');


INSERT INTO transaction_log (id_ticket, status)
VALUES ('t_2828', 'SUCCESS');

-- Sauvegarde des inscriptions dans la base de données si toute les données sont insérés.
COMMIT;
