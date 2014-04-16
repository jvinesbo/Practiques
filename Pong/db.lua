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

function DB:actualizar( ids, id)
    local tablefill =[[UPDATE datos SET ids = ]] .. ids .. [[ WHERE id = ]] .. id .. [[;]];
    db:exec(tablefill);
end

function DB:seleccionar(puntos)
	local booleano = true;
	for row in db:nrows("SELECT * FROM datos WHERE puntos =" .. puntos .. " LIMIT 1") do
        booleano = false;
    end
    return booleano;
end
return DB;