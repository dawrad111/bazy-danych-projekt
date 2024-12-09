CREATE TABLE flatpol.payment (
    id SERIAL PRIMARY KEY,
    price NUMERIC(4,2) not null,
    creationDate DATE default CURRENT_TIMESTAMP,
    advertisementId INT references flatpol.advertisement(id),
    status VARCHAR(12) not null default 'pending' CHECK (status in ('pending', 'ended', 'suspended')),
);

INSERT INTO flatpol.payment (price, advertisementId, status)
VALUES
    (100, 1, 'ended'),
    (50.00, 2, 'pending'),
    (20.00, 3, 'ended'),
    (15.00, 4, 'suspended'),
    (30.00, 5)
RETURNING *;
