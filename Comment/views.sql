-- blad, nie da sie policzyc ilosci likeow
CREATE VIEW showUserCommentsView AS
SELECT comment.advertisementId, comment.postDate, comment.content, users.name, users.surname, COUNT(like.id) AS likeCount
FROM showUserComment
INNER JOIN users
ON users.Id = comment.userId
INNER JOIN like
ON comment.id = like.commentId
WHERE comment.status = 'active' AND comment.userId = 1;

-- CREATE VIEW ActiveComplaintsView AS
-- SELECT complaint.content, complaint.postDate, u.name, u.surname, e.email
-- FROM complaint
-- INNER JOIN users u ON complaint.userId = u.id
-- INNER JOIN email e ON u.emailid = e.id
-- WHERE complaint.status = 'active';