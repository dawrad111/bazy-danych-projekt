CREATE TABLE comment (
    id SERIAL PRIMARY KEY,
	userId INTEGER REFERENCES users(id),
    advertisementId INTEGER REFERENCES advrtisement(id),
    postDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastModificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hideDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	content TEXT,
	status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'suspended'))
);