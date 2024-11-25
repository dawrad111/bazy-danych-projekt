CREATE TABLE house (
id INT PRIMARY KEY DEFAULT nextval('house_id_seq'),
stories INT,
atticSquareFootage FLOAT NULL,
terraceSquareFootage FLOAT NULL,
plotArea FLOAT NULL
);
