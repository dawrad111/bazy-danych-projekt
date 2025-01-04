-- Dodanie komentarza
CREATE OR REPLACE FUNCTION sp_insert_into_comment(
    user_id INTEGER,
    advertisement_id INTEGER,
    content TEXT,
    status VARCHAR(9) DEFAULT 'active'
)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM users
        WHERE id = user_id
    ) THEN
        RAISE EXCEPTION 'Error: User with ID % does not exist.', user_id;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM advertisement
        WHERE id = advertisement_id
    ) THEN
        RAISE EXCEPTION 'Error: Advertisement with ID % does not exist.', advertisement_id;
    END IF;

    IF status NOT IN ('active', 'suspended') THEN
        RAISE EXCEPTION 'Error: Invalid status value (%). Allowed values: active, suspended.', status;
    END IF;

    INSERT INTO comment (
        userId, advertisementId, content, status
    )
    VALUES (
        user_id, advertisement_id, content, status
    );

    RAISE NOTICE 'Comment added successfully for User ID % and Advertisement ID %.', user_id, advertisement_id;
END;
$$ LANGUAGE plpgsql;

-- Dodanie skargi
CREATE OR REPLACE FUNCTION sp_insert_into_complaint(
    user_id INTEGER,
    content TEXT,
    status VARCHAR(9) DEFAULT 'active'
)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM users
        WHERE id = user_id
    ) THEN
        RAISE EXCEPTION 'Error: User with ID % does not exist.', user_id;
    END IF;

    IF status NOT IN ('active', 'resolved', 'suspended') THEN
        RAISE EXCEPTION 'Error: Invalid status value (%). Allowed values: active, resolved, suspended.', status;
    END IF;

    INSERT INTO complaint (
        userId, content, status
    )
    VALUES (
        user_id, content, status
    );

    RAISE NOTICE 'Complaint added successfully for User ID %.', user_id;
END;
$$ LANGUAGE plpgsql;


--Dodanie like
CREATE OR REPLACE FUNCTION sp_insert_into_bumpCount(
    user_id INTEGER,
    comment_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Users
        WHERE id = user_id
    ) THEN
        RAISE EXCEPTION 'Error: User with ID % does not exist.', user_id;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM comment
        WHERE id = comment_id
    ) THEN
        RAISE EXCEPTION 'Error: Comment with ID % does not exist.', comment_id;
    END IF;

    INSERT INTO bumpCount (
        userId, commentId
    )
    VALUES (
        user_id, comment_id
    );

    RAISE NOTICE 'Bump added successfully for User ID % and Comment ID %.', user_id, comment_id;
END;
$$ LANGUAGE plpgsql;

--edycja komentarza
CREATE OR REPLACE FUNCTION sp_edit_comment(
    comment_id INTEGER,
    new_status VARCHAR(9) DEFAULT NULL,
    new_content TEXT DEFAULT NULL,
    new_hide_date TIMESTAMP DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM comment
        WHERE id = comment_id
    ) THEN
        RAISE EXCEPTION 'Error: Comment with ID % does not exist.', comment_id;
    END IF;

    IF new_status IS NOT NULL AND new_status NOT IN ('active', 'suspended') THEN
        RAISE EXCEPTION 'Error: Invalid status value (%). Allowed values: active, suspended.', new_status;
    END IF;

    UPDATE comment
    SET
        status = COALESCE(new_status, status),
        content = COALESCE(new_content, content),
        hideDate = COALESCE(new_hide_date, hideDate),
        lastModificationDate = CURRENT_TIMESTAMP
    WHERE id = comment_id;

    RAISE NOTICE 'Comment with ID % updated successfully!', comment_id;
END;
$$ LANGUAGE plpgsql;


-- edycja zażalenia
CREATE OR REPLACE FUNCTION sp_edit_complaint(
    complaint_id INTEGER,
    new_status VARCHAR(9) DEFAULT NULL,
    new_content TEXT DEFAULT NULL,
    new_solution_date TIMESTAMP DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM complaint
        WHERE id = complaint_id
    ) THEN
        RAISE EXCEPTION 'Error: Complaint with ID % does not exist.', complaint_id;
    END IF;

    IF new_status IS NOT NULL AND new_status NOT IN ('active', 'resolved', 'suspended') THEN
        RAISE EXCEPTION 'Error: Invalid status value (%). Allowed values: active, resolved, suspended.', new_status;
    END IF;

    UPDATE complaint
    SET
        status = COALESCE(new_status, status),
        content = COALESCE(new_content, content),
        solutionDate = COALESCE(new_solution_date, solutionDate)
    WHERE id = complaint_id;

    RAISE NOTICE 'Complaint with ID % updated successfully!', complaint_id;
END;
$$ LANGUAGE plpgsql;

--delete like
CREATE OR REPLACE FUNCTION sp_remove_bump(
    p_user_id INTEGER,
    p_comment_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM bumpCount
        WHERE userId = p_user_id
          AND commentId = p_comment_id
    ) THEN
        RAISE EXCEPTION 'Error: Like not found for user % on comment %.', p_user_id, p_comment_id;
    END IF;

    DELETE FROM bumpCount
    WHERE userId = p_user_id
      AND commentId = p_comment_id;

    RAISE NOTICE 'Like removed successfully for user % on comment %.', p_user_id, p_comment_id;
END;
$$ LANGUAGE plpgsql;
