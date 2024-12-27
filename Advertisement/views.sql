
CREATE VIEW flatpol.addressesView AS
SELECT a.country,
       a.region,
       a.postalCode,
       a.city,
       a.street,
       a.buildingNum,
       a.flatNum,
       c.latitude,
       c.longitude
FROM flatpol.address a
         JOIN flatpol.coordinates c ON a.coordinatesId = c.id;




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





CREATE VIEW flatpol.userPaymentsView AS
SELECT u.firstName,
       u.lastName,
       p.price,
       p.creationDate,
       p.status
FROM flatpol.payment p
         JOIN flatpol.advertisement a ON p.advertisementId = a.id
         JOIN flatpol.user u ON a.userId = u.id;

CREATE VIEW flatpol.userPaymentsSortedView AS
SELECT u.firstName,
       u.lastName,
       p.price,
       p.creationDate,
       p.status
FROM flatpol.payment p
         JOIN flatpol.advertisement a ON p.advertisementId = a.id
         JOIN flatpol.user u ON a.userId = u.id
ORDER BY p.price DESC;

-- Pokazuje platnosc jaka nalezy uiscic podczas tworzenia ogloszenia
--Ten widok pokazuje, "c. kwota, którą użytkownik zostaje obciążony za dodanie ogłoszenia". Daje się mu ID ogłoszenia, które jest tworzone.
CREATE VIEW flatpol.advertPayment AS
    SELECT
SELECT p.price,
       p.creationDate,
       p.status
FROM flatpol.payment p
         JOIN flatpol.advertisement a ON p.advertisementId = a.id
WHERE a.id = @AdvertId;