SELECT
    action,
    COUNT(*) AS 'count'
FROM
    logs
GROUP BY
    action;