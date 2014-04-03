--Include sqlite
require "sqlite3"
--Open data.db.  If the file doesn't exist it will be created
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path )   
 
--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end
 
local tablesetup = [[CREATE TABLE IF NOT EXISTS puntuaciones (id INTEGER PRIMARY KEY, jugador, puntos, tiempo);]];
print(tablesetup);
local  aux = db:exec( tablesetup );
print( aux )
local tablefill =[[INSERT INTO puntuaciones VALUES (NULL, ']].."Juan"..[[',']].."15"..[[',']].."00:05"..[['); ]]
local tablefill2 =[[INSERT INTO puntuaciones VALUES (NULL, ']].."Pepe"..[[',']].."15"..[[',']].."00:05"..[['); ]]
local tablefill3 =[[INSERT INTO puntuaciones VALUES (NULL, ']].."Rodrigo"..[[',']].."15"..[[',']].."00:05"..[['); ]]
db:exec( tablefill )
db:exec( tablefill2 )
db:exec( tablefill3 )

print( tablefill )
 
--print the sqlite version to the terminal
print( "version " .. sqlite3.version() )
 
--print all the table contents
for row in db:nrows("SELECT * FROM puntuaciones") do
  local text = row.jugador.." "..row.puntos.." "..row.tiempo
  local t = display.newText(text, 50, 120 + (20 * row.id), native.systemFont, 16)
  t:setFillColor(255,0,255)
end
 
--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )