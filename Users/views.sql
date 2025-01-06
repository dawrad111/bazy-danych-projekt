--użytkownicy zablokowani
CREATE OR REPLACE VIEW suspended_users AS
SELECT
    userId, name, surname, email, status, registrationDate
FROM
    Users
WHERE
    status = 'suspended'
ORDER BY
    registrationDate DESC;

-- użytkownicy, którzy logowali się w ciągu ostatnych 7 dni
CREATE OR REPLACE VIEW users_logged_last_7_days AS
SELECT userId, name, surname, email, lastLoginDate
FROM Users
WHERE lastLoginDate >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY lastLoginDate DESC;

--niezweryfikowani użytkownicy
CREATE OR REPLACE VIEW unverified_users AS
SELECT u.userId, u.name, u.surname, u.email, u.phoneNumber, u.registrationDate
FROM Users u
LEFT JOIN "Phone number" pn ON u.userId = pn.userId
LEFT JOIN Email e ON u.userId = e.userId
WHERE u.isVerified = FALSE
  AND (pn.isVerified = FALSE)
  AND (e.isVerified = FALSE);

-- wszystkie logi z ostatnich 24h
CREATE OR REPLACE VIEW logs_last_24h AS
SELECT l.id, l.userId, u.name, u.surname, l.activityType, l.time
FROM Logs l
JOIN Users u ON l.userId = u.userId
WHERE l.time >= CURRENT_TIMESTAMP - INTERVAL '1 day'
ORDER BY l.time DESC;

-- liczba użytkowników w każdym statusie (active, suspended itp.)
CREATE OR REPLACE VIEW user_count_by_status AS
SELECT status, COUNT(*) AS user_count
FROM Users
GROUP BY status;

-- wyświetlenie liczby aktywnych użytkowników z podziałem na role
CREATE OR REPLACE VIEW active_users_by_role AS
SELECT userType, COUNT(*) AS user_count
FROM Users
WHERE status = 'active'
GROUP BY userType;

-- użytkownicy, którzy nie logowali się w ciągu ostatnich 30 dni
CREATE OR REPLACE VIEW inactive_users_last_30_days AS
SELECT userId, name, surname, email, lastLoginDate
FROM Users
WHERE lastLoginDate < CURRENT_DATE - INTERVAL '30 days' OR lastLoginDate IS NULL;

-- wyświetlenie 10 najnowszych logowań użytkowników
CREATE OR REPLACE VIEW latest_user_logins AS
SELECT l.userId, u.name, u.surname, l.activityType, l.time
FROM Logs l
JOIN Users u ON l.userId = u.userId
WHERE l.activityType = 'login'
ORDER BY l.time DESC
LIMIT 10;

-- policzenie liczby użytkowników zarejestrowanych w ostatnim miesiącu
CREATE OR REPLACE VIEW users_registered_last_month AS
SELECT COUNT(*) AS registered_last_month
FROM Users
WHERE registrationDate >= CURRENT_DATE - INTERVAL '1 month';