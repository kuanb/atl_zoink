# ATL Zoink!

This repo contains both python and ruby scripts.

## Installation (Ruby)

```` sh
git clone git@github.com:kuanb/atl_zoink.git
cd atl_zoink
bundle install
````

### Running in Ruby

Download all .csv files to local file system.

```` sh
ruby download.rb
````


## Installation (Python 2.7)

```` sh
git clone git@github.com:kuanb/atl_zoink.git
cd atl_zoink/pyv
````
At this time, no outside dependencies required. Tool uses `datetime`, `urllib2`, `csv` libraries, all of which are included. The Python version of the application is sitting in the `.pyv/` folder. 


### Running in Python

Once in the `.pyv/` folder, you can run the tool by entering `python searchall.py`. Logging during the process will inform you of the day that is currently being queried and, if there is data for that date, how many of the results scraped were kept. Data that is determined to be kept is data that has been vetted as a unique entry and not a duplicate of one from a prior date queried on that run.

```
None for 04252014
None for 04262014
None for 04272014
None for 04282014
Got a hit on 04292014 and kept 39874 out of 39874 results.
Got a hit on 04302014 and kept 39627 out of 39628 results.
Got a hit on 05012014 and kept 39043 out of 39044 results.
Got a hit on 05022014 and kept 39519 out of 39520 results.
Got a hit on 05032014 and kept 39522 out of 39523 results.
```

Results are stored in 3 files in the `.pyv/` folder. `alldata.csv` is a giant csv where all unique row values are dumped. This is the main data set of unique row entries from the CourtBot tool. `empty.csv` is any dates that did not have data associated with it. `hasdata.csv` is any dates that did indeed have data associated with it. Dates are listed in MMDDYYYY format.