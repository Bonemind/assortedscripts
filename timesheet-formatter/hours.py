import xml.etree.ElementTree as ET
from datetime import datetime, timedelta
import dateutil.parser
from tabulate import tabulate
from pytz import timezone


class Formatter:
    def __init__(self, xml_string):
        # Set up dictionaries
        self.taskdata = {}
        self.datedata = {}
        self.xml_string = xml_string
        self.read_xml(self.xml_string)

    def read_xml(self, xml_string):

        # Read the xml logs
        tree = ET.parse('hours.xml')

        # Read the root element
        root = tree.getroot()

        projects = {}
        for project in root[0]:
            projects[project.find('projectId').text] = {}
            projects[project.find('projectId').text]['name'] = project.find('name').text
            projects[project.find('projectId').text]['customer'] = project.find('employer').text

        tags = {}
        for tag in root[5]:
            tags[tag.find('tagId').text] = tag.find('name').text

        task_tags = {}
        for task_tag in root[6]:
            task_tags[task_tag.find('taskId').text] = task_tag.find('tagId').text

        print 'starts_at;ends_at;relation;order;sub_order;description'
        for task in root[1]:
            project = projects[task.find('projectId').text]['name']
            customer = projects[task.find('projectId').text]['customer']
            tag = tags[task_tags[task.find('taskId').text]]
            start = task.find('startDate').text
            end = task.find('endDate').text
            desc = task.find('description').text.replace('\n', "")
            print '{0};{1};{2};{3};{4};{5};'.format(start, end, customer, project, tag, desc)


if __name__ == "__main__":
    with open('hours.xml', 'r') as content_file:
            content = content_file.read()
            f = Formatter(content)



