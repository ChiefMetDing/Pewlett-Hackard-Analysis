-- Deliverable 1: The number of Retiring Employees by Title (50 points) 
	-- Steps 1 to 7
	-- Joining employees and titles as emp_no ascending and to_date descending.
	-- The table contains employees whos birthday is between 1952 and 1955.
	-- The table contains employees who left the company.
	DROP TABLE IF EXISTS emptit_info;

	SELECT e.emp_no, -- show these 6 columns in the table
		e.first_name,
		e.last_name,
		tit.title,
		tit.from_date,
		tit.to_date
	INTO emptit_info -- save to a new table
	FROM employees AS e -- table on the left
		INNER JOIN titles AS tit -- table on the right
			ON (e.emp_no = tit.emp_no) -- columns to join
		--INNER JOIN dept_emp AS de -- second table
			--ON (e.emp_no = de.emp_no)
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') -- retrieve birthday between 1952 and 1955
	--AND de.to_date = '9999-01-01'
	ORDER BY e.emp_no ASC, tit.to_date DESC;

	SELECT * FROM emptit_info;

	SELECT COUNT(*) FROM emptit_info;
	
------------------------------------------------------------------------------------------------------
	-- Steps 8 to 14
	-- Remove duplicates.
	DROP TABLE IF EXISTS unique_titles;

	SELECT DISTINCT ON (et.emp_no) et.emp_no, -- select columns to show
		et.first_name,
		et.last_name,
		et.title
	INTO unique_titles -- save to a new table
	FROM emptit_info as et
	ORDER BY et.emp_no ASC, et.to_date DESC;
	
	-- Show the whole table
	SELECT * FROM unique_titles;

------------------------------------------------------------------------------------------------------
	-- Steps 15 to 20
	--Retrive the number of titles from the Unique Titles table.
	DROP TABLE IF EXISTS retiring_titles;

	SELECT COUNT (ut.emp_no),ut.title
	INTO retiring_titles
	FROM unique_titles as ut
		INNER JOIN dept_emp AS de -- second table
			ON (ut.emp_no = de.emp_no)
	WHERE de.to_date = '9999-01-01' -- remove employees had left the company
	GROUP BY ut.title
	ORDER BY count DESC;

	SELECT * FROM retiring_titles;
	
	SELECT SUM(count) FROM retiring_titles;
	
	-- Show retiring managers
	SELECT ut.emp_no,
		ut.first_name,
		ut.last_name,
		ut.title,
		d.dept_name
	FROM unique_titles as ut
	INNER JOIN dept_manager as dm
		ON ut.emp_no = dm.emp_no
	INNER JOIN departments as d
		ON dm.dept_no = d.dept_no
	WHERE ut.title = 'Manager'

------------------------------------------------------------------------------------------------------
-- Deliverable 2: The Employees Eligible for the Mentorship Program(30 points)
	-- Steps 1 to 11
	-- create a Mentorship Eligibility table
	DROP TABLE IF EXISTS mentorship_eligibility;
	
	SELECT DISTINCT ON (e.emp_no) e.emp_no, -- select columns to show
		e.first_name,
		e.last_name,
		e.birth_date,
		de.from_date,
		tit.to_date,
		tit.title
	INTO mentorship_eligibility -- new table name
	FROM employees as e -- table on the left
	INNER JOIN dept_emp as de -- second table
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles as tit -- third table
		ON (e.emp_no = tit.emp_no)
	WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
		AND (de.to_date = '9999-01-01')
	ORDER BY e.emp_no ASC, tit.to_date DESC;
		
	SELECT * FROM mentorship_eligibility;

	-- Dipayan Seghrouchni (10291) was promoted to Senior Staff.
	SELECT me.emp_no,
		me.first_name,
		me.last_name,
		titles.title,
		titles.from_date,
		titles.to_date
	FROM titles
	INNER JOIN mentorship_eligibility as me
		ON me.emp_no = titles.emp_no
	WHERE (me.emp_no = 10291)
	
--------------------------------------------------------------------------------
	-- Show mentorship counts by titles.
	DROP TABLE IF EXISTS mentorship_titles;

	SELECT COUNT (me.emp_no),me.title
	INTO mentorship_titles
	FROM mentorship_eligibility as me
	GROUP BY me.title
	ORDER BY count DESC;

	SELECT * FROM mentorship_titles;
	
	SELECT SUM(count) FROM mentorship_titles;