-- =========================
-- SQL Practice Queries
-- Database: exercises
-- Schema: cd
-- =========================

-- Q1: Add a new facility (Spa) to the facilities table
INSERT INTO cd.facilities (
    facid,
    name,
    membercost,
    guestcost,
    initialoutlay,
    monthlymaintenance
)
VALUES (
    9,
    'Spa',
    20,
    30,
    100000,
    800
);

-- Q2: Add a new facility (Spa) with automatically generated facid
INSERT INTO cd.facilities (
    facid,
    name,
    membercost,
    guestcost,
    initialoutlay,
    monthlymaintenance
)
SELECT
    MAX(facid) + 1,
    'Spa',
    20,
    30,
    100000,
    800
FROM cd.facilities;

SELECT *
FROM cd.facilities
ORDER BY facid DESC
LIMIT 1;

-- Q3:
-- We made a mistake when entering the data for the second tennis court.
-- The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.

UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2';

SELECT facid, name, initialoutlay
FROM cd.facilities
WHERE name = 'Tennis Court 2';

-- Question:
-- We want to alter the price of the second tennis court so that it costs
-- 10% more than the first one. Try to do this without using constant values
-- for the prices, so that we can reuse the statement if we want to.

UPDATE cd.facilities
SET membercost = (
        SELECT membercost * 1.1
        FROM cd.facilities
        WHERE name = 'Tennis Court 1'
    ),
    guestcost = (
        SELECT guestcost * 1.1
        FROM cd.facilities
        WHERE name = 'Tennis Court 1'
    )
WHERE name = 'Tennis Court 2';

SELECT name, membercost, guestcost
FROM cd.facilities
WHERE name IN ('Tennis Court 1', 'Tennis Court 2')
ORDER BY name;

-- Question:
-- As part of a clearout of our database, we want to delete all bookings
-- from the cd.bookings table. How can we accomplish this?

DELETE FROM cd.bookings;

SELECT COUNT(*)
FROM cd.bookings;

-- Question:
-- We want to remove member 37, who has never made a booking,
-- from our database. How can we achieve that?

DELETE FROM cd.members
WHERE memid = 37
  AND memid NOT IN (
      SELECT memid
      FROM cd.bookings
  );
SELECT *
FROM cd.members
WHERE memid = 37;

-- Question:
-- How can you produce a list of facilities that charge a fee to members,
-- and that fee is less than 1/50th of the monthly maintenance cost?
-- Return the facid, facility name, member cost, and monthly maintenance
-- of the facilities in question.

SELECT facid,
       name,
       membercost,
       monthlymaintenance
FROM cd.facilities
WHERE membercost > 0
  AND membercost < (monthlymaintenance / 50.0);

-- Question:
-- How can you produce a list of all facilities with the word 'Tennis'
-- in their name?

SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';

-- Question:
-- How can you retrieve the details of facilities with ID 1 and 5?
-- Try to do it without using the OR operator.

SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);

-- Question:
-- How can you produce a list of members who joined after the start of
-- September 2012? Return the memid, surname, firstname, and joindate
-- of the members in question.

SELECT memid,
       surname,
       firstname,
       joindate
FROM cd.members
WHERE joindate >= '2012-09-01'
ORDER BY joindate;

--Question: Produce a combined list of all surnames and facility names

--You, for some reason, want a combined list of all surnames and all
--facility names. Yes, this is a contrived example :-).
--Produce that list.


SELECT surname AS name
FROM cd.members

UNION

SELECT name
FROM cd.facilities;


-- Question:
-- How can you produce a list of the start times for bookings
-- by members named 'David Farrell'?

SELECT b.starttime
FROM cd.bookings b
JOIN cd.members m
  ON b.memid = m.memid
WHERE m.firstname = 'David'
  AND m.surname = 'Farrell'
ORDER BY b.starttime;

-- Question:
-- How can you produce a list of the start times for bookings for tennis courts,
-- for the date '2012-09-21'? Return a list of start time and facility name
-- pairings, ordered by the time.

SELECT b.starttime,
       f.name
FROM cd.bookings b
JOIN cd.facilities f
  ON b.facid = f.facid
WHERE f.name LIKE 'Tennis Court%'
  AND b.starttime >= '2012-09-21'
  AND b.starttime < '2012-09-22'
ORDER BY b.starttime;

-- Question:
-- How can you output a list of all members, including the individual
-- who recommended them (if any)? Ensure that results are ordered by
-- (surname, firstname).

select mems.firstname as memfname, mems.surname as memsname, recs.firstname as recfname, recs.surname as recsname
	from 
		cd.members mems
		left outer join cd.members recs
			on recs.memid = mems.recommendedby
order by memsname, memfname;

-- Question:
-- How can you output a list of all members who have recommended
-- another member? Ensure that there are no duplicates in the list,
-- and that results are ordered by (surname, firstname).

select distinct recs.firstname as firstname, recs.surname as surname
	from 
		cd.members mems
		inner join cd.members recs
			on recs.memid = mems.recommendedby
order by surname, firstname;  


-- Question:
-- How can you output a list of all members, including the individual who
-- recommended them (if any), without using any joins? Ensure that there are
-- no duplicates in the list, and that each firstname + surname pairing is
-- formatted as a column and ordered.

SELECT DISTINCT
       m.firstname || ' ' || m.surname AS member,
       (
           SELECT r.firstname || ' ' || r.surname
           FROM cd.members r
           WHERE r.memid = m.recommendedby
       ) AS recommender
FROM cd.members m
ORDER BY member;

-- Question:
-- Produce a count of the number of recommendations each member has made.
-- Order by member ID.

select recommendedby, count(*) 
	from cd.members
	where recommendedby is not null
	group by recommendedby
order by recommendedby; 

-- Question:
-- Produce a list of the total number of slots booked per facility.
-- For now, just produce an output table consisting of facility id
-- and slots, sorted by facility id.

SELECT facid,
       SUM(slots) AS total_slots
FROM cd.bookings
GROUP BY facid
ORDER BY facid;

-- Question:
-- Produce a list of the total number of slots booked per facility
-- in the month of September 2012. Produce an output table consisting
-- of facility id and slots, sorted by the number of slots.

SELECT facid,
       SUM(slots) AS total_slots
FROM cd.bookings
WHERE starttime >= '2012-09-01'
  AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY total_slots;

-- Question:
-- Produce a list of the total number of slots booked per facility per month
-- in the year of 2012. Produce an output table consisting of facility id
-- and slots, sorted by the id and month.

select facid, extract(month from starttime) as month, sum(slots) as "Total Slots"
	from cd.bookings
	where extract(year from starttime) = 2012
	group by facid, month
order by facid, month;  

-- Question:
-- Find the total number of members (including guests)
-- who have made at least one booking.

SELECT COUNT(DISTINCT memid) AS member_count
FROM cd.bookings;


-- Question:
-- Produce a list of each member name, id, and their first booking
-- after September 1st 2012. Order by member ID.

select mems.surname, mems.firstname, mems.memid, min(bks.starttime) as starttime
	from cd.bookings bks
	inner join cd.members mems on
		mems.memid = bks.memid
	where starttime >= '2012-09-01'
	group by mems.surname, mems.firstname, mems.memid
order by mems.memid; 

-- Question:
-- Produce a list of member names, with each row containing the total member count.
-- Order by join date, and include guest.

select count(*) over(), firstname, surname
	from cd.members
order by joindate 

-- Question:
-- Produce a monotonically increasing numbered list of members
-- (including guests), ordered by their date of joining.
-- Remember that member IDs are not guaranteed to be sequential.

select row_number() over(order by joindate), firstname, surname
	from cd.members
order by joindate 

-- Question:
-- Output the facility id that has the highest number of slots booked.
-- Ensure that in the event of a tie, all tieing results get output.

select facid, total from (
	select facid, sum(slots) total, rank() over (order by sum(slots) desc) rank
        	from cd.bookings
		group by facid
	) as ranked
	where rank = 1  
	
-- Question:
-- Output the names of all members, formatted as 'Surname, Firstname'.

SELECT surname || ', ' || firstname AS member_name
FROM cd.members
ORDER BY surname, firstname;

-- Question:
-- You've noticed that the club's member table has telephone numbers
-- with very inconsistent formatting. You'd like to find all the
-- telephone numbers that contain parentheses, returning the member ID
-- and telephone number sorted by member ID.

SELECT memid,
       telephone
FROM cd.members
WHERE telephone LIKE '%(%'
ORDER BY memid;

-- Question:
-- You'd like to produce a count of how many members you have whose
-- surname starts with each letter of the alphabet. Sort by the letter,
-- and don't worry about printing out a letter if the count is 0.

SELECT SUBSTRING(surname FROM 1 FOR 1) AS first_letter,
       COUNT(*) AS member_count
FROM cd.members
GROUP BY first_letter
ORDER BY first_letter;





