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
    RACE_NUMBER INT NOT NULL CHECK (RACE_NUMBER > 0),
    RACE_SEASON_YEAR INT NOT NULL CHECK (RACE_SEASON_YEAR > 0),
    RACE_DATE TIMESTAMP NOT NULL,
    COUNTRY_LOCATION_CODE VARCHAR(3) NOT NULL REFERENCES COUNTRIES(CODE),
    COUNTRY_LOCATION_PLACE VARCHAR(64) NOT NULL,
    UNIQUE (RACE_NUMBER, RACE_SEASON_YEAR)

);

CREATE TABLE DRIVERS (
    id SERIAL PRIMARY KEY,
    GIVEN_NAME VARCHAR(64) NOT NULL,
    SURNAME VARCHAR(64) NOT NULL,
    BIRTHDAY TIMESTAMP NOT NULL,
    NATIONALITY_CODE VARCHAR(3) NOT NULL REFERENCES COUNTRIES(CODE),
    WINNINGS SMALLINT NOT NULL CHECK (WINNINGS >= 0)
);

CREATE TABLE TEAMS (
    id SERIAL PRIMARY KEY,
    TITLE VARCHAR(64) NOT NULL UNIQUE
);

CREATE TABLE TEAM_COMPOSITIONS (
    id SERIAL PRIMARY KEY,
    TEAM_ID INT NOT NULL REFERENCES TEAMS(id),
    SEASON_YEAR INT NOT NULL CHECK (SEASON_YEAR > 0),
    MOTOR_PRODUCER_NAME VARCHAR(64) NOT NULL,
    NATIONALITY_CODE VARCHAR(3) NOT NULL REFERENCES COUNTRIES(CODE),
    MAIN_DRIVER_1_ID INT NOT NULL REFERENCES DRIVERS(id),
    MAIN_DRIVER_1_NUMBER VARCHAR(16) NOT NULL,
    MAIN_DRIVER_2_ID INT NOT NULL REFERENCES DRIVERS(id),
    MAIN_DRIVER_2_NUMBER VARCHAR(16) NOT NULL,
    RESERVE_DRIVER_ID INT NOT NULL REFERENCES DRIVERS(id),
    UNIQUE (TEAM_ID, SEASON_YEAR),
    CHECK (
        MAIN_DRIVER_1_ID != MAIN_DRIVER_2_ID
        AND MAIN_DRIVER_1_ID != RESERVE_DRIVER_ID
        AND MAIN_DRIVER_2_ID != RESERVE_DRIVER_ID
    )
);

CREATE TABLE RESULTS (
    id SERIAL PRIMARY KEY,
    DRIVER_ID INT NOT NULL REFERENCES DRIVERS(id),
    GRAN_PRIX_ID INT NOT NULL REFERENCES CHAMPIONSHIP_CALENDARS(id),
    DRIVER_PLACE SMALLINT NOT NULL CHECK (DRIVER_PLACE > 0),
    DRIVER_SCORE SMALLINT NOT NULL CHECK (DRIVER_SCORE >= 0),
    DRIVER_TIME TIME,
    DRIVER_DISQUALIFIED_DESCRIPTION TEXT CHECK (
    (DRIVER_TIME IS NOT NULL AND DRIVER_DISQUALIFIED_DESCRIPTION IS NULL)
    OR
    (DRIVER_TIME IS NULL AND DRIVER_DISQUALIFIED_DESCRIPTION IS NOT NULL)),
    DRIVER_LAPS_WON SMALLINT NOT NULL CHECK (DRIVER_LAPS_WON >= 0),
    UNIQUE (DRIVER_ID, GRAN_PRIX_ID)
);
    
