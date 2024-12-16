INSERT INTO comment (userId, advertisementId, content, status)
VALUES (1, 1, 'Ogloszenie zgodne z opisem', 'active';

INSERT INTO complaint (userId, content, status)
VALUES (1, 'Proszę o sprawdzenie statusu płatnosci o numerze 1', 'active');

INSERT INTO like (userId, commentId)
VALUES (1, 1);

SELECT COUNT(*)
FROM like
WHERE commentId = 1;

SELECT comment.id, comment.content, comment.postDate, COUNT(like.id) AS likeCount
FROM comment
LEFT JOIN like
ON comment.id = like.commentId
WHERE comment.status = 'active' AND comment.advertisement.Id = 1
GROUP BY comment.id, comment.content, comment.postDate
ORDER BY comment.postDate;

SELECT comment.id, comment.content, comment.postDate, COUNT(like.id) AS likeCount
FROM comment
LEFT JOIN like
ON comment.id = like.commentId
WHERE comment.status = 'active' AND comment.advertisement.Id = 1
GROUP BY comment.id, comment.content, comment.postDate
ORDER BY likeCount DESC;

SELECT *
FROM complaint
WHERE complaint.solutionDate IS NULL;

CREATE VIEW viewActiveComplaints AS
SELECT complaint.content, complaint.postDate, users.name, users.surname, users.email
FROM complaint
INNER JOIN users
ON complaint.userId = users.userId
WHERE complaint.status = 'active';

UPDATE complaint
SET complaint.solutionDate = CURRENT_TIMESTAMP,
    complaint.status = 'resolved'
WHERE complaint.id = 1;

UPDATE comment
SET comment.content = 'New contnent value',
    lastModofocationDate = CURRENT_TIMESTAMP
WHERE comment id = 1;

DELETE FROM like
WHERE like.id = 1;

CREATE VIEW showUserComments AS
SELECT comment.advertisementId, comment.postDate, comment.content, users.name, users.surname, COUNT(like.id) AS likeCount
FROM showUserComment
INNER JOIN users
ON users.userId = comment.userId
INNER JOIN like
ON comment.id = like.commentId
WHERE comment.status = 'active' AND comment.userId = 1;

SELECT advertisement.title, advertisement.addressId, COUNT(comment.Id)
FROM advertisement
INNER JOIN comment 
ON advertisement.id = comment.advertisementId
WHERE advertisement.status = "active"
GROUP BY advertisement.title, advertisement.addressId, advertisement.status
ORDER BY COUNT(comment.Id) ASC
