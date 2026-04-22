-- math operators
select 10 + 20;

select 100-50;

select 2*3;

select 10/5;

select sqrt(25);

select log(2);

select exp(4);

select round(5.3),round(5.7);

-- floor: looks for greatest integer less than number
--ceil : looks for smallest integere which is greater than given number
select floor(3.4),ceil(3.4);

-- date and time
-- find todays date
select current_date;

-- current_time'
select current_time;

-- current date and time
select current_timestamp;

--age
select age(current_date,'2020-04-10');

-- extract date and time components

select extract(year from current_timestamp);
select extract(month from current_timestamp);
select extract(day from current_timestamp);
select extract(hour from current_timestamp);
select extract(minute from current_timestamp);
select extract(second from current_timestamp);

-- to_char
select to_char(current_date , 'Month');
select to_char(current_date , 'Mon');
select to_char(current_date , 'day');
select to_char(current_date , 'dy');

-- Interval 
-- what would be the date after 10 days
select current_date +Interval '10days';
-- what would be date after a 2months
select current_date +Interval '2 months';
-- what would be the date after 1 year
select current_date +Interval '1 year';

-- what was the date 1 year ago
select current_date -Interval '1 year';








