-- Privileges for current user
SHOW GRANTS FOR CURRENT_USER();

-- Show create statement for current user
SHOW CREATE USER CURRENT_USER();

-- General info about user (actual & matched at server config), current schema & server version
SELECT USER(), CURRENT_USER(), DATABASE(), VERSION();
