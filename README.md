# ATL Zoink!

This repo contains both python and ruby scripts.

## Installation

```` sh
git clone git@github.com:kuanb/atl_zoink.git
cd atl_zoink
bundle install # if you're going to run the ruby script
````

## Usage

Download all .csv files to local file system.

```` sh
ruby extract.rb
````

Store .csv data in a database.

```` sh
ruby transform_and_load.rb
````
