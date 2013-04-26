ALTER TABLE userRetailerPreferences RENAME TO temp1;
ALTER TABLE userItemPreferences RENAME TO temp2;

CREATE TABLE userRetailerPreferences (
id   			INTEGER REFERENCES users(id) ON DELETE CASCADE,
retailerID    	INTEGER REFERENCES retailers(id)
);

CREATE TABLE userItemPreferences (
id   			INTEGER REFERENCES users(id) ON DELETE CASCADE,
itemCategory    VARCHAR(255)
);

INSERT INTO userRetailerPreferences (id, retailerID) VALUES (
1,
1
);

INSERT INTO userRetailerPreferences (id, retailerID) VALUES (
1,
2
);

INSERT INTO userRetailerPreferences (id, retailerID) VALUES (
2,
1
);

INSERT INTO userRetailerPreferences (id, retailerID) VALUES (
2,
2
);

INSERT INTO userRetailerPreferences (id, retailerID) VALUES (
2,
3
);

INSERT INTO userRetailerPreferences (id, retailerID) VALUES (
2,
4
);

INSERT INTO userRetailerPreferences (id, retailerID) VALUES (
3,
1
);

INSERT INTO userRetailerPreferences (id, retailerID) VALUES (
3,
4
);

INSERT INTO userRetailerPreferences (id, retailerID) VALUES (
3,
15
);

----------------------------------------------------------------------------------
-- Insert statments for test item preferences
----------------------------------------------------------------------------------

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
1,
'Electronics'
);

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
1,
'Clothing'
);

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
2,
'Electronics'
);

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
2,
'Clothing'
);

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
2,
'Home Improvement'
);

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
2,
'Menswear'
);

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
2,
'Computers'
);

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
3,
'Shoes'
);

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
3,
'Womens Clothing'
);

INSERT INTO userItemPreferences (id, itemCategory) VALUES (
3,
'Clothing'
);

ALTER TABLE coupons ADD COLUMN retailerid INTEGER;
UPDATE coupons set retailerid = 1 where retailername = "Target";
UPDATE coupons set retailerid = 2 where retailername = "Best Buy";
UPDATE coupons set retailerid = 3 where retailername = "Home Depot";
UPDATE coupons set retailerid = 4 where retailername = "Staples";
UPDATE coupons set retailerid = 5 where retailername = "Dominos";
UPDATE coupons set retailerid = 6 where retailername = "Express";
UPDATE coupons set retailerid = 7 where retailername = "Forever 21";
UPDATE coupons set retailerid = 8 where retailername = "Gamestop";
UPDATE coupons set retailerid = 9 where retailername = "Macys";
UPDATE coupons set retailerid = 10 where retailername = "Nordstrom";
UPDATE coupons set retailerid = 11 where retailername = "Office Max";
UPDATE coupons set retailerid = 12 where retailername = "Old Navy";
UPDATE coupons set retailerid = 13 where retailername = "Sears";
UPDATE coupons set retailerid = 14 where retailername = "Victorias Secret";
UPDATE coupons set retailerid = 15 where retailername = "Walmart";
