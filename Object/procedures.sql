--WIDOKI--------------

--nie jestem pewien czy potrzebne
--ogloszenia z domami i zdjęciami
CREATE VIEW flatpol.selectAdsHousesPhotos AS
SELECT a.id, a.title, o.id, o.description, p.id, p.photoURL, h.id, pr.price
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON o.photosID = p.id
JOIN House h ON o.typeId IS NOT NULL AND o.typeId = h.id
JOIN Price pr ON a.priceId = pr.id;

--ogloszenia z mieszkaniami i zdjęciami
CREATE VIEW flatpol.selectAdsHousesPhotos AS
SELECT a.id, a.title, o.id, o.description, p.id, p.photoURL, pr.price
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON o.photosID = p.id
JOIN House h ON o.typeId IS NULL
JOIN Price pr ON a.priceId = pr.id;




--wylistowanie wszystkiego zwiazanego z domem
CREATE VIEW flatpol.selectAdsHousesPhotos AS
SELECT a.*, o.*, p.*, h.*, pr.*, ad.*
FROM Advertisement a
LEFT JOIN Object o ON a.objectId = o.id
LEFT JOIN Photos p ON o.photosId = p.id
JOIN House h ON o.typeId IS NOT NULL AND o.typeId = h.id
LEFT JOIN Price pr ON a.priceId = pr.id
LEFT JOIN Address ad ON a.addressId = ad.id;

--wylistowanie wszystkiego zwiazanego z mieszkaniem
CREATE VIEW flatpol.selectAdsFlatsPhotos AS
SELECT o.*, p.*, pr.*, ad.*
FROM Object
LEFT JOIN Photos p ON o.photosId = p.id
LEFT JOIN Price pr ON a.priceId = pr.id
LEFT JOIN Address ad ON a.addressId = ad.id;





--wyszuaknie istotnych informacji od mieszkan
CREATE VIEW flatpol.selectFlatsAll AS
    SELECT o.id,
    ph.photoURL,
    o.description,
    o.squareFootage,
    o.rooms,
    o.bathrooms,
    o.floor
    o.basementSquareFootage,
    o.balconysquareFootage,
FROM flatpol.object o
LEFT JOIN flatpol.photos ph ON ph.id = o.photosId;

--wyszuaknie istotnych informacji od domow,
--to mozna dac jako SELECT * FROM selectFlatsALL WHERE
--np. o.bathrooms > 2 albo WHERE h.plotArea < 1000 ORDER BY h.plotArea DESC;
CREATE VIEW flatpol.selectHousesAll AS
    SELECT o.id,
    ph.photoURL,
    o.squareFootage,
    o.description,
    o.rooms,
    o.bathrooms,
    o.basementSquareFootage,
    o.balconysquareFootage,
    h.stories,
    h.atticSquareFootage,
    h.terraceSquareFootage,
    h.plotArea
FROM flatpol.object o
JOIN flatpol.house h ON h.id = o.typeId
LEFT JOIN flatpol.photos ph ON ph.id = o.photosId;





--wylistowanie cen
CREATE VIEW flatpol.showPrices AS
    SELECT
    a.id,
    pr.price,
    pr.rent,
    pr.media,
    pr.typeOfPayment,
    pr.deposit,
    pr.typeOfOwner
FROM flatpol.Advertisement
JOIN flatpol.Price pr ON a.priceId = pr.id;

--sortowanie po cenach
CREATE VIEW flatpol.showPrices AS
    SELECT
    a.id,
    SUM(pr.price,
    pr.rent,
    pr.media) AS price_final
FROM flatpol.Advertisement
JOIN flatpol.Price pr ON a.priceId = pr.id
ORDER BY price_final DESC;



--pod takie pokazanie na stronie
--wyszukanie opisów mieszkań
CREATE VIEW flatpol.objectDesc AS
SELECT a.id, o.id, o.description
FROM flatpol.Advertisement a
JOIN flatpol.Object o ON a.objectId = o.id;


--wylistowanie tylko zdjec
CREATE VIEW flatpol.showOnlyPhotos AS
    SELECT o.id, p.photoURL
    FROM Object o
    LEFT JOIN Photos p ON o.photosId = p.id;


--wylistowanie ilosci zdjec
CREATE VIEW flatpol.photo_count_per_object AS
SELECT o.id, COUNT(p.id)
FROM object o
LEFT JOIN photos p ON o.photosId = p.id
GROUP BY o.id;







--PROCEDURY----------------
--wyszukanie po konkretnym miescie
CREATE PROCEDURE flatpol.searchHouseCity @City nvarchar(40)
AS
BEGIN

SELECT * FROM flatpol.selectAdsHousesPhotos WHERE ad.city = @City
END;
GO


--wyszukanie po konkretnym miescie i kodzie pocztowym
CREATE PROCEDURE flatpol.searchHouseCity @City nvarchar(40), @PostalCode nvarchar(10)
AS
BEGIN

SELECT * FROM flatpol.selectAdsHousesPhotos WHERE ad.city = @City AND ad.postalCode = @PostalCode
END;
GO

--wstawianie danych do tabel
CREATE PROCEDURE flatpol.insertIntoObject
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


--wyszukanie po dowonlej wartości z objects, price czy house???








--testowe wartosci:-------------------------
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
