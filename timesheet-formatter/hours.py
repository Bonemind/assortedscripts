import xml.etree.ElementTree as ET
from datetime import datetime, timedelta
import dateutil.parser

# Read the xml logs
tree = ET.parse('hours.xml')

# Read the root element
root = tree.getroot()

class Formatter:
    def __init__(self):
        # Set up dictionaries
        self.taskdata = {}
        self.datedata = {}

    def row(self, taskrow):
        # Gets passed a task row
        # Pulls out the start, end and description
        start =  dateutil.parser.parse(task.find("startDate").text)
        end = dateutil.parser.parse(task.find("endDate").text)
        description = task.find("description").text

        # Calculate time by description
        if not self.taskdata.has_key(taskrow.find("description").text):
            self.taskdata[description] = end - start
        else:
            self.taskdata[description] += (end - start)


        # Calculate time by date
        if not self.datedata.has_key(start.date()):
            self.datedata[start.date()] = {}
            self.datedata[start.date()]["total"] = timedelta()

        if not self.datedata[start.date()].has_key(description):
            self.datedata[start.date()][description] = end - start
            self.datedata[start.date()]["total"] += (end - start)
        else:
            self.datedata[start.date()][description] += end - start
            self.datedata[start.date()]["total"] += (end - start)

    def hours_by_task(self):
        for t in sorted(f.get_task_data()):
            print "{0} | {1}".format(t, f.get_task_data()[t])

    def hours_by_date(self):
        # Stores the total time spent on a task
        total_by_task = {}

        # The final table that will be used to print headers and tasks
        final_table = {}

        # Create headers
        final_table["headers"] = []
        final_table["headers"].append("Task")
        final_table["tasks"] = set()

        
        # Add the tasks to  the column, and headers fields tot the row output
        for d in sorted(self.datedata):
            final_table["headers"].append(d)
            date = "{0}-{1}-{2} | ".format(d.day, d.month, d.year)
            for row in self.datedata[d]:
                final_table["tasks"].add(row)
                if not total_by_task.has_key(row):
                    total_by_task[row] = timedelta()

                total_by_task[row] += self.datedata[d][row]


        # Add a 'total' column
        final_table["headers"].append("Total")

        # Print the columns, and try to space them
        for idx, header in enumerate(final_table["headers"]):
            if idx == 0:
                print str(header) + (25 - len(str(header))) * " " ,
            else: 
                print str(header) + (12 - len(str(header))) * " " ,
        
        print ""

        # Print the tasks, and the time spent on a certain date, row by row
        # one task at a time
        for i, task in enumerate(sorted(final_table["tasks"])):
            print task + (25  - len(task)) * " ",

            # Find any row time logs for every date
            # Since the data was totaled by date, by task already we can just dump entries
            for d in sorted(self.datedata):
                printed = False
                for row in self.datedata[d]:
                    if row == task:
                        hours = str(self.datedata[d][row])
                        print hours + ((14 - len(hours)) * " "),
                        printed = True

                 # No entry was printed, no work was done on this date for this task
                if not printed:
                    print 5 * " " + "-" + 5 * " ",
            
            # print the total time spent on a task on a given week
            print total_by_task[task],

            print ""



f = Formatter()

for task in root[1]:
    f.row(task)

f.hours_by_date()

