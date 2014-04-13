DB = {}

local db;
local sqlite3 = require "sqlite3"

-- conexiones sqlite para guardar puntuaciones del juego.
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path ) ;

function DB:insertar( ids,  username,  email,  puntos, fecha, dispositivo)
    local tablefill =[[INSERT INTO datos VALUES (NULL, ']].. ids ..[[',']].. username ..[[',']].. email .. [[',']].. puntos ..[[',']].. fecha ..[[',']].. dispositivo..[['); ]];
    db:exec(tablefill);
end

return DB;