require 'nokogiri'
require 'pry'
require './nokogiri_to_hash'
require 'pp'

doc = File.open("hours.xml") { |f| Nokogiri::XML(f) }

# Get arrays for required data
projects = Hash.xml_node_to_hash(doc.xpath('//projects').first)[:project]
tasks = Hash.xml_node_to_hash(doc.xpath('//tasks').first)[:task]
breaks = Hash.xml_node_to_hash(doc.xpath('//breaks').first)[:break]
tags = Hash.xml_node_to_hash(doc.xpath('//tags').first)[:tag]
tasktags = Hash.xml_node_to_hash(doc.xpath('//taskTags').first)[:taskTag]
# 2015-09-07T12:26:00+02:00;2015-09-07T12:43:00+02:00;Airexpressbus;API;;Dataontwerp;
#

# Build tasks with references
tasks.each do |task|

	task[:startDate] = DateTime.parse(task[:startDate])
	task[:endDate] = DateTime.parse(task[:endDate])

	task[:project] = projects.find{|hash| hash[:projectId] == task[:projectId]}
	task[:breaks] = breaks.select{|hash| hash[:taskId] == task[:taskId]}

	task[:breaks].map! do |b|
		b[:startDate] = DateTime.parse(b[:startDate])
		b[:endDate] = DateTime.parse(b[:endDate])
		next b
	end

	taskTags = tasktags.select{|hash| hash[:taskId] == task[:taskId]}

	task[:tags] = []
	taskTags.each do |tt|
		tag = tags.find{|hash| tt[:tagId] == hash[:tagId]}
		task[:tags] << tag unless tag.nil?
	end
end

def as_csv(task_hash)
	
end

# Split tasks if they have breaks
split_tasks = []
tasks.each do |task|
	if task[:breaks].size == 0
		split_tasks << task
		next
	end

	breaks = task[:breaks].sort_by{ |b| b[:startDate] }
	breaks.each_with_index do |b, i|
		if i == 0
			# First break, create a new task where the end time is the start time of the break
			workingtask = task.clone
			workingtask[:endDate] = b[:startDate]
			split_tasks << workingtask
		end
		if i == breaks.size - 1
			# Last break, create a new task where the start date is the end time of the last date
			workingtask = task.clone
			workingtask[:startDate] = b[:endDate]
			split_tasks << workingtask
		end

		if i > 0 && i < breaks.size - 1
			# No special break, create a new task that starts at the previous end date and the current start date
			workingtask = task.clone
			workingtask[:startDate] = breaks[i - 1][:endDate]
			workingtask[:endDate] = breaks[i][:startDate]
			split_tasks << workingtask
		end
	end
end


binding.pry
