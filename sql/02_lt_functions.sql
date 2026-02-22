SELECT *
        SELECT DISTINCT
            ON (uic) uic, infoprice_id, vol, relvol, lasttraded, net_d, perc_d, lastupdated_at
        FROM nb_infoprices
        WHERE
            lastupdated_at::date = CURRENT_DATE
        ORDER BY uic, lastupdated_at DESC
    ) t
ORDER BY relvol DESC;
--
--
--
--
--
SELECT
    FIRST_VALUE(lasttraded) OVER (
        PARTITION BY
            uic
        ORDER BY lastupdated_at DESC
    ) AS llasttraded,
    FIRST_VALUE(lasttraded) OVER (
        PARTITION BY
            uic
        ORDER BY lastupdated_at ASC
    ) AS m15_ago_lasttraded,
    FIRST_VALUE(infoprice_id) OVER (
        PARTITION BY
            uic
        ORDER BY lastupdated_at DESC
    ) AS iinfoprice_id
FROM nb_infoprices
WHERE
    lastupdated_at IS NOT NULL
    AND lastupdated_at >= NOW() - INTERVAL '1115 minute';
--
--
--
--
--
--
SELECT
    n.*,
    sub.lasttraded_gain,
    sub.lasttraded_gain_percen
    FROM (
        SELECT
            FIRST_VALUE(infoprice_id) OVER (
                PARTITION BY uic
                ORDER BY lastupdated_at DESC
            ) AS iinfoprice_id,
            FIRST_VALUE(lasttraded) OVER (
                PARTITION BY uic
                ORDER BY lastupdated_at DESC
            ) - FIRST_VALUE(lasttraded) OVER (
                PARTITION BY uic
                ORDER BY lastupdated_at ASC
            ) AS lasttraded_gain,
            (FIRST_VALUE(lasttraded) OVER (
                PARTITION BY uic
                ORDER BY lastupdated_at DESC
            ) - FIRST_VALUE(lasttraded) OVER (
                PARTITION BY uic
                ORDER BY lastupdated_at ASC
            )) / NULLIF(FIRST_VALUE(lasttraded) OVER (
                PARTITION BY uic
                ORDER BY lastupdated_at ASC
            ), 0) * 100 AS lasttraded_gain_percen
        FROM nb_infoprices
        WHERE lastupdated_at >= NOW() - INTERVAL '1115 minute'
    ) AS sub
    JOIN nb_infoprices n
        ON n.infoprice_id = sub.iinfoprice_id
    ORDER BY sub.lasttraded_gain_percen DESC
LIMIT 100;
-- 
-- 
-- 
SELECT
    n.*,
    sub.vol_gain,
    sub.vol_gain_percen
FROM (
    SELECT
        FIRST_VALUE(infoprice_id) OVER (
            PARTITION BY uic
            ORDER BY lastupdated_at DESC
        ) AS iinfoprice_id,
        
        -- Absolute gain in volume
        FIRST_VALUE(vol) OVER (
            PARTITION BY uic
            ORDER BY lastupdated_at DESC
        ) - FIRST_VALUE(vol) OVER (
            PARTITION BY uic
            ORDER BY lastupdated_at ASC
        ) AS vol_gain,

        -- Percentage gain in volume
        (FIRST_VALUE(vol) OVER (
            PARTITION BY uic
            ORDER BY lastupdated_at DESC
        ) - FIRST_VALUE(vol) OVER (
            PARTITION BY uic
            ORDER BY lastupdated_at ASC
        )) / NULLIF(FIRST_VALUE(vol) OVER (
            PARTITION BY uic
            ORDER BY lastupdated_at ASC
        ), 0) * 100 AS vol_gain_percen

    FROM nb_infoprices
    WHERE lastupdated_at >= NOW() - INTERVAL '1115 minute'
) AS sub
JOIN nb_infoprices n
    ON n.infoprice_id = sub.iinfoprice_id
ORDER BY sub.vol_gain_percen DESC
LIMIT 100;
-- 
-- 
-- 

-- VWAP
SELECT symbol, (
        SUM(price * volume) OVER (
            PARTITION BY
                symbol
            ORDER BY timestamp
        )
    ) / (
        SUM(volume) OVER (
            PARTITION BY
                symbol
            ORDER BY timestamp
        )
    ) AS current_vwap
FROM stock_data
WHERE
    timestamp >= date_trunc('day', NOW())
ORDER BY symbol, timestamp;

--
--
--
--
--

-- Pivot Points

WITH
    yesterday_data AS (
        SELECT open, high, low,
        close
        FROM lt_hists
        WHERE
            uic = 123 -- Замените на нужный вам идентификатор акции (uic)
            AND time_at >= date_trunc('day', NOW()) - INTERVAL '1 day'
            AND time_at < date_trunc('day', NOW())
    )
SELECT
    -- Главная точка опоры
    (
        high + low +
        close
    ) / 3 AS pivot_point,
    -- Уровни сопротивления
    (
        2 * (
            high + low +
            close
        ) / 3
    ) - low AS resistance_1,
    (
        high + low +
        close
    ) / 3 + (high - low) AS resistance_2,
    high + 2 * (
        (
            high + low +
            close
        ) / 3 - low
    ) AS resistance_3,
    -- Уровни поддержки
    (
        2 * (
            high + low +
            close
        ) / 3
    ) - high AS support_1,
    (
        high + low +
        close
    ) / 3 - (high - low) AS support_2,
    low - 2 * (
        high - (
            high + low +
            close
        ) / 3
    ) AS support_3
FROM yesterday_data;

--
--
--
-- Fibonacci Retracement

WITH
    trend_data AS (
        SELECT MAX(high) AS trend_high, MIN(low) AS trend_low
        FROM lt_hists
        WHERE
            uic = 123
            -- Период сильного тренда, например, за последний месяц
            AND time_at >= NOW() - INTERVAL '1 month'
    )
SELECT
    trend_low + (trend_high - trend_low) * 0.236 AS fib_level_23_6,
    trend_low + (trend_high - trend_low) * 0.382 AS fib_level_38_2,
    (trend_high + trend_low) / 2 AS fib_level_50_0,
    trend_low + (trend_high - trend_low) * 0.618 AS fib_level_61_8,
    trend_low + (trend_high - trend_low) * 0.786 AS fib_level_78_6
FROM trend_data;

--
--
--
-- Average True Range, ATR (ATR — это показатель волатильности рынка. Он показывает, насколько сильно
-- цена актива колеблется в течение определённого периода, но без учёта направления движения. )

WITH
    true_range_data AS (
        SELECT
            uic,
            time_at,
            high,
            low,
            -- Получаем цену закрытия предыдущего дня
            LAG(
                close,
                1
            ) OVER (
                PARTITION BY
                    uic
                ORDER BY time_at
            ) AS prev_close,
            -- Вычисляем истинный диапазон (TR)
            GREATEST(
                high - low,
                ABS(
                    high - LAG(
                        close,
                        1
                    ) OVER (
                        PARTITION BY
                            uic
                        ORDER BY time_at
                    )
                ),
                ABS(
                    low - LAG(
                        close,
                        1
                    ) OVER (
                        PARTITION BY
                            uic
                        ORDER BY time_at
                    )
                )
            ) AS true_range
        FROM lt_hists
        WHERE
            uic = 123
    )
SELECT uic, time_at,
    -- Вычисляем скользящую среднюю от TR (обычно за 14 периодов)
    AVG(true_range) OVER (
        PARTITION BY
            uic
        ORDER BY time_at ROWS BETWEEN 13 PRECEDING
            AND CURRENT ROW
    ) AS atr
FROM true_range_data
ORDER BY time_at DESC;

--
--
--
--