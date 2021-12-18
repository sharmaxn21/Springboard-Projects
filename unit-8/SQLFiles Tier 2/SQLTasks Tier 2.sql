/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost =0

/* Q2: How many facilities do not charge a fee to members? */
4

Badminton Court
Table Tennis
Snooker Table
Pool Table

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0 AND membercost < 0.2 * (monthlymaintenance)

facid	name	     membercost	  monthlymaintenance	
0	Tennis Court 1	 5.0	       200
1	Tennis Court 2	 5.0	       200
4	Massage Room 1	 9.9	       3000
5	Massage Room 2	 9.9	       3000
6	Squash Court	 3.5	       80

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT * 
FROM Facilities
WHERE facid IN (1, 5) 

facid	name	      membercost	guestcost	initialoutlay	monthlymaintenance	
5	Massage Room 2	  9.9	        80.0	    4000	        3000
1	Tennis Court 2	  5.0	        25.0	    8000	        200

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
	CASE WHEN monthlymaintenance <100
		 THEN 'cheap'
		 ELSE 'expensive'
	END AS TYPE
FROM Facilities

name	          monthlymaintenance	type	
Tennis Court 1	  200	                expensive
Tennis Court 2	  200	                expensive
Badminton Court	  50	                cheap
Table Tennis	  10	                cheap
Massage Room 1	  3000	                expensive
Massage Room 2	  3000	                expensive
Squash Court	  80	                cheap
Snooker Table	  15	                cheap
Pool Table	      15	                cheap

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname, joindate
FROM Members
WHERE joindate = (
SELECT MAX(joindate)
FROM Members)

firstname	surname	    joindate	
Darren	    Smith	    2012-09-26 18:08:45

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT CONCAT_WS( ' ', m.firstname, m.surname ) AS member, f.name AS court_name
FROM Bookings AS b
LEFT JOIN Members AS m ON m.memid = b.memid
LEFT JOIN Facilities AS f ON b.facid = f.facid
WHERE b.facid IN ( 0, 1 ) AND m.surname != 'GUEST'
ORDER BY member;

44 total results

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name AS facility, CONCAT_WS( ' ', m.firstname, m.surname) AS name,
	CASE WHEN b.memid !=0 THEN b.slots * (f.membercost)
		 ELSE b.slots * (f.guestcost)
	END AS cost
FROM Members AS m
LEFT JOIN Bookings AS b ON m.memid = b.memid
LEFT JOIN Facilities AS f ON f.facid = b.facid
WHERE b.starttime LIKE '2012-09-14 %'
	AND CASE WHEN b.memid !=0 THEN b.slots * (f.membercost)
		ELSE b.slots * (f.guestcost)
	END >30
ORDER BY cost DESC

facility	    name	           cost	
Massage Room 2	GUEST GUEST	       320.0
Massage Room 1	GUEST GUEST	       160.0
Massage Room 1	GUEST GUEST	       160.0
Massage Room 1	GUEST GUEST	       160.0
Tennis Court 2	GUEST GUEST	       150.0
Tennis Court 1	GUEST GUEST	       75.0
Tennis Court 1	GUEST GUEST	       75.0
Tennis Court 2	GUEST GUEST	       75.0
Squash Court	GUEST GUEST	       70.0
Massage Room 1	Jemima Farrell	   39.6
Squash Court	GUEST GUEST	       35.0
Squash Court	GUEST GUEST	       35.0

/* Q9: This time, produce the same result as in Q8, but using a subquery. */


/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

