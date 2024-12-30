-- Insert address with coordinates

CREATE OR REPLACE FUNCTION sp_insertAddressWithCoordinates(
    p_Country VARCHAR(100),
    p_Region VARCHAR(100),
    p_PostalCode VARCHAR(6),
    p_City VARCHAR(100),
    p_Street VARCHAR(100),
    p_BuildingNum VARCHAR(10),
    p_FlatNum INT,
    p_Latitude DOUBLE PRECISION,
    p_Longitude DOUBLE PRECISION
)
RETURNS VOID AS $$
DECLARE
    v_CoordinatesId INT;
BEGIN
    -- Insert into coordinates table and get the id
    INSERT INTO coordinates (latitude, longitude)
    VALUES (p_Latitude, p_Longitude)
    RETURNING id INTO v_CoordinatesId;

    -- Insert into address table with the coordinates id
    INSERT INTO address (country, region, postalCode, city, street, buildingNum, flatNum, coordinatesId)
    VALUES (p_Country, p_Region, p_PostalCode, p_City, p_Street, p_BuildingNum, p_FlatNum, v_CoordinatesId);

EXCEPTION
    WHEN OTHERS THEN
        -- Rollback transaction in case of error
        RAISE;
END;
$$ LANGUAGE plpgsql;


-- nie dziala
-- Function to show all advertisements in a given area
CREATE OR REPLACE FUNCTION sp_advertisementInArea(
    p_city VARCHAR(100) DEFAULT NULL,
    p_region VARCHAR(100) DEFAULT NULL,
    p_country VARCHAR(100) DEFAULT NULL
)
RETURNS TABLE(city VARCHAR, street VARCHAR, title VARCHAR, price FLOAT) AS $$
BEGIN
    RETURN QUERY
    SELECT ad.city, ad.street, a.title, pr.price
    FROM advertisement a
         JOIN address ad ON a.addressid = ad.id
         JOIN price pr ON a.priceid = pr.id
    WHERE (p_city IS NULL OR ad.city = p_city)
      AND (p_region IS NULL OR ad.region = p_region)
      AND (p_country IS NULL OR ad.country = p_country);
END;
$$ LANGUAGE plpgsql;
-- do pop



-- doesn't work
-- should work
-- Shows all payments for a given user
CREATE OR REPLACE FUNCTION sp_user_payments(user_id INT)
RETURNS TABLE (
    first_name VARCHAR,
    last_name VARCHAR,
    price NUMERIC(4,2),
    creation_date TIMESTAMP,
    status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.firstName,
           u.lastName,
           p.price,
           p.creationDate,
           p.status
    FROM Payment p
    JOIN Advertisement a ON p.advertisementId = a.id
    JOIN "User" u ON a.userId = u.userId
    WHERE u.userId = user_id;
END;
$$ LANGUAGE plpgsql;




--Usuniecie ogloszenia (UWAGA. TYLKO PODCZAS TWORZENIA W MOMENCIE GDY SIE ROZMYSLI. OGLOSZENIA, KTORE ZOSTANA ZAAKCEPTOWANE PRZEZ UZYTKOWNIKA MAJA BYĆ UKRYWANE -> procedura hideAdvert)
CREATE OR REPLACE FUNCTION sp_delete_advertisement(advertisement_id INT)
RETURNS VOID AS $$
DECLARE
    object_id INT;
    price_id INT;
BEGIN
    -- Check if the Advertisement record exists
    IF NOT EXISTS (
        SELECT 1
        FROM Advertisement
        WHERE id = advertisement_id
    ) THEN
        RAISE NOTICE 'Error: AdvertisementId does not exist.';
        RETURN; -- Exit the function
    END IF;

    -- Find related records
    SELECT objectId, priceId
    INTO object_id, price_id
    FROM Advertisement
    WHERE id = advertisement_id;

    -- Delete payments related to Advertisement
    DELETE FROM Payment
    WHERE advertisementId = advertisement_id;

    -- Delete photos related to Object
    DELETE FROM Photos
    WHERE objectId = object_id;

    -- Delete house if there is a relation with Object
    DELETE FROM House
    WHERE id = object_id;

    -- Delete price related to Advertisement
    DELETE FROM Price
    WHERE id = price_id;

    -- Delete the object
    DELETE FROM Object
    WHERE id = object_id;

    -- Finally, delete the advertisement
    DELETE FROM Advertisement
    WHERE id = advertisement_id;

    RAISE NOTICE 'Advertisement and related records successfully deleted.';
END;
$$ LANGUAGE plpgsql;



--Procedura chowania ogloszenia (keidy np. usuwane jest konto uzytkownika)
CREATE OR REPLACE FUNCTION sp_hide_advertisement(advertisement_id INT)
RETURNS VOID AS $$
BEGIN
    -- Check if the Advertisement record exists
    IF NOT EXISTS (
        SELECT 1
        FROM Advertisement
        WHERE id = advertisement_id
    ) THEN
        RAISE NOTICE 'Error: AdvertisementId does not exist.';
        RETURN; -- Exit the function
    END IF;

    -- Hide the advertisement
    UPDATE Advertisement
    SET status = 'Hidden'
    WHERE id = advertisement_id;

    RAISE NOTICE 'Advertisement hidden successfully!';
END;
$$ LANGUAGE plpgsql;



--Procedura zawieszenia ogloszenia (keidy np. ogloszenie jest podejrzane, zgloszone)
CREATE OR REPLACE FUNCTION sp_suspend_advertisement(advertisement_id INT)
RETURNS VOID AS $$
BEGIN
    -- Check if the Advertisement record exists
    IF NOT EXISTS (
        SELECT 1
        FROM Advertisement
        WHERE id = advertisement_id
    ) THEN
        RAISE NOTICE 'Error: AdvertisementId does not exist.';
        RETURN; -- Exit the function
    END IF;

    -- Suspend the advertisement
    UPDATE Advertisement
    SET status = 'Suspended'
    WHERE id = advertisement_id;

    RAISE NOTICE 'Advertisement suspended successfully!';
END;
$$ LANGUAGE plpgsql;


--Procedura postowania ogloszenia (keidy np. ogloszenie bylo zgloszone, już nie jest lub keidy zatiwerdza sie je po platnosci)
CREATE OR REPLACE FUNCTION sp_accept_advertisement(advertisement_id INT)
RETURNS VOID AS $$
BEGIN
    -- Check if the Advertisement record exists
    IF NOT EXISTS (
        SELECT 1
        FROM Advertisement
        WHERE id = advertisement_id
    ) THEN
        RAISE NOTICE 'Error: AdvertisementId does not exist.';
        RETURN; -- Exit the function
    END IF;

    -- Update Advertisement status to 'Posted'
    UPDATE Advertisement
    SET status = 'Posted'
    WHERE id = advertisement_id;

    RAISE NOTICE 'Advertisement posted successfully!';
END;
$$ LANGUAGE plpgsql;




-- Insert a payment for a given advertisement
CREATE OR REPLACE FUNCTION sp_insert_payment(
    price NUMERIC(4, 2),
    advertisement_id INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Payment (price, advertisementId)
    VALUES (price, advertisement_id);

    RAISE NOTICE 'Payment inserted successfully!';
END;
$$ LANGUAGE plpgsql;


-- Update payment values if not null
CREATE OR REPLACE FUNCTION sp_update_payment(
    id INT,
    price NUMERIC(4, 2) DEFAULT NULL,
    status VARCHAR(12) DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    -- Update Payment
    UPDATE Payment
    SET
        price = COALESCE(price, price),
        status = COALESCE(status, status)
    WHERE id = id;

    RAISE NOTICE 'Payment updated successfully!';
END;
$$ LANGUAGE plpgsql;



--EDYCJA TABELI

CREATE OR REPLACE FUNCTION sp_edit_advertisement(
    advertisement_id INT,
    new_status VARCHAR(20) DEFAULT NULL,
    new_title VARCHAR(255) DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    -- Check if the Advertisement record exists
    IF NOT EXISTS (SELECT 1 FROM Advertisement WHERE id = advertisement_id) THEN
        RAISE NOTICE 'Error: AdvertisementId does not exist.';
        RETURN;
    END IF;

    -- Update Advertisement
    UPDATE Advertisement
    SET
        status = COALESCE(new_status, status),
        title = COALESCE(new_title, title)
    WHERE id = advertisement_id;

    RAISE NOTICE 'Advertisement updated successfully!';
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION sp_edit_payment(
    payment_id INT,
    new_price NUMERIC(10, 2) DEFAULT NULL,
    new_payment_status VARCHAR(12) DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    -- Check if the Payment record exists
    IF NOT EXISTS (SELECT 1 FROM Payment WHERE id = payment_id) THEN
        RAISE NOTICE 'Error: PaymentId does not exist.';
        RETURN;
    END IF;

    -- Update Payment
    UPDATE Payment
    SET
        price = COALESCE(new_price, price),
        status = COALESCE(new_payment_status, status)
    WHERE id = payment_id;

    RAISE NOTICE 'Payment updated successfully!';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sp_edit_coordinates(
    coordinates_id INT,
    new_latitude DOUBLE PRECISION DEFAULT NULL,
    new_longitude DOUBLE PRECISION DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    -- Check if the Coordinates record exists
    IF NOT EXISTS (SELECT 1 FROM Coordinates WHERE id = coordinates_id) THEN
        RAISE NOTICE 'Error: CoordinatesId does not exist.';
        RETURN;
    END IF;

    -- Update Coordinates
    UPDATE Coordinates
    SET
        latitude = COALESCE(new_latitude, latitude),
        longitude = COALESCE(new_longitude, longitude)
    WHERE id = coordinates_id;

    RAISE NOTICE 'Coordinates updated successfully!';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_edit_address(
    address_id INT,
    new_country VARCHAR(100) DEFAULT NULL,
    new_region VARCHAR(100) DEFAULT NULL,
    new_postal_code VARCHAR(20) DEFAULT NULL,
    new_city VARCHAR(100) DEFAULT NULL,
    new_street VARCHAR(100) DEFAULT NULL,
    new_building_num VARCHAR(20) DEFAULT NULL,
    new_flat_num VARCHAR(20) DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    -- Check if the Address record exists
    IF NOT EXISTS (SELECT 1 FROM Address WHERE id = address_id) THEN
        RAISE NOTICE 'Error: AddressId does not exist.';
        RETURN;
    END IF;

    -- Update Address
    UPDATE Address
    SET
        country = COALESCE(new_country, country),
        region = COALESCE(new_region, region),
        postalCode = COALESCE(new_postal_code, postalCode),
        city = COALESCE(new_city, city),
        street = COALESCE(new_street, street),
        buildingNum = COALESCE(new_building_num, buildingNum),
        flatNum = COALESCE(new_flat_num, flatNum)
    WHERE id = address_id;

    RAISE NOTICE 'Address updated successfully!';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sp_hideadvertisement(advertisement_id INT)
RETURNS VOID AS $$
BEGIN
    -- Check if the Advertisement record exists
    IF NOT EXISTS (
        SELECT 1
        FROM Advertisement
        WHERE id = advertisement_id
    ) THEN
        RAISE NOTICE 'Error: AdvertisementId does not exist.';
        RETURN; -- Exit the function
    END IF;

    -- Hide the advertisement
    UPDATE Advertisement
    SET status = 'Hidden'
    WHERE id = advertisement_id;

    RAISE NOTICE 'Advertisement hidden successfully!';
END;
$$ LANGUAGE plpgsql;