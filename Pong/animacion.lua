local storyboard = require "storyboard";
local scene = storyboard.newScene();
local myData = require "myData";

-- incluimos una variable y el sqlite3
local db;
local sqlite3 = require "sqlite3"

-- conexiones sqlite para guardar puntuaciones del juego.
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path ) ;

local CBE =	require( "CBEffects.Library" );
local vent = CBE.newVent {
	preset = "evil",
	positionType = "inRadius",
	xRadius = display.contentWidth, -- Instead of a circle, this time we'll make an ellipse
	yRadius = display.contentHeight, 
	colorIncr = 200,-- Simply provide xRadius and yRadius instead of just radius
	physics = {
		velocity = 0
	}
}

local txt_taptobegin;
local square;
local temporizador;
local aux = false;
local usuario;
local puntos;
local ganador;

_W = display.contentWidth; 
_H = display.contentHeight; 

function blink()
    if (aux == true) then
        if(txt_taptobegin.alpha < 1) then
            transition.to( txt_taptobegin, {time=490, alpha=1})
        else 
            transition.to( txt_taptobegin, {time=490, alpha=0.1})
        end 
    end
end

local function transicion( )
    if ( aux == true ) then
        transition.moveBy( square , { x= _W + 100, y=0, time=5000 } );
    else
        transition.cancel( square );
    end
end

local function pulsado(event)
    if ( event.phase == "began" ) then
        
    elseif ( event.phase == "ended" ) then
        vent:stop();
        timer.cancel(temporizador);
        Runtime:removeEventListener( "touch", pulsado );
        aux = false;

       storyboard.gotoScene( "puntuaciones");
    end
end 

function scene:createScene( event )
    local group = self.view

    aux = true;
    
    txt_taptobegin = display.newText("Ganador!!!", 100, 100, "Arial", 38)
    txt_taptobegin.x = _W/2
    txt_taptobegin.y = _H/4
    group:insert(txt_taptobegin);

    display.setStatusBar( display.HiddenStatusBar );

    usuario = myData.name;
    puntos = myData.points;

    for i = 1, #myData.partida do
           if (i ~= 1) then
                usuario = myData.partida[i].username;
                puntos = myData.partida[i].puntos;
           end
       end

    local txtNombre = display.newText(usuario.." "..puntos.." puntos", 100, 100, "Arial", 24);
    txtNombre.x = _W/2
    txtNombre.y = _H/2 + _H/8
    group:insert(txtNombre);

	display.setDefault( "background", 0.1, 0, 0 );
	timer.performWithDelay(100, transicion, 1);

    square = display.newText("Pulse sobre el fondo", 0, _H -10, "Arial", 10);
    group:insert(square);

    Runtime:addEventListener( "touch", pulsado );

    ganador = audio.loadSound( "ganador.mp3" );
end

function scene:enterScene( event )
    local group = self.view;
    vent:start();
    txt_blink = timer.performWithDelay(500, blink, 0);
    temporizador = timer.performWithDelay(5100, transicion, 0);

    audio.play( ganador );
end

function scene:exitScene( event )
    local group = self.view;
    audio.stop();
end

function scene:destroyScene( event )
    local group = self.view;
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;