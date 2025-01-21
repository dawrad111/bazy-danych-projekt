-- blad, nie da sie policzyc ilosci likeow
CREATE VIEW view_show_User_Comments AS
SELECT comment.advertisementId, comment.postDate, comment.content, users.name, users.surname, COUNT(like.id) AS likeCount
FROM showUserComment
INNER JOIN users
ON users.Id = comment.userId
INNER JOIN like
ON comment.id = like.commentId
WHERE comment.status = 'active' AND comment.userId = 1;

CREATE VIEW ActiveComplaintsView AS
SELECT complaint.content, complaint.postDate, u.name, u.surname, e.email
FROM complaint
INNER JOIN users u ON complaint.userId = u.id
INNER JOIN email e ON u.emailid = e.id
WHERE complaint.status = 'active';

CREATE OR REPLACE VIEW view_active_comments AS
SELECT
    c.id AS comment_id,
    c.userId AS user_id,
    u.name AS user_name,
    u.surname AS user_surname,
    c.advertisementId AS advertisement_id,
    c.postDate AS post_date,
    c.lastModificationDate AS last_modification_date,
    c.content AS comment_content
FROM
    comment c
INNER JOIN
    users u
ON
    c.userId = u.id
WHERE
    c.status = 'active';

