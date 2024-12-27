<<<<<<< HEAD
--ogloszenia z domami i zdjęciami
CREATE VIEW selectAdsHousesPhotos AS
SELECT a.id, a.title, o.id, o.description, p.id, p.photoURL, h.id, pr.price
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON  o.id = p.objectId
JOIN House h ON o.typeId IS NOT NULL AND o.typeId = h.id
JOIN Price pr ON a.priceId = pr.id;

--ogloszenia z mieszkaniami i zdjęciami
CREATE VIEW selectAdsHousesPhotos AS
SELECT a.id, a.title, o.id, o.description, p.id, p.photoURL, pr.price
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON o.id = p.objectId
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
=======
--PROCEDURY----------------

>>>>>>> origin/tomash

-- do poprawy procedura bo zmiana zdjec
--wstawianie danych do tabel
CREATE PROCEDURE flatpol.insertIntoObject
@typeId int NULL,
@squareFotoage float,
@description nvarchar,
@rooms int,
@bathrooms int,
@basementSquareFootage float NULL,
@balconySquareFootage float NULL,
@allowAnimals boolean,
@floor int NULL,
AS
BEGIN

IF @TypeId IS NOT NULL
BEGIN
    -- Sprawdzenie, czy TypeId istnieje w tabeli House
    IF NOT EXISTS (
        SELECT 1
        FROM House
        WHERE id = @TypeId
    )
    BEGIN
        PRINT 'Error: TypeId does not exist.';
        RETURN; -- Przerwij wykonanie procedury
    END;

    -- Sprawdzenie, czy floor jest NULL, gdy TypeId nie jest NULL
    IF @Floor IS NOT NULL
    BEGIN
        PRINT 'Error: Floor must be NULL when TypeId is provided.';
        RETURN; -- Przerwij wykonanie procedury
    END;
END;

INSERT INTO Object (squareFootage, description, rooms, bathrooms, basementSquareFoorage, balconySquareFootage, allowAnimals, floor, photosId, typeId)
    VALUES (@SquareFootage, @Description, @Rooms, @Bathrooms, @basementSquareFoorage, @balconySquareFootage, @allowAnimals, @floor, @PhotosId, @TypeId);

END;
GO

--wstawianie do zdjec
CREATE PROCEDURE flatpol.insertIntoPhotos
    @photoURL NVARCHAR(1000)
AS
BEGIN
    -- Wstawienie nowego rekordu do tabeli Photos
    INSERT INTO Photos (photoURL)
    VALUES (@photoURL);
END;
GO

--wstawianie do domow
CREATE PROCEDURE flatpol.insertIntoHouse
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
CREATE PROCEDURE flatpol.insertIntoPrice
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

--------------------
--zmiana zdjęcia
CREATE PROCEDURE flatpol.editPhoto
    @photo_id INT,
    @photosURL VARCHAR(1000)
AS
BEGIN
    UPDATE flatpol.Photos
    SET photoURL = @photosURL
    WHERE id = @photo_id;
IF NOT FOUND THEN
        RAISE NOTICE 'Nie znaleziono zdjęcia o id: ' + photo_id;
    ELSE
        RAISE NOTICE 'URL zdjęcia o ' + photo_id +' został zaktualizowany.';
    END IF;

<<<<<<< HEAD
--testowe wartosci:
-- niepoprawne dane co do kolumn
INSERT INTO Price (price, rent, media, deposit, typeOfPayment, typeOwner)
VALUES (1500, 600, 300, 2500, 'lump', 'Private'),
(1200, 500, 200, 1500, 'monthly', 'Agency'),
(2000, 800, 350, 2500, 'yearly', 'Private');



INSERT INTO Object (squareFootage, description, rooms, bathrooms, basementSquareFootage, balconySquareFootage, allowAnimals, floor, typeId)
VALUES (120.5, 'Spacious apartment with a balcony', 4, 2, 10.0, 5.0, TRUE, 3, 2),
(75.0, 'Cozy flat in the city center', 2, 1, NULL, 3.5, FALSE, 2, 1),
(100.0, 'Modern house with garden', 3, 1, 20.0, NULL, TRUE, 1, 3);



INSERT INTO House (stories, atticSquareFootage, terraceSquareFootage, plotArea)
VALUES (2, 15.0, 25.0, 12.0),
(3, 20.0, 30.0, 15.0),
(1, 10.0, 20.0, 8.0);



INSERT INTO Photos (photoURL, objectId)
VALUES ('http://example.com/photo1.jpg', 4),
('http://example.com/photo2.jpg', 5),
('http://example.com/photo3.jpg', 6);
=======
END;


--edycja rekordów
CREATE  PROCEDURE flatpol.editObject
     object_id INT,                -- Identyfikator rekordu do aktualizacji
     new_squareFootage FLOAT,      -- Nowa wartość squareFootage
     new_description VARCHAR,      -- Nowy opis
     new_rooms INT,                -- Nowa liczba pokoi
     new_bathrooms INT,            -- Nowa liczba łazienek
     new_basementSquareFootage FLOAT, -- Nowa powierzchnia piwnicy
     new_balconySquareFootage FLOAT,  -- Nowa powierzchnia balkonu
     new_allowAnimals BOOLEAN,     -- Czy dozwolone są zwierzęta
     new_additionalInfo VARCHAR    -- Nowe dodatkowe informacje

AS
BEGIN
    -- Aktualizacja rekordu w tabeli Object
    UPDATE flatpol.Object
    SET
        squareFootage = COALESCE(new_squareFootage, squareFootage),
        description = COALESCE(new_description, description),
        rooms = COALESCE(new_rooms, rooms),
        bathrooms = COALESCE(new_bathrooms, bathrooms),
        basementSquareFootage = COALESCE(new_basementSquareFootage, basementSquareFootage),
        balconySquareFootage = COALESCE(new_balconySquareFootage, balconySquareFootage),
        allowAnimals = COALESCE(new_allowAnimals, allowAnimals),
        additionalInfo = COALESCE(new_additionalInfo, additionalInfo)
    WHERE id = object_id;

END;



CREATE PROCEDURE flatpol.editHouse(
     house_id INT,                      -- Identyfikator rekordu do aktualizacji
     new_stories INT,                   -- Nowa liczba pięter
     new_atticSquareFootage FLOAT,      -- Nowa powierzchnia strychu
     new_terraceSquareFootage FLOAT,    -- Nowa powierzchnia tarasu
     new_plotArea FLOAT                 -- Nowa powierzchnia działki
)
AS
BEGIN
    -- Aktualizacja rekordu w tabeli House
    UPDATE flatpol.house
    SET
        stories = COALESCE(new_stories, stories),
        atticSquareFootage = COALESCE(new_atticSquareFootage, atticSquareFootage),
        terraceSquareFootage = COALESCE(new_terraceSquareFootage, terraceSquareFootage),
        plotArea = COALESCE(new_plotArea, plotArea)
    WHERE id = house_id;

END;



CREATE PROCEDURE flatpol.editPrice(
     price_id INT,               -- Identyfikator rekordu do aktualizacji
     new_price FLOAT,            -- Nowa cena
     new_rent FLOAT,             -- Nowy czynsz
     new_media FLOAT,            -- Nowe media
     new_typeOfPayment VARCHAR,  -- Nowy typ płatności
     new_deposit FLOAT,          -- Nowy depozyt
     new_typeOfOwner VARCHAR     -- Nowy typ właściciela
)
AS
BEGIN
    -- Aktualizacja rekordu w tabeli Price
    UPDATE flatpol.price
    SET
        price = COALESCE(new_price, price),
        rent = COALESCE(new_rent, rent),
        media = COALESCE(new_media, media),
        typeOFPayment = COALESCE(new_typeOfPayment, typeOFPayment),
        deposit = COALESCE(new_deposit, deposit),
        typeOfOwner = COALESCE(new_typeOfOwner, typeOfOwner)
    WHERE id = price_id;

END;
>>>>>>> origin/tomash
