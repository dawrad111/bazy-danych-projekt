--PROCEDURY----------------


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
