CREATE TABLE object (
id SERIAL PRIMARY KEY,
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



CREATE TABLE photos (
id SERIAL PRIMARY KEY,
objectId INT NOT NULL,
FOREIGN KEY (objectId) REFERENCES flatpol.object (id),
photoURL VARCHAR(1000)
);



CREATE TABLE house (
id INT PRIMARY KEY,
stories INT,
atticSquareFootage FLOAT NULL,
terraceSquareFootage FLOAT NULL,
plotArea FLOAT NULL
);



CREATE TABLE price (
id PRIMARY KEY,
price FLOAT,
rent FLOAT,
media FLOAT,
deposit FLOAT,
typeOFPayment VARCHAR,
typeOfOwner VARCHAR
);