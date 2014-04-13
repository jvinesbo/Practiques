local storyboard = require "storyboard";
local scene = storyboard.newScene();

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
        transition.moveBy( display.newText("Pulse sobre el fondo", 0, _H -10, "Arial", 10), { x= _W + 100, y=0, time=5000 } );
    end
end

local function pulsado(event)
    if ( event.phase == "began" ) then
        
    elseif ( event.phase == "ended" ) then
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

    local txtNombre = display.newText(" ", 100, 100, "Arial", 24);
    txtNombre.x = _W/2
    txtNombre.y = _H/2 + _H/8
    group:insert(txtNombre);

	display.setDefault( "background", 0.1, 0, 0 );
	timer.performWithDelay(100, transicion, 1);

    square = display.newText("", 0, _H -10, "Arial", 10)
    group:insert(square);

    Runtime:addEventListener( "touch", pulsado );
end

function scene:enterScene( event )
    local group = self.view;
    vent:start();
    txt_blink = timer.performWithDelay(500, blink, 0);
    temporizador = timer.performWithDelay(5100, transicion, 0);
end

function scene:exitScene( event )
    local group = self.view;
    vent:stop();
    transition.cancel();
    timer.cancel(temporizador);
    aux = false;
end

function scene:destroyScene( event )
    local group = self.view;
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;