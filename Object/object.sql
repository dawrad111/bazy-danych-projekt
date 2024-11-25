CREATE TABLE object (
id SERIAL PRIMARY KEY,
photosId INT NOT NULL,
FOREIGN KEY (photosId) REFERENCES flatpol.photos (id),
squareFootage FLOAT,
description VARCHAR,
rooms INT,
bathrooms INT,
basementSquareFootage FLOAT NULL,
balconySquareFootage FLOAT NULL,
allowAnimals BOOLEAN,
additional Info VARCHAR,
typeId INT NOT NULL,
FOREIGN KEY (typeId) REFERENCES flatpol.house (id),
floor INT NULL
);