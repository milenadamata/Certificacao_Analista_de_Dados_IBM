SELECT * FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas` LIMIT 10

SELECT  hotel, is_canceled, lead_time, arrival_date_year 
from `projeto-cancelamento-hoteleiro.cancelamento.reservas` limit 7

SELECT DISTINCT hotel
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas`

SELECT DISTINCT market_segment 
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas`

SELECT COUNT(*)
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas`

SELECT COUNT(*)
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas`
WHERE arrival_date_year = 2015


SELECT *
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas`
WHERE country = 'ESP' AND lead_time > 10

SELECT COUNT(*)
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas`
WHERE arrival_date_year = 2015 OR arrival_date_year = 2017

SELECT * 
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas`                                      
WHERE customer_type LIKE 'Transient%'

## criei a variavel para data completa
SELECT CONCAT(arrival_date_year,'-', arrival_date_month, '-', arrival_date_day_of_month) AS arrival_date
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas`

## criei tabela com data completa
CREATE OR REPLACE TABLE `projeto-cancelamento-hoteleiro.cancelamento.reservas2` 
AS
SELECT *, CONCAT(arrival_date_year,'-', arrival_date_month, '-', arrival_date_day_of_month) AS arrival_date
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas`


# estacoes do ano
CREATE OR REPLACE TABLE `projeto-cancelamento-hoteleiro.cancelamento.reservas2` as
SELECT *,
    CASE
      WHEN arrival_date_month = 'January' THEN 'Verão'
      WHEN arrival_date_month = 'February' THEN 'Verão'
      WHEN arrival_date_month = 'March' THEN 'Verão'
      WHEN arrival_date_month = 'April' THEN 'Outono'
      WHEN arrival_date_month = 'May' THEN 'Outono'
      WHEN arrival_date_month = 'June' THEN 'Outono'
      WHEN arrival_date_month = 'July' THEN 'Inverno'
      WHEN arrival_date_month = 'August' THEN 'Inverno'
      WHEN arrival_date_month = 'September' THEN 'Inverno'
      WHEN arrival_date_month = 'October' THEN 'Primavera'
      WHEN arrival_date_month = 'November' THEN 'Primavera'
      WHEN arrival_date_month = 'December' THEN 'Primavera'
    END AS arrival_season
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas2`

# Criando segmentação de lead_time
CREATE OR REPLACE TABLE `projeto-cancelamento-hoteleiro.cancelamento.reservas2` AS
SELECT *,
CASE
    WHEN lead_time < 30 THEN 'Curto'
    WHEN lead_time BETWEEN 30 AND 90 THEN 'Médio'
    ELSE 'Long'
    END AS lead_time_segment
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas2`

# converter mes para valor numerico

CREATE OR REPLACE TABLE
  `projeto-cancelamento-hoteleiro.cancelamento.reservas2` AS
SELECT
  *,
  CASE
    WHEN arrival_date_month = 'Janunary' THEN '01'
    WHEN arrival_date_month = 'February' THEN '02'
    WHEN arrival_date_month = 'March' THEN '03'
    WHEN arrival_date_month = 'April   ' THEN '04'
    WHEN arrival_date_month = 'May' THEN '05'
    WHEN arrival_date_month = 'June' THEN '06'
    WHEN arrival_date_month = 'July' THEN '07'
    WHEN arrival_date_month = 'August' THEN '08'
    WHEN arrival_date_month = 'September' THEN '09'
    WHEN arrival_date_month = 'October' THEN '10'
    WHEN arrival_date_month = 'November' THEN '11'
  ELSE
  '12'
END
  AS arrival_date_month_number
FROM
  `projeto-cancelamento-hoteleiro.cancelamento.reservas2`; 

# Concatenando a data com o mes em formato numerico
CREATE OR REPLACE TABLE `projeto-cancelamento-hoteleiro.cancelamento.reservas2` 
AS
SELECT *, CONCAT(arrival_date_year,'-', arrival_date_month_number, '-', arrival_date_day_of_month) AS arrival_date2
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas2` 

# Alterando o tipo para DATE para que essa coluna seja usada nas análises
CREATE OR REPLACE TABLE
  `projeto-cancelamento-hoteleiro.cancelamento.reservas2` AS
SELECT  *, CAST(arrival_date2 AS DATE) AS arrival_date_v3 
FROM `projeto-cancelamento-hoteleiro.cancelamento.reservas2`

# Criando coluna booking_date
CREATE OR REPLACE TABLE
  `projeto-cancelamento-hoteleiro.cancelamento.reservas2` AS
SELECT
  *,
  DATE_SUB(arrival_date_v3, INTERVAL lead_time DAY) AS booking_date
FROM
  `projeto-cancelamento-hoteleiro.cancelamento.reservas2`; 

  