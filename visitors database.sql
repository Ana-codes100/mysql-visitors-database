-- password is: Anafilipa15! --
CREATE DATABASE IF NOT EXISTS events_manager;
USE events_manager;

CREATE TABLE IF NOT EXISTS attendees (
attendee_id int PRIMARY KEY,
first_name varchar (45) NOT NULL,
last_name varchar(255) NOT NULL,
age INT,
postcode varchar (255),
sector varchar (255),
CONSTRAINT chk_attendee CHECK (Age>=1 AND age <= 100 AND CHAR_LENGTH(postcode) BETWEEN 5 AND 7 )  
);
ALTER TABLE attendees ENGINE = InnoDB;

SELECT * FROM attendees;

-- ALTER TABLE attendees
-- DROP COLUMN event_name;

INSERT INTO attendees
(attendee_id, first_name, last_name, age, postcode, sector)
VALUES 
(1, 'Miriam', 'Haifa', 45, 'M1 2WL', 'Advanced Machinery Manufacturing'),
(2, 'Pedro', 'Pascal', 29, 'M1 3GB', 'Software Development'),
(3, 'Julien', 'Vassiere', 33, 'M15 3LX', 'Innovation Intermediary'),
(4, 'Su', 'Weeks', 58, 'M1 2WL', 'Internet of Things (IoT)'),
(5, 'William', 'Blackshaw', 41, 'M3 5TU', '3D Printing and Additive Manufacturing'),
(6, 'Hung', 'Hueng', 26, 'M2 4SV', 'Technology Consultancy'),
(7, 'Ayanda', 'Nkosi', 67, 'M1 5FH', 'Robotics and Automation'),
(8, 'Maria', 'Oliveira', 36, 'M22 7XJ', 'Nanotechnology and Advanced Materials'),
(9, 'Andrei', 'Ionescu', 29, 'M13 0FL', 'Cybersecurity and Data Protection'),
(10, 'Amina', 'Ibrahim', 44, 'M5 3SF', 'Net Zero and Circular Economy Consultancy');

SELECT a.attendee_id, a.first_name, a.last_name, a.age, a.postcode, a.sector FROM attendees AS a;

CREATE TABLE IF NOT EXISTS events (
event_id int PRIMARY KEY, 
event_name VARCHAR (255), 
event_day DATE,
event_time TIME,
event_location VARCHAR (255)
);

ALTER TABLE events ENGINE = InnoDB;

INSERT INTO events 
(event_id, event_name, event_day, event_time, event_location)
VALUES
(1, 'Innovation', '2024-12-04', '11:30:00', 'London'),
(2, 'Manufacturing', '2023-11-16', '15:00:00', 'Birmingham'),
(3, 'AI', '2025-01-12', '17:30:00', 'Manchester');
-- DELETE FROM events
-- WHERE event_id IN (101, 102, 103);
SELECT * FROM events;


CREATE TABLE IF NOT EXISTS speakers(
speaker_id int PRIMARY KEY,
first_name varchar(255),
last_name varchar(255)
);

INSERT INTO speakers
(speaker_id, first_name, last_name)
VALUES
(1, 'Tony', 'Meyers'),
(2, 'Suzanne', 'Benson');

SELECT * FROM speakers;

-- CREATE TABLE IF NOT EXISTS attendees_attendance (
--    attendee_id INT,
--    event_id INT
-- );

-- ALTER TABLE attendees_attendance
-- ADD CONSTRAINT fk_attendee_id  FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id),
-- ADD CONSTRAINT  fk_event_id FOREIGN KEY (event_id) REFERENCES events(event_id);
 
-- If you don't define a primary key for the attendees_attendance table, it's possible to insert duplicate rows for the same combination of attendee_id and event_id. For example, you could have two rows with (1, 2) (i.e., the same attendee attending the same event), which would violate the idea of ensuring that each attendee attends a specific event only once.
-- To ensure that the same combination of attendee_id and event_id cannot be inserted twice, you should use a composite primary key. The composite primary key will enforce uniqueness for the combination of these two columns, meaning that you cannot insert duplicate records for the same attendee attending the same event. 


CREATE TABLE IF NOT EXISTS attendees_attendance (
    attendee_id INT,
    event_id INT,
    PRIMARY KEY (attendee_id, event_id),  -- Composite Primary Key
    CONSTRAINT fk_attendee_id FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id),
    CONSTRAINT fk_in_attendees_event_id FOREIGN KEY (event_id) REFERENCES events(event_id)
);

INSERT INTO attendees_attendance
(attendee_id, event_id)
VALUES
(1,2),
(1,3),
(2,1),
(3,3),
(3,1),
(4,2),
(5,1),
(5,3),
(6,3),
(7,1),
(8,3),
(8,2),
(8,1),
(9,1),
(10,3);

SELECT * FROM attendees_attendance;


CREATE TABLE IF NOT EXISTS speakers_attendance (
speaker_id int, 
event_id int,
PRIMARY KEY (speaker_id, event_id),  -- Composite Primary Key
CONSTRAINT fk_speaker_id FOREIGN KEY (speaker_id) REFERENCES speakers(speaker_id),
CONSTRAINT fk_in_speakers_event_id FOREIGN KEY (event_id) REFERENCES events(event_id)
);

INSERT INTO speakers_attendance
VALUES
(1,2),
(2,1),
(2,3);

SELECT * FROM speakers_attendance;

DESCRIBE attendees;
DESCRIBE events;
DESCRIBE speakers;

-- You might want to consider adding indexes on the attendee_id and event_id columns in the attendees_attendance and speakers_attendance tables to improve query performance, especially if you plan to join these tables with others or perform searches based on these columns frequently.
CREATE INDEX idx_attendee_id ON attendees_attendance(attendee_id);
CREATE INDEX idx_event_id ON attendees_attendance(event_id);

-- practice queries
SELECT DISTINCT a.age FROM attendees AS a;

SELECT a.age 
FROM attendees AS a 
WHERE a.postcode LIKE "M1%";

-- SELECT DISTINCT e.event_name AND e.event_id FROM events AS e;
-- The issue with your SQL query is the use of AND in the SELECT clause. The AND operator is used to combine conditions in a WHERE clause, not in the SELECT clause. You should be using a comma (,) to separate the columns you want to select.
SELECT DISTINCT e.event_name, e.event_id 
FROM events AS e;


-- ADD AUTO INCREMENT TO PRIMARY KEYS --

-- If you've added an index to the attendees table but haven't set the attendee_id column as an auto-increment column, then adding a value to attendee_id is required when inserting new rows, or MySQL will throw an error (since the column may be marked as NOT NULL or may be part of the primary key).
-- ALTER TABLE attendees
-- MODIFY attendee_id INT AUTO_INCREMENT;
-- NEED TO TEMPORARILY DROP FOREIGN KEY CONTRAINT FIRST
SHOW CREATE TABLE events_manager.attendees_attendance;
-- Once you know the name of the foreign key constraint, you can drop it using the ALTER TABLE statement

ALTER TABLE events_manager.attendees_attendance 
DROP FOREIGN KEY fk_attendee_id;

ALTER TABLE attendees 
MODIFY attendee_id INT AUTO_INCREMENT; 

ALTER TABLE events_manager.attendees_attendance 
ADD CONSTRAINT fk_attendee_id 
FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id);

-- repeat for all tables. This way, If I want to insert new values, it autogenerated the id

ALTER TABLE events_manager.speakers_attendance 
DROP FOREIGN KEY fk_speaker_id;

ALTER TABLE speakers 
MODIFY speaker_id INT AUTO_INCREMENT; 

ALTER TABLE events_manager.speakers_attendance 
ADD CONSTRAINT fk_speaker_id 
FOREIGN KEY (speaker_id) REFERENCES speakers(speaker_id);

ALTER TABLE events_manager.speakers_attendance 
DROP FOREIGN KEY fk_speaker_id;

ALTER TABLE speakers 
MODIFY speaker_id INT AUTO_INCREMENT; 

ALTER TABLE events_manager.speakers_attendance 
ADD CONSTRAINT fk_speaker_id 
FOREIGN KEY (speaker_id) REFERENCES speakers(speaker_id);

ALTER TABLE events_manager.speakers_attendance
DROP FOREIGN KEY fk_in_speakers_event_id;

ALTER TABLE events_manager.attendees_attendance
DROP FOREIGN KEY fk_in_attendees_event_id;

ALTER TABLE events
MODIFY event_id INT AUTO_INCREMENT;
-- When you use the fully qualified table name (database_name.table_name), you're explicitly telling MySQL to use a table from a specific database, which is important if your session is connected to a different database.

ALTER TABLE attendees_attendance
ADD CONSTRAINT fk_in_attendees_event_id 
FOREIGN KEY (event_id) REFERENCES events(event_id);

ALTER TABLE speakers_attendance
ADD CONSTRAINT fk_in_speakers_event_id 
FOREIGN KEY (event_id) REFERENCES events(event_id);

-- now can  insert rows without adding index

-- INSERT --

INSERT INTO attendees (first_name, last_name)
VALUES 
('Fred', 'Norman'),
('Nancy', 'Rothwell');

SELECT * FROM attendees;

INSERT INTO attendees_attendance (attendee_id, event_id)
VALUES 
(11, 1),
(12, 1);

-- UPDATE --

SELECT * FROM speakers;

-- UPDATE speakers AS s
-- SET  s.last_name = 'Johnson'
-- WHERE s.last_name = 'Meyers';

-- The error you're seeing is because safe update mode is enabled in MySQL. This mode is designed to prevent accidental updates that could affect a large number of rows unintentionally.
-- In safe update mode, MySQL requires that any UPDATE statement include a WHERE clause that either:
-- References a primary key or unique key column, or
-- Limits the update to a small subset of rows (such as using a LIMIT clause).
-- Since you're trying to update last_name without referencing a key column, MySQL prevents the query from executing to protect against the possibility of updating the entire table.
-- Use a Key Column in the WHERE Clause
-- A better practice would be to modify your UPDATE statement to use a column that is indexed or is a key (like speaker_id or another unique column) in the WHERE clause.
-- For example, assuming you have a primary key column speaker_id, you can do something like:

UPDATE speakers AS s
SET  s.last_name = 'Johnson'
WHERE s.speaker_id = 2;

SELECT a.age, a.last_name
FROM attendees AS a
WHERE a.postcode NOT LIKE 'M1%';


-- Add more rows to tables to perform more difficult queries

SELECT * FROM attendees_attendance    -- I had inserted rows into attendees that I regret so O checked that the child table did not have any dependent rows from the index of the parent table that I had last added prior and deleted rows from there
WHERE attendee_id > 12;
DELETE FROM attendees
WHERE attendee_id > 12;

INSERT INTO attendees (first_name, last_name, age, postcode, sector)
VALUES
    ('John', 'Doe', 35, 'M1 4BP', 'AI Research and Development'),
    ('Emma', 'Williams', 42, 'M1 5LU', 'Manufacturing Process Improvement'),
    ('Liam', 'Smith', 28, 'M2 3JT', 'Innovation Consultancy'),
    ('Olivia', 'Brown', 31, 'M2 4BR', 'Advanced Robotics'),
    ('Lucas', 'Taylor', 40, 'M3 5SY', 'AI and Machine Learning'),
    ('Charlotte', 'Davies', 38, 'M3 4JF', 'Smart Manufacturing'),
    ('Amelia', 'Miller', 45, 'M4 4EP', 'Digital Transformation'),
    ('James', 'Wilson', 50, 'M5 6GH', 'AI-based Manufacturing Solutions'),
    ('Benjamin', 'Moore', 32, 'M6 7UJ', 'Automation and Robotics'),
    ('Isla', 'Anderson', 26, 'M6 5AD', 'Sustainable Manufacturing'),
    ('Ethan', 'Thomas', 55, 'M7 3QX', '3D Printing Technologies'),
    ('Mia', 'Jackson', 33, 'M7 2AS', 'Cyber-Physical Systems'),
    ('Jack', 'White', 37, 'M8 4NB', 'Smart Factories'),
    ('Sophia', 'Harris', 44, 'M8 3JD', 'Data-driven Manufacturing'),
    ('Henry', 'Martin', 29, 'M9 1TG', 'Artificial Intelligence in Manufacturing'),
    ('Chloe', 'Lee', 46, 'M10 5PC', 'Automation and AI Integration'),
    ('Harry', 'Walker', 41, 'M11 6DB', 'Industrial Internet of Things (IIoT)'),
    ('Emily', 'Hall', 32, 'M12 3RW', 'Innovation in Digital Manufacturing'),
    ('Leo', 'Allen', 30, 'M13 2QZ', 'AI-driven Production Systems'),
    ('Isabelle', 'Young', 34, 'M13 1PY', 'IoT for Industrial Applications'),
    ('Alexander', 'King', 48, 'M14 3BJ', 'Machine Learning in Manufacturing'),
    ('Ella', 'Scott', 39, 'M14 4GT', 'Sustainable Innovation in Manufacturing'),
    ('George', 'Green', 50, 'M15 2LB', 'Advanced Manufacturing Techniques'),
    ('Grace', 'Adams', 31, 'M15 6WA', 'Next-generation Manufacturing'),
    ('Daniel', 'Baker', 29, 'M16 7DT', 'Robotics Engineering'),
    ('Ava', 'Graham', 41, 'M17 5ZD', 'AI for Industrial Design'),
    ('Matthew', 'Carter', 39, 'M18 1BU', 'Innovation in Production Automation'),
    ('Sophie', 'Hughes', 40, 'M19 2HF', 'Industrial Design and Innovation'),
    ('Joseph', 'Evans', 33, 'M20 5NF', 'AI Systems for Manufacturing'),
    ('Nina', 'Wood', 47, 'M21 3PR', 'Automation in Manufacturing Industries'),
    ('Ryan', 'Wright', 43, 'M22 5JS', 'AI Applications in Robotics'),
    ('Zoe', 'Edwards', 29, 'M23 4TH', 'Intelligent Manufacturing Solutions'),
    ('Samuel', 'Stewart', 34, 'M24 7DJ', 'Smart Robotics for Manufacturing'),
    ('Lily', 'Bennett', 36, 'M25 6NJ', 'Advanced Automation Solutions'),
    ('Aiden', 'Ross', 39, 'M26 3FW', 'AI Research for Industry 4.0'),
    ('Charlotte', 'Gibson', 31, 'M27 8HE', 'Innovation in Automation and Robotics'),
    ('Sebastian', 'Fox', 28, 'M28 7SH', 'AI-based Robotics Solutions'),
    ('Ella', 'Owen', 42, 'M29 5AW', 'Next-gen Manufacturing and Automation'),
    ('Isaac', 'Morris', 38, 'M30 3FB', 'AI and Robotics Development'),
    ('Leah', 'Murphy', 27, 'M31 6GD', 'Digital Manufacturing Innovation');

INSERT INTO attendees (first_name, last_name, age)
VALUES
    ('Alice', 'Johnson', 35),
    ('Bob', 'Williams', 28),
    ('Charlie', 'Brown', 40),
    ('Diana', 'Clark', 22),
    ('Ethan', 'Davis', 30);

INSERT INTO attendees (first_name, last_name, age, postcode)
VALUES
    ('Fiona', 'Martinez', 27, 'M1 2AB'),
    ('George', 'Miller', 32, 'M2 3CD'),
    ('Hannah', 'Wilson', 45, 'M3 4EF'),
    ('Ivy', 'Anderson', 38, 'M4 5GH'),
    ('Jack', 'Thomas', 50, 'M5 6IJ'),
    ('Katherine', 'Lopez', 29, 'M6 7KL'),
    ('Liam', 'Harris', 41, 'M7 8MN'),
    ('Mia', 'Garcia', 33, 'M8 9OP'),
    ('Nina', 'Martinez', 34, 'M9 1QR'),
    ('Oscar', 'Roberts', 27, 'M10 2ST');

INSERT INTO attendees (first_name, last_name, postcode)
VALUES
    ('Paul', 'Taylor', 'M2 4UV'),
    ('Quinn', 'White', 'M3 5WX'),
    ('Rachel', 'Evans', 'M4 6YZ'),
    ('Sam', 'Martin', 'M5 7AB'),
    ('Tina', 'King', 'M6 8BC'),
    ('Ursula', 'Scott', 'M7 9DE'),
    ('Victor', 'Adams', 'M8 1FG');

INSERT INTO attendees (first_name, last_name, age)
VALUES
    ('Wendy', 'Baker', 36),
    ('Xander', 'Lopez', 29),
    ('Yara', 'Perez', 41);
    
ALTER TABLE attendees ADD COLUMN email_address VARCHAR(255);
UPDATE attendees
SET email_address = CASE attendee_id
    WHEN 1 THEN 'miriam.haifa@example.com'
    WHEN 2 THEN 'pedro.pascal@example.com'
    WHEN 3 THEN 'julien.vassiere@example.com'
    WHEN 4 THEN 'su.weeks@example.com'
    WHEN 5 THEN 'william.blackshaw@example.com'
    WHEN 6 THEN 'hung.hueng@example.com'
    WHEN 7 THEN 'ayanda.nkosi@example.com'
    WHEN 8 THEN 'maria.oliveira@example.com'
    WHEN 9 THEN 'andrei.ionescu@example.com'
    WHEN 10 THEN 'amina.ibrahim@example.com'
    WHEN 11 THEN 'fred.norman@example.com'
    WHEN 12 THEN 'nancy.rothwell@example.com'
    WHEN 75 THEN 'john.doe@example.com'
    WHEN 76 THEN 'emma.williams@example.com'
    WHEN 77 THEN 'liam.smith@example.com'
    WHEN 78 THEN 'olivia.brown@example.com'
    WHEN 79 THEN 'lucas.taylor@example.com'
    WHEN 80 THEN 'charlotte.davies@example.com'
    WHEN 81 THEN 'amelia.miller@example.com'
    WHEN 82 THEN 'james.wilson@example.com'
    WHEN 83 THEN 'benjamin.moore@example.com'
    WHEN 84 THEN 'isla.anderson@example.com'
    WHEN 85 THEN 'ethan.thomas@example.com'
    WHEN 86 THEN 'mia.jackson@example.com'
    WHEN 87 THEN 'jack.white@example.com'
    WHEN 88 THEN 'sophia.harris@example.com'
    WHEN 89 THEN 'henry.martin@example.com'
    WHEN 90 THEN 'chloe.lee@example.com'
    WHEN 91 THEN 'harry.walker@example.com'
    WHEN 92 THEN 'emily.hall@example.com'
    WHEN 93 THEN 'leo.allen@example.com'
    WHEN 94 THEN 'isabelle.young@example.com'
    WHEN 95 THEN 'alexander.king@example.com'
    WHEN 96 THEN 'ella.scott@example.com'
    WHEN 97 THEN 'george.green@example.com'
    WHEN 98 THEN 'grace.adams@example.com'
    WHEN 99 THEN 'daniel.baker@example.com'
    WHEN 100 THEN 'ava.graham@example.com'
    WHEN 101 THEN 'matthew.carter@example.com'
    WHEN 102 THEN 'sophie.hughes@example.com'
    WHEN 103 THEN 'joseph.evans@example.com'
    WHEN 104 THEN 'nina.wood@example.com'
    WHEN 105 THEN 'ryan.wright@example.com'
    WHEN 106 THEN 'zoe.edwards@example.com'
    WHEN 107 THEN 'samuel.stewart@example.com'
    WHEN 108 THEN 'lily.bennett@example.com'
    WHEN 109 THEN 'aiden.ross@example.com'
    WHEN 110 THEN 'charlotte.gibson@example.com'
    WHEN 111 THEN 'sebastian.fox@example.com'
    WHEN 112 THEN 'ella.owen@example.com'
    WHEN 113 THEN 'isaac.morris@example.com'
    WHEN 114 THEN 'leah.murphy@example.com'
    WHEN 115 THEN 'alice.johnson@example.com'
    WHEN 116 THEN 'bob.williams@example.com'
    WHEN 117 THEN 'charlie.brown@example.com'
    WHEN 118 THEN 'diana.clark@example.com'
    WHEN 119 THEN 'ethan.davis@example.com'
    WHEN 120 THEN 'fiona.martinez@example.com'
    WHEN 121 THEN 'george.miller@example.com'
    WHEN 122 THEN 'hannah.wilson@example.com'
    WHEN 123 THEN 'ivy.anderson@example.com'
    WHEN 124 THEN 'jack.thomas@example.com'
    WHEN 125 THEN 'katherine.lopez@example.com'
    WHEN 126 THEN 'liam.harris@example.com'
    WHEN 127 THEN 'mia.garcia@example.com'
    WHEN 128 THEN 'nina.martinez@example.com'
    WHEN 129 THEN 'oscar.roberts@example.com'
    WHEN 130 THEN 'paul.taylor@example.com'
    WHEN 131 THEN 'quinn.white@example.com'
    WHEN 132 THEN 'rachel.evans@example.com'
    WHEN 133 THEN 'sam.martin@example.com'
    WHEN 134 THEN 'tina.king@example.com'
    WHEN 135 THEN 'ursula.scott@example.com'
    WHEN 136 THEN 'victor.adams@example.com'
    WHEN 137 THEN 'wendy.baker@example.com'
    WHEN 138 THEN 'xander.lopez@example.com'
    WHEN 139 THEN 'yara.perez@example.com'
    ELSE email_address
END
WHERE attendee_id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139);
-- The WHERE clause ensures that only the rows corresponding to those specific attendee_ids will be updated, maintaining safe update operations as required by MySQL configuration.


SELECT * FROM attendees;

SELECT COUNT(*) FROM attendees;
-- attendee_id jumps from the original 12 to 75 because I had deleted prior rows I did not like. 
-- HOwever this is fine because the purpose of auto increment is for the rows to have unique identifiers. 
-- May cause confusion if the rows where associated to other rows in child tables and transactions.
-- In most applications, the exact sequence of ID numbers is not critical. 
-- The only critical factor is that each ID is unique.

SHOW TABLE STATUS LIKE 'attendees'; -- check the status

-- I now need to asign the new attendees to the attendees_attendance table. I want to automate it based on critera.
-- For example, the attendees, sector and the event's type
SELECT DISTINCT a.sector FROM  attendees AS a; -- ask chat gpt to assign the sector to the the events according to theme (each sector could be assigned to more than one event)

-- Create temporary tables to hold sectors by theme (AI, Manufacturing, Innovation)
CREATE TEMPORARY TABLE ai_sectors (sector VARCHAR(255));
CREATE TEMPORARY TABLE manufacturing_sectors (sector VARCHAR(255));
CREATE TEMPORARY TABLE innovation_sectors (sector VARCHAR(255));

-- Insert sectors into each temporary table
INSERT INTO ai_sectors (sector) VALUES 
    ('AI Research and Development'),
    ('AI and Machine Learning'),
    ('Robotics and Automation'),
    ('Advanced Robotics'),
    ('Artificial Intelligence in Manufacturing'),
    ('Automation and AI Integration'),
    ('AI-based Manufacturing Solutions'),
    ('AI-driven Production Systems'),
    ('AI Systems for Manufacturing'),
    ('AI Applications in Robotics'),
    ('Intelligent Manufacturing Solutions'),
    ('AI Research for Industry 4.0'),
    ('AI-based Robotics Solutions'),
    ('AI and Robotics Development'),
    ('AI for Industrial Design'),
    ('Machine Learning in Manufacturing'),
    ('AI-driven Production Systems');

INSERT INTO manufacturing_sectors (sector) VALUES
    ('Advanced Machinery Manufacturing'),
    ('3D Printing and Additive Manufacturing'),
    ('Manufacturing Process Improvement'),
    ('Smart Manufacturing'),
    ('Sustainable Manufacturing'),
    ('3D Printing Technologies'),
    ('Smart Factories'),
    ('Data-driven Manufacturing'),
    ('Artificial Intelligence in Manufacturing'),
    ('Automation and Robotics'),
    ('Sustainable Innovation in Manufacturing'),
    ('Advanced Manufacturing Techniques'),
    ('Next-generation Manufacturing'),
    ('Industrial Internet of Things (IIoT)'),
    ('IoT for Industrial Applications'),
    ('Innovation in Digital Manufacturing'),
    ('Machine Learning in Manufacturing'),
    ('Advanced Automation Solutions'),
    ('Industrial Design and Innovation'),
    ('Automation in Manufacturing Industries'),
    ('Innovation in Production Automation');

INSERT INTO innovation_sectors (sector) VALUES
    ('Software Development'),
    ('Innovation Intermediary'),
    ('Internet of Things (IoT)'),
    ('Technology Consultancy'),
    ('Nanotechnology and Advanced Materials'),
    ('Cybersecurity and Data Protection'),
    ('Net Zero and Circular Economy Consultancy'),
    ('AI Research and Development'),
    ('Innovation Consultancy'),
    ('Digital Transformation'),
    ('Cyber-Physical Systems'),
    ('Innovation in Digital Manufacturing'),
    ('Sustainable Innovation in Manufacturing'),
    ('Next-generation Manufacturing'),
    ('Innovation in Production Automation'),
    ('Industrial Design and Innovation'),
    ('AI Research for Industry 4.0'),
    ('Innovation in Automation and Robotics'),
    ('Innovation in Digital Manufacturing');

-- Perform the INSERT based on the sectors matching event types
INSERT IGNORE INTO attendees_attendance (attendee_id, event_id) -- I had already matched a feww attendees so let's ignore those
SELECT a.attendee_id, e.event_id
FROM attendees a
JOIN events e
    ON (
        -- AI attendees attending AI events
        (a.sector IN (SELECT sector FROM ai_sectors) AND e.event_name LIKE '%AI%')
        
        -- Manufacturing attendees attending Manufacturing events
        OR (a.sector IN (SELECT sector FROM manufacturing_sectors) AND e.event_name LIKE '%Manufacturing%')
        
        -- Innovation attendees attending Innovation events
        OR (a.sector IN (SELECT sector FROM innovation_sectors) AND e.event_name LIKE '%Innovation%')
    );
    
    SHOW WARNINGS;
    -- but now I have to join the attendees for whom we don't know the sector. I want to match them wiht all three events just in case
    
INSERT IGNORE INTO attendees_attendance (attendee_id, event_id)
SELECT a.attendee_id, e.event_id
FROM attendees a
JOIN events e 
    ON (
        -- Attendees with NULL sector matched to all three event themes
        (a.sector IS NULL AND e.event_name LIKE '%AI%')
        OR (a.sector IS NULL AND e.event_name LIKE '%Manufacturing%')
        OR (a.sector IS NULL AND e.event_name LIKE '%Innovation%')
    );

-- Clean up by dropping the temporary tables after the operation
DROP TEMPORARY TABLE ai_sectors;
DROP TEMPORARY TABLE manufacturing_sectors;
DROP TEMPORARY TABLE innovation_sectors;

SELECT * FROM attendees_attendance;

-- check that it has worked
SELECT a.sector, a.attendee_id 
FROM attendees AS a 
WHERE a.sector IS NULL;

SELECT a.attendee_id, a.event_id 
FROM attendees_attendance AS a
WHERE a.attendee_id IN (11, 12, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128,
129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139); -- IT WORKED :D

-- INSERT INTO attendees_attendance 
-- SELECT a.attendee_id, e.event_id
-- FROM attendees AS a
-- JOIN events AS e
-- ON (
	-- AI sector should attend AI events (matching multiple keywords)
--        (a.sector LIKE '%AI%' OR a.sector LIKE '%Artificial Intelligence%' 
--        OR a.sector LIKE '%Machine Learning%' OR a.sector LIKE '%Data Science%' 
--        OR a.sector LIKE '%Automation%' )
--        AND e.event_name LIKE '%AI%'
        
        -- Innovation sector should attend Innovation events (matching multiple keywords)
--        OR (a.sector LIKE '%Innovation%' OR a.sector LIKE '%Digital Transformation%' OR a.sector LIKE '%Smart Manufacturing%' OR a.sector LIKE '%Next-gen%' OR a.sector LIKE '%IoT%' )
--        AND e.event_name LIKE '%Innovation%'
        
        -- Manufacturing sector should attend Manufacturing events (matching multiple keywords)
--        OR (a.sector LIKE '%Manufacturing%' OR a.sector LIKE '%Automation%' OR a.sector LIKE '%Robotics%' OR a.sector LIKE '%Industrial%' OR a.sector LIKE '%Production%' )
--        AND e.event_name LIKE '%Manufacturing%'
--    
-- )

-- LET'S PERFORM QUERIES BASED ON THESE TABLES --

-- Order attendees table in alphabetical order
SELECT * FROM attendees AS a
ORDER BY a.first_name ASC;

-- Count how many attendees are in each postcode band by age
SELECT 
    LEFT(a.postcode, 2) AS postcode_band,  -- Extracting the first two characters of the postcode
    a.age,
    COUNT(a.postcode) AS postcode_count    -- Counting occurrences for each postcode band
FROM 
    attendees AS a
GROUP BY 
    postcode_band, a.age                          -- Grouping by the extracted postcode band
ORDER BY 
    postcode_band, a.age;                          -- Sorting the results by postcode band
    
   -- ordering by frequency instead
   
   SELECT 
    LEFT(a.postcode, 2) AS postcode_band,  
    a.age,
    COUNT(a.postcode) AS postcode_count   
FROM 
    attendees AS a
GROUP BY 
    postcode_band, a.age                          
ORDER BY 
    postcode_count DESC;  -- most frequent attendees are 29 years old from the M1 postcode
    
-- Change a specific person's name
SELECT * FROM attendees;
UPDATE attendees AS a 
SET a.last_name = 'Smith'
WHERE a.attendee_id = 83 AND a.last_name = 'Moore';

-- SELECT a.attendee_id = 83 FROM attendees AS a; this checks T/F wether attendee_id is equal to 0, see correct code below
SELECT a.attendee_id, a.last_name FROM attendees AS a
WHERE a.attendee_id = 83 AND a.last_name = 'Smith';  -- name change worked

-- Count how many attendees attended 2 events or less
SELECT COUNT(DISTINCT(a.attendee_id)) FROM attendees_attendance AS a
WHERE a.attendee_id AND a.event_id <= 2;



