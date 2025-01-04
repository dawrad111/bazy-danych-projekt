-- insert do tabeli users
CREATE OR REPLACE FUNCTION sp_insert_into_users(
    name VARCHAR,
    surname VARCHAR,
    password_hash VARCHAR,
    email_address VARCHAR,
    phone_number TEXT,
    user_type VARCHAR,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR DEFAULT 'active',
    is_verified BOOLEAN DEFAULT FALSE
)
RETURNS VOID AS $$
DECLARE
    email_id INT;
    phone_number_id INT;
BEGIN
    IF user_type NOT IN ('operator', 'administrator', 'user') THEN
        RAISE EXCEPTION 'Error: Invalid user type value (%). Allowed values: operator, administrator, user.', user_type;
    END IF;

    IF status NOT IN ('active', 'suspended') THEN
        RAISE EXCEPTION 'Error: Invalid status value (%). Allowed values: active, suspended.', status;
    END IF;

    SELECT e.id INTO email_id
    FROM email e
    WHERE e.email = email_address;

    IF email_id IS NULL THEN
        INSERT INTO email (email, isverified)
        VALUES (email_address, FALSE)
        RETURNING id INTO email_id;
    END IF;

    SELECT pn.id INTO phone_number_id
    FROM phone_number pn
    WHERE pn.phoneNumber = phone_number;

    IF phone_number_id IS NULL THEN
        INSERT INTO phone_number (phoneNumber, isVerified)
        VALUES (phone_number, FALSE)
        RETURNING id INTO phone_number_id;
    END IF;

    INSERT INTO Users (
        name, surname, passwordHash, emailId, phoneNumberId,
        registrationDate, userType, status, isVerified
    )
    VALUES (
        name, surname, password_hash, email_id, phone_number_id,
        registration_date, user_type, status, is_verified
    );

    RAISE NOTICE 'User added successfully with email: % and phone number: %.', email_address, phone_number;
END;
$$ LANGUAGE plpgsql;

-- insert do tabeli phonenumber
CREATE OR REPLACE FUNCTION sp_insert_phone_number(
    p_phone_number VARCHAR,
    p_code VARCHAR,
    p_link_expired_date TIMESTAMP,
    p_is_verified BOOLEAN
)
RETURNS VOID AS $$
BEGIN
    -- Insert into phonenumber table
    INSERT INTO phoneNumber (
        phoneNumber, code, linkExpiredDate, isVerified, VerifiedDate
    )
    VALUES (
        p_phone_number, p_code, p_link_expired_date, p_is_verified, NULL
    );

    RAISE NOTICE 'Phone number inserted successfully.';
END;
$$ LANGUAGE plpgsql;

-- insert do tabeli email
CREATE OR REPLACE FUNCTION sp_insert_email(
    p_email VARCHAR,
    p_link VARCHAR,
    p_link_expired_date TIMESTAMP,
    p_is_verified BOOLEAN
)
RETURNS VOID AS $$
BEGIN
    -- Insert into Email table
    INSERT INTO Email (
        email, link, linkExpiredDate, isVerified, verifiedDate
    )
    VALUES (
        p_email, p_link, p_link_expired_date, p_is_verified, NULL
    );

    RAISE NOTICE 'Email inserted successfully.';
END;
$$ LANGUAGE plpgsql;

--insert do tabeli logs
CREATE OR REPLACE FUNCTION sp_insert_log(
    p_user_id INT,
    p_activity_type VARCHAR
)
RETURNS VOID AS $$
BEGIN
    -- Insert into Logs table
    INSERT INTO Logs (
        userId, activityType, time
    )
    VALUES (
        p_user_id, p_activity_type, CURRENT_TIMESTAMP
    );

    RAISE NOTICE 'Log entry inserted successfully.';
END;
$$ LANGUAGE plpgsql;


-- wszystkie logi danego użytkownika
CREATE OR REPLACE FUNCTION sp_get_user_logs(p_user_id INT)
RETURNS TABLE(
    user_id INT,
    name VARCHAR,
    surname VARCHAR,
    activity_type VARCHAR,
    log_time TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        l.userId, u.name, u.surname, l.activityType, l.time
    FROM Logs l
    JOIN Users u ON l.userId = u.userId
    WHERE u.userId = p_user_id
    ORDER BY l.time DESC;
END;
$$ LANGUAGE plpgsql;

-- szczegóły konta użytkownika na podstawie emaila

CREATE OR REPLACE FUNCTION sp_get_user_by_email(p_email VARCHAR)
RETURNS TABLE(
    user_id INT,
    name VARCHAR,
    surname VARCHAR,
    email VARCHAR,
    phone_number VARCHAR,
    registration_date TIMESTAMP,
    status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        userId, name, surname, email, phoneNumber, registrationDate, status
    FROM Users
    WHERE email = p_email;
END;
$$ LANGUAGE plpgsql;

-- Przykład edycji danych użytkownika
CREATE OR REPLACE FUNCTION sp_update_user(
    p_user_id INT,
    p_name VARCHAR,
    p_surname VARCHAR,
    p_email VARCHAR,
    p_phone_number VARCHAR,
    p_password_hash VARCHAR
)
RETURNS VOID AS $$
BEGIN
    UPDATE Users
    SET
        name = p_name,
        surname = p_surname,
        email = p_email,
        phoneNumber = p_phone_number,
        passwordHash = p_password_hash
    WHERE userId = p_user_id;

    RAISE NOTICE 'User data updated successfully.';
END;
$$ LANGUAGE plpgsql;