--użytkownicy zablokowani
CREATE OR REPLACE VIEW view_suspended_users AS
SELECT
    u.id, u.name, u.surname, e.email , u.status, u.registrationDate
FROM
    Users u
JOIN email e on e.id = u.emailid
WHERE
    status = 'suspended'
ORDER BY
    registrationDate DESC;

-- użytkownicy, którzy logowali się w ciągu ostatnych 7 dni
CREATE OR REPLACE VIEW view_users_logged_last_7_days AS
SELECT u.id, u.name, u.surname, e.email, u.lastLoginDate
FROM Users u 
JOIN email e ON u.emailid = e.id
WHERE lastLoginDate >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY lastLoginDate DESC;

--niezweryfikowani użytkownicy
CREATE OR REPLACE VIEW view_unverified_users AS
SELECT u.id, u.name, u.surname, e.email, pn.phoneNumber, u.registrationDate
FROM Users u
LEFT JOIN  phone_number pn ON u.phonenumberid = pn.id
LEFT JOIN Email e ON u.emailid = e.id
WHERE u.isVerified = FALSE
  AND (pn.isVerified = FALSE)
  AND (e.isVerified = FALSE);

-- wszystkie logi z ostatnich 24h
CREATE OR REPLACE VIEW view_logs_last_24h AS
SELECT l.id, l.userId, u.name, u.surname, l.activityType, l.time
FROM Logs l
JOIN Users u ON l.userid = u.id
WHERE l.time >= CURRENT_TIMESTAMP - INTERVAL '1 day'
ORDER BY l.time DESC;

-- liczba użytkowników w każdym statusie (active, suspended itp.)
CREATE OR REPLACE VIEW view_user_count_by_status AS
SELECT status, COUNT(*) AS user_count
FROM Users
GROUP BY status;

-- wyświetlenie liczby aktywnych użytkowników z podziałem na role
CREATE OR REPLACE VIEW view_active_users_by_role AS
SELECT userType, COUNT(*) AS user_count
FROM Users
WHERE status = 'active'
GROUP BY userType;

-- użytkownicy, którzy nie logowali się w ciągu ostatnich 30 dni
CREATE OR REPLACE VIEW view_inactive_users_last_30_days AS
SELECT u.id, u.name, u.surname, e.email, u.lastLoginDate
FROM Users u
LEFT JOIN email e on u.emailid = e.id
WHERE lastLoginDate < CURRENT_DATE - INTERVAL '30 days' OR lastLoginDate IS NULL;

-- wyświetlenie 10 najnowszych logowań użytkowników
CREATE OR REPLACE VIEW view_latest_user_logins AS
SELECT l.userId, u.name, u.surname, l.activityType, l.time
FROM Logs l
JOIN Users u ON l.userId = u.id
WHERE l.activityType = 'login'
ORDER BY l.time DESC
LIMIT 10;

-- policzenie liczby użytkowników zarejestrowanych w ostatnim miesiącu
CREATE OR REPLACE VIEW view_users_registered_last_month AS
SELECT COUNT(*) AS registered_last_month
FROM Users 
WHERE registrationDate >= CURRENT_DATE - INTERVAL '1 month';