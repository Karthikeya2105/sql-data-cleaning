CREATE TABLE  messy_data_1 (
    id SERIAL PRIMARY KEY,
    full_name TEXT,
    email TEXT,
    age INTEGER,
    department TEXT,
    join_date TEXT
);

INSERT INTO messy_data_1 (full_name, email, age, department, join_date) VALUES
(' alice smith ', 'ALICE.SMITH@GMAIL.COM', 25, 'hr', '2021/01/15'),
('Bob Jones', 'bob.jones@gmail.com', NULL, 'HR', '2020-03-12'),
('Charlie brown', 'CHARLIE@EXAMPLE.COM', 38, 'It', '2019-07-23'),
('David Clark', 'david@example.com', -1, 'IT', '2022-11-01'),
('eve  ', 'eve@@example.com', 29, 'marketing', '2020-05-30'),
('Eve', 'eve@@example.com', 29, 'Marketing ', '2020-05-30'), -- duplicate
(' Frank lee', NULL, 200, 'SALES', '2018-04-18'),
('Grace  Hopper', ' grace.hopper@company.com ', 35, 'sales', '04/10/2019'),
('Henry Ford', 'henry ford@gmail.com', 32, 'Finance', '2021-02-10'),
('Ivy Watson', 'ivywatson@gmail.com', 33, 'finance', '2022-01-01'),
('john doe', 'john.doe@GMAIL.com', NULL, 'hr', '2019-09-09'),
('John Doe', 'john.doe@gmail.com', NULL, 'HR', '2019-09-09'), -- duplicate
('kevin', '', 45, 'Support', '2021-06-01'),
('linda', 'linda@@mail.com', NULL, '', '2022-02-02'),
('michael', 'MICHAEL@example.com', 101, 'support', '2022-07-07'),
('nina', NULL, NULL, 'it', '07/15/2020');

select * from messy_data_1;

describe messy_data_1;

# trim white spaces 

update messy_data_1
set full_name = trim(full_name)
where id > 0;
-- here id is primary key so id should be mentioned

update messy_data_1
set email = trim(email)
where id > 0;

update messy_data_1
set department = trim(department)
where id > 0;

-- lowercase  email,full name , department

UPDATE messy_data_1 
SET 
    email = LOWER(email)
WHERE
    id > 0;
    
UPDATE messy_data_1 
SET 
    full_name = LOWER(full_name),
    department = lower(department)
WHERE
    id > 0;
    
-- inspect age and correct them 

select * from messy_data_1
where age is null or age < 0 or age > 120 or age not REGEXP '^[0-9]+$';

-- converted null or negative ages into 30 

update messy_data_1
set age = 30
where (age is null or age < 0 or age > 120 or age not REGEXP '^[0-9]+$') and id > 0;

SELECT full_name,age, COUNT(*)
FROM messy_data_1
GROUP BY full_name, age
HAVING COUNT(*) > 1;


-- delete duplicate records 
# first preview what are duplicate records 
# imp : dont group by id as id should be in an auto increment , group  by all except id  



SELECT *
FROM messy_data_1
WHERE id NOT IN (
    SELECT id FROM (
        SELECT MIN(id) AS id
        FROM messy_data_1
        GROUP BY full_name, email, age, department, join_date
    ) AS temp_ids
);



SET SQL_SAFE_UPDATES = 0;

DELETE FROM messy_data_1
WHERE id NOT IN (
    SELECT id FROM (
        SELECT MIN(id) AS id
        FROM messy_data_1
        GROUP BY full_name, email, age, department, join_date
    ) AS temp_ids
);

SET SQL_SAFE_UPDATES = 1;

-- we are using safe update mode so in some case it gives error so we use to keep off in some times 

SELECT *
FROM messy_data_1
WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

update messy_data_1
set email = ''
WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

update messy_data_1
set email = ''
where email is null and id > 0;

-- here email = null doesnot works , email is null only works

alter table messy_data_1
add column join_date1 date;

set sql_safe_updates = 0;


UPDATE messy_data_1
SET join_date1 = CASE
    WHEN join_date LIKE '%/%/%' THEN STR_TO_DATE(join_date, '%d/%m/%y')
    WHEN join_date LIKE '%-%-%' THEN STR_TO_DATE(join_date, '%Y-%m-%d')
    ELSE NULL
END;

alter table messy_data_1
drop column join_date;

alter table messy_data_1
change join_date1 join_date date;

set sql_safe_updates = 1;