CREATE TYPE payementStatus as ENUM('pending', 'ended', 'canceled');

CREATE TABLE flatpol.payment (
    id SERIAL PRIMARY KEY,
    price NUMERIC(4,2) not null,
    creationDate DATE default CURRENT_TIMESTAMP,
    advertisementId INT references flatpol.advertisement(id),
    status payementStatus not null default 'pending',
)