# Markdown renderer

A simple node application that renders markdown on file updates.

This application will wacht a single file and render markdown using githubs
api, then update all connected browsers.

## Usage

Copy  the auth.example.json file to auth.json, and setup your credentials, this
is to get around rate limiting.

```
npm install
node index.js <filename>
```

Then connect to localhost:8765

