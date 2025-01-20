USE telegram;

SELECT *
FROM users;

SELECT DISTINCT firstname
FROM users;

SELECT count(firstname) 
FROM users;

SELECT *
FROM channels
WHERE title LIKE '%sql%';

SELECT *
FROM channels
WHERE title COLLATE utf8mb4_0900_as_cs LIKE '%sql%'; -- cs на конце говорит о важности регистра

select *
FROM users
WHERE firstname LIKE '____'; -- оличество нижних подчеркиваний количество букв в слове

SELECT *
FROM private_messages
 WHERE sender_id = 1 AND receiver_id = 2
   OR sender_id = 2 AND receiver_id = 1
ORDER BY created_at DESC; -- сортировка в обратном порядке

ALTER TABLE private_messages
ADD COLUMN is_read BIT DEFAULT 0 NOT NULL;

SELECT *
FROM private_messages;

UPDATE private_messages
SET is_read = 1
 WHERE  sender_id = 2 AND receiver_id = 1;

SELECT count(*)
FROM private_messages
WHERE receiver_id = 1
AND is_read = 0;

SELECT *
FROM private_messages
 WHERE (sender_id = 1 AND receiver_id = 2
   OR sender_id = 2 AND receiver_id = 1) AND media_type = 'image';

SELECT min(YEAR(birthday))
FROM users;

SELECT ROUND(AVG(YEAR(birthday)))
FROM users;

SELECT 
count(*),
app_language
FROM user_settings
GROUP BY app_language
ORDER BY count(*) desc;

DESCRIBE user_settings;

SELECT 
	count(*) AS cnt,
	channel_id 
FROM channel_subscribers
WHERE status = 'joined'
GROUP BY channel_id 
ORDER BY cnt DESC 
LIMIT 1;

SELECT 
  count(*) AS cnt,
  group_id
  FROM group_messages
  GROUP BY group_id
  HAVING cnt > 80
  ORDER BY cnt desc;

SELECT *
FROM stories
WHERE user_id IN (2,3,4,5);

SELECT *
FROM users
WHERE phone IS NOT NULL;

SELECT *
FROM users
WHERE phone IS NOT null
ORDER BY id -- без сортировки пагинацию делать нельзя
LIMIT 5 OFFSET 10;

SELECT 
is_private,
IF (is_private, 'частный', 'публичный'),
title
FROM channels;

SELECT 
  COUNT(*) AS cnt,
  CASE 
    WHEN YEAR(birthday) > 1945 AND YEAR(birthday) < 1965 THEN 'baby boomer'
    WHEN YEAR(birthday) > 1964 AND YEAR(birthday) < 1980 THEN 'generation x'
    WHEN YEAR(birthday) > 1979 AND YEAR(birthday) < 1996 THEN 'millennial'
    WHEN YEAR(birthday) > 1995 AND YEAR(birthday) < 2012 THEN 'generation z'
    WHEN YEAR(birthday) > 2011 THEN 'alpha'
  END AS generation
FROM users
GROUP BY generation
ORDER BY cnt;

SELECT 
  COUNT(*) AS cnt,
  CASE 
    WHEN YEAR(birthday) BETWEEN 1945 AND 1964 THEN 'baby boomer'
    WHEN YEAR(birthday) BETWEEN 1965 AND 1979 THEN 'generation x'
    WHEN YEAR(birthday) BETWEEN 1980 AND 1995 THEN 'millennial'
    WHEN YEAR(birthday) BETWEEN 1996 AND 2011 THEN 'generation z'
    WHEN YEAR(birthday) > 2011 THEN 'alpha'
  END AS generation
FROM users
GROUP BY generation
ORDER BY cnt;
