CREATE TABLE advertisement
(
    id                   SERIAL PRIMARY KEY,
    postTime             TIMESTAMP             default current_timestamp,
    endDate              DATE null,
    userId               INT references Users (id),
    addressId            INT references address (id),
    status               VARCHAR(12)  not null default 'pending' CHECK (status IN ('pending', 'posted', 'ended', 'canceled', 'suspended')),
    title                VARCHAR(150) not null,
    lastModificationDate TIMESTAMP             default current_timestamp,
    paymentId            INT references payment (id),
    priceId              INT references price (id),
    objectId             INT references object (id)
);



INSERT INTO advertisement (userId, addressId, status, title, paymentId, priceId, objectId)
VALUES (2, 1, 'posted', 'Mieszkanie na sprzedaż', 1, 1, 1),
       (2, 2, 'posted', 'Mieszkanie na wynajem', 2, 2, 2),
       (2, 3, 'posted', 'Dom na sprzedaż', 3, 3, 3),
       (2, 4, 'posted', 'Dom na wynajem', 4, 4, 4),
       (2, 5, 'posted', 'Pokój na wynajem', 5, 5, 5) RETURNING *;


-- CREATE VIEW advertisementsView AS
-- SELECT ad.city, ad.street, a.title, pr.price, pr.currency
-- FROM advertisement a
--          JOIN address ad ON a.addressId = ad.id
--          JOIN price pr ON a.priceId = pr.id;

-- CREATE VIEW advertisementsPriceSortedView AS
-- SELECT ad.city, ad.street, a.title, pr.price, pr.currency
-- FROM advertisement a
--          JOIN address ad ON a.addressId = ad.id
--          JOIN price pr ON a.priceId = pr.id
-- ORDER BY pr.price DESC;

-- Shows all advertisements in a given area
CREATE PROCEDURE advertisementInArea
    @City VARCHAR(100) DEFAULT NULL,
    @Region VARCHAR(100) DEFAULT NULL,
    @Country VARCHAR(100) DEFAULT NULL
AS
BEGIN
    SELECT ad.city, ad.street, a.title, pr.price, pr.currency
    FROM advertisement a
         JOIN address ad ON a.addressId = ad.id
         JOIN price pr ON a.priceId = pr.id
    WHERE (@City IS NULL OR ad.City = @City)
      AND (@Region IS NULL OR ad.Region = @Region)
      AND (@Country IS NULL OR ad.Country = @Country);
END;

-- CREATE VIEW allUserAdvertisementsView AS
-- SELECT u.name,
--        u.surName,
--        ad.title,
--        ad.status,
--        pr.price,
--        pr.currency,
--        ad.postTime,
--        ad.endDate
-- FROM advertisement ad
--          JOIN users u ON ad.userId = u.id
--          JOIN price pr ON ad.priceId = pr.id;
