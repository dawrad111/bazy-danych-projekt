CREATE TABLE like (
    id SERIAL PRIMARY KEY,
	userId INTEGER REFERENCES users(id),
    commentId INTEGER REFERENCES comment(id),
);