CREATE TABLE flatpol.payment
(
    id              SERIAL PRIMARY KEY,
    price           NUMERIC(4, 2) not null,
    creationDate    DATE                   default CURRENT_TIMESTAMP,
    advertisementId INT references flatpol.advertisement (id),
    status          VARCHAR(12)   not null default 'pending' CHECK (status in ('pending', 'ended', 'suspended')),
);

INSERT INTO flatpol.payment (price, advertisementId, status)
VALUES (100, 1, 'ended'),
       (50.00, 2, 'pending'),
       (20.00, 3, 'ended'),
       (15.00, 4, 'suspended'),
       (30.00, 5) RETURNING *;


CREATE VIEW flatpol.userPaymentsView AS
SELECT u.firstName,
       u.lastName,
       p.price,
       p.creationDate,
       p.status
FROM flatpol.payment p
         JOIN flatpol.advertisement a ON p.advertisementId = a.id
         JOIN flatpol.user u ON a.userId = u.id;

CREATE VIEW flatpol.userPaymentsSortedView AS
SELECT u.firstName,
       u.lastName,
       p.price,
       p.creationDate,
       p.status
FROM flatpol.payment p
         JOIN flatpol.advertisement a ON p.advertisementId = a.id
         JOIN flatpol.user u ON a.userId = u.id
ORDER BY p.price DESC;


-- Shows all payments for a given user
CREATE PROCEDURE flatpol.userPayments(
    @UserId INT
)
    AS
BEGIN
SELECT u.firstName,
       u.lastName,
       p.price,
       p.creationDate,
       p.status
FROM flatpol.payment p
         JOIN flatpol.advertisement a ON p.advertisementId = a.id
         JOIN flatpol.user u ON a.userId = u.id
WHERE u.id = @UserId;
END;


-- Insert a payment for a given advertisement
CREATE PROCEDURE flatpol.insertPayment(
    @Price NUMERIC(4,2),
    @AdvertisementId INT
)
    AS
BEGIN
INSERT INTO flatpol.payment (price, advertisementId)
VALUES (@Price, @AdvertisementId)
END;


-- Update payment values if not null
CREATE PROCEDURE flatpol.updatePayment(
    @Id INT,
    @Price NUMERIC(4,2) = NULL,
    @Status VARCHAR(12) = NULL
)
    AS
BEGIN
UPDATE flatpol.payment
SET price  = COALESCE(@Price, price),
    status = COALESCE(@Status, status)
WHERE id = @Id;
END;

