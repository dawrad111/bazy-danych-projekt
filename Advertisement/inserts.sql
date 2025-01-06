INSERT INTO address (country, region, postalCode, city, street, buildingNum, flatNum)
VALUES ('Poland', 'Dolny Śląsk', '50-421', 'Wrocław', 'Na Grobli', '15', 12),
('Poland', 'Dolny Śląsk', '50-366', 'Wrocław', 'Grunwaldzka', '59', 3),
('Poland', 'Dolny Śląsk', '51-627', 'Wrocław', 'Wróblewskiego', '27', 5),
--     generate more values
('Poland', 'Dolny Śląsk', '50-334', 'Wrocław', 'Rozbrat', '7', 10),
('Poland', 'Dolny Śląsk', '51-640', 'Wrocław', 'Braci Gierymskich', '45A', 10),
('Poland', 'Dolny Śląsk', '50-112', 'Wrocław', 'Piłsudskiego', '31', 2),
('Poland', 'Dolny Śląsk', '50-200', 'Wrocław', 'Kościuszki', '12A', NULL),
('Poland', 'Dolny Śląsk', '50-345', 'Wrocław', 'Oławska', '8', 14),
('Poland', 'Dolny Śląsk', '50-555', 'Wrocław', 'Hallera', '45B', 3),
('Poland', 'Dolny Śląsk', '50-567', 'Wrocław', 'Powstańców Śląskich', '72', NULL),
('Poland', 'Dolny Śląsk', '51-231', 'Wrocław', 'Legnicka', '120', 18),
('Poland', 'Dolny Śląsk', '51-332', 'Wrocław', 'Plac Grunwaldzki', '15', 10),
-- Rekordy z innych miast
('Poland', 'Mazowieckie', '00-001', 'Warszawa', 'Marszałkowska', '33', NULL),
('Poland', 'Małopolskie', '31-001', 'Kraków', 'Floriańska', '7', 5),
('Poland', 'Wielkopolskie', '61-001', 'Poznań', 'Święty Marcin', '22', 8)
RETURNING *;




INSERT INTO advertisement (userId, addressId, status, title, priceId, objectId)
VALUES (1, 1, 'posted', 'Mieszkanie na sprzedaż', 1, 2),
(2, 2, 'posted', 'Mieszkanie na wynajem', 2, 3),
(3, 3, 'posted', 'Dom na sprzedaż', 3, 4),
(4, 4, 'posted', 'Dom na wynajem', 4, 5),
(5, 5, 'posted', 'Pokój na wynajem', 5, 6),
(1, 1, 'posted', 'Nowoczesne mieszkanie w centrum', 1, 7),
(2, 2, 'pending', 'Stylowe mieszkanie w sercu miasta', 2, 8),
(3, 3, 'posted', 'Dom z ogrodem na przedmieściach', 3, 9),
(4, 4, 'ended', 'Dom z garażem i basenem', 4, 10),
(5, 5, 'canceled', 'Przytulny pokój na wynajem', 5, 11),
(6, 6, 'suspended', 'Duży apartament z balkonem', 6, 12),
(7, 7, 'posted', 'Ekskluzywny dom w prestiżowej lokalizacji', null, 13),
(8, 8, 'pending', 'Przestronny pokój w świetnej lokalizacji', null, 14),
(9, 9, 'posted', 'Willa z widokiem na góry', null, 5),
(10, 10, 'ended', 'Mieszkanie do remontu w świetnej cenie', null, 4)
RETURNING *;



INSERT INTO coordinates (latitude, longitude)
VALUES
(51.1005, 17.0624),  -- Na Grobli, Wrocław
(51.1059, 17.0373), -- Grunwaldzka, Wrocław
(51.1047, 17.0745), -- Wróblewskiego, Wrocław
(51.1097, 17.0326),  -- Wrocław, Piłsudskiego
(51.1079, 17.0385),  -- Wrocław, Kościuszki
(51.1095, 17.0438),  -- Wrocław, Oławska
(51.0915, 17.0234),  -- Wrocław, Hallera
(51.0962, 17.0358),  -- Wrocław, Powstańców Śląskich
(51.1171, 17.0159),  -- Wrocław, Legnicka
(51.1138, 17.0462),  -- Wrocław, Plac Grunwaldzki
(52.2297, 21.0122),  -- Warszawa, Marszałkowska
(50.0647, 19.9450),  -- Kraków, Floriańska
(52.4095, 16.9319)  -- Poznań, Święty Marcin
RETURNING *;


INSERT INTO payment (price, status,advertisementId)
VALUES
-- Powiązane z ogłoszeniami z tabeli advertisement
(10.00, 'ended', 1),      -- Powiązane z AdvertisementId 1
(15.50, 'pending', 2),     -- Powiązane z AdvertisementId 2
(20.00, 'ended', 2),      -- Powiązane z AdvertisementId 3
(10.00, 'suspended', 3),  -- Powiązane z AdvertisementId 4
(25.00, 'ended', 1),      -- Powiązane z AdvertisementId 5
(50.00, 'pending', 4),     -- Powiązane z AdvertisementId 6
(12.00, 'suspended', 5),  -- Powiązane z AdvertisementId 7
(30.00, 'ended', 1),      -- Powiązane z AdvertisementId 8
(8.00, 'pending', 4),     -- Powiązane z AdvertisementId 9
(40.00, 'ended', 3)      -- Powiązane z AdvertisementId 10
RETURNING *;