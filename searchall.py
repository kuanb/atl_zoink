# author: KB

from datetime import timedelta, date
import urllib2
import csv

url_base = "http://courtview.atlantaga.gov/courtcalendars/court_online_calendar/codeamerica."

def daterange(start_date, end_date):
	for n in range(int ((end_date - start_date).days)):
		yield start_date + timedelta(n)

start_date = date(2014, 1, 1)
end_date = date(2016, 1, 1)


start_date = date(2015, 1, 1)
end_date = date(2016, 1, 1)


# open csvs then clean and prep to write to them as we get results
f = open('empty.csv', "w+")
f.close()

f = open('hasdata.csv', "w+")
f.close()

empty = open('empty.csv','a')
hasdata = open('hasdata.csv','a')
alldata = open('alldata.csv','a')



for single_date in daterange(start_date, end_date):
	curr_date = single_date.strftime("%m%d%Y")
	new_url = url_base + curr_date + ".csv"
	try:
		response = urllib2.urlopen(new_url)
		html = response.read()

		reader = csv.reader(html)
		for r in reader:
			alldata.write(curr_date)

		hasdata.write(curr_date)

		print "Got a hit on " + curr_date

	except urllib2.HTTPError, e:
		print "None for " + curr_date
		empty.write(curr_date)

	empty.write("\n")
	hasdata.write("\n")
	alldata.write("\n")



# we're done so let's close up shop
empty.close()
hasdata.close()
print "Done."
