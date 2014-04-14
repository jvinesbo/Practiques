var express = require("express");
var app = express();
app.use(express.bodyParser());
var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/pingpong');
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));

var puntosSchema = mongoose.Schema({
    username: String,
    email: String,
    puntos: String,
    fecha: String,
    dispositivo: String
});

var Puntos = mongoose.model('puntuaciones', puntosSchema);

var texto = "";

app.get("/", function(rec , res){
	res.type("text/plain");
	res.send("Hola");
});
	
app.get("/extraer", function(rec , res){
        res.type("text/plain");

	
	Puntos.find(function (err, points) {
  		if (err) return console.error(err);
			res.send(points);  
 	});
});
	
app.post("/insertar", function(rec , res){
	res.type("text/plain");
	
	var silence = new Puntos({ username: rec.body.username, email: rec.body.email, puntos: rec.body.puntos, fecha: rec.body.fecha, dispositivo: rec.body.dispositivo });
	silence.save();

	res.send(silence._id);
});

app.listen(process.env.PORT || 8000);

