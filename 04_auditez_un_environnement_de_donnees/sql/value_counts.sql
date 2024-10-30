SELECT
    champs,
    COUNT(champs) AS 'count'
FROM
    logs
GROUP BY
    champs
ORDER BY
    count DESC;
