local storyboard = require "storyboard";
local myData = require "myData";
local scene = storyboard.newScene();
storyboard.purgeOnSceneChange = true;
system.activate("multitouch");
require "sqlite3";
local db;

-- conexiones sqlite para guardar puntuaciones del juego.
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path ) ;

local fisica = require( "physics" )
fisica.start();
physics.setGravity(0, 0);
--fisica.setDrawMode("hybrid");

local tamanyo_width = display.actualContentWidth ;
local tamanyo_height = display.actualContentHeight;
-- sacar el centro de la pantalla de y
local centro_y = display.contentCenterY;
local centro_x = display.contentCenterX;
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
local puntos_1 = 0;
local puntos_2 = 0;
local txt_marcador_1;
local txt_marcador_2;
-- variable utilizada para saber la dirección de la bola.
local direccion = true;

-- creación de controles para las paletas.
local control_inferior;
local control_superior;

-- creación de los nombres de los jugadores
local player_uno;
local player_dos;

-- tiempo
local  tiempo;

local posicion_linea_arriba = centro_y - (centro_y / 2) - ((centro_y / 2) / 2);
local posicion_linea_bajo = centro_y + (centro_y / 2) + ((centro_y / 2) / 2);

local function movimiento( event )
    if event.phase == "began" then
    elseif event.phase == "moved" then
        
        local y = event.y;
        local aux = y;

        if (y == 30 or y < 30) then
            aux = 30;
        else
            aux = y;
        end

        if (y >= display.contentHeight - 30) then
            aux = display.contentHeight - 30;
        end

        event.target.y = aux;
    end

    return true
end

local function pintar_bola()
    -- dibujamos la pelota y la posicionamos
    pelota = display.newCircle( tamanyo_width / 2, centro_y, 10 );
    pelota:setFillColor( 1,1,1 );
    fisica.addBody(pelota, "dynamic", {bounce=1, density = 9.0, radius = 10});
    pelota:setLinearVelocity( 200, 0);
end

-- evento periodico que lo que hace es comporbar si hemos terminado la partida.
local function comprobacion()
    if (pelota.x >= display.contentHeight * 2) then
        pintar_bola();
        puntos_1 = puntos_1 + 1;
    end

    if (pelota.x <= 0) then    
        pintar_bola();
        puntos_2 = puntos_2 + 1;
    end

    if (puntos_1 == 10) then
         local tabla = {
            puntos = colisiones_1; 
            jugador = "Jugador 1";
            tiempo = tiempo;
        };
        myData.partida[#myData.partida + 1] = tabla;

        storyboard.gotoScene( "puntuaciones");
        timer.cancel(timer1);
    end

    if (puntos_2 == 10) then
        local tabla = {
            puntos = colisiones_2; 
            jugador = "Jugador 2";
            tiempo = tiempo;
        };
        myData.partida[#myData.partida + 1] = tabla;
        storyboard.gotoScene( "puntuaciones");
        timer.cancel(timer1);
    end

    -- actualizamos el texto para saber el número de rebotes de los jugadores.
    txt_marcador_1.text = puntos_1;
    txt_marcador_2.text = puntos_2;
end

local function cronometro()
    number = number + 1;
    if (number == 60) then
        number = 0;
        minutos = minutos + 1;
    end

    if (number < 10 and minutos == 0) then
        tiempo = minutos .. "0:0" .. number;
    end

    if (number >= 10 and minutos == 0) then
        tiempo = minutos .. "0:" .. number;
    end

    if (minutos > 0 and minutos < 10 and number < 10) then
        tiempo = "0" .. minutos .. ":0" .. number;
    end

    if (minutos > 0 and minutos < 10 and number >= 10) then
        tiempo = "0" .. minutos .. ":" .. number;
    end

    txt_crono.text = tiempo;
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

local function golpeo_pared( event )
    if ( event.phase == "began" ) then
        audio.play( sonido_pared );
    elseif ( event.phase == "ended" ) then
        
    end
end

-- mediante esta función lo que hacemos es crear la escena del juego.
-- añadimos cada objeto creado al group para así destruir todos los objetos cuando pasamos de escena.
function scene:createScene( event )
    local group = self.view

    -- quitar barra de estados
    display.setStatusBar( display.HiddenStatusBar );

    -- inicializamos variables
    number = 0;
    minutos = 0;
    colisiones_1 = 0;
    colisiones_2 = 0;

    pintar_bola();

    -- lo que hacemos es mostrar el texto para saber quien es cada jugador.
    player_uno = display.newText( "Jugador 1", 30 , 15, native.systemFontBold, 12 );
    player_uno:setFillColor( 1, 1, 1 );
    group:insert( player_uno );

    player_dos = display.newText( "Jugador 2", display.contentWidth - 30 , display.contentHeight - 15, native.systemFontBold, 12 );
    player_dos:setFillColor( 1, 1, 1 );
    group:insert( player_dos );

    -- escribimos el número de rebotes de los jugadores.
    txt_marcador_1 = display.newText( puntos_1, (display.contentWidth / 2) - 30 , 30, native.systemFontBold, 32 );
    txt_marcador_2 = display.newText( puntos_2, (display.contentWidth / 2) + 30 , 30, native.systemFontBold, 32 );
    group:insert(txt_marcador_1);
    group:insert(txt_marcador_2);

    -- dibujamos la paleta superior para que el jugador pueda parar la bola.
    paletaSuperior = display.newRect( 20, display.contentHeight / 2, 10, 60);
    paletaSuperior:setFillColor( 1, 1, 1 );
    fisica.addBody(paletaSuperior, "static", {density = 9.0});
    group:insert(paletaSuperior);

    -- dibujamos la paleta inferior para que el jugador pueda parar la bola.
    paletaInferior = display.newRect( display.contentWidth - 20, display.contentHeight / 2, 10, 60);
    paletaInferior:setFillColor( 1, 1, 1 );
    fisica.addBody(paletaInferior, "static", {density = 9.0});
    paletaInferior.name = "paletaInferior";
    group:insert(paletaInferior);

    paletaInferior:addEventListener( "touch", movimiento );
    paletaSuperior:addEventListener( "touch", movimiento );

    -- dibujamos la línea central de la pista de juego y la añadimos al grupo.
    local lineaCentral = display.newRect( centro_x, centro_y , 5, display.contentHeight);
    lineaCentral:setFillColor( 255,255,255 );
    group:insert(lineaCentral);

    -- situamos las líneas de fondo de la pista. La línea estará situada en el primer cuarto de la mitad de la pantalla.
    local  linea_arriba =  display.newRect( 0, -1, tamanyo_width * 2, 1);
    group:insert(linea_arriba);

    local  linea_bajo =  display.newRect( 0, display.contentHeight, tamanyo_width * 2, 1);
    lineaCentral:setFillColor( 255,255,255 );
    group:insert(linea_bajo);

    fisica.addBody(linea_bajo, "static", {});
    fisica.addBody(linea_arriba, "static", {});

    -- evento de colisión para que suene la pelota al rebotar contra las paredes.
    sonido_pared = audio.loadSound( "golpe_pared.mp3" );
    linea_bajo:addEventListener( "collision", golpeo_pared );
    linea_arriba:addEventListener( "collision", golpeo_pared );

    -- evento de colisión para que suene la pelota al colisionar contra las paletas.
    sonido_pelota = audio.loadSound( "golpe_pelota.mp3" );
    pelota:addEventListener( "collision", golpeo_bola );


    -- dibujamos el cronómetro
    txt_crono = display.newText( minutos .. "0:0" .. number, display.contentWidth, 20, native.systemFont, 18 );
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
    local group = self.view;
end

function scene:destroyScene( event )
    local group = self.view;
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;