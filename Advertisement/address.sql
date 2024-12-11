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

INSERT INTO flatpol.address (country, region, postalCode, city, street, buildingNum, flatNum)
VALUES ('Poland', 'Dolny Śląsk', '50-421', 'Wrocław', 'Na Grobli', '15', 12),
       ('Poland', 'Dolny Śląsk', '50-366', 'Wrocław', 'Grunwaldzka', '59', 3),
       ('Poland', 'Dolny Śląsk', '51-627', 'Wrocław', 'Wróblewskiego', '27', 5),
--     generate more values
       ('Poland', 'Dolny Śląsk', '50-334', 'Wrocław', 'Rozbrat', '7', 10),
       ('Poland', 'Dolny Śląsk', '51-640', 'Wrocław', 'Braci Gierymskich', '45A', 10) RETURNING *;

CREATE VIEW flatpol.addressesView AS
SELECT a.country,
       a.region,
       a.postalCode,
       a.city,
       a.street,
       a.buildingNum,
       a.flatNum,
       c.latitude,
       c.longitude
FROM flatpol.address a
         JOIN flatpol.coordinates c ON a.coordinatesId = c.id;


-- Inset address with coordinates

CREATE PROCEDURE flatpol.insertAddressWithCoordinates(
    @Country VARCHAR(100),
    @Region VARCHAR(100),
    @PostalCode VARCHAR(6),
    @City VARCHAR(100),
    @Street VARCHAR(100),
    @BuildingNum VARCHAR(10),
    @FlatNum INT,
    @Latitude DOUBLE PRECISION,
    @Longitude DOUBLE PRECISION
)
    AS
DECLARE
@CoordinatesId INT;
BEGIN
BEGIN
TRANSACTION;

INSERT INTO flatpol.coordinates (latitude, longitude)
VALUES (@Latitude, @Longitude) RETURNING coordinates.id
INTO @CoordinatesId

INSERT INTO flatpol.address (country, region, postalCode, city, street, buildingNum, flatNum, coordinatesId)
VALUES (@Country, @Region, @PostalCode, @City, @Street, @BuildingNum, @FlatNum, @CoordinatesId);

COMMIT;
END;

