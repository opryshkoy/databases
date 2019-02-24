DROP TABLE IF EXISTS RF, CITY, SERV, SUBSCRIBERS;

-- 2.1.1 

CREATE TABLE RF (

rf_id SERIAL PRIMARY KEY,

rf_dev VARCHAR (128) NOT NULL

);

--2.1.2

CREATE TABLE CITY (

city_id SERIAL PRIMARY KEY,

city_dev VARCHAR (128) NOT NULL

);

--2.1.3

CREATE TABLE SERV (

serv_id SERIAL PRIMARY KEY,

serv_dev VARCHAR (128) NOT NULL

);

--2.1.4

CREATE TABLE SUBSCRIBERS (

subs_id SERIAL PRIMARY KEY,

rf_id SERIAL REFERENCES RF (rf_id),

city_id SERIAL REFERENCES CITY (city_id),

serv_id SERIAL REFERENCES SERV (serv_id),

base NUMERIC,

new NUMERIC,

churn NUMERIC,

revenue MONEY,

arpu NUMERIC

);

--2.2.1

INSERT INTO RF (rf_id, rf_dev) VALUES

('1603', 'Бурятский'),

('1605', 'Алтайский'),

('1606', 'Красноярский');

--2.2.2

INSERT INTO CITY (city_id, city_dev) VALUES

('16031', 'Улан-Удэ'),

('16032', 'Чита'),

('16051', 'Барнаул'),

('16052', 'Горноалтайск'),

('16061', 'Красноярск'),

('16062', 'Абакан');

--2.2.3

INSERT INTO SERV (serv_id, serv_dev) VALUES

('1', 'ОТА'),

('2', 'ШПД'),

('3', 'ИТВ');

--2.2.4

INSERT INTO SUBSCRIBERS (subs_id, rf_id, city_id, serv_id, base, new, churn, revenue, arpu) VALUES

('1', '1603', '16031', '1', '46705', '209', '555', '8747', '187'),

('2', '1603', '16031', '2', '46593', '922', '574', '17496', '376'),

('3', '1603', '16031', '3', '25333', '727', '307', '6101', '241'),

('4', '1603', '16032', '1', '31136', '140', '370', '5832', '187'),

('5', '1603', '16032', '2', '31062', '614', '382', '11664', '376'),

('6', '1603', '16032', '3', '16889', '484', '205', '4067', '241'),

('7', '1605', '16051', '1', '211131', '586', '2024', '43878', '208'),

('8', '1605', '16051', '2', '144895', '1588', '1318', '49166', '339'),

('9', '1605', '16051', '3', '60379', '1147', '830', '13239', '219'),

('10', '1605', '16052', '1', '140754', '390', '1349', '29252', '208'),

('11', '1605', '16052', '2', '96596', '1058', '878', '32777', '339'),

('12', '1605', '16052', '3', '40252', '764', '554', '8826', '219'),

('13', '1606', '16061', '1', '172351', '278', '1819', '39158', '227'),

('14', '1606', '16061', '2', '138470', '2211', '2332', '52487', '379'),

('15', '1606', '16061', '3', '65377', '1632', '1337', '15225', '233'),

('16', '1606', '16062', '1', '114900', '186', '1213', '26105', '227'),

('17', '1606', '16062', '2', '92313', '1474', '1554', '34991', '379'),

('18', '1606', '16062', '3', '43584', '1088', '891', '10150', '233');


-- 3.1 Вывести список названий филиалов и количество абонентов в этих филиалах 

SELECT rf_dev, SUM (base) as SUBS

FROM RF

JOIN SUBSCRIBERS

ON RF.rf_id=SUBSCRIBERS.rf_id

GROUP BY rf_dev;

-- 3.2 Вывести список названий городов, в которых более 2000 новых абонентов 

SELECT city_dev, SUM (new) as newabns

FROM CITY

JOIN SUBSCRIBERS

ON CITY.city_id=SUBSCRIBERS.city_id

GROUP BY city_dev

HAVING SUM (new) >2000;

-- 3.3 Вывести среднее арпу по услуге ШПД 

SELECT AVG (arpu)::numeric(10,0) as avg_arpu, serv_dev

FROM SUBSCRIBERS

JOIN SERV

ON SUBSCRIBERS.serv_id=SERV.serv_id

WHERE SERV.serv_id = 2

GROUP BY serv_dev;

-- 3.4 Вывести сумму выручки по услуге ИТВ в Алтайском филиале 

SELECT rf_dev, SUM (revenue) as rev_tv

FROM SUBSCRIBERS

JOIN RF

ON RF.rf_id=SUBSCRIBERS.rf_id

WHERE serv_id=3 and RF.rf_id=1605

GROUP BY rf_dev;

-- 3.5 Вывести арпу по всем услугам в Барнауле 

SELECT city_dev, serv_dev, arpu

FROM SUBSCRIBERS

JOIN CITY

ON CITY.city_id=SUBSCRIBERS.city_id

JOIN SERV

ON SERV.serv_id=SUBSCRIBERS.serv_id

WHERE CITY.city_id=16051;

--3.6 Вывести город с минимальным оттоком абонентов 

WITH min_churn

AS (

SELECT city_dev, SUM (churn) as churn

FROM CITY

JOIN SUBSCRIBERS

ON CITY.city_id=SUBSCRIBERS.city_id

GROUP BY city_dev

ORDER BY churn ASC

)

SELECT * FROM min_churn

WHERE churn IN (

SELECT churn

FROM min_churn

LIMIT 1

);

-- 3.7 Вывести услугу с максимальной выручкой 

WITH max_revenue

AS (

SELECT serv_dev, SUM (revenue) as revenue

FROM SERV

JOIN SUBSCRIBERS

ON SERV.serv_id=SUBSCRIBERS.serv_id

GROUP BY serv_dev

ORDER BY revenue DESC

)

SELECT * FROM max_revenue

WHERE revenue IN (

SELECT revenue

FROM max_revenue

LIMIT 1

);

-- 3.8 Вывести список городов и суммарную выручку по тем городам, где арпу по услуге ОТА > 200

SELECT city_dev, SUM (revenue)

FROM SUBSCRIBERS

JOIN CITY

ON CITY.city_id=SUBSCRIBERS.city_id

WHERE SUBSCRIBERS.city_id IN (

SELECT SUBSCRIBERS.city_id

FROM SUBSCRIBERS

WHERE serv_id=1

and arpu>200)

GROUP BY city_dev;

-- 3.9 Вывести среднее arpu по услуге ШПД только по тем городам, где отток абонентов по услуге ШПД < 1000

WITH avg_arpu

AS (

SELECT city_dev, serv_dev, arpu

FROM SUBSCRIBERS

JOIN CITY

ON CITY.city_id=SUBSCRIBERS.city_id

JOIN SERV

ON SUBSCRIBERS.serv_id=SERV.serv_id

WHERE SERV.serv_id=2 and churn<1000

)

SELECT AVG (arpu)::numeric(10,0) as avg_arpu

FROM avg_arpu;

--3.10 Вывести среднюю абонентскую базу по услуге ИТВ по тем региональным филиалам, где арпу ИТВ > 230

WITH avg_base

AS (

SELECT base

FROM SUBSCRIBERS

WHERE serv_id=3 and arpu>230

GROUP BY base

)

SELECT AVG (base)::numeric(10,0) as avg_base

FROM avg_base;
