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

SELECT advertisement.title, advertisement.addressId, COUNT(comment.Id)
FROM advertisement
INNER JOIN comment
ON advertisement.id = comment.advertisementId
WHERE advertisement.status = "active"
GROUP BY advertisement.title, advertisement.addressId, advertisement.status
ORDER BY COUNT(comment.Id) ASC