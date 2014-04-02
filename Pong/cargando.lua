local widget = require("widget");
local storyboard = require "storyboard";
local myData = require "myData";
local scene = storyboard.newScene();

local progressView;
local contador = 0;

-- incluimos una variable y el sqlite3
local db;
require "sqlite3"

-- conexiones sqlite para guardar puntuaciones del juego.
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path ) ;

local function cargar()
	contador = contador + 0.2;
	progressView:setProgress( contador );

	if (contador == 1) then
		storyboard.gotoScene( "opciones_juego");
	end
end 

function scene:createScene( event )
    local group = self.view

    local fondo = display.newImageRect( "fondo.jpg", 480, 320 )
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

	-- creamos la tabla si no existe, despues recorremos la tabla para recuperar todas las puntuaciones. Despues lo añadimos al myData
	local tablesetup = [[CREATE TABLE IF NOT EXISTS puntuaciones (id INTEGER PRIMARY KEY, jugador, puntos, tiempo);]];
	print(tablesetup);
	db:exec( tablesetup );

	for row in db:nrows("SELECT * FROM puntuaciones") do
		print( "hola" )
		local tabla = {
            puntos = row.puntos; 
            jugador = row.jugador;
            tiempo = row.tiempo;
        };

        myData.partida[#myData.partida + 1] = tabla;
	end
end

function scene:enterScene( event )
    local group = self.view;

    -- quitar barra de estados
    display.setStatusBar( display.HiddenStatusBar );
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