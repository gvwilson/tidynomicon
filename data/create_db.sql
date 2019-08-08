-- Create database to be used for learners.
-- Original from http://github.com/swcarpentry/sql-novice-survey/.

-- Generate tables.
create table Person (person_id text, personal_name text, family_name text);
create table Site (site_id text, latitude real, longitude real);
create table Visited (visit_id integer, site_id text, visit_date text);
create table Measurements (visit_id integer, person_id text, quantity text, reading real);

-- Import data.
.mode csv
.import data/person.csv Person
.import data/site.csv Site
.import data/visited.csv Visited
.import data/measurements.csv Measurements

-- Remove CSV header lines.
delete from Person where rowid = 1;
delete from Site where rowid = 1;
delete from Visited where rowid = 1;
delete from Measurements where rowid = 1;

-- Convert empty strings to NULLs.
UPDATE Visited SET visit_date = null WHERE visit_date = '';
UPDATE Measurements SET person_id = null WHERE person_id = '';
