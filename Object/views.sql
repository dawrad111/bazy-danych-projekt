--WIDOKI--------------

--nie jestem pewien czy potrzebne
--ogloszenia z domami, mieszkaniami i zdjęciami
-- g
begin transaction;
CREATE VIEW selectAdsHousesPhotos AS
SELECT a.id AS advertisement_id, a.title, 
       o.id AS object_id, o.description, 
       p.id AS photo_id, p.photoURL, 
       h.id AS house_id, 
       pr.price
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
LEFT JOIN Photos p ON o.id = p.objectId
LEFT JOIN House h ON o.typeId = h.id
LEFT JOIN Price pr ON a.priceId = pr.id;

--wylistowanie wszystkiego zwiazanego z domem/mieszkaniem
CREATE VIEW selectAdsEverythingView AS
SELECT a.id AS advertisement_id, a.*, 
       o.id AS object_id, o.*, 
       p.id AS photo_id, p.*, 
       h.id AS house_id, h.*, 
       pr.id AS price_id, pr.*, 
       ad.id AS address_id, ad.*
FROM Advertisement a
LEFT JOIN Object o ON a.objectId = o.id
LEFT JOIN Photos p ON o.id = p.objectId
LEFT JOIN House h ON o.typeId = h.id
LEFT JOIN Price pr ON a.priceId = pr.id
LEFT JOIN Address ad ON a.addressId = ad.id;


-- wyszuaknie istotnych informacji od mieszkan
-- Te procedure przewiduje jako jedno z wyswietlanych podczas tworzenia ogloszenia mieszkania
CREATE VIEW selectFlatsAll AS
    SELECT o.id,
    ph.photoURL,
    o.description,
    o.squareFootage,
    o.rooms,
    o.bathrooms,
    o.floor,
    o.basementSquareFootage,
    o.balconysquareFootage,
    o.allowanimals
FROM object o
LEFT JOIN photos ph ON o.id = ph.objectId;

-- wyszuaknie istotnych informacji od domow,
-- to mozna dac jako SELECT * FROM selectFlatsALL WHERE
-- np. o.bathrooms > 2 albo WHERE h.plotArea < 1000 ORDER BY h.plotArea DESC;
-- Tę procedurę przewiduję jako jedną z wyswietlanych podczas tworzenia domu
CREATE VIEW selectHousesAll AS
    SELECT o.id,
    ph.photoURL,
    o.squareFootage,
    o.description,
    o.rooms,
    o.bathrooms,
    o.basementSquareFootage,
    o.balconysquareFootage,
    h.stories,
    h.atticSquareFootage,
    h.terraceSquareFootage,
    h.plotArea,
    o.allowanimals
FROM object o
JOIN house h ON h.id = o.typeId
LEFT JOIN photos ph ON o.id = ph.objectId;




-- Te procedure przewiduje jako jedna z wyswietlanych podczas tworzenia ogloszenia
-- wylistowanie cen
CREATE VIEW showPrices AS
    SELECT
    pr.price,
    pr.rent,
    pr.media,
    pr.typeOfPayment,
    pr.deposit,
    pr.typeOfOwner
FROM price pr
JOIN advertisement a ON a.priceId = pr.id;






--sortowanie po cenach
-- Error in query: ERROR: function sum(integer, double precision, double precision) does not exist
-- LINE 5: SUM(pr.price,
-- HINT: No function matches the given name and argument types. You might need to add explicit type casts.
-- CREATE VIEW showFinalPrices AS
--     SELECT
--     a.id,
--     SUM(pr.price,
--     pr.rent,
--     pr.media) AS price_final
-- FROM Advertisement a
-- JOIN Price pr ON a.priceId = pr.id
-- ORDER BY price_final DESC;



--pod takie pokazanie na stronie
--wyszukanie opisów mieszkań
CREATE VIEW objectDesc AS
SELECT a.id as AdvertisementId, o.id as ObjectId, o.description
FROM Advertisement a
JOIN Object o ON a.objectId = o.id;


--wylistowanie tylko zdjec
CREATE VIEW showOnlyPhotos AS
    SELECT o.id, p.photoURL
    FROM Object o
    LEFT JOIN Photos p ON o.id = p.objectId;


--wylistowanie ilosci zdjec
CREATE VIEW photo_count_per_object AS
SELECT o.id, COUNT(p.id)
FROM object o
LEFT JOIN photos p ON o.id = p.objectId
GROUP BY o.id;

commit;