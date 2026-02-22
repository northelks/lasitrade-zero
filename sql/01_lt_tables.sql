DROP TABLE IF EXISTS nb_instruments;

DROP TABLE IF EXISTS nb_watchlists;

DROP TABLE IF EXISTS nb_infoprices;

DROP TABLE IF EXISTS nb_hists_5m;

DROP TABLE IF EXISTS nb_hists_1d;

DROP TABLE IF EXISTS nb_news;

DROP TABLE IF EXISTS nb_trade_messages;

--
--
--

CREATE TABLE nb_instruments (
    uic INTEGER NOT NULL PRIMARY KEY,
    symbol TEXT NOT NULL,
    name TEXT NOT NULL,
    viewed_at TIMESTAMPTZ,
    watchlist_ids UUID [],
    created_at TIMESTAMPTZ NOT NULL
);

--

CREATE TABLE nb_watchlists (
    watchlist_id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

--

CREATE TABLE nb_infoprices (
    infoprice_id BIGSERIAL PRIMARY KEY,
    uic INTEGER REFERENCES nb_instruments (uic) ON DELETE CASCADE,
    vol BIGINT NOT NULL,
    relvol REAL NOT NULL,
    lasttraded REAL NOT NULL,
    net_d REAL NOT NULL,
    perc_d REAL NOT NULL,
    lastupdated_at TIMESTAMPTZ NOT NULL,
    net_m REAL NOT NULL,
    perc_m REAL NOT NULL
);

CREATE INDEX idx_nb_infoprices_uic_lastupdated ON nb_infoprices (uic, lastupdated_at DESC);

ALTER TABLE nb_infoprices
ADD CONSTRAINT nb_infoprices_unique_uic_lastupdated_at UNIQUE (uic, lastupdated_at);

CREATE OR REPLACE FUNCTION calculate_5min_changes()
RETURNS TRIGGER AS $$
DECLARE
    v_old_vol REAL;
BEGIN
    SELECT vol INTO v_old_vol
    FROM nb_infoprices
    WHERE uic = NEW.uic
      AND lastupdated_at >= NEW.lastupdated_at - INTERVAL '5 minutes'
      AND lastupdated_at < NEW.lastupdated_at
    ORDER BY lastupdated_at ASC
    LIMIT 1;
    
    IF v_old_vol IS NOT NULL THEN
        NEW.net_m := NEW.vol - v_old_vol;
        NEW.perc_m := ((NEW.vol - v_old_vol) / NULLIF(v_old_vol, 0)) * 100;
    ELSE
        NEW.net_m := 0;
        NEW.perc_m := 0;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculate_5min_changes
    BEFORE INSERT ON nb_infoprices
    FOR EACH ROW
    EXECUTE FUNCTION calculate_5min_changes();

--

CREATE TABLE nb_hists_5m (
    hist_id BIGSERIAL PRIMARY KEY,
    uic INTEGER REFERENCES nb_instruments (uic) ON DELETE CASCADE,
    open REAL NOT NULL,
    high REAL NOT NULL,
    low REAL NOT NULL,
    close REAL NOT NULL,
    volume BIGINT NOT NULL,
    time_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_nb_hists_5m_uic_time ON nb_hists_5m (uic, time_at DESC);

ALTER TABLE nb_hists_5m
ADD CONSTRAINT nb_hists_5m_unique_uic_time_at UNIQUE (uic, time_at);

CREATE TABLE nb_hists_1d (
    hist_id BIGSERIAL PRIMARY KEY,
    uic INTEGER REFERENCES nb_instruments (uic) ON DELETE CASCADE,
    open REAL NOT NULL,
    high REAL NOT NULL,
    low REAL NOT NULL,
    close REAL NOT NULL,
    volume BIGINT NOT NULL,
    time_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_nb_hists_1d_uic_time ON nb_hists_1d (uic, time_at DESC);

ALTER TABLE nb_hists_1d
ADD CONSTRAINT nb_hists_1d_unique_uic_time_at UNIQUE (uic, time_at);

--

CREATE TABLE nb_news (
    news_id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
    uic INTEGER REFERENCES nb_instruments (uic) ON DELETE CASCADE,
    text TEXT,
    provider TEXT,
    url TEXT,
    time_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_nb_news_uic_time ON nb_news (uic, time_at DESC);

--

CREATE TABLE nb_trade_messages (
    trade_message_id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
    message_header TEXT,
    message_id TEXT,
    message_type TEXT,
    order_id TEXT,
    position_id TEXT,
    source_order_id TEXT,
    message_body TEXT,
    seen BOOLEAN,
    date_time TIMESTAMPTZ NOT NULL
);

--

CREATE TABLE nb_market_data (
    market_data_id BIGSERIAL PRIMARY KEY,
    uic INTEGER REFERENCES nb_instruments (uic) ON DELETE CASCADE,
    price REAL NOT NULL,
    price_net REAL NOT NULL,
    price_perc REAL NOT NULL,
    market_cap REAL NOT NULL,
    volume REAL NOT NULL,
    volume_per REAL NOT NULL,
    shs_outstand REAL NOT NULL,
    shs_float REAL NOT NULL,
    shs_float_per REAL NOT NULL,
    short_interest REAL NOT NULL,
    short_ratio REAL NOT NULL,
    short_float REAL NOT NULL,
    time_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_nb_market_data_uic_time ON nb_news (uic, time_at DESC);

-------

SELECT *
FROM (
        SELECT DISTINCT
            ON (uic) uic, infoprice_id, vol, relvol, lasttraded, net_d, perc_d, lastupdated_at
        FROM nb_infoprices
        ORDER BY uic, lastupdated_at DESC
    ) t
ORDER BY relvol DESC;

SELECT DISTINCT
    ON (n.uic) n.*,
    sub.lasttraded_gain,
    sub.lasttraded_gain_percen
FROM (
        SELECT
            FIRST_VALUE(infoprice_id) OVER (
                PARTITION BY
                    uic
                ORDER BY lastupdated_at DESC
            ) AS iinfoprice_id, FIRST_VALUE(lasttraded) OVER (
                PARTITION BY
                    uic
                ORDER BY lastupdated_at DESC
            ) - FIRST_VALUE(lasttraded) OVER (
                PARTITION BY
                    uic
                ORDER BY lastupdated_at ASC
            ) AS lasttraded_gain, (
                FIRST_VALUE(lasttraded) OVER (
                    PARTITION BY
                        uic
                    ORDER BY lastupdated_at DESC
                ) - FIRST_VALUE(lasttraded) OVER (
                    PARTITION BY
                        uic
                    ORDER BY lastupdated_at ASC
                )
            ) / NULLIF(
                FIRST_VALUE(lasttraded) OVER (
                    PARTITION BY
                        uic
                    ORDER BY lastupdated_at ASC
                ), 0
            ) * 100 AS lasttraded_gain_percen
        FROM nb_infoprices
        WHERE
            lastupdated_at >= (
                SELECT MAX(lastupdated_at)
                FROM nb_infoprices
            ) - INTERVAL '15 minute'
            AND uic = ANY (ARRAY[12])
    ) AS sub
    JOIN nb_infoprices n ON n.infoprice_id = sub.iinfoprice_id
WHERE
    sub.lasttraded_gain > 0
ORDER BY n.uic, sub.lasttraded_gain_percen DESC
LIMIT 50;

---

WITH
    bounds AS (
        SELECT MAX(lastupdated_at) AS max_ts, MAX(lastupdated_at) - INTERVAL '15 minute' AS min_ts
        FROM nb_infoprices
    ),
    windowed AS (
        SELECT i.uic, i.lasttraded, i.lastupdated_at
        FROM nb_infoprices i
            JOIN bounds b ON i.lastupdated_at >= b.min_ts
            AND i.lastupdated_at <= b.max_ts
    ),
    agg AS (
        SELECT DISTINCT
            ON (uic) uic,
            FIRST_VALUE(lasttraded) OVER (
                PARTITION BY
                    uic
                ORDER BY lastupdated_at ASC
            ) AS first_price,
            FIRST_VALUE(lasttraded) OVER (
                PARTITION BY
                    uic
                ORDER BY lastupdated_at DESC
            ) AS last_price
        FROM windowed
    )
SELECT
    uic,
    last_price,
    first_price,
    (last_price - first_price) AS price_gain,
    (last_price - first_price) / NULLIF(first_price, 0) * 100 AS price_gain_perc
FROM agg
WHERE
    last_price <> first_price
ORDER BY price_gain_perc DESC;

SELECT DISTINCT
    ON (n.uic) n.*,
    sub.lasttraded_gain,
    sub.lasttraded_gain_percen
FROM (
        SELECT
            FIRST_VALUE(infoprice_id) OVER (
                PARTITION BY
                    uic
                ORDER BY lastupdated_at DESC
            ) AS iinfoprice_id, FIRST_VALUE(lasttraded) OVER (
                PARTITION BY
                    uic
                ORDER BY lastupdated_at DESC
            ) - FIRST_VALUE(lasttraded) OVER (
                PARTITION BY
                    uic
                ORDER BY lastupdated_at ASC
            ) AS lasttraded_gain, (
                FIRST_VALUE(lasttraded) OVER (
                    PARTITION BY
                        uic
                    ORDER BY lastupdated_at DESC
                ) - FIRST_VALUE(lasttraded) OVER (
                    PARTITION BY
                        uic
                    ORDER BY lastupdated_at ASC
                )
            ) / NULLIF(
                FIRST_VALUE(lasttraded) OVER (
                    PARTITION BY
                        uic
                    ORDER BY lastupdated_at ASC
                ), 0
            ) * 100 AS lasttraded_gain_percen
        FROM nb_infoprices
        WHERE
            lastupdated_at >= (
                SELECT MAX(lastupdated_at)
                FROM nb_infoprices
            ) - INTERVAL '8440 minute'
    ) AS sub
    JOIN nb_infoprices n ON n.infoprice_id = sub.iinfoprice_id
WHERE
    sub.lasttraded_gain > 0
ORDER BY n.uic, sub.lasttraded_gain_percen DESC
LIMIT 50;