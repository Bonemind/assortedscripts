## Formatter for the timesheet android app

### Setup

Clone the repo

cd into sheet-update-watcher

Copy config.json.example to config.json

'nma_apikey' is the api key for notifymyandroid

'sheet_id' is the google-sheets identification number

Copy secrets.json.example to secrets.json

Follow setup at [On behalf of you](https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md)

Run docker build

Setup cronjob or something to trigger check

Expects sheet to be the following

date(Y-m-d) | irrelevant | irrelevant | Field to fill in

