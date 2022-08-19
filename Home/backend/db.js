var sql = require('mssql');
var config = {
    user: 'sa',
    password: 'dominiotech',
    server: 'JULIAN-DMT',
    options: {
        database: 'Pruebas_Julian'
    }
};

// var connection = new sql.Connection(config);
// connection.connect(function(err) {
//     if (err) throw err;
// });
// var req = new sql.Request(connection);
module.exports = config;

//  function getDoc(){

//     var req = new sql.Request(conn);

//     conn.connect(function(err){
//         if (err) {
//             console.log(err);
//             return;
//         }
//         console.log("entro");
//         req.query("select * from doc",function(err,recordset) {
//             if(err){
//                 console.log(err);
//             }else{
//                 console.log(recordset);
//             }
//         });


//     });

// }
// getDoc();
