SELECT
    *
FROM
    logs
WHERE
    id_ligne IN (SELECT DISTINCT id_ligne FROM logs WHERE detail = 't_2828');