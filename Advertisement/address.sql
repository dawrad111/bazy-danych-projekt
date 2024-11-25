CREATE TABLE flatpol.address (
    id SERIAL PRIMARY KEY,
    country VARCHAR(100) not null,
    region VARCHAR(100) not null ,
    postalCode VARCHAR(6) not null ,
    city VARCHAR(100) not null ,
    street VARCHAR(100) null ,
    buildingNum VARCHAR(10) not null,
    flatNum INT null ,
    coordinatesId INT references flatpol.coordinates(id) ,
)