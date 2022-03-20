-- Keep a log of any SQL queries you execute as you solve the mystery.

/*
CRIME NOTES:

Date 7/28/20
Location: Chamberlin St
Time: 10:15 AM




-- END OF CRIME NOTES --*/

/* Starting point */
SELECT  description
FROM    crime_scene_reports
WHERE   month = 7
        AND day = 28
        AND street = "Chamberlin Street";

/* Witnesses who mentioned "courthouse"*/
SELECT  name, transcript
FROM    interviews
WHERE   transcript
        LIKE "%courthouse%"
        AND month = "7";
-- Ruth: 10 min of theft, theif car parking lot courthouse. SECURTIY FOOTAGE
-- Eugene: morning, ATM Fifer Street, thief withdrew money
-- Raymond: Was on call < min, thief asked on phone to buy flight next morning from Fiftyville


/* Plate @ courthosue - time, date, & location */
SELECT  year, month, day, hour, license_plate
FROM    courthouse_security_logs
WHERE   year = 2020
        AND month = 7
        AND day = 29
        AND hour < 12;
-- 2020 | 7 | 29 | 8 | 2HB7G9N
-- 2020 | 7 | 29 | 8 | B3VSJVF
-- 2020 | 7 | 29 | 8 | IH61GO8
-- 2020 | 7 | 29 | 8 | 8BB36NX
-- 2020 | 7 | 29 | 8 | C4559Y9
-- 2020 | 7 | 29 | 8 | 2001OV9
-- 2020 | 7 | 29 | 8 | GW362R6
-- 2020 | 7 | 29 | 8 | 106OW2W
-- 2020 | 7 | 29 | 9 | 97O6H62
-- 2020 | 7 | 29 | 9 | 878Z799
-- 2020 | 7 | 29 | 9 | P45A66L
-- 2020 | 7 | 29 | 9 | DVS39US
-- 2020 | 7 | 29 | 9 | 1FBL6TH
-- 2020 | 7 | 29 | 10 | FQUFJ16
-- 2020 | 7 | 29 | 10 | 64I1286
-- 2020 | 7 | 29 | 10 | WR2G758
-- 2020 | 7 | 29 | 11 | 4963D92
-- 2020 | 7 | 29 | 11 | S5EI3B0
-- 2020 | 7 | 29 | 11 | 594IBK6
-- 2020 | 7 | 29 | 11 | Y18DLY3


/* Flight city name  */
SELECT id, abbreviation, full_name
FROM airports
WHERE city = "Fiftyville";
-- CSF | Fiftyville Regional Airport

/* Flights leaving next morning after crime day*/
SELECT  id
FROM    flights
WHERE   year = 2020
        AND month = 7
        AND day = 29
        AND hour < 12;
-- id
-- 36
-- 43


/* (1) ATM Transactions time, date, & location */
SELECT  name, phone_number, passport_number, license_plate
        FROM bank_accounts
        JOIN atm_transactions
        ON atm_transactions.account_number = bank_accounts.account_number
        JOIN people
        ON people.id = bank_accounts.person_id
WHERE   atm_transactions.year = 2020
        AND atm_transactions.month = 7
        AND atm_transactions.day = 28
        AND atm_transactions.atm_location = "Fifer Street"
        AND atm_transactions.transaction_type = "withdraw";
-- name | phone_number | passport_number | license_plate
-- Ernest | (367) 555-5533 | 5773159633 | 94KL13X
-- Russell | (770) 555-1861 | 3592750733 | 322W7JE
-- Roy | (122) 555-4581 | 4408372428 | QX4YZN3
-- Bobby | (826) 555-1652 | 9878712108 | 30G67EN
-- Elizabeth | (829) 555-5269 | 7049073643 | L93JTIZ
-- Danielle | (389) 555-5198 | 8496433585 | 4328GD8
-- Madison | (286) 555-6063 | 1988161715 | 1106N58
-- Victoria | (338) 555-6650 | 9586786673 | 8X428L0


/* (2) Calls less than a minute */
SELECT  name, caller, duration
FROM    people
        JOIN phone_calls
        ON phone_calls.caller = people.phone_number
WHERE   year = 2020
        AND month = 7
        AND day = 28
        AND duration < 60;
-- name | caller | duration
-- Roger | (130) 555-0289 | 51
-- Evelyn | (499) 555-9472 | 36
-- Ernest | (367) 555-5533 | 45
-- Evelyn | (499) 555-9472 | 50
-- Madison | (286) 555-6063 | 43
-- Russell | (770) 555-1861 | 49
-- Kimberly | (031) 555-6622 | 38
-- Bobby | (826) 555-1652 | 55
-- Victoria | (338) 555-6650 | 54

/* (3) Who left the courhouse in the morning */
SELECT  name, courthouse_security_logs.license_plate
FROM    people
        JOIN courthouse_security_logs
        ON courthouse_security_logs.license_plate = people.license_plate
WHERE   year = 2020
        AND month = 7
        AND day = 28
        AND hour < 12
        AND activity = "exit"
ORDER BY name;
-- Alice | 1M92998
-- Amber | 6P58WS2
-- Andrew | W2CT78U
-- Berthold | 4V16VO0
-- Carolyn | P14PE2Q
-- Danielle | 4328GD8
-- Debra | 47MEFVA
-- Donna | 8LLB02B
-- Elizabeth | L93JTIZ
-- Ernest | 94KL13X
-- Evelyn | 0NTHK55
-- George | L68E5I0
-- Jordan | HW0488P
-- Joshua | 1FBL6TH
-- Madison | 1106N58
-- Martha | O784M2U
-- Michael | HOD8639
-- Patrick | 5P2BI95
-- Peter | N507616
-- Rachel | 7Z8B130
-- Ralph | 3933NUH
-- Roger | G412CB7
-- Russell | 322W7JE
-- Wayne | D965M59


/* Intersect (1)(2) and (3)
The witness account of time of atm visit, phone call,
and courthouse parking lot sighting*/
SELECT  name,
        phone_number
FROM    bank_accounts
        JOIN atm_transactions
        ON  atm_transactions.account_number = bank_accounts.account_number
        JOIN people
        ON  people.id = bank_accounts.person_id
WHERE   atm_transactions.year = 2020
        AND atm_transactions.month = 7
        AND atm_transactions.day = 28
        AND atm_transactions.atm_location = "Fifer Street"
        AND atm_transactions.transaction_type = "withdraw"
INTERSECT
SELECT  name,
        caller
FROM    people
        JOIN phone_calls
        ON  phone_calls.caller = people.phone_number
WHERE   year = 2020
        AND month = 7
        AND day = 28
        AND duration < 60
        AND license_plate IN (SELECT courthouse_security_logs.license_plate
                                FROM    people
                                        JOIN courthouse_security_logs
                                        ON courthouse_security_logs.license_plate = people.license_plate
                                WHERE   year = 2020
                                        AND month = 7
                                        AND day = 28
                                        AND activity = "exit");
-- name | phone_number
-- Ernest | (367) 555-5533
-- Madison | (286) 555-6063
-- Russell | (770) 555-1861


/* Get passport info with Intersect above */
SELECT name, passport_number
FROM people
WHERE name IN (SELECT  name
        FROM    bank_accounts
                JOIN atm_transactions
                ON  atm_transactions.account_number = bank_accounts.account_number
                JOIN people
                ON  people.id = bank_accounts.person_id
        WHERE   atm_transactions.year = 2020
                AND atm_transactions.month = 7
                AND atm_transactions.day = 28
                AND atm_transactions.atm_location = "Fifer Street"
                AND atm_transactions.transaction_type = "withdraw"
        INTERSECT
        SELECT  name
        FROM    people
                JOIN phone_calls
                ON  phone_calls.caller = people.phone_number
        WHERE   year = 2020
                AND month = 7
                AND day = 28
                AND duration < 60
                AND license_plate IN (SELECT courthouse_security_logs.license_plate
                                        FROM    people
                                                JOIN courthouse_security_logs
                                                ON courthouse_security_logs.license_plate = people.license_plate
                                        WHERE   year = 2020
                                                AND month = 7
                                                AND day = 28
                                                AND activity = "exit"));
-- name | passport_number
-- Madison | 1988161715
-- Russell | 3592750733
-- Ernest | 5773159633

/* Determine if suspect took flight next day, get the seat number & flight id, if applicable */
SELECT  seat, flight_id
FROM    passengers
        JOIN flights
        ON flights.id = passengers.flight_id
WHERE   passport_number = "1988161715"
        AND year = 2020
        AND month = 7
        AND day = 29
        AND hour < 12;

SELECT  seat, hour
FROM    passengers
        JOIN flights
        ON flights.id = passengers.flight_id
WHERE   passport_number = "3592750733"
        AND year = 2020
        AND month = 7
        AND day = 29
        AND hour < 12;

SELECT  seat, hour
FROM    passengers
        JOIN flights
        ON flights.id = passengers.flight_id
WHERE   passport_number = "5773159633"
        AND year = 2020
        AND month = 7
        AND day = 29
        AND hour < 12;
-- seat | flight_id
-- 6D | 36
-- seat | hour
-- 4A | 8

/* Recall the flight numbers*/
/* Flights leaving next morning after crime day*/
SELECT  id
FROM    flights
WHERE   year = 2020
        AND month = 7
        AND day = 29
        AND hour < 12;
-- id
-- 36
-- 43

/*SUSPECT: ERNEST*/

/* Where's Ernie going on his flight?*/
SELECT  city as destination
FROM    airports
WHERE   id = (  SELECT destination_airport_id
                FROM flights
                WHERE id =36);
                -- destination
                -- London

SELECT  name
FROM    people
WHERE   phone_number IN (SELECT receiver
                         FROM   phone_calls
                         WHERE  year = 2020
                                AND month = 7
                                AND day = 28
                                AND duration < 60
                                AND caller = ( SELECT phone_number
                                                FROM people
                                                WHERE name = "Ernest"));
/*ACCOMPLICE: BERTHOLD*/
