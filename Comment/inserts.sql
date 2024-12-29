INSERT INTO Comment (userId, advertisementId, content, status)
VALUES
(1, 31, 'Bardzo polecam!', 'active'),
(2, 32, 'Produkt zgodny z opisem', 'active'),
(3, 33, 'Szybka wysyłka!', 'active'),
(4, 34, 'Nie polecam. Problemy z dostawą.', 'suspended'),
(3, 35, 'Świetny kontakt z sprzedawcą!', 'active'),
(6, 36, 'Towar uszkodzony', 'suspended'),
(7, 37, 'Super jakość!', 'active'),
(5, 38, 'Zbyt drogo.', 'suspended'),
(9, 39, 'OK', 'active'),
(10, 40, 'Polecam w 100%!', 'active');

INSERT INTO Complaint (userId, content, status)
VALUES
(1, 'Proszę o sprawdzenie płatności za ogłoszenie nr 101.', 'active'),
(2, 'Reklamacja dotycząca jakości ogłoszenia nr 102.', 'resolved'),
(3, 'Nieprawidłowe dane ogłoszenia nr 103.', 'active'),
(4, 'Problem z dostawą produktu z ogłoszenia nr 104.', 'active'),
(5, 'Brak kontaktu ze sprzedawcą z ogłoszenia nr 105.', 'resolved'),
(6, 'Uszkodzony towar w ogłoszeniu nr 106.', 'active'),
(5, 'Ogłoszenie niezgodne z opisem nr 107.', 'suspended'),
(8, 'Proszę o anulowanie ogłoszenia nr 108.', 'active'),
(9, 'Zwrot pieniędzy za ogłoszenie nr 109.', 'resolved'),
(10, 'Prośba o edycję ogłoszenia nr 110.', 'active');

INSERT INTO bump_count (userId, commentId)
VALUES
(1, 1),
(1, 2),
(3, 2),
(1, 4),
(5, 5),
(6, 2),
(7, 7),
(1, 8),
(9, 9),
(1, 10);