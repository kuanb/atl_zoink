from datetime import timedelta, date
import urllib2
import csv
csv.field_size_limit(1000000000)

url_base = "http://courtview.atlantaga.gov/courtcalendars/court_online_calendar/codeamerica."

def daterange(start_date, end_date):
	for n in range(int ((end_date - start_date).days)):
		yield start_date + timedelta(n)

start_date = date(2014, 1, 1)
end_date = date(2016, 1, 1)
start_date = date(2014, 10, 1)
end_date = date(2016, 10, 5)


# open csvs then clean and prep to write to them as we get results
f = open("empty.csv", "w+")
f.close()

f = open("hasdata.csv", "w+")
f.close()

f = open("alldata.csv", "w+")
f.close()



for single_date in daterange(start_date, end_date):	
	curr_date = single_date.strftime("%m%d%Y")
	new_url = url_base + curr_date + ".csv"

	try:
		response = urllib2.urlopen(new_url)
		reader = csv.reader(response, delimiter="|")

		lines = []
		for r in reader:
			entry = ",".join(r)
			lines.append(entry)

		keep = []
		checker = open("alldata.csv")
		base = csv.reader(checker, delimiter=",")
		for l in lines:
			do_keep = True
			for b in base:
				compare = ",".join(b)
				if compare == l:
					do_keep = False
			if do_keep is True:
				keep.append(l)
		checker.close()

		alldata = open("alldata.csv","a")
		for k in keep:
			alldata.write(k)
			alldata.write("\n")
		alldata.close()

		hasdata = open("hasdata.csv","a")
		hasdata.write(curr_date)
		hasdata.write("\n")
		hasdata.close()

		print "Got a hit on " + curr_date + "and kept " + len(keep) + " out of " + len(lines) + " results."

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