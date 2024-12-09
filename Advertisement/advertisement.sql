CREATE TABLE flatpol.advertisement (
    id SERIAL PRIMARY KEY,
    postTime TIMESTAMP default current_timestamp,
    endDate DATE null,
    userId INT references flatpol.user(id),
    addressId INT references flatpol.address(id),
    status VARCHAR(12) not null default 'pending' CHECK (status IN ('pending', 'posted', 'ended', 'canceled', 'suspended')) ,
    title VARCHAR(150) not null,
    lastModificationDate TIMESTAMP default current_timestamp,
    paymentId INT references flatpol.payment(id),
    priceId INT references flatpol.price(id),
    objectId INT references flatpol.object(id),
);



INSERT INTO flatpol.advertisement (userId, addressId, status, title, paymentId, priceId, objectId)
VALUES
    (1, 1, 'posted', 'Mieszkanie na sprzedaż', 1, 1, 1),
    (2, 2, 'posted', 'Mieszkanie na wynajem', 2, 2, 2),
    (3, 3, 'posted', 'Dom na sprzedaż', 3, 3, 3),
    (4, 4, 'posted', 'Dom na wynajem', 4, 4, 4),
    (5, 5, 'posted', 'Pokój na wynajem', 5, 5, 5)
RETURNING *;
