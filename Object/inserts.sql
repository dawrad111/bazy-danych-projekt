--testowe wartosci:-------------------------
INSERT INTO Price (id, price, rent, media, deposit, typeOfPayment, typeofOwner)
VALUES
(1, 1500, 600, 300, 2500, 'lump', 'Private'),
(2,1200, 500, 200, 1500, 'monthly', 'Agency'),
(3, 2000, 800, 350, 2500, 'yearly', 'Private'),
(4, 1000, 800, 300, 2100, 'lump', 'Private'),
(5, 2200, 900, 200, 3100, 'lump', 'Agency'),
(6, 2700, 900, 500, 4300, 'yearly', 'Agency')
;






INSERT INTO Object (squareFootage, description, rooms, bathrooms, basementSquareFootage, balconySquareFootage, allowAnimals, floor, typeId)
VALUES
(120.5, 'Spacious apartment with a balcony', 4, 2, 10.0, 5.0, TRUE, 3, NULL),
(75.0, 'Cozy flat in the city center', 2, 1, NULL, 3.5, FALSE, 2, NULL),
(100.0, 'Modern house with garden', 3, 1, 20.0, NULL, TRUE, NULL, 1),
(95.5, 'Beautifully designed apartment with plenty of natural light and a spacious kitchen area.', 3, 1, NULL, 4.0, TRUE, 4, NULL),
(200.0, 'Luxury house with a large garden, private pool, and fully equipped modern amenities.', 6, 3, 50.0, 10.0, TRUE, NULL, 4),
(65.0, 'Small cozy flat, perfect for couples, located in a quiet neighborhood near parks.', 2, 1, NULL, 2.0, FALSE, 1, NULL),
(150.0, 'Family home with a large basement and spacious living room, located in the suburbs.', 5, 2, 40.0, NULL, TRUE, NULL, 5),
(120.0, 'Contemporary apartment with a stunning view of the city skyline, includes parking.', 3, 2, NULL, 6.0, TRUE, 8, NULL),
(180.0, 'Spacious villa featuring high ceilings, a garage, and a private backyard.', 4, 2, 30.0, 8.0, TRUE, NULL, 6),
(50.0, 'Compact studio apartment ideal for students, includes all basic amenities.', 1, 1, NULL, 1.0, FALSE, 5, NULL),
(240.0, 'Expansive countryside house with a large plot of land, perfect for farming.', 7, 4, 80.0, NULL, TRUE, NULL, 7),
(100.0, 'Modern duplex apartment with a shared terrace and close proximity to transport hubs.', 3, 2, NULL, 3.0, TRUE, 7, NULL),
(170.0, 'Rustic house with a fireplace, wooden interiors, and breathtaking mountain views.', 4, 2, 25.0, NULL, TRUE, NULL, 8);




INSERT INTO House (stories, atticSquareFootage, terraceSquareFootage, plotArea)
VALUES
(2, 15.0, 25.0, 12.0),  -- Pasuje do rekordu w Object o id = 2, typeId = 4
(3, 20.0, 30.0, 15.0),  -- Pasuje do rekordu w Object o id = 4, typeId = 5
(1, 10.0, 20.0, 8.0),   -- Pasuje do rekordu w Object o id = 6, typeId = 6
(2, 12.5, 18.0, 10.0),  -- Pasuje do rekordu w Object o id = 8, typeId = 7
(3, 22.0, 35.0, 20.0), -- Pasuje do rekordu w Object o id = 10, typeId = 8
(2, NULL, 15.0, 25.0), -- Przykład bez poddasza, pasuje do Object id = 12
(1, 8.0, NULL, 30.0),  -- Przykład bez tarasu, pasuje do Object id = 14
(4, 25.0, 40.0, 50.0), -- Duży dom, pasuje do Object id = 16
(2, 14.0, 22.0, 18.0), -- Średniej wielkości, pasuje do Object id = 18
(3, 18.0, 28.0, 35.0); -- Pasuje do Object id = 20





INSERT INTO Photos (objectId,photoURL)
VALUES
(9,'http://example.com/photo33.jpg'),
(10, 'http://example.com/photo4.jpg'),
(13, 'http://example.com/photo5.jpg'),
(6, 'http://example.com/photo6.jpg'),
(4, 'http://example.com/photo7.jpg'),
(5, 'http://example.com/photo8.jpg'),
(5, 'http://example.com/photo9.jpg'),
(5, 'http://example.com/photo10.jpg'),
(8, 'http://example.com/photo11.jpg'),
(9, 'http://example.com/photo12.jpg'),
(12, 'http://example.com/photo13.jpg');