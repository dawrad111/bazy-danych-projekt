CREATE TABLE object (
id SERIAL PRIMARY KEY,
squareFootage FLOAT,
description VARCHAR,
rooms INT,
bathrooms INT,
basementSquareFootage FLOAT NULL,
balconySquareFootage FLOAT NULL,
allowAnimals BOOLEAN,
additionalInfo VARCHAR,
typeId INT NOT NULL,
FOREIGN KEY (typeId) REFERENCES house (id),
floor INT NULL
);