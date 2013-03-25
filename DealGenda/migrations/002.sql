CREATE TABLE users_2 (id INTEGER PRIMARY KEY AUTOINCREMENT, email varchar(255), password varchar(255), fname varchar(255), lname varchar(255), gender varchar(255), birthday DATE)
INSERT INTO users_2(email, password, fname, lname, gender, birthday) SELECT * FROM users
ALTER TABLE users RENAME TO users_old
ALTER TABLE users_2 RENAME TO users