local storyboard = require "storyboard";
local scene = storyboard.newScene();

local hierba = display.newImageRect( "hierba.jpg", 320, 480 )
hierba.x = 160
hierba.y = 240

local fisica = require( "physics" )
fisica.start();
--physics.setGravity(0, 9.8);
fisica.setDrawMode("hybrid");

local tamanyo_width = display.actualContentWidth ;
local tamanyo_height = display.actualContentHeight;

local paletaSuperior = display.newRect( tamanyo_width / 2, 0, 60, 10);
paletaSuperior:setFillColor( 1, 0.4, 0.1, 0.7 );
fisica.addBody(paletaSuperior, "kinematic", {friction=0.5, density = 9.0});

local paletaInferior = display.newRect( tamanyo_width / 2, 480, 60, 10);
paletaInferior:setFillColor( 1, 0.4, 0.1, 0.7 );
fisica.addBody(paletaInferior, "kinematic", {friction=0.5, density = 9.0});
paletaInferior.name = "paletaInferior";

local lineaCentral = display.newRect( 0, 240, tamanyo_width * 2, 5);
lineaCentral:setFillColor( 255,255,255 );

local pelota = display.newCircle( tamanyo_width / 2, 15, 10 );
pelota:setFillColor( 0,0,0 );
fisica.addBody(pelota, "dynamic", {friction=0.5, bounce=1, density = 9.0, radius = 10});
pelota:setLinearVelocity( 0, 10 );

local paredIzq = display.newRect(0, 0, 1, display.contentHeight + 500);
local paredDer = display.newRect(tamanyo_width, 0, 1, tamanyo_height * 2);

fisica.addBody(paredIzq, "static", {friction = 1.0});
fisica.addBody(paredDer, "static", {friction = 1.0});

local function movimiento( event )
    if event.phase == "began" then
        event.target.x = event.x -- store x location of object
        --event.target.y = event.y -- store y location of object
    elseif event.phase == "moved" then
        local x = (event.x - event.xStart) 
        --local y = (event.y - event.yStart) + event.target.y

    	if (x < 0) then
    		event.target.x = 30;
    	elseif (x >= tamanyo_width - 30) then
	    		event.target.x = tamanyo_width - 30;
	    	else 
	    		event.target.x = x

    		event.target.x = x
    	end
    end

    return true
end

paletaInferior:addEventListener( "touch", movimiento );
paletaSuperior:addEventListener( "touch", movimiento );

local function comprobacion()
    if (pelota.y >= tamanyo_height or pelota.y <= 0) then
        storyboard.removeScene( scene );
        storyboard.gotoScene( "puntuaciones");
    end
end

timer.performWithDelay(300, comprobacion, 0)

return scene