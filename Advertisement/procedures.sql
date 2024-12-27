
-- Inset address with coordinates

CREATE PROCEDURE insertAddressWithCoordinates(
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

INSERT INTO coordinates (latitude, longitude)
VALUES (@Latitude, @Longitude) RETURNING coordinates.id
INTO @CoordinatesId

INSERT INTO address (country, region, postalCode, city, street, buildingNum, flatNum, coordinatesId)
VALUES (@Country, @Region, @PostalCode, @City, @Street, @BuildingNum, @FlatNum, @CoordinatesId);

COMMIT;
END;




-- Shows all advertisements in a given area
CREATE PROCEDURE advertisementInArea(
    @City VARCHAR(100) = NULL,
    @Region VARCHAR(100) = NULL,
    @Country VARCHAR(100) = NULL)
    AS
BEGIN
SELECT ad.city, ad.street, a.title, pr.price, pr.currency,
FROM advertisement a
         JOIN address ad ON a.addressId = ad.id
         JOIN price pr ON a.priceId = pr.id
WHERE (@City IS NULL OR ad.City = @City)
  AND (@Region IS NULL OR ad.Region = @Region)
  AND (@Country IS NULL OR ad.Country = @Country);
END;






-- Shows all payments for a given user
CREATE PROCEDURE userPayments(
    @UserId INT
)
    AS
BEGIN
SELECT u.firstName,
       u.lastName,
       p.price,
       p.creationDate,
       p.status
FROM payment p
         JOIN advertisement a ON p.advertisementId = a.id
         JOIN user u ON a.userId = u.id
WHERE u.id = @UserId;
END;



--Usuniecie ogloszenia (UWAGA. TYLKO PODCZAS TWORZENIA W MOMENCIE GDY SIE ROZMYSLI. OGLOSZENIA, KTORE ZOSTANA ZAAKCEPTOWANE PRZEZ UZYTKOWNIKA MAJA BYĆ UKRYWANE -> procedura hideAdvert)
CREATE PROCEDURE deleteAdvert
    @AdvertisementId INT
AS
BEGIN
    -- Sprawdzenie, czy rekord Advertisement istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Advertisement
        WHERE id = @AdvertisementId
    )
    BEGIN
        PRINT 'Error: AdvertisementId does not exist.';
        RETURN; -- Przerwij wykonanie procedury
    END;

    -- Znalezienie powiązanych rekordów
    DECLARE @ObjectId INT;
    DECLARE @PriceId INT;

    SELECT @ObjectId = objectId, @PriceId = priceId
    FROM Advertisement
    WHERE id = @AdvertisementId;

    -- Usuwanie płatności powiązanych z Advertisement
    DELETE FROM Payment
    WHERE advertisementId = @AdvertisementId;

    -- Usuwanie zdjęć powiązanych z Object
    DELETE FROM Photos
    WHERE objectId = @ObjectId;

    -- Usuwanie domu, jeśli istnieje powiązanie z Object
    DELETE FROM House
    WHERE id = @ObjectId;

    -- Usuwanie ceny powiązanej z Advertisement
    DELETE FROM Price
    WHERE id = @PriceId;

    -- Usunięcie obiektu
    DELETE FROM Object
    WHERE id = @ObjectId;

    -- Na końcu usunięcie ogłoszenia
    DELETE FROM Advertisement
    WHERE id = @AdvertisementId;

    PRINT 'Advertisement and related records successfully deleted.';
END;
GO



--Procedura chowania ogloszenia (keidy np. usuwane jest konto uzytkownika)
CREATE PROCEDURE hideAdvert
    @AdvertisementId INT
AS
BEGIN
    -- Sprawdzenie, czy AdvertisementId istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Advertisement
        WHERE id = @AdvertisementId
    )
    BEGIN
        PRINT 'Error: AdvertisementId does not exist.';
        RETURN; -- Przerwij wykonanie procedury
    END;

    -- Ukrycie ogłoszenia
    UPDATE Advertisement
    SET status = 'Hidden'
    WHERE id = @AdvertisementId;

    PRINT 'Advertisement hidden successfully!';
END;
GO



--Procedura zawieszenia ogloszenia (keidy np. ogloszenie jest podejrzane, zgloszone)
CREATE PROCEDURE suspendAdvert
    @AdvertisementId INT
AS
BEGIN
    -- Sprawdzenie, czy AdvertisementId istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Advertisement
        WHERE id = @AdvertisementId
    )
    BEGIN
        PRINT 'Error: AdvertisementId does not exist.';
        RETURN; -- Przerwij wykonanie procedury
    END;

    -- Ukrycie ogłoszenia
    UPDATE Advertisement
    SET status = 'Suspended'
    WHERE id = @AdvertisementId;

    PRINT 'Advertisement suspended successfully!';
END;
GO


--Procedura postowania ogloszenia (keidy np. ogloszenie bylo zgloszone, już nie jest lub keidy zatiwerdza sie je po platnosci)
CREATE PROCEDURE acceptAdvert
    @AdvertisementId INT
AS
BEGIN
    -- Sprawdzenie, czy AdvertisementId istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Advertisement
        WHERE id = @AdvertisementId
    )
    BEGIN
        PRINT 'Error: AdvertisementId does not exist.';
        RETURN; -- Przerwij wykonanie procedury
    END;

    -- Ukrycie ogłoszenia
    UPDATE Advertisement
    SET status = 'Posted'
    WHERE id = @AdvertisementId;

    PRINT 'Advertisement suspended successfully!';
END;
GO




-- Insert a payment for a given advertisement
CREATE PROCEDURE insertPayment(
    @Price NUMERIC(4,2),
    @AdvertisementId INT
)
    AS
BEGIN
INSERT INTO payment (price, advertisementId)
VALUES (@Price, @AdvertisementId)
END;


-- Update payment values if not null
CREATE PROCEDURE updatePayment(
    @Id INT,
    @Price NUMERIC(4,2) = NULL,
    @Status VARCHAR(12) = NULL
)
    AS
BEGIN
UPDATE payment
SET price  = COALESCE(@Price, price),
    status = COALESCE(@Status, status)
WHERE id = @Id;
END;



--EDYCJA TABELI

REATE PROCEDURE editAdvertisement
    @AdvertisementId INT,
    @NewStatus VARCHAR(20) NULL,
    @NewTitle NVARCHAR(255) NULL
AS
BEGIN
    -- Sprawdzenie, czy AdvertisementId istnieje
    IF NOT EXISTS (SELECT 1 FROM Advertisement WHERE id = @AdvertisementId)
    BEGIN
        PRINT 'Error: AdvertisementId does not exist.';
        RETURN;
    END;

    -- Aktualizacja Advertisement
    UPDATE Advertisement
    SET
        status = COALESCE(@NewStatus, status),
        title = COALESCE(@NewTitle, title)
    WHERE id = @AdvertisementId;

    PRINT 'Advertisement updated successfully!';
END;
GO




CREATE PROCEDURE editPayment
    @PaymentId INT,
    @NewPrice NUMERIC(10, 2) NULL,
    @NewPaymentStatus VARCHAR(12) NULL
AS
BEGIN
    -- Sprawdzenie, czy PaymentId istnieje
    IF NOT EXISTS (SELECT 1 FROM Payment WHERE id = @PaymentId)
    BEGIN
        PRINT 'Error: PaymentId does not exist.';
        RETURN;
    END;

    -- Aktualizacja Payment
    UPDATE Payment
    SET
        price = COALESCE(@NewPrice, price),
        status = COALESCE(@NewPaymentStatus, status)
    WHERE id = @PaymentId;

    PRINT 'Payment updated successfully!';
END;
GO

CREATE PROCEDURE editCoordinates
    @CoordinatesId INT,
    @NewLatitude DOUBLE PRECISION NULL,
    @NewLongitude DOUBLE PRECISION NULL
AS
BEGIN
    -- Sprawdzenie, czy CoordinatesId istnieje
    IF NOT EXISTS (SELECT 1 FROM Coordinates WHERE id = @CoordinatesId)
    BEGIN
        PRINT 'Error: CoordinatesId does not exist.';
        RETURN;
    END;

    -- Aktualizacja Coordinates
    UPDATE Coordinates
    SET
        latitude = COALESCE(@NewLatitude, latitude),
        longitude = COALESCE(@NewLongitude, longitude)
    WHERE id = @CoordinatesId;

    PRINT 'Coordinates updated successfully!';
END;
GO


CREATE PROCEDURE editAddress
    @AddressId INT,
    @NewCountry NVARCHAR(100) NULL,
    @NewRegion NVARCHAR(100) NULL,
    @NewPostalCode NVARCHAR(20) NULL,
    @NewCity NVARCHAR(100) NULL,
    @NewStreet NVARCHAR(100) NULL,
    @NewBuildingNum NVARCHAR(20) NULL,
    @NewFlatNum NVARCHAR(20) NULL
AS
BEGIN
    -- Sprawdzenie, czy AddressId istnieje
    IF NOT EXISTS (SELECT 1 FROM Address WHERE id = @AddressId)
    BEGIN
        PRINT 'Error: AddressId does not exist.';
        RETURN;
    END;

    -- Aktualizacja Address
    UPDATE Address
    SET
        country = COALESCE(@NewCountry, country),
        region = COALESCE(@NewRegion, region),
        postalCode = COALESCE(@NewPostalCode, postalCode),
        city = COALESCE(@NewCity, city),
        street = COALESCE(@NewStreet, street),
        buildingNum = COALESCE(@NewBuildingNum, buildingNum),
        flatNum = COALESCE(@NewFlatNum, flatNum)
    WHERE id = @AddressId;

    PRINT 'Address updated successfully!';
END;
GO