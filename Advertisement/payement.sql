CREATE TABLE flatpol.payment (
    id SERIAL PRIMARY KEY,
    price NUMERIC(4,2) not null,
    creationDate DATE default CURRENT_TIMESTAMP,
    advertisementId INT references flatpol.advertisement(id),
    status VARCHAR(12) not null default 'pending' CHECK (status in ('pending', 'ended', 'suspended')),
)