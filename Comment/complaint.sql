CREATE TABLE complaint (
    id SERIAL PRIMARY KEY,
	userId INTEGER NOT NULL users(id),
    postDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    solutionDate TIMESTAMP DEFAULT NULL,
	status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'resolved', 'suspended'))
);