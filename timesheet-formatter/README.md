## Formatter for the timesheet android app

### Setup

clone the repo
cd into timesheet-formatter

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
    -h, --help                       Show this message
```
Exports will be written to `${pwd}/out`



