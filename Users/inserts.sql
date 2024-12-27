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


INSERT INTO Users (name, surname, passwordHash, email, phoneNumber, lastLoginDate, registrationDate, userType, status, isVerified)
VALUES
('Alice', 'Smith', 'hash1234', 'alice.smith@example.com', '+48123456789', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'active', FALSE),
('John', 'Doe', 'hash5678', 'john.doe@example.com', '+48223456780', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'administrator', 'active', TRUE),
('Eva', 'Brown', 'hash91011', 'eva.brown@example.com', '+48111122233', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'suspended', FALSE),
('Lucas', 'Johnson', 'hash1213', 'lucas.j@example.com', '+48333444556', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'operator', 'active', TRUE),
('Marta', 'Kowalska', 'hash1415', 'marta.k@example.com', '+48555666777', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'active', TRUE),
('Adam', 'Nowak', 'hash1617', 'adam.nowak@example.com', '+48666777888', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'operator', 'active', TRUE),
('Kasia', 'Wójcik', 'hash1819', 'kasia.wojcik@example.com', '+48777888999', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'suspended', FALSE),
('Paul', 'White', 'hash2021', 'paul.white@example.com', '+48888999000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'active', TRUE),
('Anna', 'Adams', 'hash2223', 'anna.adams@example.com', '+48999000111', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'active', FALSE),
('Peter', 'Smith', 'hash2425', 'peter.smith@example.com', '+48001122334', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'administrator', 'active', TRUE);

INSERT INTO PhoneNumber (userId, phoneNumber, code, linkExpiredDate, isVerified, verifiedDate)
VALUES
(1, '+48123456789', '123456', CURRENT_TIMESTAMP + INTERVAL '10 minutes', FALSE, NULL),
(2, '+48223456780', '654321', CURRENT_TIMESTAMP + INTERVAL '15 minutes', TRUE, CURRENT_TIMESTAMP),
(3, '+48111122233', '789123', CURRENT_TIMESTAMP + INTERVAL '20 minutes', FALSE, NULL),
(4, '+48333444556', '321789', CURRENT_TIMESTAMP + INTERVAL '5 minutes', TRUE, CURRENT_TIMESTAMP),
(5, '+48555666777', '555666', CURRENT_TIMESTAMP + INTERVAL '30 minutes', TRUE, CURRENT_TIMESTAMP),
(6, '+48666777888', '666777', CURRENT_TIMESTAMP + INTERVAL '12 minutes', TRUE, CURRENT_TIMESTAMP),
(7, '+48777888999', '777888', CURRENT_TIMESTAMP + INTERVAL '25 minutes', FALSE, NULL),
(8, '+48888999000', '888999', CURRENT_TIMESTAMP + INTERVAL '35 minutes', TRUE, CURRENT_TIMESTAMP),
(9, '+48999000111', '999000', CURRENT_TIMESTAMP + INTERVAL '45 minutes', FALSE, NULL),
(10, '+48001122334', '000111', CURRENT_TIMESTAMP + INTERVAL '8 minutes', TRUE, CURRENT_TIMESTAMP);


INSERT INTO Email (userId, email, link, linkExpiredDate, isVerified, verifiedDate)
VALUES
(1, 'alice.smith@example.com', 'http://example.com/verify1', CURRENT_TIMESTAMP + INTERVAL '1 day', FALSE, NULL),
(2, 'john.doe@example.com', 'http://example.com/verify2', CURRENT_TIMESTAMP + INTERVAL '2 days', TRUE, CURRENT_TIMESTAMP),
(3, 'eva.brown@example.com', 'http://example.com/verify3', CURRENT_TIMESTAMP + INTERVAL '1 day', FALSE, NULL),
(4, 'lucas.j@example.com', 'http://example.com/verify4', CURRENT_TIMESTAMP + INTERVAL '1 day', TRUE, CURRENT_TIMESTAMP),
(5, 'marta.k@example.com', 'http://example.com/verify5', CURRENT_TIMESTAMP + INTERVAL '2 days', TRUE, CURRENT_TIMESTAMP),
(6, 'adam.nowak@example.com', 'http://example.com/verify6', CURRENT_TIMESTAMP + INTERVAL '3 days', TRUE, CURRENT_TIMESTAMP),
(7, 'kasia.wojcik@example.com', 'http://example.com/verify7', CURRENT_TIMESTAMP + INTERVAL '4 days', FALSE, NULL),
(8, 'paul.white@example.com', 'http://example.com/verify8', CURRENT_TIMESTAMP + INTERVAL '1 day', TRUE, CURRENT_TIMESTAMP),
(9, 'anna.adams@example.com', 'http://example.com/verify9', CURRENT_TIMESTAMP + INTERVAL '2 days', FALSE, NULL),
(10, 'peter.smith@example.com', 'http://example.com/verify10', CURRENT_TIMESTAMP + INTERVAL '3 days', TRUE, CURRENT_TIMESTAMP);


INSERT INTO Logs (userId, activityType, time)
VALUES
(1, 'login', CURRENT_TIMESTAMP),
(2, 'logout', CURRENT_TIMESTAMP),
(3, 'comment', CURRENT_TIMESTAMP),
(4, 'like', CURRENT_TIMESTAMP),
(5, 'like', CURRENT_TIMESTAMP),
(6, 'login', CURRENT_TIMESTAMP),
(7, 'register', CURRENT_TIMESTAMP),
(8, 'comment', CURRENT_TIMESTAMP),
(9, 'login', CURRENT_TIMESTAMP),
(10, 'like', CURRENT_TIMESTAMP);
