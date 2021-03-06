# Courtbot - Ruby

## Installation

Download source code and install package dependencies.

```` sh
git clone git@github.com:kuanb/atl_zoink.git
cd atl_zoink/rb
bundle install
````

## Prerequisites

[Install](http://data-creative.info/process-documentation/2015/07/18/how-to-set-up-a-mac-development-environment.html#ruby) ruby and bundler.

[Install](http://data-creative.info/process-documentation/2015/07/18/how-to-set-up-a-mac-development-environment.html#postgresql) postgresql.

Create user.

```` sh
psql
CREATE USER courtbot WITH ENCRYPTED PASSWORD 'c0urtb0t!';
ALTER USER courtbot CREATEDB;
ALTER USER courtbot WITH SUPERUSER;
\q
````

Create database.

```` sh
psql -U courtbot --password -d postgres -f $(pwd)/db/create.sql
````

Migrate database.

```` sh
ruby db/migrate/create_data_urls.rb
ruby db/migrate/create_appointments.rb
ruby db/migrate/create_citations.rb
ruby db/migrate/create_violations.rb
````

Optionally seed the database with fixtures.

```` sh
ruby db/seed.rb
````

## Usage

Extract, transform, and load all .csv data into a database.

```` sh
ruby script/extract_transform_and_load.rb
````

Backup database.

```` sh
pg_dump courtbot_atl > ~/Desktop/courtbot_atl_development.sql
````
