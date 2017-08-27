---
layout: single
title: Let's write our first "Hello MongoDB" with NodeJS
date: '2012-04-01 20:57:55'
tags:
- javascript
- mongodb
- nodejs
---

As you have seen recently, i'm not writing so much here, because i'm working on new technologies like [NodeJS](http://nodejs.org/ "NodeJS") and [MongoDB](http://www.mongodb.org/ "MongoDB"). Fascinated by this next-gen "AMP", i'm trying to write my first scripts trying to make such a basic job: get some data from somewhere, save them into the DB then next, and finally, get all the items that are in our "table" (i'll explain you later why i'm writing it like this).

First of all, i have to explain you something before we can start. MongoDB, as you may know, is a next generation NO-SQL in-mind to store data in it. But, just like SQL Databases, they do not use "tables" as we do not have to declare table columns or something like that. We have **collections** defined by **models**. Something like virtual "tables" where:

*   Collection = list of "tables"
*   Models =  column of the tables (with flexible data type: integers, strings, arrays or objects)

So, when you'll catch this knowledge, you'll be ready to start this simple tutorial. What we will need to accomplish this are:

*   [NWM](http://nwm.julianxhokaxhiu.com/ "NWM") (made by me, a simple "WAMP-like", ready-to-use with NodeJS and MongoDB)
*   [MongoVue](http://www.mongovue.com/ "MongoVUE") (to inspect the database, just like PhpMyAdmin, feel free to use the one you prefer, optional)
*   MongoDB instance running (run your "start MongoDB" script inside NWM, usually located at Start -> All Programs -> NWM -> Start MongoDB).

Obviously, i'm not going to explain how to install them, basically you have to download them, install and you're done. For MongoDB will be used the "test" database, automatically created for default setups.

## Prepare our database

Open your Command Prompt (until now, it will be called CMD) and write these command

```sh
mongo [Enter]
use test [Enter]
> db.addUser("test","test"); [Enter]
exit [Enter]
```

what we have done here, was adding a user for the connection (actually not really required, as we're in a testing environment) and initializing the database.

## Install "mongoose" for NodeJS

Just like PHP, also NodeJS (let's think about it, like an Apache+PHP) does not have a native library to connect to MongoDB, so we have to install it by ourself. So open your CMD and type this command

```sh
npm install mongoose
```

and wait until it finishes.

## Run our script

Yes, it's not just like Apache that you have a "www" directory where you put your scripts and then point to your "localhost" and you can see them. In NodeJS you have to run your script by typing this in your CMD

```sh
node your_script.js
```

So what what we have to do now is copying this script

```javascript
/*
Author: Julian Xhokaxhiu
Version: Do you really think it is necessary?
Description: This is a simple "Hello MongoDB" to set and get data, to/from database.
*/
/*
@http: Our HTTP library so we can output a response to the browser
*/
var http = require('http');
/*
@mongoose: Our DB library, so we can get/set our data from/to database
*/
var mongoose = require('mongoose');
/*
@Schema: basic schema to store data into the database.
@Mixed: object datatype to store our simple object in the database
*/
var Schema = mongoose.Schema, Mixed = Schema.Types.Mixed;
/*
@RequestObject: this will be our "template" to store the data into our collection
*/
var RequestObject = new Schema({
id: Number, //int
req: Mixed //object
});
// let's connect to the database...
mongoose.connect('mongodb://localhost/test');
// tell mongoose that this is our template so we can request it later
mongoose.model('RequestObject',RequestObject);
// @i: simple counter
var i = 0;
// create our server listener @ "http://localhost:80"
http.createServer(function(req,res){
// tell the browser that this we will output JSON
res.writeHead(200,{'Content-Type':'application/json'});
// get the template so we can build an object to store, or retrive data later
var ro = mongoose.model('RequestObject');
// create an object store
var tmp = new ro();
// setting values into it...
tmp.id = i;
tmp.req = {
'headers':req.headers,
'httpVersion':req.httpVersion,
'method':req.method,
'trailers':req.trailers,
'url':req.url
};
// ...and saving into the database
tmp.save(function(err){
// if something bad happens, tell the error
if(err)res.write('{"Save Error":"'+err.err+'"}');
});
ro.find({},function(err,objs){
// if something bad happens, tell the error
if(err)res.write('{"Find Error":"'+err.err+'"}');
else{
// Get our data from the collection store
res.write(JSON.stringify(objs));
// Finally, close the HTTP response, we're done.
res.end();
}
});
// increase our simple counter...
i++;
}).listen(80,'127.0.0.1');
// Just tell the console that we're running at this address, purely informative
console.log('Server running at http://127.0.0.1:80/');
```

and save it to our preferred location (the Desktop will be fine) and call it "_test.js_". Then finally, to test it, just type

```sh
cd Desktop
node test.js
```

and point your browser at [http://localhost/](http://localhost/) so you can view your data.

## Congratulations!

You made it! You're runnig the "Hello MongoDB" script and you're pushing data into the database. After this, you're getting ALL the data inside the database.

So, what will MongoVUE will be need for? Well, if you're curious to know how the data is inside (let's think about PHPMyAdmin ) and you want to view/edit/delete data into, you can do that. I'm NOT going to explain how to use it, think about this as a reference. You can find more Admin UIs for MongoDB at [http://www.mongodb.org/display/DOCS/Admin+UIs](http://www.mongodb.org/display/DOCS/Admin+UIs)

Comment below if you find any mistake or you have any suggestion regarding this article.
So, thanks for reading, i hope you'll enjoy this.