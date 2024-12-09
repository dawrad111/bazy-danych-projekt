CREATE TABLE flatpol.address (
    id SERIAL PRIMARY KEY,
    country VARCHAR(100) not null,
    region VARCHAR(100) not null ,
    postalCode VARCHAR(6) not null ,
    city VARCHAR(100) not null ,
    street VARCHAR(100) null ,
    buildingNum VARCHAR(10) not null,
    flatNum INT null ,
    coordinatesId INT references flatpol.coordinates(id) null,
);

    INSERT INTO flatpol.address (country, region, postalCode, city, street, buildingNum, flatNum)
VALUES
    ('Poland', 'Dolny Śląsk', '50-421', 'Wrocław', 'Na Grobli', '15', 12),
    ('Poland', 'Dolny Śląsk', '50-366', 'Wrocław', 'Grunwaldzka', '59', 3),
    ('Poland', 'Dolny Śląsk', '51-627', 'Wrocław', 'Wróblewskiego', '27', 5),
--     generate more values
    ('Poland', 'Dolny Śląsk', '50-334', 'Wrocław', 'Rozbrat', '7', 10),
    ('Poland', 'Dolny Śląsk', '51-640', 'Wrocław', 'Braci Gierymskich', '45A', 10)
RETURNING *;



SELECT * FROM flatpol.address;
