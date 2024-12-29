
-- do poprawy procedura bo zmiana zdjec
--wstawianie danych do tabel
begin transaction;
CREATE OR REPLACE FUNCTION sp_insert_into_object(
    square_footage FLOAT,
    description TEXT,
    rooms INT,
    bathrooms INT,
    allow_animals BOOLEAN,
    type_id INT DEFAULT NULL,
    basement_square_footage FLOAT DEFAULT NULL,
    balcony_square_footage FLOAT DEFAULT NULL,
    floor INT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    IF type_id IS NOT NULL THEN
        -- Check if TypeId exists in the House table
        IF NOT EXISTS (
            SELECT 1
            FROM House
            WHERE id = type_id
        ) THEN
            RAISE NOTICE 'Error: TypeId does not exist.';
            RETURN; -- Exit the function
        END IF;

        -- Check if floor is NULL when TypeId is provided
        IF floor IS NOT NULL THEN
            RAISE NOTICE 'Error: Floor must be NULL when TypeId is provided.';
            RETURN; -- Exit the function
        END IF;
    END IF;

    INSERT INTO Object (squareFootage, description, rooms, bathrooms, basementSquareFootage, balconySquareFootage, allowAnimals, floor, typeId)
    VALUES (square_footage, description, rooms, bathrooms, basement_square_footage, balcony_square_footage, allow_animals, floor, type_id);

    RAISE NOTICE 'Object inserted successfully!';
END;
$$ LANGUAGE plpgsql;

--wstawianie do domow
CREATE OR REPLACE FUNCTION sp_insert_into_house(
    stories INT,
    attic_square_footage FLOAT DEFAULT NULL,
    terrace_square_footage FLOAT DEFAULT NULL,
    plot_area FLOAT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    -- Insert a new record into the House table
    INSERT INTO House (stories, atticSquareFootage, terraceSquareFootage, plotArea)
    VALUES (stories, attic_square_footage, terrace_square_footage, plot_area);

    RAISE NOTICE 'House inserted successfully!';
END;
$$ LANGUAGE plpgsql;

--wstawianie do ceny
CREATE OR REPLACE FUNCTION sp_insert_into_price(
    price FLOAT,
        type_of_payment VARCHAR(50),
    type_owner VARCHAR(50),
    rent FLOAT DEFAULT NULL,
    media FLOAT DEFAULT NULL,
    deposit FLOAT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    -- Insert a new record into the Price table
    INSERT INTO Price (price, rent, media, deposit, typeOfPayment, typeOwner)
    VALUES (price, rent, media, deposit, type_of_payment, type_owner);

    RAISE NOTICE 'Price inserted successfully!';
END;
$$ LANGUAGE plpgsql;


--zmiana zdjęcia
CREATE OR REPLACE FUNCTION sp_edit_photo(
    photo_id INT,
    photos_url VARCHAR(1000)
)
RETURNS VOID AS $$
BEGIN
    -- Update the photo URL
    UPDATE Photos
    SET photoURL = photos_url
    WHERE id = photo_id;

    -- Check if the photo was found and updated
    IF NOT FOUND THEN
        RAISE NOTICE 'Nie znaleziono zdjęcia o id: %', photo_id;
    ELSE
        RAISE NOTICE 'URL zdjęcia o id: % został zaktualizowany.', photo_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


--edycja rekordów
CREATE OR REPLACE FUNCTION sp_edit_object(
    object_id INT,                -- Identyfikator rekordu do aktualizacji
    new_squareFootage FLOAT DEFAULT NULL,      -- Nowa wartość squareFootage
    new_description VARCHAR DEFAULT NULL,      -- Nowy opis
    new_rooms INT DEFAULT NULL,                -- Nowa liczba pokoi
    new_bathrooms INT DEFAULT NULL,            -- Nowa liczba łazienek
    new_basementSquareFootage FLOAT DEFAULT NULL, -- Nowa powierzchnia piwnicy
    new_balconySquareFootage FLOAT DEFAULT NULL,  -- Nowa powierzchnia balkonu
    new_allowAnimals BOOLEAN DEFAULT NULL,     -- Czy dozwolone są zwierzęta
    new_additionalInfo VARCHAR DEFAULT NULL    -- Nowe dodatkowe informacje
)
RETURNS VOID AS $$
BEGIN
    -- Aktualizacja rekordu w tabeli Object
    UPDATE Object
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

    RAISE NOTICE 'Object updated successfully!';
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION sp_edit_house(
    house_id INT,                      -- Identyfikator rekordu do aktualizacji
    new_stories INT DEFAULT NULL,                   -- Nowa liczba pięter
    new_atticSquareFootage FLOAT DEFAULT NULL,      -- Nowa powierzchnia strychu
    new_terraceSquareFootage FLOAT DEFAULT NULL,    -- Nowa powierzchnia tarasu
    new_plotArea FLOAT DEFAULT NULL                 -- Nowa powierzchnia działki
)
RETURNS VOID AS $$
BEGIN
    -- Aktualizacja rekordu w tabeli House
    UPDATE House
    SET
        stories = COALESCE(new_stories, stories),
        atticSquareFootage = COALESCE(new_atticSquareFootage, atticSquareFootage),
        terraceSquareFootage = COALESCE(new_terraceSquareFootage, terraceSquareFootage),
        plotArea = COALESCE(new_plotArea, plotArea)
    WHERE id = house_id;

    RAISE NOTICE 'House updated successfully!';
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION sp_edit_price(
    price_id INT,               -- Identyfikator rekordu do aktualizacji
    new_price FLOAT DEFAULT NULL,            -- Nowa cena
    new_rent FLOAT DEFAULT NULL,             -- Nowy czynsz
    new_media FLOAT DEFAULT NULL,            -- Nowe media
    new_typeOfPayment VARCHAR DEFAULT NULL,  -- Nowy typ płatności
    new_deposit FLOAT DEFAULT NULL,          -- Nowy depozyt
    new_typeOfOwner VARCHAR DEFAULT NULL     -- Nowy typ właściciela
)
RETURNS VOID AS $$
BEGIN
    -- Aktualizacja rekordu w tabeli Price
    UPDATE Price
    SET
        price = COALESCE(new_price, price),
        rent = COALESCE(new_rent, rent),
        media = COALESCE(new_media, media),
        typeOfPayment = COALESCE(new_typeOfPayment, typeOfPayment),
        deposit = COALESCE(new_deposit, deposit),
        typeOfOwner = COALESCE(new_typeOfOwner, typeOfOwner)
    WHERE id = price_id;

    RAISE NOTICE 'Price updated successfully!';
END;
$$ LANGUAGE plpgsql;

commit;