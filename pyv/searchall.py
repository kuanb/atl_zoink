from datetime import timedelta, date
import urllib2

import csv
csv.field_size_limit(1000000000)

import sqlite3 as lite
import sys
con = None


# housekeeping to get the db set up and clean
con = lite.connect("all.db")
try:
	cur = con.cursor()
	cur.execute("DROP TABLE IF EXISTS allatl")
	cur.execute("CREATE TABLE allatl(case_date TEXT, case_defendant TEXT, citation_location TEXT, case_room TEXT, case_time TEXT, citation_id TEXT, citation_violation_id TEXT, citation_violation_description TEXT, citation_payable TEXT)")
except lite.Error, e:
	print "Error %s:" % e.args[0]
	sys.exit(1)
finally:
	if con:
		con.close()
	con = None


# base information/parameters for running operation
url_base = "http://courtview.atlantaga.gov/courtcalendars/court_online_calendar/codeamerica."
start_date = date(2014, 4, 25)
end_date = date(2016, 1, 1)


# func utils
def daterange(start_date, end_date):
	for n in range(int ((end_date - start_date).days)):
		yield start_date + timedelta(n)


# open csvs then clean and prep to write to them as we get results
f = open("empty.csv", "w+")
f.close()
f = open("hasdata.csv", "w+")
f.close()



for single_date in daterange(start_date, end_date):	
	curr_date = single_date.strftime("%m%d%Y")
	new_url = url_base + curr_date + ".csv"

	try:
		response = urllib2.urlopen(new_url)
		reader = csv.reader(response, delimiter="|")

		lines = []
		for r in reader:
			lines.append(tuple(r))
		l = tuple(lines)
		con = lite.connect("all.db")
		with con:
			cur = con.cursor()
			cur.executemany("INSERT INTO allatl VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)", l)
		con = None

		hasdata = open("hasdata.csv","a")
		hasdata.write(curr_date)
		hasdata.write("\n")
		hasdata.close()

		print "Got a hit on " + curr_date 

	except urllib2.HTTPError, e:
		empty = open("empty.csv","a")
		empty.write(curr_date)
		empty.write("\n")
		empty.close()

		print "None for " + curr_date



# we"re done so let"s close up shop
empty.close()
hasdata.close()
print "Done."