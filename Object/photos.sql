CREATE TABLE photos (
id SERIAL PRIMARY KEY,
photoURL VARCHAR(1000),
objectId INT REFERENCES object(id)
);

ALTER TABLE photos
ADD objectId INT REFERENCES object(id);