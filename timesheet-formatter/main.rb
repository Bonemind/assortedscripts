require 'nokogiri'
require 'pry'
require './nokogiri_to_hash'
require 'pp'
require 'timerizer'
require 'optparse'

doc = File.open("hours.xml") { |f| Nokogiri::XML(f) }

OUT_FOLDER = "./out"

# Get arrays for required data
projects = Hash.xml_node_to_hash(doc.xpath('//projects').first)[:project]
tasks = Hash.xml_node_to_hash(doc.xpath('//tasks').first)[:task]
breaks = Hash.xml_node_to_hash(doc.xpath('//breaks').first)[:break]
tags = Hash.xml_node_to_hash(doc.xpath('//tags').first)[:tag]
tasktags = Hash.xml_node_to_hash(doc.xpath('//taskTags').first)[:taskTag]
# 2015-09-07T12:26:00+02:00;2015-09-07T12:43:00+02:00;Airexpressbus;API;;Dataontwerp;
#

def as_csv(task_hash, filename)
	# Write a csv of the data
	header = 'starts_at;ends_at;relation;order;sub_order;description'
	lines = []
	lines << header
	task_hash.each do |task|
		line = []
		line << task[:startDate]
		line << task[:endDate]
		line << task[:project][:employer]
		line << task[:project][:name]
		line << task[:tags].map{|t| t[:name]}.join(',')
		line << task[:description]
		lines << line.join(';')
	end
	filename = OUT_FOLDER + "/#{filename}.csv"
	File.open(filename, 'w') do |file|
		file.write(lines.join("\r\n"))
	end
	puts "Wrote #{filename}"
end

def export(tasks, filename)
	as_csv(tasks, filename)
end

def export_bydate(tasks, start_date, end_date)
	start_date_parsed = DateTime.parse(start_date).to_date
	end_date_parsed = DateTime.parse(end_date).to_date

	# Select only those dates
	previous_week_tasks = tasks.select do |t|
		next t[:startDate] >= start_date_parsed && t[:startDate] <= end_date_parsed
	end

	# Write the csv
	export(previous_week_tasks, "#{start_date_parsed}-to-#{end_date_parsed}")
end

def export_all(tasks)
	export(tasks, "all-#{DateTime.now}")
end

def last_week_export(tasks)
	# Get the date of the previous sunday and the monday before that
	last_sunday = DateTime.now - DateTime.now.wday
	last_monday = 6.days.before(last_sunday)
	last_sunday = last_sunday.to_date.to_s
	last_monday = last_monday.to_date.to_s
	export_bydate(tasks, last_monday, last_sunday)
end



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


options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: main.rb [options]"

	opts.on("-a", "--all", "Export all time") do |v|
		options[:all] = true
	end

	opts.on("-s", "--start [DATE]", "Export start date, requires end date as well") do |v|
		options[:start_date] = nil if v === true
		options[:start_date] = v unless v === true
	end

	opts.on("-e", "--end [DATE]", "Export end date, requires start date as well") do |v|
		options[:end_date] = nil if v === true
		options[:end_date] = v unless v === true
	end

	opts.on("-w", "--last-week", "Exports the previous week (Last sunday until monday before that)") do |v|
		options[:week] = true
	end

	opts.on_tail("-h", "--help", "Show this message") do
		puts opts
		exit
	end
end.parse!

def process_options(tasks, opts)
	puts opts

	unless opts[:start_date].nil? && opts[:end_date].nil?
		fail ArgumentError.new('Missing start or end date') if opts[:start_date].nil? || opts[:end_date].nil?
	end
	export_all(tasks) if opts[:all]
	last_week_export(tasks) if opts[:week]

	if opts[:start_date] && opts[:end_date]
		export_bydate(tasks, opts[:start_date], opts[:end_date])
	end
end

process_options(split_tasks, options)
