host = db.serverStatus().host;
prompt = function() { return db+"@"+host+"$ "; }

function ldtools() { load('/Users/sreeram.mittapalli/code/rally_ram_dot_files/db_queries/mongo_tools.js'); }
Object.defineProperty(this, "rt", {
    get: function() { load('/Users/sreeram.mittapalli/code/rally_ram_dot_files/db_queries/mongo_tmp.js'); },
});

// http://tylerbrock.github.com/mongo-hacker
function ldmongohacker() {
    if (typeof(mongo_hacker_config) == "object") {  // loading the js multiple times definitely will screw things up
        print("!! mongo_hacker_config object defined, mongo hacker already loaded!!")
    } else {
        load('/Users/sreeram.mittapalli/rams_dot_files/mongo/mongo_hacker.js');
    }
}

ldtools()
ldmongohacker()

// see https://github.com/xavierguihot/mongorc
print("Aliases - Helpers:");
print(" * tree: prints all databases and collections");
print(" * indexes: prints all databases, collections and indexes");
print(" * cleanCache(): drops cache collections");


/** Prints a pretty tree of the database/collection structure */
Object.defineProperty(this, "tree", {
    get: function() { return _walk_through_dbs_and_collections(db, false) },
});

/** Prints a pretty tree of the database/collection/index structure */
Object.defineProperty(this, "indexes", {
    get: function() { return _walk_through_dbs_and_collections(db, true) },
});

/** Common implementation for tree and indexes aliases.
 *
 * @param {object} db
 * @param {boolean} displayIndexes if indexes are printed in the returned tree
 * @returns {string} the pretty print of the database tree
 */
function _walk_through_dbs_and_collections(db, displayIndexes) {

    // The database tree we'll progressively build and which is finally returned
    // to be printed in the console:
    var prettyTree = "";

    // The list of databases:
    var databaseList = db.adminCommand({ listDatabases: 1 })["databases"];

    // We walk through databases:
    databaseList.forEach( function(database) {

        // Let's enter the database:
        db = db.getSiblingDB(database["name"]);

        // We gather data for the current database:
        var dbSizeOnDisk = (database["sizeOnDisk"] / (1024*1024*1024)).toFixed(3) + "GB";
        var dbStats = db.runCommand({ dbStats: 1, scale: 1024*1024*1024 });
	    var dataSize = (dbStats["dataSize"]).toFixed(3) + "GB";
	    var indexSize = (dbStats["indexSize"]).toFixed(3) + "GB";
	    var nbrOfDocuments = dbStats["objects"].toString();

	    prettyTree += (
	    	" * " + dbSizeOnDisk + "-" + dataSize + "-" + indexSize +
	    	" (" + nbrOfDocuments + ")              " + database["name"] + "\r\n"
	    );

	    // The list of collections in the current database:
	    var collections = db.runCommand("listCollections")["cursor"]["firstBatch"];

	    collections.forEach( function(collection) {
	    	if (collection["name"] != "system.indexes") {

			    // The nbr of documents this collection contains:
			    var count = db.runCommand({ count: collection["name"] })["n"];

			    prettyTree += "	* " + collection["name"] + " (" + count.toString() + ")\r\n";

			    if (displayIndexes) {

					var indexes = db.runCommand({
					    collStats: collection["name"], scale: 1024 * 1024
					})["indexSizes"];

					var pretty_indexes = ""

					for (var index in indexes)
						if (index != "_id_")
							pretty_indexes += index.toString() + " - ";

					if (pretty_indexes != "")
						prettyTree += "		* " + pretty_indexes + "\r\n";
				}
			}
		});
	});

	// And we return for printing the pretty tree:
	return prettyTree.substring(0, prettyTree.length - 1);
}


/** Drop any collections (from all databases) which contain "_cache" in its name */
function cleanCache() {

	// Since we need to walk through all databases during this process, we need
	// to store the current working database in order to get back to this
	// database once the result is returned:
	var currentDB = db;

	// The list of databases:
	var databaseList = db.adminCommand({ listDatabases: 1 })["databases"];

	// We walk through databases:
	databaseList.forEach( function(database) {

		// Let's enter the database:
		db = db.getSiblingDB(database["name"]);

		// The list of collections in the current database:
		var collections = db.runCommand("listCollections")["cursor"]["firstBatch"];

		for (var j = 0; j < collections.length; j++) {

			// If the collection contains "_cache" in its name, we drop it:
			if (collections[j]["name"].indexOf("_cache") >= 0) {
				print(collections[j]["name"]);
				db.runCommand({ drop: collections[j]["name"] })
			}
		}
	});

	// And we go back to the initial working database:
	db = db.getSiblingDB(currentDB);
}
