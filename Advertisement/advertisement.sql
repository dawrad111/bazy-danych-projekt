CREATE TYPE status as ENUM('pending', 'posted', 'ended', 'canceled', 'deleted');

CREATE TABLE flatpol.advertisement (
    id SERIAL PRIMARY KEY,
    postTime TIMESTAMP default current_timestamp,
    endDate DATE null,
    userId INT references flatpol.user(id),
    addressId INT references flatpol.address(id),
    status status not null default 'pending' ,
    title VARCHAR(150) not null,
    lastModificationDate TIMESTAMP default current_timestamp,
    paymentId INT references flatpol.payment(id),
    priceId INT references flatpol.price(id),
    objectId INT references flatpol.object(id),
);