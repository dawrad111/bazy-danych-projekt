CREATE TABLE comment (
    id SERIAL PRIMARY KEY,
	userId INTEGER NOT NULL users(id),
    advertisementId INTEGER NOT NULL advrtisement(id),
    postDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastModificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hideDate TIMESTAMP DEFAULT NULL,
	content TEXT NOT NULL ,
	status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'suspended'))
);

CREATE TABLE complaint (
    id SERIAL PRIMARY KEY,
	userId INTEGER NOT NULL users(id),
    content TEXT NOT NULL,
    postDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    solutionDate TIMESTAMP DEFAULT NULL,
	status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'resolved', 'suspended'))
);

CREATE TABLE like (
    id SERIAL PRIMARY KEY,
	userId INTEGER NOT NULL users(id),
    commentId INTEGER NOT NULL comment(id),
);