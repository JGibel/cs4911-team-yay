-- DealGenda Coupon Application Dummy Backend
-- Douglas Abrams, Kaitlynn Myrick & Jenelle Walker
-- 2/25/2013
-- CS 4911

-- This script creates the database tables for the DealGenda application.  This will be used for
-- testing the functionality of the iPhone application

----------------------------------------------------------------------------------

-- Terminal Commands to run .sql file to create .db
-- cd Desktop 						(or wheverever the file is stored)
-- sqlite3 dummy.db < dummy.sql 	(creates the dummy.db file by reading in the file dummy.sql)
-- sqlite3 dummy.db 				(allows sql commands to be read into the terminal on dummy.db)
-- select * from sqlite_master ; 	(shows all database info, ; termintes commands)

----------------------------------------------------------------------------------

-- Drop the tables if they already exist

DROP TABLE IF EXISTS version;

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS retailers;

DROP TABLE IF EXISTS coupons;

DROP TABLE IF EXISTS userRetailerPreferences;

DROP TABLE IF EXISTS userItemPreferences;

DROP TABLE IF EXISTS items;

--Create table to keep track of app user's version
CREATE TABLE version(
	id INTEGER NOT NULL PRIMARY KEY
);

-- Create the table which will contain all user information
CREATE TABLE users (
	id				INTEGER PRIMARY KEY AUTOINCREMENT,
	email   		VARCHAR(255),       
    password    	VARCHAR(255),
    fname   		VARCHAR(255),
    lname    		VARCHAR(255),                   
    gender 			VARCHAR(255),                   
    birthday   		DATE
);

-- Create the table which will contain all retailer information
CREATE TABLE retailers (
	id				INTEGER PRIMARY KEY AUTOINCREMENT,
    name      		VARCHAR(255),    	
    logo 			VARCHAR(255),
    color     		VARCHAR(255)
);

-- Create the table which will contain all coupon information
CREATE TABLE coupons (
    barcode   			VARCHAR(255) PRIMARY KEY,
    retailerName		VARCHAR(255),
    itemCategory1		VARCHAR(255),
    itemCategory2	      VARCHAR(255),
    itemCategory3             VARCHAR(255),
    expdate    			DATE,
    offer   			VARCHAR(255),
    details    			TEXT,
    extendrange 		DATE,
    hasBeenExtended		BOOLEAN
);

-- Create the table which will contain retailer preferences for each user
CREATE TABLE userRetailerPreferences (
    user   			VARCHAR(255),
    retailer    	VARCHAR(255)
);

-- Create the table which will contain item preferences for each user
CREATE TABLE userItemPreferences (
    user   			VARCHAR(255),
    itemCategory    VARCHAR(255)    			
);

CREATE TABLE items (
    category		VARCHAR(255) PRIMARY KEY
);



----------------------------------------------------------------------------------
-- Insert statements for test data
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Insert statments for initial version
----------------------------------------------------------------------------------

INSERT INTO version VALUES (1);
----------------------------------------------------------------------------------
-- Insert statments for test users
----------------------------------------------------------------------------------

INSERT INTO users (email, password, fname, lname, gender, birthday) VALUES (
    'jdoe@email.com',
    'Password1',
    'John',
    'Doe',
    'Male',
    '1/1/1980'
);

INSERT INTO users (email, password, fname, lname, gender, birthday) VALUES (
    'gburdell@gatech.edu',
    'GoJackets',
    'George',
    'Burdell',
    'Male',
    '5/23/1910'
);

INSERT INTO users (email, password, fname, lname, gender, birthday) VALUES (
    'bsmith@email.com',
    'password1234',
    'Beatrice',
    'Smith',
    'Female',
    '2/24/1971'
);

----------------------------------------------------------------------------------
-- Insert statments for test retailers
----------------------------------------------------------------------------------

INSERT INTO retailers (name, logo, color) VALUES (
    'Target',
    'http://www.thismommysavesmoney.com/wp-content/uploads/2012/10/targetlogo.jpg',
    'F81800'
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Best Buy',
    'http://blog.hubspot.com/Portals/249/images/best-buy-logo.jpg',
    '27346B'
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Home Depot',
    'http://www.webtalentmarketing.com/wp-content/uploads/2012/04/homedepot.jpg',
    'FF6125'
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Staples',
    'http://www.reviversoft.com/blog/wp-content/uploads/2012/11/Staples-Logo.jpg',
    'FF0016'
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Dominos',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Express',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Forever 21',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Gamestop',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Macys',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Nordstrom',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'OfficeMax',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Old Navy',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Sears',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Victorias Secret',
    null,
    null
);

INSERT INTO retailers (name, logo, color) VALUES (
    'Walmart',
    null,
    null
);


----------------------------------------------------------------------------------
-- Insert statments for test coupons
----------------------------------------------------------------------------------

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '0100865',
    'Target',
    'Electronics',
    null,
    null,
    '2/28/2013',
    '$5 off Headphones',
    '$5 off any Skullcandy heaphones of $30 or more.  Applies at all Targets within the state of Georgia',
    '3/10/2013', 
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '1234567',
    'Best Buy',
    'Home Improvement',
    'Home Theater',
    null,
    '3/15/2013',
    'Free Appliance Delivery',
    'Generico offers this pass, including all information, software, products and services available from this pass or offered as part of or in conjunction with this pass (the "pass"), to you, the user, conditioned upon your acceptance of all of the terms, conditions, policies and notices stated here. Generico reserves the right to make changes to these Terms and Conditions immediately by posting the changed Terms and Conditions in this location.  Use the pass at your own risk. This pass is provided to you "asis" without warranty of any kind either express or implied. Neither Generico nor its employees, agents, third-party information providers, merchants, licensors or the like warrant that the pass or its operation will be accurate, reliable, uninterrupted or error-free. No agent or representative has the authority to create any warranty regarding the pass on behalf of Generico. Generico reserves the right to change or discontinue at any time any aspect or feature of the pass.',
    '4/07/2013',
    'TRUE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '7654321',
    'Target',
    'Clothing',
    'Menswear',
    'Womens Clothing',
    '2/28/2013',
    '15% off of Socks',
    'Valid on purchases of 30 socks or more.  Valid brands include Haynes, Target and Fruit of the Loom. Limit one use per customer',
    '3/10/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '6868686',
    'Home Depot',
    'Home Improvement',
    null,
    null,
    '6/04/2013',
    'Free Roller with Purchase of 1 Gal of Bear Paint',
    'Home Depot Brand Roller.  Limit one per gallon of paint.  Applies to Bear Premium Paints.  Not Valid in Hawaii',
    '8/10/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '8765309',
    'Staples',
    'Luggage',
    null,
    null,
    '3/30/2013',
    '%15 off of Briefcases',
    'Applies to Samsonite brand briefcases.  Limit 3 per customer.  Valid in Georgia Only.',
    '5/10/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '8765435',
    'Best Buy',
    'Electronics',
    'Computers',
    null,
    '10/30/2013',
    '%15 off of Mac Stuff',
    'Applies to Mac stuff.  Limit 1 per customer.  Does not apply to items that are not equal to a gift card.',
    '11/10/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '8198335',
    'Best Buy',
    'Games',
    'Electronics',
    null,
    '1/15/2013',
    '%15 off of PC Games',
    'Applies to PC games only.  Limit 1 per customer.  Does not apply to items that are not equal to a t-shirt.',
    '1/20/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '1198335',
    'Target',
    'Televisions',
    'Electronics',
    'Home Theater',
    '1/18/2013',
    '%15 off of Sony TV',
    'Applies to Sony brand flat screen televisions.  Limit 1 per customer.  Does not apply to items that are not equal to a gift card.',
    '1/28/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '8111115',
    'Target',
    'Womens Clothing',
    'Shoes',
    'Clothing',
    '2/15/2013',
    '%15 off of a single shoe',
    'Void if the number of shoes purchased is greater than one.',
    '2/20/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '4811115',
    'Dominos',
    'Food',
    null,
    null,
    '2/5/2013',
    'Free cheese sticks',
    'Free order of cheese sticks with the purchase of one large 3 topping pizza.',
    '2/10/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '4811116',
    'Gamestop',
    'Games',
    'Electronics',
    null,
    '3/5/2013',
    '$5 off any preorder game',
    '$5 off the total price of a preordered game.  Not valid with other coupons.  Applies to Georgia and Florida Gamestops only.',
    '3/20/2013',
    'TRUE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '4811117',
    'Macys',
    'Menswear',
    'Clothing',
    null,
    '4/5/2013',
    '10% off Mens Jacket',
    '10% off the price of any mens suit jacket or winter coat.',
    '4/10/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '4811109',
    'Walmart',
    'Baby Items',
    null,
    null,
    '8/21/2013',
    'Buy one get one free Baby Bottles',
    'Buy one Avent brand Baby Bottle get the second one free.',
    '9/01/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '4811225',
    'Walmart',
    'Food',
    null,
    null,
    '10/6/2013',
    '5% off Tyson Chicken',
    '5% off one Tyson brand chicken product.',
    '10/11/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '4813315',
    'Walmart',
    'Home Theater',
    'Televisions',
    null,
    '4/1/2013',
    '50% off Purchase of $150 or More',
    '50% off the purchase of a home theater system of $150 or more.  Only valid at participating Walmart locations.  Cannot be used in combination with another offer.',
    '4/30/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '3711115',
    'Sears',
    'Kitchen',
    'Home Improvement',
    null,
    '5/1/2013',
    'Free Knife Block',
    'Free knife block set with the purchase of $200 or more.  Knife block set is preselected by Sears.  Only valid at participating Sears locations.',
    '5/30/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '4833345',
    'Victorias Secret',
    'Womens Clothing',
    'Clothing',
    null,
    '3/30/2013',
    '10% off one Bra',
    '10% off the purchase of one Victorias Secret brand bra.',
    '4/10/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '4833349',
    'Express',
    'Womens Clothing',
    'Clothing',
    'Menswear',
    '4/30/2013',
    '10% off Total Purchase',
    '10% off the entire purchase.',
    '5/10/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '1113349',
    'Forever 21',
    'Clothing',
    'Womens Clothing',
    null,
    '4/15/2013',
    '10% off Total Purchase',
    '10% off the entire purchase.',
    '5/15/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '1113360',
    'Old Navy',
    'Clothing',
    null,
    null,
    '4/15/2013',
    '10% off Total Purchase',
    '10% off the entire purchase.',
    '5/15/2013',
    'FALSE'
);

INSERT INTO coupons (barcode, retailerName, itemCategory1, itemCategory2, itemCategory3, expdate, offer, details, extendrange, hasBeenExtended) VALUES (
    '1113360',
    'OfficeMax',
    'Electronics',
    null,
    null,
    '4/15/2013',
    '10% off Electronics',
    '10% off of any Electronic device.',
    '5/15/2013',
    'FALSE'
);

----------------------------------------------------------------------------------
-- Insert statments for test retailer preferences
----------------------------------------------------------------------------------

INSERT INTO userRetailerPreferences (user, retailer) VALUES (
    'jdoe@email.com',
    'Target'
);

INSERT INTO userRetailerPreferences (user, retailer) VALUES (
    'jdoe@email.com',
    'Best Buy'
);

INSERT INTO userRetailerPreferences (user, retailer) VALUES (
    'gburdell@gatech.edu',
    'Target'
);

INSERT INTO userRetailerPreferences (user, retailer) VALUES (
    'gburdell@gatech.edu',
    'Best Buy'
);

INSERT INTO userRetailerPreferences (user, retailer) VALUES (
    'gburdell@gatech.edu',
    'Home Depot'
);

INSERT INTO userRetailerPreferences (user, retailer) VALUES (
    'gburdell@gatech.edu',
    'Staples'
);

INSERT INTO userRetailerPreferences (user, retailer) VALUES (
    'bsmith@email.com',
    'Target'
);

INSERT INTO userRetailerPreferences (user, retailer) VALUES (
    'bsmith@email.com',
    'Staples'
);

INSERT INTO userRetailerPreferences (user, retailer) VALUES (
    'bsmith@email.com',
    'Walmart'
);

----------------------------------------------------------------------------------
-- Insert statments for test item preferences
----------------------------------------------------------------------------------

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'jdoe@email.com',
    'Electronics'
);

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'jdoe@email.com',
    'Clothing'
);

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'gburdell@gatech.edu',
    'Electronics'
);

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'gburdell@gatech.edu',
    'Clothing'
);

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'gburdell@gatech.edu',
    'Home Improvement'
);

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'gburdell@gatech.edu',
    'Menswear'
);

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'gburdell@gatech.edu',
    'Computers'
);

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'bsmith@email.com',
    'Shoes'
);

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'bsmithc@email.com',
    'Womens Clothing'
);

INSERT INTO userItemPreferences (user, itemCategory) VALUES (
    'bsmith@email.com',
    'Clothing'
);

----------------------------------------------------------------------------------
-- Insert statments for test item categories 
----------------------------------------------------------------------------------

INSERT INTO items (category) VALUES (
	'Baby Items'
);

INSERT INTO items (category) VALUES (
	'Bathroom'
);

INSERT INTO items (category) VALUES (
	'Bedroom'
);

INSERT INTO items (category) VALUES (
	'Clothing'
);

INSERT INTO items (category) VALUES (
	'Computers'
);

INSERT INTO items (category) VALUES (
	'Dining'
);

INSERT INTO items (category) VALUES (
	'Electronics'
);

INSERT INTO items (category) VALUES (
	'Food'
);

INSERT INTO items (category) VALUES (
	'Games'
);

INSERT INTO items (category) VALUES (
	'Home Improvement'
);

INSERT INTO items (category) VALUES (
	'Home Theater'
);

INSERT INTO items (category) VALUES (
	'Kitchen'
);

INSERT INTO items (category) VALUES (
	'Luggage'
);

INSERT INTO items (category) VALUES (
	'Menswear'
);

INSERT INTO items (category) VALUES (
	'Mobile Phones'
);

INSERT INTO items (category) VALUES (
	'Shoes'
);

INSERT INTO items (category) VALUES (
	'Televisions'
);

INSERT INTO items (category) VALUES (
	'Womens Clothing'
);
