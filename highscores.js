function dbInit()
{
    var db = LocalStorage.openDatabaseSync("Highscores", "", "Results table", 1000000)
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS hgsc(name text,score numeric)')
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle()
{
    try {
        var db = LocalStorage.openDatabaseSync("Highscores", "",
                                               "Results table", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}

function dbInsert(PName, PScore)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO hgsc VALUES(?, ?)',
                      [PName, PScore])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    return rowid;
}

function dbReadAll(listModel)
{
    var db = dbGetHandle()
    db.transaction(function (tx) {
        var results = tx.executeSql(
                    'SELECT rowid,name,score FROM hgsc order by score asc')
        for (var i = 0; i < results.rows.length; i++) {
            listModel.append({
                                 id: results.rows.item(i).rowid,
                                 checked: " ",
                                 name: results.rows.item(i).name,
                                 score: results.rows.item(i).score
                             })
        }
    })
}

function dbUpdate(PName, PScore, Prowid)
{
    var db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql(
                    'update hgsc set name=?, score=?, where rowid = ?', [PName, PScore, Prowid])
    })
}
