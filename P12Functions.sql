--1--
CREATE or REPLACE FUNCTION del_under18()
returns SETOF INTEGER AS $$
DELETE FROM CUSTOMERS WHERE AGE<18
RETURNING customerid;
$$ language sql;
--2--
CREATE TYPE return_before_after AS (before int, after int);
CREATE or replace FUNCTION del_under18_2() RETURNS return_before_after AS
$$
DECLARE
	before integer;
	after integer;
BEGIN
SELECT count(*) INTO before FROM customers;
DELETE FROM customers WHERE age < 18;
SELECT count(*) INTO after FROM customers;
RETURN (before, after);
END;
$$ LANGUAGE plpgsql;
--3--
CREATE FUNCTION insert_category1_sql(pcategory integer, pname varchar) RETURNS void AS
$$
INSERT INTO categories VALUES (pcategory, pname);					
$$ LANGUAGE sql;
--3v2--
CREATE FUNCTION insert_category2_sql(integer, varchar) RETURNS void AS
$$
INSERT INTO categories VALUES ($1, $2);					
$$ LANGUAGE sql;
--3v3--
CREATE FUNCTION insert_category3_sql(category integer, categoryname varchar) RETURNS void AS
$$
	INSERT INTO categories VALUES (insert_category3_sql.category,
	insert_category3_sql.categoryname);				
$$ LANGUAGE sql; 
CREATE FUNCTION insert_category4_sql(pcategory categories) RETURNS void AS
$$
	INSERT INTO categories VALUES (pcategory.category,
	pcategory.categoryname);				
$$ LANGUAGE sql;
--4--
CREATE FUNCTION show_name_sql(id integer, OUT first varchar, OUT last varchar) AS $$
select firstname, lastname from customers where customerid = $1; 
$$ LANGUAGE SQL;
--5--
CREATE FUNCTION show_name_plpgsql(id integer, OUT first varchar, OUT last varchar)
AS $$
begin
select firstname into first from customers where customerid = $1; 
select lastname into last from customers where customerid = $1;
end;
$$ LANGUAGE PLPGSQL;
--6--
CREATE FUNCTION show_cust_sql(id integer) 
RETURNS customers AS $$
select * from customers where customerid = $1;
$$ LANGUAGE SQL;
--7--
CREATE or replace FUNCTION show_prod_sql(INOUT prod_id integer, OUT title varchar(50), OUT price numeric) AS
$$					
	SELECT prod_id,title, price FROM products WHERE prod_id = show_prod_sql.prod_id;
$$ LANGUAGE sql; 
CREATE or replace FUNCTION show_prod_plpgsql(INOUT prod_id integer, OUT title varchar(50), OUT price numeric) RETURNS RECORD AS
$$
BEGIN					
	SELECT p.prod_id,p.title,p.price INTO 
		show_prod_plpgsql.prod_id,
		show_prod_plpgsql.title,
		show_prod_plpgsql.price
	FROM products p WHERE p.prod_id = show_prod_plpgsql.prod_id;
END;
$$ LANGUAGE plpgsql;
--8--
CREATE or replace FUNCTION avg_price_sql() 
RETURNS numeric AS $$
select avg(price) from products;
$$ LANGUAGE SQL;
--8v2--
CREATE or replace FUNCTION avg_price_plpgsql() 
RETURNS numeric AS $$
begin
RETURN (select avg(price) from products);
end;
$$ LANGUAGE PLPGSQL;
19:40
-- NOT AVG --
CREATE or replace FUNCTION avg_price_noavg() 
RETURNS numeric AS $$
select SUM(price)/COUNT(price) from products;
$$ LANGUAGE SQL;
--9--
CREATE or replace FUNCTION mySum(integer, integer) RETURNS bigint AS
$$
BEGIN
	RETURN $1+$2;
END;
$$ LANGUAGE plpgsql;