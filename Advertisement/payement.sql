CREATE TABLE payment
(
    id              SERIAL PRIMARY KEY,
    price           NUMERIC(4, 2) not null,
    creationDate    DATE                   default CURRENT_TIMESTAMP,
    status          VARCHAR(12)   not null default 'pending' CHECK (status in ('pending', 'ended', 'suspended')),
    advertisementId INT NOT NULL REFERENCES advertisement(id);
)
INSERT INTO payment (price, status,advertisementId)
VALUES (100, 'ended',1),
       (50.00, 'pending',2),
       (20.00, 'ended',2),
       (15.00, 'suspended',3),
       (30.00,,4) RETURNING *;


UPDATE payment
SET advertisementid = advertisement.id 
FROM advertisement
WHERE advertisement.paymentid = payment.id
-- CREATE VIEW userPaymentsView AS
-- SELECT u.name,
--        u.surName,
--        p.price,
--        p.creationDate,
--        p.status
-- FROM payment p
--          JOIN advertisement a ON p.id = a.paymentId
--          JOIN users u ON a.userId = u.id;

-- CREATE VIEW userPaymentsSortedView AS
-- SELECT u.name,
--        u.surName,
--        p.price,
--        p.creationDate,
--        p.status
-- FROM payment p
--          JOIN advertisement a ON p.id = a.paymentId
--          JOIN users u ON a.userId = u.id
-- ORDER BY p.price DESC;


-- Shows all payments for a given user
CREATE PROCEDURE userPayments(
    @UserId INT
)
    AS
BEGIN
SELECT u.firstName,
       u.lastName,
       p.price,
       p.creationDate,
       p.status
FROM payment p
         JOIN advertisement a ON p.advertisementId = a.id
         JOIN user u ON a.userId = u.id
WHERE u.id = @UserId;
END;


-- Insert a payment for a given advertisement
CREATE PROCEDURE insertPayment(
    @Price NUMERIC(4,2),
    @AdvertisementId INT
)
    AS
BEGIN
INSERT INTO payment (price, advertisementId)
VALUES (@Price, @AdvertisementId)
END;


-- Update payment values if not null
CREATE PROCEDURE updatePayment(
    @Id INT,
    @Price NUMERIC(4,2) = NULL,
    @Status VARCHAR(12) = NULL
)
    AS
BEGIN
UPDATE payment
SET price  = COALESCE(@Price, price),
    status = COALESCE(@Status, status)
WHERE id = @Id;
END;

