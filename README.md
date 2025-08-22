# MySQL Visitors Database

This project implements a **relational database** for managing events, attendees, and speakers.  
It was built as a learning project to practice **SQL fundamentals**, including schema design, normalisation, constraints, and queries.

## 📋 Features
- **Database schema** with multiple related tables:
  - `attendees` — stores information about event attendees
  - `events` — stores event details
  - `speakers` — stores speaker details
  - `attendees_attendance` — join table for attendee–event relationships
  - `speakers_attendance` — join table for speaker–event relationships
- **Constraints**:
  - Primary keys, foreign keys, composite keys
  - Data validation with `CHECK` constraints
- **Indexes** to improve query performance
- **Auto-increment IDs** for primary keys
- **Practice queries** covering `SELECT`, `JOIN`, `GROUP BY`, `ORDER BY`, `UPDATE`, and `DELETE`

## 🛠️ How to Run
1. Open MySQL and create the database:
   ```sql
   CREATE DATABASE IF NOT EXISTS events_manager;
   USE events_manager;
