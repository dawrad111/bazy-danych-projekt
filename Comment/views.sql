CREATE VIEW showUserComments AS
SELECT comment.advertisementId, comment.postDate, comment.content, users.name, users.surname, COUNT(like.id) AS likeCount
FROM showUserComment
INNER JOIN users
ON users.userId = comment.userId
INNER JOIN like
ON comment.id = like.commentId
WHERE comment.status = 'active' AND comment.userId = 1;

CREATE VIEW viewActiveComplaints AS
SELECT complaint.content, complaint.postDate, users.name, users.surname, users.email
FROM complaint
INNER JOIN users
ON complaint.userId = users.userId
WHERE complaint.status = 'active';