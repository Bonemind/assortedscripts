# Time by msec by default
# This denotes ticks per second
tps = 1000

if ARGV[0] == '-h'
	puts 'sw.rb [INTERVAL_AS_FLOAT]'
	puts '10 sec: sw.rb 0.1'
	puts '1 msec: sw.rb 1000'
	exit()
end

# Rudimentary read from args
tps = ARGV[0].to_f unless ARGV[0].nil?

# Count seconds and milliseconds
s = 0
ms = 0
def printtime(s, ms)
	print "\r"
	print "#{s}.#{ms}"
end

# Loop while not killed
# print on every loop
while true do
	ms = ms + 1
	if ms >= tps
		s = s + (ms / tps).floor
		ms = 0
	end
	printtime(s, ms)
	sleep(1.0 / tps)
end
