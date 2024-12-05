CREATE TABLE IF NOT EXISTS Organizations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL
);
CREATE TABLE IF NOT EXISTS Channels(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    organization_id INT NOT NULL,
    FOREIGN KEY(organization_id) REFERENCES Organizations(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL
);
CREATE TABLE IF NOT EXISTS Messages(
    id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    post_time TIMESTAMP DEFAULT current_timestamp,
    user_id INT NOT NULL,
    channel_id INT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES Users(id),
    FOREIGN KEY(channel_id) REFERENCES Channels(id) ON DELETE CASCADE
);
USE chat_system;
-- inserting values in organization table
INSERT INTO Organizations (name)
VALUES ("Lambda School");
-- inserting values into users table
INSERT INTO Users (name)
VALUES ("Alice"),
    ("Bob"),
    ("Chris");
-- inserting values into channels table 
INSERT INTO Channels (name, organization_id)
VALUES ("#general", 1),
    ("#random", 1);
-- inserting values into messages table
INSERT INTO Messages (content, user_id, channel_id)
VALUES ("Hi,folks", 1, 1),
    ("Hi Alice", 2, 1),
    ("we are gonna talk about random topics", 3, 2),
    ("ok chris", 1, 2),
    ("Welcome everyone!", 1, 1),
    -- Alice in #general
    ("Sounds good, Chris!", 2, 2),
    -- Bob in #random
    ("Let's discuss ideas", 3, 2),
    -- Chris in #random
    ("How is everyone doing?", 1, 1),
    -- Alice in #general
    ("Do we have any updates?", 2, 1),
    -- Bob in #general
    ("Looking forward to it!", 3, 2);
-- Chris in #random
-- querying by select 
-- List all organization names
SELECT name
from Organizations;
-- List all channel names.
select name
from Channels;
-- List all channels in a specific organization by organization name.
SELECT *
FROM Channels
WHERE organization_id IN (
        SELECT id
        FROM Organizations
    );
-- List all messages in a specific channel by channel name #general in order of post_time, descending.
SELECT *
FROM Messages
WHERE channel_id IN (
        SELECT id
        FROM Channels
        where name = "#general"
    )
ORDER BY post_time DESC;
-- List all channels to which user Alice belongs.
SELECT DISTINCT name
FROM Channels c
    LEFT JOIN Messages m ON c.id = m.channel_id
WHERE m.user_id IN (
        SELECT id
        FROM Users
        where name = "Alice"
    );
-- List all users that belong to channel #general.
WITH CTE AS(
    SELECT DISTINCT m.user_id
    FROM Channels c
        LEFT JOIN Messages m ON c.id = m.channel_id
    WHERE c.name = "#general"
)
SELECT name
FROM Users
Where id IN (
        SELECT *
        FROM CTE
    );
-- List all messages in all channels by user Alice.
SELECT content,
    channel_id
FROM Messages
where user_id IN (
        SELECT id
        FROM Users
        where name = "Alice"
    );
-- List all messages in #random by user Bob
SELECT content
FROM Messages
where user_id IN (
        SELECT id
        FROM Users
        WHERE name = "Bob"
    )
    AND channel_id IN (
        SELECT id
        FROM Channels
        WHERE name = "#random"
    );
-- List the count of messages across all channels per user
-- SELECT
u.name,
COUNT(*) AS Message_Count
FROM Users u
    LEFT JOIN Messages m ON u.id = m.user_id
GROUP BY u.name;
--  List the count of messages per user per channel.
SELECT u.name AS User_Name,
    c.name AS Channel_Name,
    COUNT(*) AS Message_Count
FROM Messages m
    LEFT JOIN Users u ON m.user_id = u.id
    LEFT JOIN Channels c ON m.channel_id = c.id
GROUP BY u.name,
    c.name;
-- What SQL keywords or concept would you use if you wanted to automatically delete all messages by a user if that user were deleted from the user table?
-- ON DELETE CASCADE
