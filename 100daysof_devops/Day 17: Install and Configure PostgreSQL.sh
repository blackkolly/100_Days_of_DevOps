The Nautilus application development team has shared that they are planning to deploy one newly developed application on Nautilus infra in Stratos DC. The application uses PostgreSQL database, so as a pre-requisite we need to set up PostgreSQL database server as per requirements shared below:



PostgreSQL database server is already installed on the Nautilus database server.


a. Create a database user kodekloud_cap and set its password to YchZHRcLkL.


b. Create a database kodekloud_db9 and grant full permissions to user kodekloud_cap on this database.


Note: Please do not try to restart PostgreSQL server service




PostgreSQL is already installed on `stdb01` (the DB server), you just need to:

1. Connect to the DB server

   ssh peter@stdb01.stratos.xfusioncorp.com
   # password: Sp!dy
  

2. Switch to postgres system user (default admin for PostgreSQL):

   sudo su - postgres

3. Login to PostgreSQL shell:

   psql
  
4. Create the database user with password:
   CREATE USER kodekloud_cap WITH PASSWORD 'YchZHRcLkL';
  

5. Create the database
   CREATE DATABASE kodekloud_db9;
   

6. Grant all privileges on the database to the user:
   GRANT ALL PRIVILEGES ON DATABASE kodekloud_db9 TO kodekloud_cap;
   

7.Exit psql:
   \q
   

8. Exit postgres user shell
   exit
  

