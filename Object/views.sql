--WIDOKI--------------

--nie jestem pewien czy potrzebne
--ogloszenia z domami i zdjęciami
CREATE VIEW flatpol.selectAdsHousesPhotos AS
SELECT a.id, a.title, o.id, o.description, p.id, p.photoURL, h.id, pr.price
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON o.photosID = p.id
JOIN House h ON o.typeId IS NOT NULL AND o.typeId = h.id
JOIN Price pr ON a.priceId = pr.id;

--ogloszenia z mieszkaniami i zdjęciami
CREATE VIEW flatpol.selectAdsHousesPhotos AS
SELECT a.id, a.title, o.id, o.description, p.id, p.photoURL, pr.price
FROM Advertisement a
JOIN Object o ON a.objectId = o.id
JOIN Photos p ON o.photosID = p.id
JOIN House h ON o.typeId IS NULL
JOIN Price pr ON a.priceId = pr.id;




--wylistowanie wszystkiego zwiazanego z domem
CREATE VIEW flatpol.selectAdsHousesPhotos AS
SELECT a.*, o.*, p.*, h.*, pr.*, ad.*
FROM Advertisement a
LEFT JOIN Object o ON a.objectId = o.id
LEFT JOIN Photos p ON o.photosId = p.id
JOIN House h ON o.typeId IS NOT NULL AND o.typeId = h.id
LEFT JOIN Price pr ON a.priceId = pr.id
LEFT JOIN Address ad ON a.addressId = ad.id;

--wylistowanie wszystkiego zwiazanego z mieszkaniem
CREATE VIEW flatpol.selectAdsFlatsPhotos AS
SELECT o.*, p.*, pr.*, ad.*
FROM Object
LEFT JOIN Photos p ON o.photosId = p.id
LEFT JOIN Price pr ON a.priceId = pr.id
LEFT JOIN Address ad ON a.addressId = ad.id;





--wyszuaknie istotnych informacji od mieszkan
--Te procedure przewiduje jako jedno z wyswietlanych podczas tworzenia ogloszenia mieszkania
CREATE VIEW flatpol.selectFlatsAll AS
    SELECT o.id,
    ph.photoURL,
    o.description,
    o.squareFootage,
    o.rooms,
    o.bathrooms,
    o.floor
    o.basementSquareFootage,
    o.balconysquareFootage,
    o.allowanimals
FROM flatpol.object o
LEFT JOIN flatpol.photos ph ON ph.id = o.photosId;

--wyszuaknie istotnych informacji od domow,
--to mozna dac jako SELECT * FROM selectFlatsALL WHERE
--np. o.bathrooms > 2 albo WHERE h.plotArea < 1000 ORDER BY h.plotArea DESC;
--Tę procedurę przewiduję jako jedną z wyswietlanych podczas tworzenia domu
CREATE VIEW flatpol.selectHousesAll AS
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
FROM flatpol.object o
JOIN flatpol.house h ON h.id = o.typeId
LEFT JOIN flatpol.photos ph ON ph.id = o.photosId;




--Te procedure przewiduje jako jedna z wyswietlanych podczas tworzenia ogloszenia
--wylistowanie cen
CREATE VIEW flatpol.showPrices AS
    SELECT
    pr.price,
    pr.rent,
    pr.media,
    pr.typeOfPayment,
    pr.deposit,
    pr.typeOfOwner
FROM flatpol.price
JOIN flatpol.advertisement a ON a.priceId = pr.id;






--sortowanie po cenach
CREATE VIEW flatpol.showPrices AS
    SELECT
    a.id,
    SUM(pr.price,
    pr.rent,
    pr.media) AS price_final
FROM flatpol.Advertisement
JOIN flatpol.Price pr ON a.priceId = pr.id
ORDER BY price_final DESC;



--pod takie pokazanie na stronie
--wyszukanie opisów mieszkań
CREATE VIEW flatpol.objectDesc AS
SELECT a.id, o.id, o.description
FROM flatpol.Advertisement a
JOIN flatpol.Object o ON a.objectId = o.id;


--wylistowanie tylko zdjec
CREATE VIEW flatpol.showOnlyPhotos AS
    SELECT o.id, p.photoURL
    FROM Object o
    LEFT JOIN Photos p ON o.photosId = p.id;


--wylistowanie ilosci zdjec
CREATE VIEW flatpol.photo_count_per_object AS
SELECT o.id, COUNT(p.id)
FROM object o
LEFT JOIN photos p ON o.photosId = p.id
GROUP BY o.id;
