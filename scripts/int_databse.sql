Here’s your comment block rewritten in the same professional structure as your Silver and Bronze stored procedures, with formatting suitable for GitHub, team projects, or production documentation:

sql
Copy
Edit
/*
===============================================================================
 Script Name     : Create Database and Schemas
 Purpose         : Creates the 'DataWarehouse' database along with its 
                   associated schemas: 'bronze', 'silver', and 'gold'.

 Description     :
    - Checks if the 'DataWarehouse' database exists.
    - If it exists, drops the database after forcing single-user mode.
    - Recreates the database from scratch.
    - Creates the following schemas within the database:
        * bronze : Raw staging layer for data ingestion
        * silver : Cleaned and transformed layer
        * gold   : Aggregated and analytics-ready layer

 WARNING         :
    - Running this script will permanently delete the 'DataWarehouse' database 
      and all its contents if it already exists.
    - Ensure appropriate backups and authorization before execution.

 Parameters      : None

 Returns         : None

 Usage           : 
    Run this script manually via SSMS or automate as part of a deployment pipeline.

 Author          : Amine Bouraoui
 Created On      : 2025-07-26
 Last Modified   : 2025-07-28
===============================================================================
*/
