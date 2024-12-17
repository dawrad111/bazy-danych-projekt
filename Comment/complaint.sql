CREATE TABLE complaint (
    id SERIAL PRIMARY KEY,
	userId INTEGER NOT NULL users(id),
    content TEXT NOT NULL,
    postDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    solutionDate TIMESTAMP DEFAULT NULL,
	status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'resolved', 'suspended'))
);