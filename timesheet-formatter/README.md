## Formatter for the timesheet android app

### Setup

Clone the repo

cd into timesheet-formatter

(Optional) Copy `mail.example.json` to `mail.json` and configure where you want your mails sent.


```
bundle install
```

To run:

```
bundle exec ruby main.rb
```

### Usage

```
Usage: main.rb [options]
    -a, --all                        Export all time
    -s, --start [DATE]               Export start date, requires end date as well
    -e, --end [DATE]                 Export end date, requires start date as well
    -w, --last-week                  Exports the previous week (Last sunday until monday before that)
    -f, --file [FILE]                The filename to read
    -d, --drive [SEARCH]             The drive filename part to search for
    -m, --mail                       Whether to send an email
    -h, --help                       Show this message

```
Exports will be written to `${cwd}/out`

### Cron

To run this script in a cronjob add something like the following to crontab:

```
 0 6 * * 1 /bin/bash -l -c 'cd <timesheet-formatter dir> && ./run.sh'
```

This will run the timesheet formatter every monday at 6am and send an email with the output



