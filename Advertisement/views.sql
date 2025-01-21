
CREATE OR ALTER VIEW address_view AS
SELECT a.country,
       a.region,
       a.postalCode,
       a.city,
       a.street,
       a.buildingNum,
       a.flatNum,
       c.latitude,
       c.longitude
FROM address a
         LEFT JOIN coordinates c ON a.coordinatesId = c.id;




CREATE VIEW view_advertisements AS
SELECT a.id, ad.city, ad.street, a.title, pr.price
FROM advertisement a
         JOIN address ad ON a.addressId = ad.id
         JOIN price pr ON a.priceId = pr.id;

CREATE VIEW view_advertisements_price_sorted_view AS
SELECT ad.city, ad.street, a.title, pr.price
FROM advertisement a
         JOIN address ad ON a.addressId = ad.id
         JOIN price pr ON a.priceId = pr.id
ORDER BY pr.price DESC;


CREATE VIEW allUserAdvertisementsView AS
SELECT u.name,
       u.surname,
       ad.title,
       ad.status,
       pr.price,
       ad.postTime,
       ad.endDate
FROM advertisement ad
         JOIN users u ON ad.userId = u.id
         JOIN price pr ON ad.priceId = pr.id;





CREATE OR ALTER VIEW view_user_payments AS
SELECT u.name,
       u.surName,
       p.price,
       p.creationDate,
       p.status
FROM payment p
         JOIN advertisement a ON p.advertisementId = a.id
         JOIN users u ON a.userId = u.id;

CREATE VIEW userPaymentsSortedView AS
SELECT u.name,
       u.surName,
       p.price,
       p.creationDate,
       p.status
FROM payment p
         JOIN advertisement a ON p.advertisementId = a.id
         JOIN users u ON a.userId = u.id
ORDER BY p.price DESC;