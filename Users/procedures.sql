--użytkownicy zablokowani

SELECT
    userId, name, surname, email, status, registrationDate
FROM
    Users
WHERE
    status = 'suspended'
ORDER BY
    registrationDate DESC;

-- wszystkie logi danego użytkownika

SELECT
    l.userId, u.name, u.surname, l.activityType, l.time
FROM
    Logs l
JOIN
    Users u ON l.userId = u.userId
WHERE
    u.userId = 1  -- ID konkretnego użytkownika
ORDER BY
    l.time DESC;

-- użytkownicy, którzy logowali się w ciągu ostatnych 7 dni

SELECT userId, name, surname, email, lastLoginDate
FROM Users
WHERE lastLoginDate >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY lastLoginDate DESC;

--niezweryfikowani użytkownicy

SELECT u.userId, u.name, u.surname, u.email, u.phoneNumber, u.registrationDate
FROM Users u
LEFT JOIN "Phone number" pn ON u.userId = pn.userId
LEFT JOIN Email e ON u.userId = e.userId
WHERE u.isVerified = FALSE
  AND (pn.isVerified = FALSE)
  AND (e.isVerified = FALSE);

-- wszystkie logi z ostatnich 24h

SELECT l.id, l.userId, u.name, u.surname, l.activityType, l.time
FROM Logs l
JOIN Users u ON l.userId = u.userId
WHERE l.time >= CURRENT_TIMESTAMP - INTERVAL '1 day'
ORDER BY l.time DESC;

-- liczba użytkowników w każdym statusie (active, suspended itp.)

SELECT status, COUNT(*) AS user_count
FROM Users
GROUP BY status;

-- szczegóły konta użytkownika na podstawie emaila

SELECT userId, name, surname, email, phoneNumber, registrationDate, status
FROM Users
WHERE email = 'example@example.com';

-- wyświetlenie liczby aktywnych użytkowników z podziałem na role

SELECT userType, COUNT(*) AS user_count
FROM Users
WHERE status = 'active'
GROUP BY userType;

-- użytkownicy, którzy nie logowali się w ciągu ostatnich 30 dni

SELECT userId, name, surname, email, lastLoginDate
FROM Users
WHERE lastLoginDate < CURRENT_DATE - INTERVAL '30 days' OR lastLoginDate IS NULL;

-- wyświetlenie 10 najnowszych logowań użytkowników

SELECT l.userId, u.name, u.surname, l.activityType, l.time
FROM Logs l
JOIN Users u ON l.userId = u.userId
WHERE l.activityType = 'login'
ORDER BY l.time DESC
LIMIT 10;

-- policzenie liczby użytkowników zarejestrowanych w ostatnim miesiącu

SELECT COUNT(*) AS registered_last_month
FROM Users
WHERE registrationDate >= CURRENT_DATE - INTERVAL '1 month';