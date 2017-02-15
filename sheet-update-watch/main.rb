require 'google_drive'
require 'pp'
require 'ruby-notify-my-android'
require 'json'

config_file = File.read('config.json')
config = JSON.parse(config_file)
DATE_FIELD = 0
ACTIVITIES_FIELD = 3


session = GoogleDrive::Session.from_config('secrets.json')
ws = session.spreadsheet_by_key(config['sheet_id']).worksheets[0]
today_string = Time.now.strftime("%Y-%m-%d")
today = ws.rows.select do |row|
	row[DATE_FIELD] == today_string
end
today = today[0]

exit if today.nil?

if today[ACTIVITIES_FIELD].empty?
	NMA.notify do |n|
		n.apikey = config['nma_apikey']
		n.priority = NMA::Priority::MODERATE
		n.application = 'DailySheetCheck'
		n.event = 'Daily log sheet check'
		n.description = "You didn't fill in what you did for " + today_string
	end
end
