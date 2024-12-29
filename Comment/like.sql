CREATE TABLE bump_count (
    id SERIAL PRIMARY KEY,
	userId INTEGER NOT NULL REFERENCES Users(id),
    commentId INTEGER NOT NULL REFERENCES comment(id)
);