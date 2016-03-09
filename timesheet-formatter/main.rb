require 'nokogiri'
require 'pry'
require './nokogiri_to_hash'
require 'pp'

doc = File.open("hours.xml") { |f| Nokogiri::XML(f) }
projects = Hash.xml_node_to_hash(doc.xpath('//projects').first)[:project]
tasks = Hash.xml_node_to_hash(doc.xpath('//tasks').first)[:task]
breaks = Hash.xml_node_to_hash(doc.xpath('//breaks').first)[:break]
tags = Hash.xml_node_to_hash(doc.xpath('//tags').first)[:tag]
tasktags = Hash.xml_node_to_hash(doc.xpath('//taskTags').first)[:taskTag]

tasks.each do |task|
	task[:project] = projects.find{|hash| hash[:projectId] == task[:projectId]}
	task[:breaks] = breaks.select{|hash| hash[:taskId] == task[:taskId]}
	taskTags = tasktags.select{|hash| hash[:taskId] == task[:taskId]}

	task[:tags] = []
	taskTags.each do |tt|
		tag = tags.find{|hash| tt[:tagId] == hash[:tagId]}
		task[:tags] << tag unless tag.nil?
	end
end


binding.pry
