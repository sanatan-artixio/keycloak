-- Keycloak Database Setup Script
-- This script creates the keycloak database and sets up user permissions

-- Connect to PostgreSQL as superuser (postgres) to create database and user
-- psql -U postgres -h localhost

-- Create the keycloak database
CREATE DATABASE keycloak
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- User already exists, skipping user creation
-- If you need to modify the user password, uncomment the line below:
-- ALTER USER quriousri_owner WITH PASSWORD 'new_password_here';

-- Grant database connection privileges
GRANT CONNECT ON DATABASE keycloak TO quriousri_owner;

-- Connect to the keycloak database to set schema permissions
\c keycloak;

-- Grant usage on public schema
GRANT USAGE ON SCHEMA public TO quriousri_owner;

-- Grant all privileges on public schema
GRANT ALL PRIVILEGES ON SCHEMA public TO quriousri_owner;

-- Grant all privileges on all tables in public schema
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO quriousri_owner;

-- Grant all privileges on all sequences in public schema
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO quriousri_owner;

-- Grant all privileges on all functions in public schema
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO quriousri_owner;

-- Set default privileges for future objects created by any user in public schema
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO quriousri_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO quriousri_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO quriousri_owner;

-- Grant CREATE privilege on public schema (allows creating tables, indexes, etc.)
GRANT CREATE ON SCHEMA public TO quriousri_owner;

-- Make quriousri_owner owner of the public schema (optional, for full control)
-- ALTER SCHEMA public OWNER TO quriousri_owner;

-- Display granted privileges (for verification)
\dp public.*

-- Display user roles and privileges
SELECT 
    r.rolname as username,
    r.rolsuper as is_superuser,
    r.rolcreatedb as can_create_db,
    r.rolcreaterole as can_create_role,
    r.rolcanlogin as can_login
FROM pg_roles r 
WHERE r.rolname = 'quriousri_owner';

-- Show database access privileges
SELECT 
    datname as database_name,
    datacl as access_privileges
FROM pg_database 
WHERE datname = 'keycloak';

COMMENT ON DATABASE keycloak IS 'Keycloak Identity and Access Management Database';

-- Success message
\echo 'Keycloak database setup completed successfully!'
\echo 'Database: keycloak'
\echo 'User: quriousri_owner'
\echo 'Privileges: Full access to public schema'
