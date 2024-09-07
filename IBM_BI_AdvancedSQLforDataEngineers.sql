-- EXERCISE 1, QUESTION 1: Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.

SELECT cs.NAME_OF_SCHOOL, cs.COMMUNITY_AREA_NAME,cs.AVERAGE_STUDENT_ATTENDANCE
FROM chicago_public_schools cs LEFT JOIN chicago_socioeconomic_data cd 
ON cs.community_area_number = cd.community_area_number  
WHERE hardship_index = 98

  
-- EXERCISE 1, QUESTION 2: Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.

SELECT cc.case_number, cc.primary_type, cd.community_area_number
FROM chicago_crime cc LEFT JOIN chicago_socioeconomic_data cd 
ON cc.community_area_number = cd.community_area_number  
WHERE cc.location_description LIKE 'SCHOOL%'

  
-- EXERCISE 2: Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in the second column.

DROP VIEW school_view;

CREATE VIEW school_view AS 
SELECT NAME_OF_SCHOOL AS School_Name,
		Safety_Icon AS Safety_Rating,
		Family_Involvement_Icon AS Family_Rating,
		Environment_Icon AS Environment_Rating,
		Instruction_Icon AS Instruction_Rating,
		Leaders_Icon AS Leaders_Rating,
		Teachers_Icon AS Teachers_Rating
FROM chicago_public_schools cp;

-- Write and execute a SQL statement that returns all of the columns from the view.

SELECT * FROM school_view;

-- QUESTION 1: Write and execute a SQL statement that returns just the school name and leaders rating from the view.

SELECT School_Name, Leaders_Rating FROM school_view;


-- EXERCISE 3, QUESTION 1: Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer. Don't forget to use the #SET TERMINATOR statement to use the @ for the CREATE statement terminator.

DELIMITER //
  
CREATE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leaders_Score Integer )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN 

END
//


-- EXERCISE 3, QUESTION 2: Inside your stored procedure, write a SQL statement to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value in the in_Leader_Score parameter.

DROP PROCEDURE UPDATE_LEADERS_SCORE;

DELIMITER //
  
CREATE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leaders_Score Integer )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN 
	
	UPDATE chicago_public_schools
	SET Leaders_Score = in_Leaders_Score
	WHERE School_ID = in_School_ID;
  
 END
 //


-- EXERCISE 3, QUESTION 3: Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using the following information.

DROP PROCEDURE UPDATE_LEADERS_SCORE;

DELIMITER //
  
CREATE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leaders_Score Integer )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN 
	
	UPDATE chicago_public_schools
	SET Leaders_Score = in_Leaders_Score
	WHERE School_ID = in_School_ID;
	
	IF (in_Leaders_Score > 0 AND in_Leaders_Score < 20) THEN                      -- Start of conditional statement
        UPDATE chicago_public_schools 
        SET Leaders_icon = 'Very weak'
        WHERE School_ID = in_School_ID;
        
    ELSEIF in_Leaders_Score < 40 THEN
    	UPDATE chicago_public_schools 
        SET Leaders_icon = 'weak'
        WHERE School_ID = in_School_ID;
    	
    ELSEIF in_Leaders_Score < 60 THEN
    	UPDATE chicago_public_schools 
        SET Leaders_icon = 'Average'
        WHERE School_ID = in_School_ID;
 
 	ELSEIF in_Leaders_Score < 80 THEN
 		UPDATE chicago_public_schools 
        SET Leaders_icon = 'Strong'
        WHERE School_ID = in_School_ID;
 	
 	ELSEIF in_Leaders_Score < 100 THEN
 		UPDATE chicago_public_schools 
        SET Leaders_icon = 'Very Strong'
        WHERE School_ID = in_School_ID;

   END IF;                 
END
@                                               -- Routine termination character


-- EXERCISE 3, QUESTION 4: Write a query to call the stored procedure, passing a valid school ID and a leader score of 50, to check that the procedure works as expected

DELIMITER ;
  
SELECT School_ID, Leaders_icon FROM chicago_public_schools WHERE School_ID =610038;

CALL UPDATE_LEADERS_SCORE(610038,100);

SELECT School_ID, Leaders_icon FROM chicago_public_schools WHERE School_ID =610038;


-- EXERCISE 4, QUESTION 1: Update your stored procedure definition. Add a generic ELSE clause to the IF statement that ROLLS BACK the current work if the score did not fit any of the preceding categories.
-- EXERCISE 4, QUESTION 2: Update your stored procedure definition again. Add a statement to COMMIT the current unit of work at the end of the procedure.

DROP PROCEDURE UPDATE_LEADERS_SCORE;

DELIMITER @
  
CREATE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leaders_Score Integer )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN 
	
	UPDATE chicago_public_schools
	SET Leaders_Score = in_Leaders_Score
	WHERE School_ID = in_School_ID;
	
	IF (in_Leaders_Score > 0 AND in_Leaders_Score < 20) THEN                      -- Start of conditional statement
        UPDATE chicago_public_schools 
        SET Leaders_icon = 'Very weak'
        WHERE School_ID = in_School_ID;
        
    ELSEIF in_Leaders_Score < 40 THEN
    	UPDATE chicago_public_schools 
        SET Leaders_icon = 'weak'
        WHERE School_ID = in_School_ID;
    	
    ELSEIF in_Leaders_Score < 60 THEN
    	UPDATE chicago_public_schools 
        SET Leaders_icon = 'Average'
        WHERE School_ID = in_School_ID;
 
 	ELSEIF in_Leaders_Score < 80 THEN
 		UPDATE chicago_public_schools 
        SET Leaders_icon = 'Strong'
        WHERE School_ID = in_School_ID;
 	
 	ELSEIF in_Leaders_Score < 100 THEN
 		UPDATE chicago_public_schools 
        SET Leaders_icon = 'Very Strong'
        WHERE School_ID = in_School_ID;
    ELSE 
    	ROLLBACK WORK;
    END IF;                 
    COMMIT WORK;
END
@                                                             -- Routine termination character


-- Run your code to replace the stored procedure.
-- NOTE: I had to alter column to be able to run procedure using following command 
ALTER TABLE chicago_public_schools MODIFY Leaders_Icon VARCHAR(11);

-- OTHER QUESTIONS OF THE HANDS-ON LAB:

-- Write and run one query to check that the updated stored procedure works as expected when you use a valid score of 38.

SELECT School_ID, Leaders_icon FROM chicago_public_schools WHERE School_ID =610038;

CALL UPDATE_LEADERS_SCORE(610038, 38);

-- Write and run another query to check that the updated stored procedure works as expected when you use an invalid score of 101.

SELECT School_ID, Leaders_icon FROM chicago_public_schools WHERE School_ID =610038;

CALL UPDATE_LEADERS_SCORE(610038, 101);



-- OFICIAL ANSWERS --

-- E1 - Q1

-- SQL query is correct; it uses a join and returns 4 rows. The SQL query should either use a left outer join like: 

FROM census_data a LEFT OUTER JOIN chicago_public_schools b 

ON a.community_area_number = b.community_area_number 

-- or a right outer join like:

FROM chicago_public_schools  a RIGHT OUTER JOIN census_data b 

ON a.community_area_number = b.community_area_number


-- E2 - Q2

-- SQL query is correct; it uses a join and returns 12 rows. The SQL query should either use a left outer join like:

FROM chicago_crime_data a LEFT OUTER JOIN census_data b 
ON a.community_area_number = b.community_area_number 

-- or a right outer join like:

FROM census_data a RIGHT OUTER JOIN chicago_crime_data b 
ON a.community_area_number = b.community_area_number


-- E2 - Q1

-- SQL query correctly returns two columns, named SCHOOL_NAME and LEADERS_RATING from the view that they created.


-- E3 - Q1

-- SQL query is similar to the following:

DELIMITER //

CREATE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID integer, IN in_Leader_Score integer)
LANGUAGE SQL				
END //
DELIMITER ; 


-- E3 - Q2 

-- SQL query is similar to the following:

DELIMITER //
CREATE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID integer, IN in_Leader_Score integer)
		LANGUAGE SQL
		MODIFIES SQL DATA
				BEGIN 
						UPDATE chicago_public_schools
						SET  Leaders_Score = in_Leader_Score
						WHERE School_ID = in_School_ID;
				END //
  DELIMITER ;


-- E3 - Q3

-- SQL query is similar to the following:

DELIMITER //

CREATE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID integer, IN in_Leader_Score integer)
		LANGUAGE SQL
		MODIFIES SQL DATA
				BEGIN 
						UPDATE chicago_public_schools
						SET  Leaders_Score = in_Leader_Score
						WHERE School_ID = in_School_ID;
						
						IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Very_weak'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;
						ELSEIF in_Leader_Score >= 20  AND in_Leader_Score < 40   THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Weak'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;
						ELSEIF in_Leader_Score >= 40 and in_Leader_Score < 60 THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Average'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;
						ELSEIF in_Leader_Score >= 60 and in_Leader_Score < 80 THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Strong'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;
						ELSEIF in_Leader_Score >= 80 and in_Leader_Score < 100 THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Very_Strong'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;

 						END IF;


								
				END //
  DELIMITER ; 


-- E3 - Q4

-- SQL query contains the following and the results pane states that the stored procedure was successfully created.

DELIMITER //

CREATE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID integer, IN in_Leader_Score integer)
		LANGUAGE SQL
		MODIFIES SQL DATA
				BEGIN 
						UPDATE chicago_public_schools
						SET  Leaders_Score = in_Leader_Score
						WHERE School_ID = in_School_ID;
						
						IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Very_weak'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;
						ELSEIF in_Leader_Score >= 20  AND in_Leader_Score < 40   THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Weak'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;
						ELSEIF in_Leader_Score >= 40 and in_Leader_Score < 60 THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Average'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;
						ELSEIF in_Leader_Score >= 60 and in_Leader_Score < 80 THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Strong'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;
						ELSEIF in_Leader_Score >= 80 and in_Leader_Score < 100 THEN
								UPDATE chicago_public_schools
								SET Leaders_Icon = 'Very_Strong'
								WHERE in_School_ID = School_ID AND in_Leader_Score = Leaders_Score;

 						END IF;


								
				END //
  DELIMITER ; 


-- E4 - Q1

-- Stored procedure definition now contains an ELSE clause and ROLLBACK WORK before the END IF statement.

-- E4 - Q2 

-- Stored procedure definition now contains a COMMIT statement after the END IF statement.
