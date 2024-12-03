INSERT INTO Users (
    name, surname, passwordHash, email, phoneNumber, lastLoginDate, 
    registrationDate, userType, status, isVerified
) VALUES (
    'Alice', 'Smith', 'example_hash', 'alice.smith@example.com', 
    '+48123456789', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
    'user', 'active', FALSE
);

INSERT INTO "Phone number" (
    userId, phoneNumber, code, codeExpiredDate, isVerified, VerifiedDate
) VALUES (
    1, '+48123456789', '123456', 
    CURRENT_TIMESTAMP + INTERVAL '10 minutes', FALSE, NULL
);

INSERT INTO Email (
    userId, email, link, linkExpiredDate, isVerified, verifiedDate
) VALUES (
    1, 'alice.smith@example.com', 'http://example.com/verify_email', 
    CURRENT_TIMESTAMP + INTERVAL '1 day', FALSE, NULL
);

INSERT INTO Logs (
    userId, activityType, time
) VALUES (
    1, 'login', CURRENT_TIMESTAMP
);


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

