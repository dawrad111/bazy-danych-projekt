CREATE TABLE flatpol.advertisement
(
    id                   SERIAL PRIMARY KEY,
    postTime             TIMESTAMP             default current_timestamp,
    endDate              DATE null,
    userId               INT references flatpol.user (id),
    addressId            INT references flatpol.address (id),
    status               VARCHAR(12)  not null default 'pending' CHECK (status IN ('pending', 'posted', 'ended', 'canceled', 'suspended')),
    title                VARCHAR(150) not null,
    lastModificationDate TIMESTAMP             default current_timestamp,
    paymentId            INT references flatpol.payment (id),
    priceId              INT references flatpol.price (id),
    objectId             INT references flatpol.object (id),
);



INSERT INTO flatpol.advertisement (userId, addressId, status, title, paymentId, priceId, objectId)
VALUES (1, 1, 'posted', 'Mieszkanie na sprzedaż', 1, 1, 1),
       (2, 2, 'posted', 'Mieszkanie na wynajem', 2, 2, 2),
       (3, 3, 'posted', 'Dom na sprzedaż', 3, 3, 3),
       (4, 4, 'posted', 'Dom na wynajem', 4, 4, 4),
       (5, 5, 'posted', 'Pokój na wynajem', 5, 5, 5) RETURNING *;


CREATE VIEW flatpol.advertisementsView AS
SELECT ad.city, ad.street, a.title, pr.price, pr.currency,
FROM flatpol.advertisement a
         JOIN flatpol.address ad ON a.addressId = ad.id
         JOIN flatpol.price pr ON a.priceId = pr.id;

CREATE VIEW flatpol.advertisementsPriceSortedView AS
SELECT ad.city, ad.street, a.title, pr.price, pr.currency,
FROM flatpol.advertisement a
         JOIN flatpol.address ad ON a.addressId = ad.id
         JOIN flatpol.price pr ON a.priceId = pr.id
ORDER BY pr.price DESC;

-- Shows all advertisements in a given area
CREATE PROCEDURE flatpol.advertisementInArea(
    @City VARCHAR(100) = NULL,
    @Region VARCHAR(100) = NULL,
    @Country VARCHAR(100) = NULL)
    AS
BEGIN
SELECT ad.city, ad.street, a.title, pr.price, pr.currency,
FROM flatpol.advertisement a
         JOIN flatpol.address ad ON a.addressId = ad.id
         JOIN flatpol.price pr ON a.priceId = pr.id
WHERE (@City IS NULL OR ad.City = @City)
  AND (@Region IS NULL OR ad.Region = @Region)
  AND (@Country IS NULL OR ad.Country = @Country);
END;

CREATE VIEW flatpol.allUserAdvertisementsView AS
SELECT u.firstName,
       u.lastName,
       ad.title,
       ad.status,
       pr.price,
       pr.currency,
       ad.postTime,
       ad.endDate
FROM flatpol.advertisement ad
         JOIN flatpol.user u ON ad.userId = u.id
         JOIN flatpol.price pr ON ad.priceId = pr.id;

