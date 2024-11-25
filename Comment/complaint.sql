CREATE TABLE complaint (
    id SERIAL PRIMARY KEY,
	userId INTEGER REFERENCES users(id),
    postDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    solutionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'resolved', 'suspended'))
);