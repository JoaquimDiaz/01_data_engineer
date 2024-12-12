CREATE TABLE transaction_log (
    id_ticket CHAR(100) NOT NULL, -- ticket associé à la transaction
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Time of the transaction
    status CHAR(50) NOT NULL, -- SUCCESS ou FAILURE
    message_erreur VARCHAR(255);
    PRIMARY KEY (id_ticket)
);

