CREATE TABLE comment (
    id SERIAL PRIMARY KEY,
	userId INTEGER NOT NULL REFERENCES Users(id),
    advertisementId INTEGER NOT NULL REFERENCES advertisement(id),
    postDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastModificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hideDate TIMESTAMP DEFAULT NULL,
	content TEXT NOT NULL ,
	status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'suspended'))
);