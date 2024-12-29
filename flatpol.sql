--
-- PostgreSQL database dump
--

-- Dumped from database version 17.1 (Debian 17.1-1.pgdg120+1)
-- Dumped by pg_dump version 17.1 (Debian 17.1-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sp_accept_advertisement(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_accept_advertisement(advertisement_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_accept_advertisement(advertisement_id integer) OWNER TO postgres;

--
-- Name: sp_advertisementinarea(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_advertisementinarea(p_city character varying DEFAULT NULL::character varying, p_region character varying DEFAULT NULL::character varying, p_country character varying DEFAULT NULL::character varying) RETURNS TABLE(city character varying, street character varying, title character varying, price numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_advertisementinarea(p_city character varying, p_region character varying, p_country character varying) OWNER TO postgres;

--
-- Name: sp_delete_advertisement(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_advertisement(advertisement_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_delete_advertisement(advertisement_id integer) OWNER TO postgres;

--
-- Name: sp_edit_address(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_edit_address(address_id integer, new_country character varying DEFAULT NULL::character varying, new_region character varying DEFAULT NULL::character varying, new_postal_code character varying DEFAULT NULL::character varying, new_city character varying DEFAULT NULL::character varying, new_street character varying DEFAULT NULL::character varying, new_building_num character varying DEFAULT NULL::character varying, new_flat_num character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_edit_address(address_id integer, new_country character varying, new_region character varying, new_postal_code character varying, new_city character varying, new_street character varying, new_building_num character varying, new_flat_num character varying) OWNER TO postgres;

--
-- Name: sp_edit_advertisement(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_edit_advertisement(advertisement_id integer, new_status character varying DEFAULT NULL::character varying, new_title character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_edit_advertisement(advertisement_id integer, new_status character varying, new_title character varying) OWNER TO postgres;

--
-- Name: sp_edit_coordinates(integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_edit_coordinates(coordinates_id integer, new_latitude double precision DEFAULT NULL::double precision, new_longitude double precision DEFAULT NULL::double precision) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_edit_coordinates(coordinates_id integer, new_latitude double precision, new_longitude double precision) OWNER TO postgres;

--
-- Name: sp_edit_house(integer, integer, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_edit_house(house_id integer, new_stories integer DEFAULT NULL::integer, new_atticsquarefootage double precision DEFAULT NULL::double precision, new_terracesquarefootage double precision DEFAULT NULL::double precision, new_plotarea double precision DEFAULT NULL::double precision) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_edit_house(house_id integer, new_stories integer, new_atticsquarefootage double precision, new_terracesquarefootage double precision, new_plotarea double precision) OWNER TO postgres;

--
-- Name: sp_edit_object(integer, double precision, character varying, integer, integer, double precision, double precision, boolean, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_edit_object(object_id integer, new_squarefootage double precision DEFAULT NULL::double precision, new_description character varying DEFAULT NULL::character varying, new_rooms integer DEFAULT NULL::integer, new_bathrooms integer DEFAULT NULL::integer, new_basementsquarefootage double precision DEFAULT NULL::double precision, new_balconysquarefootage double precision DEFAULT NULL::double precision, new_allowanimals boolean DEFAULT NULL::boolean, new_additionalinfo character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_edit_object(object_id integer, new_squarefootage double precision, new_description character varying, new_rooms integer, new_bathrooms integer, new_basementsquarefootage double precision, new_balconysquarefootage double precision, new_allowanimals boolean, new_additionalinfo character varying) OWNER TO postgres;

--
-- Name: sp_edit_payment(integer, numeric, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_edit_payment(payment_id integer, new_price numeric DEFAULT NULL::numeric, new_payment_status character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_edit_payment(payment_id integer, new_price numeric, new_payment_status character varying) OWNER TO postgres;

--
-- Name: sp_edit_photo(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_edit_photo(photo_id integer, photos_url character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_edit_photo(photo_id integer, photos_url character varying) OWNER TO postgres;

--
-- Name: sp_edit_price(integer, double precision, double precision, double precision, character varying, double precision, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_edit_price(price_id integer, new_price double precision DEFAULT NULL::double precision, new_rent double precision DEFAULT NULL::double precision, new_media double precision DEFAULT NULL::double precision, new_typeofpayment character varying DEFAULT NULL::character varying, new_deposit double precision DEFAULT NULL::double precision, new_typeofowner character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_edit_price(price_id integer, new_price double precision, new_rent double precision, new_media double precision, new_typeofpayment character varying, new_deposit double precision, new_typeofowner character varying) OWNER TO postgres;

--
-- Name: sp_hide_advertisement(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_hide_advertisement(advertisement_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_hide_advertisement(advertisement_id integer) OWNER TO postgres;

--
-- Name: sp_hideadvertisement(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_hideadvertisement(advertisement_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_hideadvertisement(advertisement_id integer) OWNER TO postgres;

--
-- Name: sp_insert_into_house(integer, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_into_house(stories integer, attic_square_footage double precision DEFAULT NULL::double precision, terrace_square_footage double precision DEFAULT NULL::double precision, plot_area double precision DEFAULT NULL::double precision) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Insert a new record into the House table
    INSERT INTO House (stories, atticSquareFootage, terraceSquareFootage, plotArea)
    VALUES (stories, attic_square_footage, terrace_square_footage, plot_area);

    RAISE NOTICE 'House inserted successfully!';
END;
$$;


ALTER FUNCTION public.sp_insert_into_house(stories integer, attic_square_footage double precision, terrace_square_footage double precision, plot_area double precision) OWNER TO postgres;

--
-- Name: sp_insert_into_object(double precision, text, integer, integer, boolean, integer, double precision, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_into_object(square_footage double precision, description text, rooms integer, bathrooms integer, allow_animals boolean, type_id integer DEFAULT NULL::integer, basement_square_footage double precision DEFAULT NULL::double precision, balcony_square_footage double precision DEFAULT NULL::double precision, floor integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_insert_into_object(square_footage double precision, description text, rooms integer, bathrooms integer, allow_animals boolean, type_id integer, basement_square_footage double precision, balcony_square_footage double precision, floor integer) OWNER TO postgres;

--
-- Name: sp_insert_into_price(double precision, character varying, character varying, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_into_price(price double precision, type_of_payment character varying, type_owner character varying, rent double precision DEFAULT NULL::double precision, media double precision DEFAULT NULL::double precision, deposit double precision DEFAULT NULL::double precision) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Insert a new record into the Price table
    INSERT INTO Price (price, rent, media, deposit, typeOfPayment, typeOwner)
    VALUES (price, rent, media, deposit, type_of_payment, type_owner);

    RAISE NOTICE 'Price inserted successfully!';
END;
$$;


ALTER FUNCTION public.sp_insert_into_price(price double precision, type_of_payment character varying, type_owner character varying, rent double precision, media double precision, deposit double precision) OWNER TO postgres;

--
-- Name: sp_insert_payment(numeric, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_payment(price numeric, advertisement_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Payment (price, advertisementId)
    VALUES (price, advertisement_id);

    RAISE NOTICE 'Payment inserted successfully!';
END;
$$;


ALTER FUNCTION public.sp_insert_payment(price numeric, advertisement_id integer) OWNER TO postgres;

--
-- Name: sp_insertaddresswithcoordinates(character varying, character varying, character varying, character varying, character varying, character varying, integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insertaddresswithcoordinates(p_country character varying, p_region character varying, p_postalcode character varying, p_city character varying, p_street character varying, p_buildingnum character varying, p_flatnum integer, p_latitude double precision, p_longitude double precision) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_insertaddresswithcoordinates(p_country character varying, p_region character varying, p_postalcode character varying, p_city character varying, p_street character varying, p_buildingnum character varying, p_flatnum integer, p_latitude double precision, p_longitude double precision) OWNER TO postgres;

--
-- Name: sp_suspend_advertisement(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_suspend_advertisement(advertisement_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.sp_suspend_advertisement(advertisement_id integer) OWNER TO postgres;

--
-- Name: sp_update_payment(integer, numeric, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_payment(id integer, price numeric DEFAULT NULL::numeric, status character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update Payment
    UPDATE Payment
    SET
        price = COALESCE(price, price),
        status = COALESCE(status, status)
    WHERE id = id;

    RAISE NOTICE 'Payment updated successfully!';
END;
$$;


ALTER FUNCTION public.sp_update_payment(id integer, price numeric, status character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    id integer NOT NULL,
    country character varying(100) NOT NULL,
    region character varying(100) NOT NULL,
    postalcode character varying(6) NOT NULL,
    city character varying(100) NOT NULL,
    street character varying(100),
    buildingnum character varying(10) NOT NULL,
    flatnum integer,
    coordinatesid integer
);


ALTER TABLE public.address OWNER TO postgres;

--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.address_id_seq OWNER TO postgres;

--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.address_id_seq OWNED BY public.address.id;


--
-- Name: coordinates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coordinates (
    id integer NOT NULL,
    latitude double precision,
    longitude double precision
);


ALTER TABLE public.coordinates OWNER TO postgres;

--
-- Name: address_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.address_view AS
 SELECT a.country,
    a.region,
    a.postalcode,
    a.city,
    a.street,
    a.buildingnum,
    a.flatnum,
    c.latitude,
    c.longitude
   FROM (public.address a
     LEFT JOIN public.coordinates c ON ((a.coordinatesid = c.id)));


ALTER VIEW public.address_view OWNER TO postgres;

--
-- Name: advertisement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.advertisement (
    id integer NOT NULL,
    posttime timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    enddate date,
    userid integer,
    addressid integer,
    status character varying(12) DEFAULT 'pending'::character varying NOT NULL,
    title character varying(150) NOT NULL,
    lastmodificationdate timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    paymentid integer,
    priceid integer,
    objectid integer,
    CONSTRAINT advertisement_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'posted'::character varying, 'ended'::character varying, 'canceled'::character varying, 'suspended'::character varying])::text[])))
);


ALTER TABLE public.advertisement OWNER TO postgres;

--
-- Name: advertisement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.advertisement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.advertisement_id_seq OWNER TO postgres;

--
-- Name: advertisement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.advertisement_id_seq OWNED BY public.advertisement.id;


--
-- Name: bump_count; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bump_count (
    id integer NOT NULL,
    userid integer NOT NULL,
    commentid integer NOT NULL
);


ALTER TABLE public.bump_count OWNER TO postgres;

--
-- Name: bump_count_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bump_count_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bump_count_id_seq OWNER TO postgres;

--
-- Name: bump_count_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bump_count_id_seq OWNED BY public.bump_count.id;


--
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment (
    id integer NOT NULL,
    userid integer NOT NULL,
    advertisementid integer NOT NULL,
    postdate timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    lastmodificationdate timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    hidedate timestamp without time zone,
    content text NOT NULL,
    status character varying(9) NOT NULL,
    CONSTRAINT comment_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'suspended'::character varying])::text[])))
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comment_id_seq OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_id_seq OWNED BY public.comment.id;


--
-- Name: complaint; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.complaint (
    id integer NOT NULL,
    userid integer NOT NULL,
    content text NOT NULL,
    postdate timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    solutiondate timestamp without time zone,
    status character varying(9) NOT NULL,
    CONSTRAINT complaint_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'resolved'::character varying, 'suspended'::character varying])::text[])))
);


ALTER TABLE public.complaint OWNER TO postgres;

--
-- Name: complaint_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.complaint_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.complaint_id_seq OWNER TO postgres;

--
-- Name: complaint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.complaint_id_seq OWNED BY public.complaint.id;


--
-- Name: coordinates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coordinates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.coordinates_id_seq OWNER TO postgres;

--
-- Name: coordinates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coordinates_id_seq OWNED BY public.coordinates.id;


--
-- Name: email; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email (
    id integer NOT NULL,
    email character varying NOT NULL,
    link character varying,
    linkexpiredate timestamp without time zone,
    isverified boolean DEFAULT false NOT NULL,
    verifieddate timestamp without time zone
);


ALTER TABLE public.email OWNER TO postgres;

--
-- Name: email_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.email_id_seq OWNER TO postgres;

--
-- Name: email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_id_seq OWNED BY public.email.id;


--
-- Name: house; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.house (
    id integer NOT NULL,
    stories integer,
    atticsquarefootage double precision,
    terracesquarefootage double precision,
    plotarea double precision
);


ALTER TABLE public.house OWNER TO postgres;

--
-- Name: house_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.house_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.house_id_seq OWNER TO postgres;

--
-- Name: house_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.house_id_seq OWNED BY public.house.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    userid integer NOT NULL,
    activitytype character varying NOT NULL,
    "time" timestamp without time zone NOT NULL
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO postgres;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- Name: object; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.object (
    id integer NOT NULL,
    squarefootage double precision,
    description character varying,
    rooms integer,
    bathrooms integer,
    basementsquarefootage double precision,
    balconysquarefootage double precision,
    allowanimals boolean,
    additionalinfo character varying,
    typeid integer,
    floor integer
);


ALTER TABLE public.object OWNER TO postgres;

--
-- Name: object_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.object_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.object_id_seq OWNER TO postgres;

--
-- Name: object_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.object_id_seq OWNED BY public.object.id;


--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id integer NOT NULL,
    price numeric(4,2) NOT NULL,
    creationdate date DEFAULT CURRENT_TIMESTAMP,
    status character varying(12) DEFAULT 'pending'::character varying NOT NULL,
    CONSTRAINT payment_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'ended'::character varying, 'suspended'::character varying])::text[])))
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_id_seq OWNER TO postgres;

--
-- Name: payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_id_seq OWNED BY public.payment.id;


--
-- Name: phone_number; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phone_number (
    id integer NOT NULL,
    phonenumber text NOT NULL,
    code character varying,
    linkexpireddate timestamp without time zone,
    isverified boolean DEFAULT false NOT NULL,
    verifieddate timestamp without time zone
);


ALTER TABLE public.phone_number OWNER TO postgres;

--
-- Name: phone_number_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phone_number_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.phone_number_id_seq OWNER TO postgres;

--
-- Name: phone_number_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.phone_number_id_seq OWNED BY public.phone_number.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.photos (
    id integer NOT NULL,
    photourl character varying(1000),
    objectid integer
);


ALTER TABLE public.photos OWNER TO postgres;

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.photos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.photos_id_seq OWNER TO postgres;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.photos_id_seq OWNED BY public.photos.id;


--
-- Name: price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price (
    id integer NOT NULL,
    price integer,
    rent double precision,
    typeofpayment character varying,
    typeofowner character varying,
    media double precision,
    deposit double precision
);


ALTER TABLE public.price OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying NOT NULL,
    surname character varying NOT NULL,
    passwordhash character varying NOT NULL,
    emailid integer NOT NULL,
    phonenumberid integer NOT NULL,
    lastlogindate timestamp without time zone,
    registrationdate timestamp without time zone NOT NULL,
    usertype character varying NOT NULL,
    status character varying(9) NOT NULL,
    isverified boolean DEFAULT false NOT NULL,
    CONSTRAINT users_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'suspended'::character varying])::text[]))),
    CONSTRAINT users_usertype_check CHECK (((usertype)::text = ANY ((ARRAY['operator'::character varying, 'administrator'::character varying, 'user'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_userid_seq OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.id;


--
-- Name: view_active_complaints; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_active_complaints AS
 SELECT complaint.content,
    complaint.postdate,
    u.name,
    u.surname,
    e.email
   FROM ((public.complaint
     JOIN public.users u ON ((complaint.userid = u.id)))
     JOIN public.email e ON ((u.emailid = e.id)))
  WHERE ((complaint.status)::text = 'active'::text);


ALTER VIEW public.view_active_complaints OWNER TO postgres;

--
-- Name: view_advertisements; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_advertisements AS
 SELECT ad.city,
    ad.street,
    a.title,
    pr.price
   FROM ((public.advertisement a
     JOIN public.address ad ON ((a.addressid = ad.id)))
     JOIN public.price pr ON ((a.priceid = pr.id)));


ALTER VIEW public.view_advertisements OWNER TO postgres;

--
-- Name: view_advertisements_price_sorted_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_advertisements_price_sorted_view AS
 SELECT ad.city,
    ad.street,
    a.title,
    pr.price
   FROM ((public.advertisement a
     JOIN public.address ad ON ((a.addressid = ad.id)))
     JOIN public.price pr ON ((a.priceid = pr.id)))
  ORDER BY pr.price DESC;


ALTER VIEW public.view_advertisements_price_sorted_view OWNER TO postgres;

--
-- Name: view_all_flats; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_all_flats AS
 SELECT o.id,
    ph.photourl,
    o.description,
    o.squarefootage,
    o.rooms,
    o.bathrooms,
    o.floor,
    o.basementsquarefootage,
    o.balconysquarefootage,
    o.allowanimals
   FROM (public.object o
     LEFT JOIN public.photos ph ON ((o.id = ph.objectid)));


ALTER VIEW public.view_all_flats OWNER TO postgres;

--
-- Name: view_all_houses; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_all_houses AS
 SELECT o.id,
    ph.photourl,
    o.squarefootage,
    o.description,
    o.rooms,
    o.bathrooms,
    o.basementsquarefootage,
    o.balconysquarefootage,
    h.stories,
    h.atticsquarefootage,
    h.terracesquarefootage,
    h.plotarea,
    o.allowanimals
   FROM ((public.object o
     JOIN public.house h ON ((h.id = o.typeid)))
     LEFT JOIN public.photos ph ON ((o.id = ph.objectid)));


ALTER VIEW public.view_all_houses OWNER TO postgres;

--
-- Name: view_all_user_advertisements; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_all_user_advertisements AS
 SELECT u.name,
    u.surname,
    ad.title,
    ad.status,
    pr.price,
    ad.posttime,
    ad.enddate
   FROM ((public.advertisement ad
     JOIN public.users u ON ((ad.userid = u.id)))
     JOIN public.price pr ON ((ad.priceid = pr.id)));


ALTER VIEW public.view_all_user_advertisements OWNER TO postgres;

--
-- Name: view_only_photos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_only_photos AS
 SELECT o.id,
    p.photourl
   FROM (public.object o
     LEFT JOIN public.photos p ON ((o.id = p.objectid)));


ALTER VIEW public.view_only_photos OWNER TO postgres;

--
-- Name: view_photo_count_per_object; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_photo_count_per_object AS
 SELECT o.id,
    count(p.id) AS count
   FROM (public.object o
     LEFT JOIN public.photos p ON ((o.id = p.objectid)))
  GROUP BY o.id;


ALTER VIEW public.view_photo_count_per_object OWNER TO postgres;

--
-- Name: view_prices; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_prices AS
 SELECT pr.price,
    pr.rent,
    pr.media,
    pr.typeofpayment,
    pr.deposit,
    pr.typeofowner
   FROM (public.price pr
     JOIN public.advertisement a ON ((a.priceid = pr.id)));


ALTER VIEW public.view_prices OWNER TO postgres;

--
-- Name: view_user_payments; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_user_payments AS
 SELECT u.name,
    u.surname,
    p.price,
    p.creationdate,
    p.status
   FROM ((public.payment p
     JOIN public.advertisement a ON ((p.id = a.paymentid)))
     JOIN public.users u ON ((a.userid = u.id)));


ALTER VIEW public.view_user_payments OWNER TO postgres;

--
-- Name: view_user_payments_sorted; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_user_payments_sorted AS
 SELECT u.name,
    u.surname,
    p.price,
    p.creationdate,
    p.status
   FROM ((public.payment p
     JOIN public.advertisement a ON ((p.id = a.paymentid)))
     JOIN public.users u ON ((a.userid = u.id)))
  ORDER BY p.price DESC;


ALTER VIEW public.view_user_payments_sorted OWNER TO postgres;

--
-- Name: address id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address ALTER COLUMN id SET DEFAULT nextval('public.address_id_seq'::regclass);


--
-- Name: advertisement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisement ALTER COLUMN id SET DEFAULT nextval('public.advertisement_id_seq'::regclass);


--
-- Name: bump_count id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bump_count ALTER COLUMN id SET DEFAULT nextval('public.bump_count_id_seq'::regclass);


--
-- Name: comment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment ALTER COLUMN id SET DEFAULT nextval('public.comment_id_seq'::regclass);


--
-- Name: complaint id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint ALTER COLUMN id SET DEFAULT nextval('public.complaint_id_seq'::regclass);


--
-- Name: coordinates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinates ALTER COLUMN id SET DEFAULT nextval('public.coordinates_id_seq'::regclass);


--
-- Name: email id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email ALTER COLUMN id SET DEFAULT nextval('public.email_id_seq'::regclass);


--
-- Name: house id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.house ALTER COLUMN id SET DEFAULT nextval('public.house_id_seq'::regclass);


--
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- Name: object id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.object ALTER COLUMN id SET DEFAULT nextval('public.object_id_seq'::regclass);


--
-- Name: payment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment ALTER COLUMN id SET DEFAULT nextval('public.payment_id_seq'::regclass);


--
-- Name: phone_number id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone_number ALTER COLUMN id SET DEFAULT nextval('public.phone_number_id_seq'::regclass);


--
-- Name: photos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos ALTER COLUMN id SET DEFAULT nextval('public.photos_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.address (id, country, region, postalcode, city, street, buildingnum, flatnum, coordinatesid) FROM stdin;
1	Poland	Dolny Śląsk	50-421	Wrocław	Na Grobli	15	12	\N
2	Poland	Dolny Śląsk	50-366	Wrocław	Grunwaldzka	59	3	\N
3	Poland	Dolny Śląsk	51-627	Wrocław	Wróblewskiego	27	5	\N
4	Poland	Dolny Śląsk	50-334	Wrocław	Rozbrat	7	10	\N
5	Poland	Dolny Śląsk	51-640	Wrocław	Braci Gierymskich	45A	10	\N
6	Poland	Dolny Śląsk	50-112	Wrocław	Piłsudskiego	31	2	\N
7	Poland	Dolny Śląsk	50-200	Wrocław	Kościuszki	12A	\N	\N
8	Poland	Dolny Śląsk	50-345	Wrocław	Oławska	8	14	\N
9	Poland	Dolny Śląsk	50-555	Wrocław	Hallera	45B	3	\N
10	Poland	Dolny Śląsk	50-567	Wrocław	Powstańców Śląskich	72	\N	\N
11	Poland	Dolny Śląsk	51-231	Wrocław	Legnicka	120	18	\N
12	Poland	Dolny Śląsk	51-332	Wrocław	Plac Grunwaldzki	15	10	\N
13	Poland	Mazowieckie	00-001	Warszawa	Marszałkowska	33	\N	\N
14	Poland	Małopolskie	31-001	Kraków	Floriańska	7	5	\N
15	Poland	Wielkopolskie	61-001	Poznań	Święty Marcin	22	8	\N
\.


--
-- Data for Name: advertisement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.advertisement (id, posttime, enddate, userid, addressid, status, title, lastmodificationdate, paymentid, priceid, objectid) FROM stdin;
31	2024-12-29 20:29:30.96182	\N	1	1	posted	Mieszkanie na sprzedaż	2024-12-29 20:29:30.96182	1	1	2
32	2024-12-29 20:29:30.96182	\N	2	2	posted	Mieszkanie na wynajem	2024-12-29 20:29:30.96182	2	2	3
33	2024-12-29 20:29:30.96182	\N	3	3	posted	Dom na sprzedaż	2024-12-29 20:29:30.96182	3	3	4
34	2024-12-29 20:29:30.96182	\N	4	4	posted	Dom na wynajem	2024-12-29 20:29:30.96182	4	4	5
35	2024-12-29 20:29:30.96182	\N	5	5	posted	Pokój na wynajem	2024-12-29 20:29:30.96182	5	5	6
36	2024-12-29 20:29:30.96182	\N	1	1	posted	Nowoczesne mieszkanie w centrum	2024-12-29 20:29:30.96182	1	1	7
37	2024-12-29 20:29:30.96182	\N	2	2	pending	Stylowe mieszkanie w sercu miasta	2024-12-29 20:29:30.96182	2	2	8
38	2024-12-29 20:29:30.96182	\N	3	3	posted	Dom z ogrodem na przedmieściach	2024-12-29 20:29:30.96182	3	3	9
39	2024-12-29 20:29:30.96182	\N	4	4	ended	Dom z garażem i basenem	2024-12-29 20:29:30.96182	4	4	10
40	2024-12-29 20:29:30.96182	\N	5	5	canceled	Przytulny pokój na wynajem	2024-12-29 20:29:30.96182	5	5	11
41	2024-12-29 20:29:30.96182	\N	6	6	suspended	Duży apartament z balkonem	2024-12-29 20:29:30.96182	6	6	12
42	2024-12-29 20:29:30.96182	\N	7	7	posted	Ekskluzywny dom w prestiżowej lokalizacji	2024-12-29 20:29:30.96182	7	\N	13
43	2024-12-29 20:29:30.96182	\N	8	8	pending	Przestronny pokój w świetnej lokalizacji	2024-12-29 20:29:30.96182	8	\N	14
44	2024-12-29 20:29:30.96182	\N	9	9	posted	Willa z widokiem na góry	2024-12-29 20:29:30.96182	9	\N	5
45	2024-12-29 20:29:30.96182	\N	10	10	ended	Mieszkanie do remontu w świetnej cenie	2024-12-29 20:29:30.96182	10	\N	4
\.


--
-- Data for Name: bump_count; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bump_count (id, userid, commentid) FROM stdin;
1	1	1
2	1	2
3	3	2
4	1	4
5	5	5
6	6	2
7	7	7
8	1	8
9	9	9
10	1	10
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment (id, userid, advertisementid, postdate, lastmodificationdate, hidedate, content, status) FROM stdin;
1	1	31	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	Bardzo polecam!	active
2	2	32	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	Produkt zgodny z opisem	active
3	3	33	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	Szybka wysyłka!	active
4	4	34	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	Nie polecam. Problemy z dostawą.	suspended
5	3	35	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	Świetny kontakt z sprzedawcą!	active
6	6	36	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	Towar uszkodzony	suspended
7	7	37	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	Super jakość!	active
8	5	38	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	Zbyt drogo.	suspended
9	9	39	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	OK	active
10	10	40	2024-12-29 20:31:08.873485	2024-12-29 20:31:08.873485	\N	Polecam w 100%!	active
\.


--
-- Data for Name: complaint; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.complaint (id, userid, content, postdate, solutiondate, status) FROM stdin;
1	1	Proszę o sprawdzenie płatności za ogłoszenie nr 101.	2024-12-29 20:31:02.950606	\N	active
2	2	Reklamacja dotycząca jakości ogłoszenia nr 102.	2024-12-29 20:31:02.950606	\N	resolved
3	3	Nieprawidłowe dane ogłoszenia nr 103.	2024-12-29 20:31:02.950606	\N	active
4	4	Problem z dostawą produktu z ogłoszenia nr 104.	2024-12-29 20:31:02.950606	\N	active
5	5	Brak kontaktu ze sprzedawcą z ogłoszenia nr 105.	2024-12-29 20:31:02.950606	\N	resolved
6	6	Uszkodzony towar w ogłoszeniu nr 106.	2024-12-29 20:31:02.950606	\N	active
7	5	Ogłoszenie niezgodne z opisem nr 107.	2024-12-29 20:31:02.950606	\N	suspended
8	8	Proszę o anulowanie ogłoszenia nr 108.	2024-12-29 20:31:02.950606	\N	active
9	9	Zwrot pieniędzy za ogłoszenie nr 109.	2024-12-29 20:31:02.950606	\N	resolved
10	10	Prośba o edycję ogłoszenia nr 110.	2024-12-29 20:31:02.950606	\N	active
\.


--
-- Data for Name: coordinates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coordinates (id, latitude, longitude) FROM stdin;
1	51.1005	17.0624
2	51.1059	17.0373
3	51.1047	17.0745
4	51.1097	17.0326
5	51.1079	17.0385
6	51.1095	17.0438
7	51.0915	17.0234
8	51.0962	17.0358
9	51.1171	17.0159
10	51.1138	17.0462
11	52.2297	21.0122
12	50.0647	19.945
13	52.4095	16.9319
\.


--
-- Data for Name: email; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email (id, email, link, linkexpiredate, isverified, verifieddate) FROM stdin;
1	alice.smith@example.com	http://example.com/verify1	2024-12-30 20:16:48.439919	f	\N
2	john.doe@example.com	http://example.com/verify2	2024-12-31 20:16:48.439919	t	2024-12-29 20:16:48.439919
3	eva.brown@example.com	http://example.com/verify3	2024-12-30 20:16:48.439919	f	\N
4	lucas.j@example.com	http://example.com/verify4	2024-12-30 20:16:48.439919	t	2024-12-29 20:16:48.439919
5	marta.k@example.com	http://example.com/verify5	2024-12-31 20:16:48.439919	t	2024-12-29 20:16:48.439919
6	adam.nowak@example.com	http://example.com/verify6	2025-01-01 20:16:48.439919	t	2024-12-29 20:16:48.439919
7	kasia.wojcik@example.com	http://example.com/verify7	2025-01-02 20:16:48.439919	f	\N
8	paul.white@example.com	http://example.com/verify8	2024-12-30 20:16:48.439919	t	2024-12-29 20:16:48.439919
9	anna.adams@example.com	http://example.com/verify9	2024-12-31 20:16:48.439919	f	\N
10	peter.smith@example.com	http://example.com/verify10	2025-01-01 20:16:48.439919	t	2024-12-29 20:16:48.439919
\.


--
-- Data for Name: house; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.house (id, stories, atticsquarefootage, terracesquarefootage, plotarea) FROM stdin;
1	2	15	25	12
2	3	20	30	15
3	1	10	20	8
4	2	12.5	18	10
5	3	22	35	20
6	2	\N	15	25
7	1	8	\N	30
8	4	25	40	50
9	2	14	22	18
10	3	18	28	35
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, userid, activitytype, "time") FROM stdin;
1	1	login	2024-12-29 20:19:46.77148
2	2	logout	2024-12-29 20:19:46.77148
3	3	comment	2024-12-29 20:19:46.77148
4	4	like	2024-12-29 20:19:46.77148
5	5	like	2024-12-29 20:19:46.77148
6	6	login	2024-12-29 20:19:46.77148
7	7	register	2024-12-29 20:19:46.77148
8	8	comment	2024-12-29 20:19:46.77148
9	9	login	2024-12-29 20:19:46.77148
10	10	like	2024-12-29 20:19:46.77148
\.


--
-- Data for Name: object; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.object (id, squarefootage, description, rooms, bathrooms, basementsquarefootage, balconysquarefootage, allowanimals, additionalinfo, typeid, floor) FROM stdin;
2	120.5	Spacious apartment with a balcony	4	2	10	5	t	\N	\N	3
3	75	Cozy flat in the city center	2	1	\N	3.5	f	\N	\N	2
4	100	Modern house with garden	3	1	20	\N	t	\N	1	\N
5	95.5	Beautifully designed apartment with plenty of natural light and a spacious kitchen area.	3	1	\N	4	t	\N	\N	4
6	200	Luxury house with a large garden, private pool, and fully equipped modern amenities.	6	3	50	10	t	\N	4	\N
7	65	Small cozy flat, perfect for couples, located in a quiet neighborhood near parks.	2	1	\N	2	f	\N	\N	1
8	150	Family home with a large basement and spacious living room, located in the suburbs.	5	2	40	\N	t	\N	5	\N
9	120	Contemporary apartment with a stunning view of the city skyline, includes parking.	3	2	\N	6	t	\N	\N	8
10	180	Spacious villa featuring high ceilings, a garage, and a private backyard.	4	2	30	8	t	\N	6	\N
11	50	Compact studio apartment ideal for students, includes all basic amenities.	1	1	\N	1	f	\N	\N	5
12	240	Expansive countryside house with a large plot of land, perfect for farming.	7	4	80	\N	t	\N	7	\N
13	100	Modern duplex apartment with a shared terrace and close proximity to transport hubs.	3	2	\N	3	t	\N	\N	7
14	170	Rustic house with a fireplace, wooden interiors, and breathtaking mountain views.	4	2	25	\N	t	\N	8	\N
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, price, creationdate, status) FROM stdin;
1	10.00	2024-12-29	ended
2	15.50	2024-12-29	pending
3	20.00	2024-12-29	ended
4	10.00	2024-12-29	suspended
5	25.00	2024-12-29	ended
6	50.00	2024-12-29	pending
7	12.00	2024-12-29	suspended
8	30.00	2024-12-29	ended
9	8.00	2024-12-29	pending
10	40.00	2024-12-29	ended
\.


--
-- Data for Name: phone_number; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.phone_number (id, phonenumber, code, linkexpireddate, isverified, verifieddate) FROM stdin;
1	+48123456789	123456	2024-12-29 20:26:11.62648	f	\N
2	+48223456780	654321	2024-12-29 20:31:11.62648	t	2024-12-29 20:16:11.62648
3	+48111122233	789123	2024-12-29 20:36:11.62648	f	\N
4	+48333444556	321789	2024-12-29 20:21:11.62648	t	2024-12-29 20:16:11.62648
5	+48555666777	555666	2024-12-29 20:46:11.62648	t	2024-12-29 20:16:11.62648
6	+48666777888	666777	2024-12-29 20:28:11.62648	t	2024-12-29 20:16:11.62648
7	+48777888999	777888	2024-12-29 20:41:11.62648	f	\N
8	+48888999000	888999	2024-12-29 20:51:11.62648	t	2024-12-29 20:16:11.62648
9	+48999000111	999000	2024-12-29 21:01:11.62648	f	\N
10	+48001122334	000111	2024-12-29 20:24:11.62648	t	2024-12-29 20:16:11.62648
\.


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.photos (id, photourl, objectid) FROM stdin;
1	http://example.com/photo33.jpg	9
2	http://example.com/photo4.jpg	10
3	http://example.com/photo5.jpg	13
4	http://example.com/photo6.jpg	6
5	http://example.com/photo7.jpg	4
6	http://example.com/photo8.jpg	5
7	http://example.com/photo9.jpg	5
8	http://example.com/photo10.jpg	5
9	http://example.com/photo11.jpg	8
10	http://example.com/photo12.jpg	9
11	http://example.com/photo13.jpg	12
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price (id, price, rent, typeofpayment, typeofowner, media, deposit) FROM stdin;
1	1500	600	lump	Private	300	2500
2	1200	500	monthly	Agency	200	1500
3	2000	800	yearly	Private	350	2500
4	1000	800	lump	Private	300	2100
5	2200	900	lump	Agency	200	3100
6	2700	900	yearly	Agency	500	4300
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, surname, passwordhash, emailid, phonenumberid, lastlogindate, registrationdate, usertype, status, isverified) FROM stdin;
1	Alice	Smith	hash1234	1	1	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	user	active	f
2	John	Doe	hash5678	2	2	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	administrator	active	t
3	Eva	Brown	hash91011	3	3	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	user	suspended	f
4	Lucas	Johnson	hash1213	4	4	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	operator	active	t
5	Marta	Kowalska	hash1415	5	5	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	user	active	t
6	Adam	Nowak	hash1617	6	6	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	operator	active	t
7	Kasia	Wójcik	hash1819	7	7	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	user	suspended	f
8	Paul	White	hash2021	8	8	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	user	active	t
9	Anna	Adams	hash2223	9	9	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	user	active	f
10	Peter	Smith	hash2425	10	10	2024-12-29 20:18:30.414587	2024-12-29 20:18:30.414587	administrator	active	t
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.address_id_seq', 15, true);


--
-- Name: advertisement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.advertisement_id_seq', 45, true);


--
-- Name: bump_count_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bump_count_id_seq', 10, true);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_id_seq', 10, true);


--
-- Name: complaint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.complaint_id_seq', 10, true);


--
-- Name: coordinates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coordinates_id_seq', 13, true);


--
-- Name: email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_id_seq', 10, true);


--
-- Name: house_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.house_id_seq', 10, true);


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_seq', 10, true);


--
-- Name: object_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.object_id_seq', 14, true);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_id_seq', 10, true);


--
-- Name: phone_number_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.phone_number_id_seq', 10, true);


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.photos_id_seq', 11, true);


--
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_userid_seq', 10, true);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: advertisement advertisement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisement
    ADD CONSTRAINT advertisement_pkey PRIMARY KEY (id);


--
-- Name: bump_count bump_count_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bump_count
    ADD CONSTRAINT bump_count_pkey PRIMARY KEY (id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: complaint complaint_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint
    ADD CONSTRAINT complaint_pkey PRIMARY KEY (id);


--
-- Name: coordinates coordinates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinates
    ADD CONSTRAINT coordinates_pkey PRIMARY KEY (id);


--
-- Name: email email_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_email_key UNIQUE (email);


--
-- Name: email email_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_pkey PRIMARY KEY (id);


--
-- Name: house house_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.house
    ADD CONSTRAINT house_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: object object_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.object
    ADD CONSTRAINT object_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: phone_number phone_number_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone_number
    ADD CONSTRAINT phone_number_pkey PRIMARY KEY (id);


--
-- Name: photos photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: address address_coordinatesid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_coordinatesid_fkey FOREIGN KEY (coordinatesid) REFERENCES public.coordinates(id);


--
-- Name: advertisement advertisement_addressid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisement
    ADD CONSTRAINT advertisement_addressid_fkey FOREIGN KEY (addressid) REFERENCES public.address(id);


--
-- Name: advertisement advertisement_objectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisement
    ADD CONSTRAINT advertisement_objectid_fkey FOREIGN KEY (objectid) REFERENCES public.object(id);


--
-- Name: advertisement advertisement_paymentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisement
    ADD CONSTRAINT advertisement_paymentid_fkey FOREIGN KEY (paymentid) REFERENCES public.payment(id);


--
-- Name: advertisement advertisement_priceid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisement
    ADD CONSTRAINT advertisement_priceid_fkey FOREIGN KEY (priceid) REFERENCES public.price(id);


--
-- Name: advertisement advertisement_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisement
    ADD CONSTRAINT advertisement_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: bump_count bump_count_commentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bump_count
    ADD CONSTRAINT bump_count_commentid_fkey FOREIGN KEY (commentid) REFERENCES public.comment(id);


--
-- Name: bump_count bump_count_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bump_count
    ADD CONSTRAINT bump_count_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: comment comment_advertisementid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_advertisementid_fkey FOREIGN KEY (advertisementid) REFERENCES public.advertisement(id);


--
-- Name: comment comment_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: complaint complaint_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint
    ADD CONSTRAINT complaint_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: logs logs_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: object object_typeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.object
    ADD CONSTRAINT object_typeid_fkey FOREIGN KEY (typeid) REFERENCES public.house(id);


--
-- Name: photos photos_objectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_objectid_fkey FOREIGN KEY (objectid) REFERENCES public.object(id);


--
-- Name: users users_emailid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_emailid_fkey FOREIGN KEY (emailid) REFERENCES public.email(id);


--
-- Name: users users_phonenumberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phonenumberid_fkey FOREIGN KEY (phonenumberid) REFERENCES public.phone_number(id);


--
-- PostgreSQL database dump complete
--

