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
-- sacar el centro de la pantalla de y
local centro_y = display.contentCenterY;
local pelota;
local timer1;
local sonido_pelota;
local sonido_pared;
local contador = 0;
local txt_crono;
local number = 0;
local minutos = 0;
local paletaSuperior;
local paletaInferior;
-- variables utilizadas para contar el número de rebotes de la pelota en la paleta.
local colisiones_1 = 0;
local colisiones_2 = 0;
local txt_colisiones_1;
local txt_colisones_2;
-- variable utilizada para saber la dirección de la bola.
local direccion = true;

local posicion_linea_arriba = centro_y - (centro_y / 2) - ((centro_y / 2) / 2);
local posicion_linea_bajo = centro_y + (centro_y / 2) + ((centro_y / 2) / 2);

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

local function hacer_grande()
    --[[if (pelota.path.radius < 15) then
        pelota.path.radius = pelota.path.radius + 2;
    end]]--
end 

local function hacer_pequenyo()
    --[[if (pelota.path.radius > 10) then
        pelota.path.radius = pelota.path.radius - 2;  
    end]]-- 
end 

-- evento periodico que lo que hace es comporbar si hemos terminado la partida.
local function comprobacion()
    if (pelota.y >= posicion_linea_bajo or pelota.y <= posicion_linea_arriba) then
        --storyboard.gotoScene( "puntuaciones");
        timer.cancel(timer1);
    end

    if (direccion == true) then
        if (pelota.y < centro_y) then
            hacer_grande();
        else
            hacer_pequenyo();
        end
    else
        if (pelota.y > centro_y) then
            hacer_grande(); 
        else
            hacer_pequenyo();         
        end
    end

    -- actualizamos el texto para saber el número de rebotes de los jugadores.
    txt_colisiones_1.text = "Rebotes: " .. colisiones_1;
    txt_colisiones_2.text = "Rebotes: " .. colisiones_2;
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

-- metodo utilizado para emitir un sonido cuando la bola colisiona con las tabletas de los jugadores. También utilizamos
-- el método para intercambiar las direcciones de la pelota.
local function golpeo_bola( event )
    if ( event.phase == "began" ) then
        audio.play( sonido_pelota );
        if (direccion == true) then
            direccion = false;
        else 
            direccion = true;
        end
    elseif ( event.phase == "ended" ) then

    end
end

-- evento que se ejecuta cada vez que la pelota colisiona con las paletas.
local function colisiona( event )
    if (event.phase == "began") then
        if (event.target.name == "paletaInferior") then
            colisiones_2 = colisiones_2 + 1;
        else
            colisiones_1 = colisiones_1 + 1;
        end
    end
end

local function golpeo_pared( event )
    if ( event.phase == "began" ) then
        audio.play( sonido_pared );
    elseif ( event.phase == "ended" ) then
        
    end
end

-- función que utilizamos par incrementar la posición de la paleta. Mediante el nombre comprobamos que bóton es el que lanza el evento.
local function incrementar( event )
    if ( event.phase == "began" ) then
        if (event.target.name == "derecho_superior") then
            paletaSuperior.x = paletaSuperior.x + 2;
        end
        if (event.target.name == "derecho_inferior") then
            paletaInferior.x = paletaInferior.x + 2;
        end
    elseif ( event.phase == "ended" ) then
        if (event.target.name == "derecho_superior") then
            paletaSuperior.x = paletaSuperior.x + 2;
        end
        if (event.target.name == "derecho_inferior") then
            paletaInferior.x = paletaInferior.x + 2;
        end
    end
end

-- función que utilizamos par decrementar la posición de la paleta. Mediante el nombre comprobamos que bóton es el que lanza el evento.
local function decrementar( event )
    if ( event.phase == "began" ) then
        if (event.target.name == "izquierdo_superior") then
            paletaSuperior.x = paletaSuperior.x - 2;
        end
        if (event.target.name == "izquierdo_inferior") then
            paletaInferior.x = paletaInferior.x - 2;
        end
    elseif ( event.phase == "ended" ) then
        if (event.target.name == "izquierdo_superior") then
            paletaSuperior.x = paletaSuperior.x - 2;
        end
        if (event.target.name == "izquierdo_inferior") then
            paletaInferior.x = paletaInferior.x - 2;
        end
    end
end

-- mediante esta función lo que hacemos es crear la escena del juego.
-- añadimos cada objeto creado al group para así destruir todos los objetos cuando pasamos de escena.
function scene:createScene( event )
    local group = self.view

    local hierba = display.newImageRect( "hierba.jpg", 320, 480 );
    hierba.x = 160;
    hierba.y = 240;
    group:insert(hierba);

    -- boton izquierdo inferior
    local boton_izquierdo_inf = display.newImageRect( "flechaizquierda.png", 30, 30 );
    boton_izquierdo_inf.x = tamanyo_width / 2 - 30;
    boton_izquierdo_inf.y = posicion_linea_bajo + 30;
    boton_izquierdo_inf:addEventListener( "touch", decrementar );
    boton_izquierdo_inf.name = "izquierdo_inferior";
    group:insert(boton_izquierdo_inf);

    -- boton derecho inferior
    local boton_derecho_inf = display.newImageRect( "flechaderecha.png", 30, 30 );
    boton_derecho_inf.x = tamanyo_width / 2 + 30;
    boton_derecho_inf.y = posicion_linea_bajo + 30;
    boton_derecho_inf:addEventListener( "touch", incrementar);
    boton_derecho_inf.name = "derecho_inferior";
    group:insert( boton_derecho_inf );

    -- boton izquierdo superior
    local boton_izquierdo_sup = display.newImageRect( "flechaizquierda.png", 30, 30 );
    boton_izquierdo_sup.x = tamanyo_width / 2 - 30;
    boton_izquierdo_sup.y = posicion_linea_arriba - 30;
    boton_izquierdo_sup:addEventListener( "touch", decrementar );
    boton_izquierdo_sup.name = "izquierdo_superior";
    group:insert(boton_izquierdo_sup);

    -- boton derecho superior
    local boton_derecho_sup = display.newImageRect( "flechaderecha.png", 30, 30 );
    boton_derecho_sup.x = tamanyo_width / 2 + 30;
    boton_derecho_sup.y = posicion_linea_arriba - 30;
    boton_derecho_sup:addEventListener( "touch", incrementar);
    boton_derecho_sup.name = "derecho_superior";
    group:insert( boton_derecho_sup );

    -- lo que hacemos es mostrar el texto para saber quien es cada jugador.
    local player_uno = display.newText( "Jugador 1", 40 , 45, native.systemFontBold, 12 );
    player_uno:setFillColor( 1, 0, 0 );
    group:insert( player_uno );
    local player_dos = display.newText( "Jugador 2", 40 , display.contentHeight - 40, native.systemFontBold, 12 );
    player_dos:setFillColor( 1, 0, 0 );
    group:insert( player_dos );

    -- escribimos el número de rebotes de los jugadores.
    txt_colisiones_1 = display.newText( "Rebotes: " .. colisiones_1, tamanyo_width - 50 , 45, native.systemFontBold, 12 );
    txt_colisiones_2 = display.newText( "Rebotes: " .. colisiones_2, tamanyo_width - 50, display.contentHeight - 40, native.systemFontBold, 12 );

    -- dibujamos la paleta superior para que el jugador pueda parar la bola.
    paletaSuperior = display.newRect( tamanyo_width / 2, posicion_linea_arriba + 10, 60, 10);
    paletaSuperior:setFillColor( 1, 0.4, 0.1, 0.7 );
    fisica.addBody(paletaSuperior, "kinematic", {density = 9.0});
    group:insert(paletaSuperior);

    -- dibujamos la paleta inferior para que el jugador pueda parar la bola.
    paletaInferior = display.newRect( tamanyo_width / 2, posicion_linea_bajo - 10, 60, 10);
    paletaInferior:setFillColor( 1, 0.4, 0.1, 0.7 );
    fisica.addBody(paletaInferior, "kinematic", {density = 9.0});
    paletaInferior.name = "paletaInferior";
    group:insert(paletaInferior);

    paletaInferior:addEventListener( "touch", movimiento );
    paletaSuperior:addEventListener( "touch", movimiento );

    paletaInferior:addEventListener( "collision", colisiona );
    paletaSuperior:addEventListener( "collision", colisiona );

    -- dibujamos la línea central de la pista de juego y la añadimos al grupo.
    local lineaCentral = display.newRect( 0, centro_y, tamanyo_width * 2, 5);
    lineaCentral:setFillColor( 255,255,255 );
    group:insert(lineaCentral);

    -- situamos las líneas de fondo de la pista. La línea estará situada en el primer cuarto de la mitad de la pantalla.
    local  linea_arriba =  display.newRect( 0, posicion_linea_arriba, tamanyo_width * 2, 5);
    lineaCentral:setFillColor( 255,255,255 );
    group:insert(linea_arriba);

    local  linea_bajo =  display.newRect( 0, posicion_linea_bajo, tamanyo_width * 2, 5);
    lineaCentral:setFillColor( 255,255,255 );
    group:insert(linea_bajo);

    -- dibujamos la pelota y la posicionamos
    pelota = display.newCircle( tamanyo_width / 2, centro_y, 10 );
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

    -- evento de colisión para que suene la pelota al colisionar contra las paletas.
    sonido_pelota = audio.loadSound( "golpe_pelota.mp3" );
    pelota:addEventListener( "collision", golpeo_bola );

    -- evento de colisión para que suene la pelota al rebotar contra las paredes.
    sonido_pared = audio.loadSound( "golpe_pared.mp3" );
    paredIzq:addEventListener( "collision", golpeo_pared );
    paredDer:addEventListener( "collision", golpeo_pared );

    -- dibujamos el cronómetro
    txt_crono = display.newText( minutos .. "0:0" .. number, tamanyo_width - 40, -10, native.systemFont, 18 );
    group:insert( txt_crono );
end

function scene:enterScene( event )
    local group = self.view

    -- cuando entramos en la escena arrancamos los timer. timer1 nos sirve para controlar el final del juego.
    -- cronometro para medir el tiempo de la partida.
    timer1 = timer.performWithDelay(300, comprobacion, 0);
    cronometro = timer.performWithDelay(1000, cronometro, 0);
end

function scene:exitScene( event )
    local group = self.view
end

function scene:destroyScene( event )
    local group = self.view
    timer.cancel(cronometro);
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;