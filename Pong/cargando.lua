local widget = require("widget");
local storyboard = require "storyboard";
local scene = storyboard.newScene();
require( "conexion" );

local progressView;
local contador = 0;

-- incluimos una variable y el sqlite3
local db;
local sqlite3 = require "sqlite3"

-- conexiones sqlite para guardar puntuaciones del juego.
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path ) ;

local function cargar()
	contador = contador + 0.2;
	progressView:setProgress( contador );

	if (contador == 1) then
			-- creamos la tabla si no existe, despues recorremos la tabla para recuperar todas las puntuaciones. Despues lo añadimos al myData
		--local tablesetup = [[DROP TABLE puntuaciones;]];
		local tablesetup = [[CREATE TABLE IF NOT EXISTS datos (id INTEGER PRIMARY KEY, ids VARCHAR(100), username VARCHAR(100), email VARCHAR(100), puntos VARCHAR(100), fecha VARCHAR(100), dispositivo VARCHAR(100));]];
		local  aux =  db:exec( tablesetup );

		for row in db:nrows("SELECT * FROM datos") do
			print( row.ids );
		end

		storyboard.gotoScene( "opciones_juego");	
	end
end 

function scene:createScene( event )
    local group = self.view

    -- quitar barra de estados
    display.setStatusBar( display.HiddenStatusBar );

  	display.setDefault( "background", 1, 1, 1 );

    local fondo = display.newImageRect( "fondo.png", 480, 320 )
	fondo.x = 240
	fondo.y = 160

	group:insert(fondo);

	progressView = widget.newProgressView{
	    left = 10,
	    top = display.contentHeight - 20,
	    width = display.contentWidth - 20,
	    isAnimated = true
	}
	
	group:insert(progressView);

	local cargando = display.newText( "Cargando...", display.contentWidth / 2, display.contentHeight - 30, native.systemFontBold, 16 )
	cargando:setFillColor( 0, 0, 0 );
	group:insert(cargando);

	local timer = timer.performWithDelay(1000, cargar, 5);

	-- hacemos llamada a método GET de la clase conexion para recuperar toda la información de la base de datos.
	Conexion:get("David", "vinyes@hotmail.es", "100");

end

function scene:enterScene( event )
    local group = self.view;

end

function scene:exitScene( event )
    local group = self.view

    -- cerramos la conexión de la base de datos sqlite
    db:close();
end

function scene:destroyScene( event )
    local group = self.view
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;