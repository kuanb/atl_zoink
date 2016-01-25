	var express = require("express");
	var app = express();

	// set the view engine to ejs
	app.set('view engine', 'ejs');
	app.use(express.static(__dirname + './views'));
	app.use(express.static(__dirname + './static'));
	app.use(express.static(__dirname + './bower_components'));

	// favicon
	var favicon = require('serve-favicon');
	app.use(favicon(__dirname + '/static/favicon.ico'));

	var port = process.env.PORT || 8080; 


	// this will let us get the data from a POST
	var bodyParser = require("body-parser");
	app.use(bodyParser.json());
	app.use(bodyParser.urlencoded({ extended: true }));

	// bcrypt setup
	var uuid = require('node-uuid');

	var emailUser = require('./utils/emailError.js').emailUser;
	var emailUserPW = function (text, send_to, cb) {
		emailUser(credentials, text, send_to, cb);
	};

	// attach to MySQL db and start server
	var fs = require("fs");
	var credentials, mysql, pool, sqlite3, usersDB;
	fs.readFile("credentials.json", "utf8", function (err, data) {
		if (err) throw err;
		credentials = JSON.parse(data);

		mysql = require("mysql");
		pool = mysql.createPool({
			connectionLimit: 100, //important
			host: credentials.host,
			user: credentials.user,
			password: credentials.password,
			database: credentials.database,
			debug: false
		});

		pool.getConnection(function (err, connection) {
			try { connection.release(); } catch (e) { console.log("Error on connection release: ", e) }
			if (err && false) {
				console.log("Connection to MySQL server failed.");
			} else {

				// now attach to local sqlite3 user accounts
				sqlite3 = require('sqlite3').verbose();
				usersDB = new sqlite3.Database('database/users.db');
				usersDB.run("CREATE TABLE if not exists users (email TEXT, password TEXT, token TEXT, organization TEXT, last_req TEXT);", function () {
					var q = "PRAGMA table_info(users)";
					usersDB.all(q, function (err, res) {
						if (err) {
							console.log("Server failed to start, SQLITE3 database errors occurred.");
						} else {
							var schemaBad = false;
							res.map(function (ea) { return {type: ea.type, name: ea.name }; });
							res.forEach(function (ea) { if (ea.type !== "TEXT") { schemaBad = true; } });

							var reference = ["email", "xp", "token", "organization", "last_req"];
							res.forEach(function (ea, i) { if (reference[i] !== ea.name) { schemaBad = true; } });

							// designed to only handle old pw col name issue
							if (schemaBad) {
								usersDB.serialize(function() {
								  usersDB.run("ALTER TABLE users RENAME TO users_temp;");
								  usersDB.run("CREATE TABLE users (email TEXT, xp TEXT, token TEXT, organization TEXT, last_req TEXT);");
							    usersDB.run("INSERT INTO users(email, xp, token, organization, last_req) SELECT email, password, token, organization, last_req FROM users_temp;");
							    usersDB.run("DROP TABLE users_temp;", function () { startServer(); });
								});
							} else {
								startServer();
							}
						}
					});
				});
			}
		});
	});


	// pool manager for mysql connections
	function handle_database (query, cb) {console.log(query);
		pool.getConnection(function (err, connection) {
			if (err) {
				connection.release();
				cb({"code" : 100, "status" : "Error in connection database"});
			} else {
				connection.query(query, function (err, rows) {
					connection.release();
					cb(err, rows);
				});

				// error handling on streamed response
				connection.on("error", function (err) {      
					cb({"code" : 100, "status" : "Error in connection database"});
				});
			}
		});
	};


	app.get("/developer", function(req, res) {
		res.status(200).render("developer_login");
	});


	// start server
	function startServer () {
		app.listen(port);
		console.log("bus-data-api now running on port " + port);	
	};