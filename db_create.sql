/*
    Килеев Сергей Игоревич
    Вариант №2
    Описание соревнования автогонок класса Формула-1. Включает в себя: календарь чемпионата, список автогонщиков, составы команд, результаты соревнований. Каждая запись в календаре чемпионата состоит из: названия гран-при, её номера среди других гран-при, даты проведения, страны проведения и места проведения. Каждый элемент списка автогонщиков состоит из: фамилии, имени, даты рождения, страны и количества побед гонщика. Составы команд характеризуются: названием команды, названием производителя мотора, двумя основными автогонщиками с номерами их машин, одного запасного автогонщика без номера машины, страны происхождения команды. Результаты соревнований представляют собой информацию по каждому автогонщику и каждому гран-при о месте, занятом данным автогонщиком на данном гран-при, количестве заработанных им очков на данном гран-при, времени, затраченном им на данную гонку или причине его схода, количестве кругов лидирования данного гонщика в данном гран-при.
    В одной и той же стране может проводиться несколько гран-при в один и тот же год. 
    Составы команд не могут меняться в течение года.
*/

CREATE TABLE COUNTRIES (
    id SERIAL PRIMARY KEY,
    CODE VARCHAR(3) NOT NULL UNIQUE,
    FULL_NAME VARCHAR(64) NOT NULL
); 

CREATE TABLE CHAMPIONSHIP_CALENDARS (
    id SERIAL PRIMARY KEY,
    RACE_NAME VARCHAR(64) NOT NULL,
    RACE_NUMBER INT NOT NULL UNIQUE,
    RACE_DATE TIMESTAMP NOT NULL,
    COUNTRY_LOCATION_CODE VARCHAR(3) NOT NULL REFERENCES COUNTRIES(CODE),
    COUNTRY_LOCATION_PLACE VARCHAR(64) NOT NULL
);

CREATE TABLE DRIVERS (
    id SERIAL PRIMARY KEY,
    GIVEN_NAME VARCHAR(64) NOT NULL,
    SURNAME VARCHAR(64) NOT NULL,
    BIRTHDAY TIMESTAMP NOT NULL,
    NATIONALITY_CODE VARCHAR(3) NOT NULL REFERENCES COUNTRIES(CODE),
    WINNINGS SMALLINT NOT NULL
);

CREATE TABLE TEAMS (
    id SERIAL PRIMARY KEY,
    TITLE VARCHAR(64) NOT NULL,
    MOTOR_PRODUCER_NAME VARCHAR(64) NOT NULL,
    NATIONALITY_CODE VARCHAR(3) NOT NULL REFERENCES COUNTRIES(CODE),
    FIRST_DRIVER_ID INT NOT NULL UNIQUE REFERENCES DRIVERS(id),
    FIRST_DRIVER_NUMBER_PLATE VARCHAR(16) NOT NULL,
    SECOND_DRIVER_ID INT NOT NULL UNIQUE REFERENCES DRIVERS(id) CHECK (SECOND_DRIVER_ID != FIRST_DRIVER_ID),
    SECOND_DRIVER_NUMBER_PLATE VARCHAR(16) NOT NULL,
    THIRD_DRIVER_ID INT NOT NULL UNIQUE REFERENCES DRIVERS(id) CHECK (THIRD_DRIVER_ID != FIRST_DRIVER_ID AND THIRD_DRIVER_ID != SECOND_DRIVER_ID),
    SEASON_YEAR INT NOT NULL,
    UNIQUE (TITLE, SEASON_YEAR)
);

CREATE TABLE RESULTS (
    id SERIAL PRIMARY KEY,
    DRIVER_ID INT NOT NULL REFERENCES DRIVERS(id),
    GRAN_PRIX_ID INT NOT NULL REFERENCES CHAMPIONSHIP_CALENDARS(id),
    DRIVER_PLACE SMALLINT NOT NULL,
    DRIVER_SCORE SMALLINT NOT NULL,
    DRIVER_TIME TIME,
    DRIVER_DISQUALIFIED_DESCRIPTION TEXT CHECK (DRIVER_TIME IS NULL OR DRIVER_TIME = '00:00:00'),
    DRIVER_LAPS_WON SMALLINT NOT NULL
);
    
