CREATE TABLE advertisement
(
    id                   SERIAL PRIMARY KEY,
    postTime             TIMESTAMP             default current_timestamp,
    endDate              DATE null,
    userId               INT references Users (id),
    addressId            INT references address (id),
    status               VARCHAR(12)  not null default 'pending' CHECK (status IN ('pending', 'posted', 'ended', 'canceled', 'suspended')),
    title                VARCHAR(150) not null,
    lastModificationDate TIMESTAMP             default current_timestamp,
    paymentId            INT references payment (id),
    priceId              INT references price (id),
    objectId             INT references object (id)
);



CREATE TABLE coordinates (
    id SERIAL PRIMARY KEY ,
    latitude DOUBLE PRECISION null,
    longitude DOUBLE PRECISION null,
)


CREATE TABLE address
(
    id            SERIAL PRIMARY KEY,
    country       VARCHAR(100) not null,
    region        VARCHAR(100) not null,
    postalCode    VARCHAR(6)   not null,
    city          VARCHAR(100) not null,
    street        VARCHAR(100) null,
    buildingNum   VARCHAR(10)  not null,
    flatNum       INT null,
    coordinatesId INT references coordinates (id) null,
);


CREATE TABLE payment
(
    id              SERIAL PRIMARY KEY,
    price           NUMERIC(4, 2) not null,
    creationDate    DATE                   default CURRENT_TIMESTAMP,
    advertisementId INT references advertisement (id),
    status          VARCHAR(12)   not null default 'pending' CHECK (status in ('pending', 'ended', 'suspended')),
);