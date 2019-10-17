host = db.serverStatus().host;
prompt = function() { return db+"@"+host+"$ "; }

// function sc() { printjson(db.getCollectionNames()); }
Object.defineProperty(this, "sc", { get: function() { printjson(db.getCollectionNames()) }, configurable: true })

//function sd() { printjson(db.adminCommand({ listDatabases: 1 })) }  //NOTE: cant define foo prop on Object and func foo()
Object.defineProperty(this, "sd", { get: function() { printjson(db.adminCommand({ listDatabases: 1 })) }, configurable: true })

Object.defineProperty(this, "sdh", { get: function() { printjson(db.getMongo().getDatabaseNames()) }, configurable: true }) // mongohacker way

function ldrallytools() { load('/Users/sreeram.mittapalli/code/rally_ram_dot_files/db_queries/mongo_rally_tools.js'); }
function ldramtools() { load('/Users/sreeram.mittapalli/rams_dot_files/mongo/mongo_ram_tools.js'); }

// http://tylerbrock.github.com/mongo-hacker
function ldmongohacker() {
    if (typeof(mongo_hacker_config) == "object") {  // loading the js multiple times definitely will screw things up
        print("!! mongo_hacker_config object defined, mongo hacker already loaded!!")
    } else {
        load('/Users/sreeram.mittapalli/rams_dot_files/mongo/mongo_hacker.js');
    }
}

ldramtools()
ldrallytools()
ldmongohacker()
