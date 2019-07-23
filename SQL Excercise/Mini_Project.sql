/* Q1: Some of the facilities charge a fee to members, but some do not. Please list the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost !=0
LIMIT 0 , 30 

/* Q2: How many facilities do not charge a fee to members? */ 

SELECT COUNT( membercost ) AS Membercost
FROM Facilities
WHERE membercost =0
LIMIT 0 , 30;

 /* Q3: How can you produce a list of facilities that charge a fee to members, where the fee is less than 20% of the facility's monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0.0
AND membercost < monthlymaintenance * .2
LIMIT 0 , 30 

/* Q4: How can you retrieve the details of facilities with ID 1 and 5? Write the query without using the OR operator. */

 SELECT * 
FROM Facilities
WHERE facid
IN ( 1, 5 ) 
LIMIT 0 , 30


/* Q5: How can you produce a list of facilities, with each labelled as 'cheap' or 'expensive', depending on if their monthly maintenance cost is more than $100? Return the name and monthly maintenance of the facilities in question. */ 

SELECT name, monthlymaintenance, 
CASE 
WHEN monthlymaintenance >100
THEN "expensive"
WHEN monthlymaintenance <100
THEN "cheap"
END AS cheaporexpensive
FROM Facilities
LIMIT 0 , 30;


/* Q6: You'd like to get the first and last name of the last member(s) who signed up. Do not use the LIMIT clause for your solution.
*/
SELECT  `firstname` ,  `surname` ,  `joindate` 
FROM Members
WHERE joindate = ( (

SELECT MAX( joindate ) 
FROM Members )
)
OR joindate = ( (

SELECT MIN( joindate ) 
FROM Members )
)

/* Another solution */

SELECT  `firstname` ,  `surname` ,  `joindate` 
FROM Members
WHERE joindate = ( (

SELECT MAX( joindate ) 
FROM Members )
)
UNION 
SELECT  `firstname` ,  `surname` ,  `joindate` 
FROM Members
WHERE joindate = ( (

SELECT MIN( joindate ) 
FROM Members )
)

/* Q7: How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name. */ 
SELECT DISTINCT Facilities.name AS TennisCourt, CONCAT( Members.firstname, "  ", Members.surname ) AS Name
FROM Bookings
INNER JOIN Facilities ON Bookings.facid= Facilities.facid
INNER JOIN Members ON Bookings.memid= Members.memid
WHERE Facilities.name LIKE "Tennis Court%"
LIMIT 0 , 30




/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user's ID is always 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost, and do not use any subqueries. */

SELECT Facilities.name AS facility, CONCAT( Members.firstname, ' ', Members.surname ) AS name, 
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END AS cost
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER JOIN Members ON Bookings.memid = Members.memid
WHERE Bookings.starttime LIKE '2012-09-14%'
AND (Bookings.memid =0 AND (Facilities.guestcost * Bookings.slots >30)OR (Bookings.memid !=0 AND Facilities.membercost * Bookings.slots >30))
ORDER BY `cost` ASC 
LIMIT 0 , 30





/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT * 
FROM (

SELECT Facilities.name AS facility, CONCAT( Members.firstname, ' ', Members.surname ) AS name, 
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END AS Cost
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER JOIN Members ON Bookings.memid = Members.memid
AND Bookings.starttime LIKE '2012-09-14%'
)subquerry
WHERE subquerry.Cost >30
ORDER BY subquerry.Cost DESC

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
                                                                          
                                                                          
                                                                          
SELECT * 
FROM (

SELECT Facilities.name, SUM( 
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END ) AS Revenue
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER JOIN Members ON Bookings.memid = Members.memid
GROUP BY Facilities.name
)subquerry
WHERE subquerry.Revenue <1000
LIMIT 0 , 30
