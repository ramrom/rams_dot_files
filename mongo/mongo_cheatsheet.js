//load external file
load('external_file.js')

//console clear
cls

// keys of object
Object.keys({"a":1,"b":2})  // will return ["a","b"]
Object.keys({"a":1,"b":2}).length  // will return 2
myobj={"a":1,"b":2}
Object.keys(myobj).forEach(function(key){print(myobj[key])})  // how to iterate over all keys in object
javascript iterating over array: usage: https://stackoverflow.com/questions/3010840/loop-through-an-array-in-javascript

//local variables, here a is local, b is global
function foo() { var a = 3; b = 4; }

//print type
a = {"1": 3}
print(typeof(a))  //should print 'object' to screen

//print array of collection names
print(db.getCollectionNames())  // flat/compact
printjson(db.getCollectionNames())  //pp newlined

print(JSON.stringify(a)) // compact and not so readable
print(JSON.stringify(a, null, 4)) // indented 4 spaces and newlined, more readable
print(tojson(a))
printjson(a)  // same as above, indented 2 spaces, colorized, printjson(x) = print(tojson(x))

//print result to console for singular result i think...
r = db.eligiblityRecord.find({rallyId:"95ebbaf6-d55a-4eac-85f7-24fb8dc63fd3"})
print(r)

//print result to console for multiple results of find() i think...
db.partner.find().forEach(function(r) { print(JSON.stringify(r)) })
db.partner.find().forEach(printjson) // pretty prints with 6? space indent

//console pretty print
db.FooCollection.find().pretty()
DBQuery.prototype._prettyShell = true // make pretty() it default

// ********** QUERYING *****************
it  // to get more results if we hit the shellbatchsize limit of find
db.fooCollection.find({"field":"exactValue"})
db.fooCollection.find({field:"exactValue"})

db.fooCollection.find({field: { embedfield: "value", embedfield2: "value2" }})  // query where field has exact doc value
db.fooCollection.find({"field.embedfield": "value"})  // query on embedded field value

db.fooCollection.find({ field: { $in: ["exactVal1","exactVal2"] } })
db.fooCollection.find({ $or: [ "intField": { $lt: 10 }, "strField": { $gt: 3 } ] })
db.fooCollection.find({ intField: { $lt: 10 }, strField: { $or: [ { $gt: 3 }, { $in: ["a","b"] } ] } }) // ands are implicit

//2nd arg to find() specifies result fields to return
db.fooCollection.find({field1:"exactValue"},{field2:1}) //get only field2 and id
db.fooCollection.find({field1:"exactValue"}, {field2:1,_id:0}) //supress id field
db.fooCollection.find({field1:"exactValue"}, {field2:0}) // return all fields except field2
db.fooCollection.find({field1:"exactValue"},{field3:1, "field2.embeddedfield4":1}) // get field3 and emmbedded field4 in field

db.fooCollection.find( { item: null } ) // find docs where item field equals `null` value OR doc doesnt have field named item
db.fooCollection.find( { item: { $exists: false } } ) // find docs which dont have field named item

// MONGO HACKER QUERY
db.partner.find().sort({shortName:1}).reverse().limit(3).select({fullName:1,dude:1}).ugly()
count collections   // pretty summaries
count docs          // pretty summaries
db.fooCollection.find().ugly()  // no query newlines and indenting


//default max size is 20, can change this
DBQuery.shellBatchSize = 100



// SH/ELIG queries
db.ssoVendorConfig.find().select({_id:0,vendorId:1,ssoPartnerName:1,ssoType:1}).ugly()
