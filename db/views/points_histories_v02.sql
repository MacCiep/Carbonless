SELECT
    points_history.partner_name,
    points_history.points,
    points_history.user_id,
    points_history.history_type,
    points_history.prize_title,
    points_history.created_at
FROM
    (
        SELECT
            purchases.user_id AS user_id,
            purchases.created_at AS created_at,
            partners.name AS partner_name,
            partners.points AS points,
            NULL AS prize_title,
            'purchase' AS history_type
        FROM
            purchases
                INNER JOIN machines ON purchases.machine_id = machines.id
                INNER JOIN partners ON machines.partner_id = partners.id
        UNION
        SELECT
            travel_sessions.user_id AS user_id,
            travel_sessions.updated_at AS created_at,
            partners.name AS partner_name,
            travel_sessions.points AS points,
            NULL AS prize_title,
            'travel' AS history_type
        FROM
            travel_sessions
                INNER JOIN machines ON travel_sessions.machine_id = machines.id
                INNER JOIN partners ON machines.partner_id = partners.id
        WHERE
                travel_sessions.success = TRUE
        UNION
        SELECT
            users_prizes.user_id AS user_id,
            users_prizes.created_at AS created_at,
            partners.name AS partner_name,
            prizes.price AS points,
            prizes.title AS prize_title,
            'prize' AS history_type
        FROM
            users_prizes
                INNER JOIN prizes ON users_prizes.prize_id = prizes.id
                INNER JOIN partners ON prizes.partner_id = partners.id
    ) AS points_history
ORDER BY
    created_at DESC
