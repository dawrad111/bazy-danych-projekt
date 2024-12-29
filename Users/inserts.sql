INSERT INTO Users (name, surname, passwordHash, emailid, phoneNumberid, lastLoginDate, registrationDate, userType, status, isVerified)
VALUES
('Alice', 'Smith', 'hash1234', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'active', FALSE),
('John', 'Doe', 'hash5678', 2, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'administrator', 'active', TRUE),
('Eva', 'Brown', 'hash91011', 3, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'suspended', FALSE),
('Lucas', 'Johnson', 'hash1213', 4, 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'operator', 'active', TRUE),
('Marta', 'Kowalska', 'hash1415', 5, 5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'active', TRUE),
('Adam', 'Nowak', 'hash1617', 6, 6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'operator', 'active', TRUE),
('Kasia', 'Wójcik', 'hash1819', 7, 7, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'suspended', FALSE),
('Paul', 'White', 'hash2021', 8, 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'active', TRUE),
('Anna', 'Adams', 'hash2223', 9, 9, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'user', 'active', FALSE),
('Peter', 'Smith', 'hash2425', 10, 10, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'administrator', 'active', TRUE);

INSERT INTO Phone_Number (phoneNumber, code, linkExpiredDate, isVerified, verifiedDate)
VALUES
('+48123456789', '123456', CURRENT_TIMESTAMP + INTERVAL '10 minutes', FALSE, NULL),
('+48223456780', '654321', CURRENT_TIMESTAMP + INTERVAL '15 minutes', TRUE, CURRENT_TIMESTAMP),
('+48111122233', '789123', CURRENT_TIMESTAMP + INTERVAL '20 minutes', FALSE, NULL),
('+48333444556', '321789', CURRENT_TIMESTAMP + INTERVAL '5 minutes', TRUE, CURRENT_TIMESTAMP),
('+48555666777', '555666', CURRENT_TIMESTAMP + INTERVAL '30 minutes', TRUE, CURRENT_TIMESTAMP),
('+48666777888', '666777', CURRENT_TIMESTAMP + INTERVAL '12 minutes', TRUE, CURRENT_TIMESTAMP),
('+48777888999', '777888', CURRENT_TIMESTAMP + INTERVAL '25 minutes', FALSE, NULL),
('+48888999000', '888999', CURRENT_TIMESTAMP + INTERVAL '35 minutes', TRUE, CURRENT_TIMESTAMP),
('+48999000111', '999000', CURRENT_TIMESTAMP + INTERVAL '45 minutes', FALSE, NULL),
('+48001122334', '000111', CURRENT_TIMESTAMP + INTERVAL '8 minutes', TRUE, CURRENT_TIMESTAMP);


INSERT INTO Email (email, link, linkExpireDate, isVerified, verifiedDate)
VALUES
('alice.smith@example.com', 'http://example.com/verify1', CURRENT_TIMESTAMP + INTERVAL '1 day', FALSE, NULL),
('john.doe@example.com', 'http://example.com/verify2', CURRENT_TIMESTAMP + INTERVAL '2 days', TRUE, CURRENT_TIMESTAMP),
('eva.brown@example.com', 'http://example.com/verify3', CURRENT_TIMESTAMP + INTERVAL '1 day', FALSE, NULL),
('lucas.j@example.com', 'http://example.com/verify4', CURRENT_TIMESTAMP + INTERVAL '1 day', TRUE, CURRENT_TIMESTAMP),
('marta.k@example.com', 'http://example.com/verify5', CURRENT_TIMESTAMP + INTERVAL '2 days', TRUE, CURRENT_TIMESTAMP),
('adam.nowak@example.com', 'http://example.com/verify6', CURRENT_TIMESTAMP + INTERVAL '3 days', TRUE, CURRENT_TIMESTAMP),
('kasia.wojcik@example.com', 'http://example.com/verify7', CURRENT_TIMESTAMP + INTERVAL '4 days', FALSE, NULL),
('paul.white@example.com', 'http://example.com/verify8', CURRENT_TIMESTAMP + INTERVAL '1 day', TRUE, CURRENT_TIMESTAMP),
('anna.adams@example.com', 'http://example.com/verify9', CURRENT_TIMESTAMP + INTERVAL '2 days', FALSE, NULL),
('peter.smith@example.com', 'http://example.com/verify10', CURRENT_TIMESTAMP + INTERVAL '3 days', TRUE, CURRENT_TIMESTAMP);


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
