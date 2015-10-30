var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var hound = require('hound');
var fs = require('fs');
var needle = require('needle');


// URL to post markdown to
var GITHUB_MD_URL = 'https://api.github.com/markdown';


//Normalized args
var args = process.argv.slice(2);

//Check if we got passed exactly 1 file
if (args.length !== 1) {
	console.log('This script requires 1 file as an argument, exiting...');
	process.exit(1);
}

//Get the filename an check if it actually is a file
var filename = args[0];
if (!fs.lstatSync(filename).isFile()) {
	console.log(filename + ' does not appear to be a file, exiting...');
	process.exit(1);
}

//Setup a watcher for the passed file
var watcher = hound.watch(filename);

//Emit an updating event on change
watcher.on('change', function(file, stats) {
	update(file);
	io.emit('updating', file);
});

//Serve index.html
app.get('/', function(req, res) {
	res.sendFile(__dirname + '/index.html');
});

//Serve index.html
app.get('/gh-md-css.css', function(req, res) {
	res.sendFile(__dirname + '/gh-md-css.css');
});

//Start listening on post 8765
http.listen(8765, function() {
	console.log('Server started on port 8765');
});

//Update the file when a client connects
io.on('connection', function(socket) {
	update(filename);
});


//Handle a file update
function update(file) {
	//Read the file contents
	fs.readFile(file, 'utf8',function(err,data) {
		//Prepare the json POST object
		var post_data = { text: data, mode: 'gfm', context: '' };

		//Send a post request to github to transform to markdown
		needle.request('post', GITHUB_MD_URL, post_data, {json: true}, 
			function(err, resp) {
				if (err) {
					io.emit('update', JSON.stringify(err));
				} else {
					io.emit('update', resp.body);
				}
		});
	});
}
