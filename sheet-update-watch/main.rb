require 'google_drive'
require 'pp'
require 'net/https'
require 'json'

config_file = File.read('config.json')
CONFIG = JSON.parse(config_file)
DATE_FIELD = 0
ACTIVITIES_FIELD = 3
PUSHOVER_URL = 'https://api.pushover.net/1/messages.json'
PUSHOVER_URI = URI.parse(PUSHOVER_URL)

def send_pushover_notification(title, content)
	req = Net::HTTP::Post.new(PUSHOVER_URI.path)
	req.set_form_data({
		:token => CONFIG['pushover_apikey'],
		:user => CONFIG['pushover_userkey'],
		:title => title,
		:message => content
	})
	res = Net::HTTP.new(PUSHOVER_URI.host, PUSHOVER_URI.port)
	res.use_ssl = true
	res.verify_mode = OpenSSL::SSL::VERIFY_PEER
	res.start {|http| http.request(req) }
end

session = GoogleDrive::Session.from_config('secrets.json')
ws = session.spreadsheet_by_key(CONFIG['sheet_id']).worksheets[0]
today_string = Time.now.strftime("%Y-%m-%d")
today = ws.rows.select do |row|
	row[DATE_FIELD] == today_string
end
today = today[0]

exit if today.nil?

if today[ACTIVITIES_FIELD].empty?
	send_pushover_notification('Daily log sheet check', "You didn't fill in what you did for #{today_string}")
end
