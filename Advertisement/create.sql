CREATE TABLE flatpol.advertisement
(
    id                   SERIAL PRIMARY KEY,
    postTime             TIMESTAMP             default current_timestamp,
    endDate              DATE null,
    userId               INT references flatpol.user (id),
    addressId            INT references flatpol.address (id),
    status               VARCHAR(12)  not null default 'pending' CHECK (status IN ('pending', 'posted', 'ended', 'canceled', 'suspended')),
    title                VARCHAR(150) not null,
    lastModificationDate TIMESTAMP             default current_timestamp,
    paymentId            INT references flatpol.payment (id),
    priceId              INT references flatpol.price (id),
    objectId             INT references flatpol.object (id),
);



CREATE TABLE flatpol.coordinates (
    id SERIAL PRIMARY KEY ,
    latitude DOUBLE PRECISION null,
    longitude DOUBLE PRECISION null,
)


CREATE TABLE flatpol.address
(
    id            SERIAL PRIMARY KEY,
    country       VARCHAR(100) not null,
    region        VARCHAR(100) not null,
    postalCode    VARCHAR(6)   not null,
    city          VARCHAR(100) not null,
    street        VARCHAR(100) null,
    buildingNum   VARCHAR(10)  not null,
    flatNum       INT null,
    coordinatesId INT references flatpol.coordinates (id) null,
);


CREATE TABLE flatpol.payment
(
    id              SERIAL PRIMARY KEY,
    price           NUMERIC(4, 2) not null,
    creationDate    DATE                   default CURRENT_TIMESTAMP,
    advertisementId INT references flatpol.advertisement (id),
    status          VARCHAR(12)   not null default 'pending' CHECK (status in ('pending', 'ended', 'suspended')),
);