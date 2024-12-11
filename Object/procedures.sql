--ogloszenia z domami i zdjęciami
CREATE VIEW selectAdsHousesPhotos AS
SELECT a.id, a.title, o.id, o.description, p.id, p.photoURL, h.id, pr.price
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON o.photosID = p.id
JOIN House h ON o.typeId IS NOT NULL AND o.typeId = h.id
JOIN Price pr ON a.priceId = pr.id;

--ogloszenia z mieszkaniami i zdjęciami
CREATE VIEW selectAdsHousesPhotos AS
SELECT a.id, a.title, o.id, o.description, p.id, p.photoURL, pr.price
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON o.photosID = p.id
JOIN House h ON o.typeId IS NULL
JOIN Price pr ON a.priceId = pr.id;

--wylistowanie wszystkiego zwiazanego z domem
CREATE VIEW selectAdsHousesPhotos AS
SELECT a.*, o.*, p.*, h.*, pr.*, ad.*
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON o.photosId = p.id
JOIN House h ON o.typeId IS NOT NULL AND o.typeId = h.id
JOIN Price pr ON a.priceId = pr.id
JOIN Address ad ON a.addressId = ad.id;

--wylistowanie wszystkiego zwiazanego z mieszkaniem
CREATE VIEW selectAdsFlatsPhotos AS
SELECT a.*, o.*, p.*, pr.*, ad.*
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON o.photosId = p.id
JOIN House h ON o.typeId IS NULL
JOIN Price pr ON a.priceId = pr.id
JOIN Address ad ON a.addressId = ad.id;


--wyszukanie po konkretnym miescie
CREATE PROCEDURE searchHouseCity @City nvarchar(40)
AS
BEGIN

SELECT * FROM selectAdsHousesPhotos WHERE ad.city = @City
END;
GO


--wyszukanie po konkretnym miescie i kodzie pocztowym
CREATE PROCEDURE searchHouseCity @City nvarchar(40), @PostalCode nvarchar(10)
AS
BEGIN

SELECT * FROM selectAdsHousesPhotos WHERE ad.city = @City AND ad.postalCode = @PostalCode
END;
GO

--wstawianie danych do tabel
CREATE PROCEDURE insertIntoObject
@squareFotoage float,
@description nvarchar,
@rooms int,
@bathrooms int,
@basementSquareFootage float NULL,
@balconySquareFootage float NULL,
@allowAnimals boolean,
@typeId int NULL,
@floor int NULL,
@photosId INT
AS
BEGIN

IF @PhotosId IS NOT NULL AND NOT EXISTS (
	SELECT 1 FROM Photos WHERE id = @photosId
)
BEGIN
PRINT 'Error: PhotosId does nott exist.';
RETURN;
END;

IF @TypeId IS NOT NULL AND NOT EXISTS (
SELECT 1 FROM House WHERE id = @typeId
)
BEGIN
PRINT 'Error: TypeId does not exist.';
END;

INSERT INTO Object (squareFootage, description, rooms, bathrooms, basementSquareFoorage, balconySquareFootage, allowAnimals, floor, photosId, typeId)
    VALUES (@SquareFootage, @Description, @Rooms, @Bathrooms, @basementSquareFoorage, @balconySquareFootage, @allowAnimals, @floor, @PhotosId, @TypeId);

END;
GO


--wstawianie do zdjec
CREATE PROCEDURE insertIntoPhotos
    @photoURL NVARCHAR(1000)
AS
BEGIN
    -- Wstawienie nowego rekordu do tabeli Photos
    INSERT INTO Photos (photoURL)
    VALUES (@photoURL);
END;
GO
--wstawianie do domow
CREATE PROCEDURE insertIntoHouse
    @stories INT,
    @atticSquareFootage FLOAT NULL,
    @terraceSquareFootage FLOAT NULL,
    @plotArea FLOAT NULL
AS
BEGIN
    -- Wstawienie nowego rekordu do tabeli House
    INSERT INTO House (stories, atticSquareFootage, terraceSquareFootage, plotArea)
    VALUES (@stories, @atticSquareFootage, @terraceSquareFootage, @plotArea);

END;
GO

--wstawianie do ceny
CREATE PROCEDURE insertIntoPrice
    @price FLOAT,
    @rent FLOAT NULL,
    @media FLOAT NULL,
    @deposit FLOAT NULL,
    @typeOfPayment VARCHAR(50),
    @typeOwner VARCHAR(50)
AS
BEGIN
    -- Wstawienie nowego rekordu do tabeli Price
    INSERT INTO Price (price, rent, media, deposit, typeOfPayment, typeOwner)
    VALUES (@price, @rent, @media, @deposit, @typeOfPayment, @typeOwner);

END;
GO


--testowe wartosci:
INSERT INTO Price (price, rent, media, deposit, typeOfPayment, typeOwner)
VALUES (1500, 600, 300, 2500, 'lump', 'Private');

INSERT INTO Price (price, rent, media, deposit, typeOfPayment, typeOwner)
VALUES (1200, 500, 200, 1500, 'monthly', 'Agency');

INSERT INTO Price (price, rent, media, deposit, typeOfPayment, typeOwner)
VALUES (2000, 800, 350, 2500, 'yearly', 'Private');



INSERT INTO Object (squareFootage, description, rooms, bathrooms, basementSquareFootage, balconySquareFootage, allowAnimals, floor, photoId, typeId)
VALUES (120.5, 'Spacious apartment with a balcony', 4, 2, 10.0, 5.0, TRUE, 3, 1, 2);


INSERT INTO Object (squareFootage, description, rooms, bathrooms, basementSquareFootage, balconySquareFootage, allowAnimals, floor, photoId, typeId)
VALUES (75.0, 'Cozy flat in the city center', 2, 1, NULL, 3.5, FALSE, 2, 2, 1);


INSERT INTO Object (squareFootage, description, rooms, bathrooms, basementSquareFootage, balconySquareFootage, allowAnimals, floor, photoId, typeId)
VALUES (100.0, 'Modern house with garden', 3, 1, 20.0, NULL, TRUE, 1, 3, 3);



INSERT INTO House (stories, atticSquareFootage, terraceSquareFootage, pilotArea)
VALUES (2, 15.0, 25.0, 12.0);


INSERT INTO House (stories, atticSquareFootage, terraceSquareFootage, pilotArea)
VALUES (3, 20.0, 30.0, 15.0);


INSERT INTO House (stories, atticSquareFootage, terraceSquareFootage, pilotArea)
VALUES (1, 10.0, 20.0, 8.0);



INSERT INTO Photos (photoURL)
VALUES ('http://example.com/photo1.jpg');


INSERT INTO Photos (photoURL)
VALUES ('http://example.com/photo2.jpg');


INSERT INTO Photos (photoURL)
VALUES ('http://example.com/photo3.jpg');
