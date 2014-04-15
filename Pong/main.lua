local storyboard = require "storyboard";

-- incluimos una variable y el sqlite3
local db;
local sqlite3 = require "sqlite3"

-- conexiones sqlite para guardar puntuaciones del juego.
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path ) ;

--local tablefill =[[DELETE FROM datos;]];
--db:exec(tablefill);

--[[for row in db:nrows("SELECT * FROM datos") do
        print( row.id );
        print( row.username );
        print( row.puntos );
end]]--

sonido_app = audio.loadSound( "funnysong.mp3" );
audio.play( sonido_app );

storyboard.gotoScene( "cargando");