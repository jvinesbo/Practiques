local storyboard = require "storyboard";
local scene = storyboard.newScene();
storyboard.purgeOnSceneChange = true
system.activate("multitouch");

local fisica = require( "physics" )
fisica.start();
physics.setGravity(0, 0);
--fisica.setDrawMode("hybrid");

local tamanyo_width = display.actualContentWidth ;
local tamanyo_height = display.actualContentHeight;
local pelota;
local timer1;
local sonido_pelota;
local sonido_pared;
local contador = 0;
local txt_crono;
local number = 0;
local minutos = 0;

local function movimiento( event )
    if event.phase == "began" then
        event.target.x = event.x -- store x location of object
        --event.target.y = event.y -- store y location of object
    elseif event.phase == "moved" then
        local x = (event.x - event.xStart);
        --local y = (event.y - event.yStart) + event.target.y
        local aux = 0;

        if (x == 30 or x < 30) then
            aux = 30;
        else
            aux = x;
        end

        if (x >= tamanyo_width - 30) then
            aux = tamanyo_width - 30;
        end

        event.target.x = aux;
    end

    return true
end

local function comprobacion()
    if (pelota.y >= tamanyo_height or pelota.y <= 0) then
        storyboard.gotoScene( "puntuaciones");
        timer.cancel(timer1);
        timer.cancel(cronometro);
    end
end

local function cronometro()
    number = number + 1;
    if (number == 60) then
        number = 0;
        minutos = minutos + 1;
    end

    if (number < 10 and minutos == 0) then
        txt_crono.text = minutos .. "0:0" .. number;
    end

    if (number >= 10 and minutos == 0) then
        txt_crono.text = minutos .. "0:" .. number;
    end

    if (minutos > 0 and minutos < 10 and number < 10) then
        txt_crono.text = "0" .. minutos .. ":0" .. number;
    end

    if (minutos > 0 and minutos < 10 and number >= 10) then
        txt_crono.text = "0" .. minutos .. ":" .. number;
    end
end

local function onCollision( event )
    if ( event.phase == "began" ) then
        audio.play( sonido_pelota );
    elseif ( event.phase == "ended" ) then
        print( "ended" );
    end
end

local function golpeo_pared( event )
    if ( event.phase == "began" ) then
        audio.play( sonido_pared );
    elseif ( event.phase == "ended" ) then
        print( "ended" );
    end
end

function scene:createScene( event )
    local group = self.view

    local hierba = display.newImageRect( "hierba.jpg", 320, 480 );
    hierba.x = 160;
    hierba.y = 240;

    group:insert(hierba);

    local player_uno = display.newText( "Jugador 1", 40 , -10, native.systemFontBold, 12 );
    player_uno:setFillColor( 1, 0, 0 );
    group:insert( player_uno );

    local player_dos = display.newText( "Jugador 2", 40 , tamanyo_height - 80, native.systemFontBold, 12 );
    player_dos:setFillColor( 1, 0, 0 );
    group:insert( player_dos );

    local paletaSuperior = display.newRect( tamanyo_width / 2, 0, 60, 10);
    paletaSuperior:setFillColor( 1, 0.4, 0.1, 0.7 );
    fisica.addBody(paletaSuperior, "kinematic", {density = 9.0});

    group:insert(paletaSuperior);

    local paletaInferior = display.newRect( tamanyo_width / 2, 480, 60, 10);
    paletaInferior:setFillColor( 1, 0.4, 0.1, 0.7 );
    fisica.addBody(paletaInferior, "kinematic", {density = 9.0});
    paletaInferior.name = "paletaInferior";

    group:insert(paletaInferior);

    paletaInferior:addEventListener( "touch", movimiento );
    paletaSuperior:addEventListener( "touch", movimiento );

    local lineaCentral = display.newRect( 0, 240, tamanyo_width * 2, 5);
    lineaCentral:setFillColor( 255,255,255 );

    group:insert(lineaCentral);

    pelota = display.newCircle( tamanyo_width / 2, 15, 10 );
    pelota:setFillColor( 0,0,0 );
    fisica.addBody(pelota, "dynamic", {bounce=1, density = 9.0, radius = 10});
    pelota:setLinearVelocity( 0, 200);

    group:insert(pelota);

    local paredIzq = display.newRect(0, 0, 1, display.contentHeight + 500);
    local paredDer = display.newRect(tamanyo_width, 0, 1, tamanyo_height * 2);

    group:insert(paredIzq);
    group:insert(paredDer);

    fisica.addBody(paredIzq, "static", {});
    fisica.addBody(paredDer, "static", {});

    Runtime:addEventListener( "collision", onCollision );
    sonido_pelota = audio.loadSound( "golpe_pelota.mp3" );

    sonido_pared = audio.loadSound( "golpe_pared.mp3" );

    paredIzq:addEventListener( "collision", golpeo_pared );
    paredDer:addEventListener( "collision", golpeo_pared );

    txt_crono = display.newText( minutos .. "0:0" .. number, tamanyo_width - 40, -10, native.systemFont, 18 );
    group:insert( txt_crono );
end

function scene:enterScene( event )
    local group = self.view

    timer1 = timer.performWithDelay(300, comprobacion, 0);

    cronometro = timer.performWithDelay(1000, cronometro, 0);
end

function scene:exitScene( event )
    local group = self.view
end

function scene:destroyScene( event )
    local group = self.view
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;