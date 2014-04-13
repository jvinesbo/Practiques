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

local paletaIzquierda;
local paletaDerecha;
-- variables utilizadas para contar el número de rebotes de la pelota en la paleta.
local puntos_1 = 0;
local puntos_2 = 0;
local txt_marcador_1;
local txt_marcador_2;
-- variable utilizada para saber la dirección de la bola.
local direccion = true;
-- creación de los nombres de los jugadores
local player_uno_name;
local player_dos_name;
-- creación de los nombres de los jugadores
local player_uno;
local player_dos;
-- tiempo
local  tiempo;
-- empezar el crono del tiempo de la partida
local crono_empezado = false;
-- comprobar si la bola ya esta pintada
local bola_pintada = false;
-- número de puntos para que termine la partida
local tantos = 5;
-- velocidad de la bola
local velocidadX;
local velocidadY;
-- contador que nos servira para incrementar la velocidad de la bola;
local contador = 0;
-- para comprobar si empezamos el juego
local empezar_juego = false;
-- variable que utilizamos para saber donde tenemos que pintar la bola si en la parte derecha o izquieda.
local controlar_salida = false;

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

local function cronometro()
    -- comprobamos el valor del contador y si han pasado diez segundos incrementamos la velocidad.
    if (empezar_juego == true) then
        if (contador == 10) then
            if (bola_pintada == true) then
                local vx, vy = pelota:getLinearVelocity();
                -- comprobamos si las velocidades son positivas o negativas para que el incremento de velocidad funcione bien.
                if (vx < 0) then
                    vx = vx - 30;
                else
                    vx = vx + 30;
                end

                if (vy < 0) then
                    vy = vy - 30;
                else
                    vy = vy + 30;
                end 

                pelota:setLinearVelocity( vx, vy );

                contador = 0;
            end
        else
            if (bola_pintada == true) then
                contador = contador + 1;
            end 
        end

        if (bola_pintada == true) then
             number = number + 1;
            if (number == 60) then
                number = 0;
                minutos = minutos + 1;
            end

            if (number < 10 and minutos == 0) then
                tiempo = minutos .. "0 0" .. number;
            end

            if (number >= 10 and minutos == 0) then
                tiempo = minutos .. "0 " .. number;
            end

            if (minutos > 0 and minutos < 10 and number < 10) then
                tiempo = "0" .. minutos .. " 0" .. number;
            end

            if (minutos > 0 and minutos < 10 and number >= 10) then
                tiempo = "0" .. minutos .. " " .. number;
            end

            if (minutos >= 10 and number < 10) then
                tiempo = " " .. minutos .. " 0" .. number;
            end

            if (minutos >= 10 and number >= 10) then
                tiempo = " " .. minutos .. " " .. number;
            end

            txt_crono.text = tiempo;
        end
    end 
end

local function pintar_bola()
    -- comprobación que hacemos para empezar el crono cuando pintemos la bola.
    if (crono_empezado == false and bola_pintada == true) then
        crono_empezado = true;
        cronometro = timer.performWithDelay(1000, cronometro, 0);
    end
<<<<<<< HEAD

    velocidadX = math.random(100, 200);
    velocidadY = math.random(-200, 200 )

    if (empezar_juego == true) then
        -- dibujamos la pelota y la posicionamos
        if (bola_pintada == false) then
            if (controlar_salida == false) then
                pelota = display.newCircle( display.contentWidth - 20, paletaDerecha.y, 10 );
            else
                pelota = display.newCircle( 40, paletaIzquierda.y, 10 );
            end
            
            pelota:setFillColor( 1, 1, 1, 0.7 );
            fisica.addBody(pelota, "dynamic", {bounce=1, density = 9.0, radius = 10});
            pelota:setLinearVelocity( velocidadX, velocidadY);

            -- inicializamos el contador
            contador = 0;

            -- evento de colisión para que suene la pelota al colisionar contra las paletas.
            sonido_pelota = audio.loadSound( "golpe_pelota.mp3" );
            pelota:addEventListener( "collision", golpeo_bola );

            bola_pintada = true;
        end 
=======
<<<<<<< HEAD
    velocidad_y = math.random(-80, 80);
    velocidad_x = math.random(200, 350);
=======
    velocidad = math.random(100, 200);
>>>>>>> c3a1d34803c86e9f4441777c42d43b67b48ba5f0
    -- dibujamos la pelota y la posicionamos
    if (bola_pintada == false) then
        pelota = display.newCircle( display.contentWidth / 2, centro_y, 10 );
        pelota:setFillColor( 1, 1, 1, 0.7 );
        fisica.addBody(pelota, "dynamic", {bounce=1, density = 9.0, radius = 10});
        pelota:setLinearVelocity( velocidad, velocidad);

        -- inicializamos el contador
        contador = 0;

        -- evento de colisión para que suene la pelota al colisionar contra las paletas.
        sonido_pelota = audio.loadSound( "golpe_pelota.mp3" );
        pelota:addEventListener( "collision", golpeo_bola );

        bola_pintada = true;
>>>>>>> 8a9ab8102c13da0e78c0d2600d6ba35daebfff1f
    end
end

-- función utilizada para mostrar dialogos.
local function dialogo( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
            empezar_juego = true;
        end
    end
end

-- evento periodico que lo que hace es comporbar si hemos terminado la partida.
local function comprobacion()
    if (bola_pintada == true) then
        if (pelota.x >= display.contentWidth) then
            puntos_1 = puntos_1 + 1;
            bola_pintada = false;
            controlar_salida = false;
        end

        if (pelota.x <= 0) then    
            puntos_2 = puntos_2 + 1;
            bola_pintada = false;
            controlar_salida = true;
        end
    end
  

    if (puntos_1 == tantos) then
         local tabla = {
            puntos = puntos_1  * (( minutos * 60) + number); 
            jugador = player_uno_name;
            tiempo = tiempo;
        };
        myData.partida[#myData.partida + 1] = tabla;

        local tablefill =[[INSERT INTO puntuaciones VALUES (NULL, ']].. player_uno_name ..[[',']].. puntos_1 ..[[',']].. tiempo ..[['); ]]
        db:exec(tablefill)

        storyboard.gotoScene( "animacion");
        timer.cancel(timer1);
    end

    if (puntos_2 == tantos) then
        local tabla = {
            puntos = puntos_2 * (( minutos * 60) + number); 
            jugador = player_dos_name;
            tiempo = tiempo;
        };
        myData.partida[#myData.partida + 1] = tabla;
        
        local tablefill =[[INSERT INTO puntuaciones VALUES (NULL, ']].. player_dos_name ..[[',']].. puntos_2 ..[[',']].. tiempo ..[['); ]]
        db:exec(tablefill)

        storyboard.gotoScene( "animacion");
        timer.cancel(timer1);
    end

    -- actualizamos el texto para saber el número de rebotes de los jugadores.
    txt_marcador_1.text = puntos_1;
    txt_marcador_2.text = puntos_2;
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
    local group = self.view;

    display.setDefault( "background", 0, 0, 0 );

     -- inicializamos variables
    number = 0;
    minutos = 0;
    puntos_1 = 0;
    puntos_2 = 0;
    crono_empezado = false;
    empezar_juego = false;
    contador = 0;
    controlar_salida = false;

    player_uno_name = myData.name_player_one;
    player_dos_name = myData.name_player_two;
    
    pintar_bola();

    -- mostrar información al usuario.
    local alert = native.showAlert( "Información", "Pulse sobre el fondo para que salga la bola.", { "OK" }, dialogo);

    -- quitar barra de estados
    display.setStatusBar( display.HiddenStatusBar );

    local fondo = display.newImageRect( "fondo_negro.png", 480, 320 );
    fondo.x = 240;
    fondo.y = 160;
    group:insert(fondo);
    fondo:addEventListener( "touch", pintar_bola );

    -- lo que hacemos es mostrar el texto para saber quien es cada jugador.
    player_uno = display.newText( player_uno_name, display.contentWidth / 2 - 50 , display.contentHeight - 15, native.systemFontBold, 12 );
    player_uno:setFillColor( 1, 1, 1 );
    group:insert( player_uno );

    player_dos = display.newText( player_dos_name, display.contentWidth / 2  + 50, display.contentHeight - 15, native.systemFontBold, 12 );
    player_dos:setFillColor( 1, 1, 1 );
    group:insert( player_dos );

    -- escribimos el número de rebotes de los jugadores.
    txt_marcador_1 = display.newText( puntos_1, (display.contentWidth / 2) - 40 , 30, native.systemFontBold, 32 );
    txt_marcador_2 = display.newText( puntos_2, (display.contentWidth / 2) + 40 , 30, native.systemFontBold, 32 );
    group:insert(txt_marcador_1);
    group:insert(txt_marcador_2);

    -- dibujamos la paleta izquierda para que el jugador pueda parar la bola.
    paletaIzquierda = display.newImageRect( "paletaIzquierda.png", 60, 60 );
    paletaIzquierda.x = 0;
    paletaIzquierda.y = display.contentHeight / 2;
    fisica.addBody(paletaIzquierda, "static");
    group:insert(paletaIzquierda);
    paletaIzquierda:addEventListener( "touch", movimiento );

    -- dibujamos la paleta derecha para que el jugador pueda parar la bola.
    paletaDerecha = display.newImageRect( "paletaDerecha.png", 60, 60 );
    paletaDerecha.x = display.contentWidth;
    paletaDerecha.y = display.contentHeight / 2;
    fisica.addBody(paletaDerecha, "static");
    group:insert(paletaDerecha);
    paletaDerecha:addEventListener( "touch", movimiento );

    -- dibujamos la línea central de la pista de juego y la añadimos al grupo.
    local lineaCentral = display.newRect( centro_x, centro_y , 2, display.contentHeight);
    lineaCentral:setFillColor( 255,255,255 );
    group:insert(lineaCentral);

    -- situamos las líneas laterales de la pista.
    local  linea_arriba =  display.newRect( 0, 0, tamanyo_width * 2, 0);
    group:insert(linea_arriba);

    local  linea_bajo =  display.newRect( 0, display.contentHeight, tamanyo_width * 2, 0);
    lineaCentral:setFillColor( 255,255,255 );
    group:insert(linea_bajo);

    fisica.addBody(linea_bajo, "static", {});
    fisica.addBody(linea_arriba, "static", {});

    -- evento de colisión para que suene la pelota al rebotar contra las paredes.
    sonido_pared = audio.loadSound( "golpe_pared.mp3" );
    linea_bajo:addEventListener( "collision", golpeo_pared );
    linea_arriba:addEventListener( "collision", golpeo_pared );

    -- dibujamos el cronómetro
    txt_crono = display.newText( minutos .. "0:0" .. number, display.contentWidth / 2, display.contentHeight - 40, native.systemFont, 18 );
    group:insert( txt_crono );
end

function scene:enterScene( event )
    local group = self.view

    -- cuando entramos en la escena arrancamos los timer. timer1 nos sirve para controlar el final del juego.
    -- cronometro para medir el tiempo de la partida.
    timer1 = timer.performWithDelay(300, comprobacion, 0);
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