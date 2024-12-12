ALTER TABLE logs
ADD CONSTRAINT check_prix
CHECK IF champs = 'prix' THEN CAST(details) AS FLOAT;