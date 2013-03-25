CREATE TABLE retailers_2 (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(255), logo varchar(255), color varchar(255))
INSERT INTO retailers_2(name, logo, color) SELECT * FROM retailers
ALTER TABLE retailers RENAME TO retailers_old
ALTER TABLE retailers_2 RENAME TO retailers