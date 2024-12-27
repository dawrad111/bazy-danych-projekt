INSERT INTO Comment (userId, advertisementId, content, status)
VALUES
(1, 1, 'Bardzo polecam!', 'active'),
(2, 2, 'Produkt zgodny z opisem', 'active'),
(3, 3, 'Szybka wysyłka!', 'active'),
(4, 4, 'Nie polecam. Problemy z dostawą.', 'suspended'),
(5, 5, 'Świetny kontakt z sprzedawcą!', 'active'),
(6, 6, 'Towar uszkodzony', 'suspended'),
(7, 7, 'Super jakość!', 'active'),
(8, 8, 'Zbyt drogo.', 'suspended'),
(9, 9, 'OK', 'active'),
(10, 10, 'Polecam w 100%!', 'active');

INSERT INTO Complaint (userId, content, status)
VALUES
(1, 'Proszę o sprawdzenie płatności za ogłoszenie nr 101.', 'active'),
(2, 'Reklamacja dotycząca jakości ogłoszenia nr 102.', 'resolved'),
(3, 'Nieprawidłowe dane ogłoszenia nr 103.', 'active'),
(4, 'Problem z dostawą produktu z ogłoszenia nr 104.', 'active'),
(5, 'Brak kontaktu ze sprzedawcą z ogłoszenia nr 105.', 'resolved'),
(6, 'Uszkodzony towar w ogłoszeniu nr 106.', 'active'),
(7, 'Ogłoszenie niezgodne z opisem nr 107.', 'suspended'),
(8, 'Proszę o anulowanie ogłoszenia nr 108.', 'active'),
(9, 'Zwrot pieniędzy za ogłoszenie nr 109.', 'resolved'),
(10, 'Prośba o edycję ogłoszenia nr 110.', 'active');

INSERT INTO Like (userId, commentId)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);
