# Create keyspace
CREATE KEYSPACE example
WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 1};

CREATE TABLE emp(
   emp_id int PRIMARY KEY,
   emp_name text,
   emp_city text,
   emp_sal varint,
   emp_phone varint
);
