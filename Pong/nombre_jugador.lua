local widget = require("widget");
local storyboard = require "storyboard";
local myData = require "myData";
local scene = storyboard.newScene();

-- crear el text field
local txt_player_uno;
local txt_player_dos;

local player_uno_name = "Juan";
local player_dos_name = "Pepe";

local nombre;

-- función utilizada para mostrar dialogos.
local function dialogo( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then

        end
    end
end

local function textListener( event )

    if ( event.phase == "began" ) then

        -- user begins editing text field
        print( event.text )

    elseif ( event.phase == "ended" ) then

        -- text field loses focus

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
    	if (event.target.name == "player_uno") then
    		player_uno_name = txt_player_uno.text;
    		native.setKeyboardFocus( nil );
    	end
    	
        if (event.target.name == "player_dos") then
    		player_dos_name = txt_player_dos.text;
    		native.setKeyboardFocus( nil );
    	end

    elseif ( event.phase == "editing" ) then

        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )

    end
end

local function eventoJuego( event )
    if ( "ended" == event.phase ) then
    	if (player_uno_name == nil or player_dos_name == nil) then
    		local alert = native.showAlert( "Información", "Introduzca los nombres de los jugadores.", { "OK" }, dialogo);
    	else
    		myData.name_player_one = player_uno_name;
	    	myData.name_player_two = player_dos_name;
	        storyboard.gotoScene( "juego");
    	end
    end
end

function scene:createScene( event )
    local group = self.view;

    local fondo = display.newImageRect( "nombres.png", 480, 320 )
	fondo.x = 240
	fondo.y = 160

	group:insert(fondo);

	-- Create text field
	txt_player_uno = native.newTextField( display.contentWidth / 2 + (display.contentWidth / 6), 180, 180, 30 );
	txt_player_uno:addEventListener( "userInput", textListener );
	txt_player_uno.name = "player_uno";
	native.setKeyboardFocus( txt_player_uno );
	group:insert(txt_player_uno);

	-- Create text field
	txt_player_dos = native.newTextField( display.contentWidth / 2 + (display.contentWidth / 6), 220, 180, 30 );
	txt_player_dos:addEventListener( "userInput", textListener );
	txt_player_dos.name = "player_dos";
	native.setKeyboardFocus( txt_player_dos );
	group:insert(txt_player_dos);

    local btn_juego = widget.newButton{
	    width = 150,
	    height = 30,
	    left = display.contentWidth / 2 - 75,
	    top = display.contentHeight - 50,
	    id = "btn_juego",
	    label = "Iniciar Juego",
	    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	    defaultFile = "defaultButton.png",
	    overFile = "overButton.png",
	    onEvent = eventoJuego
	}

	group:insert(btn_juego)
end

function scene:enterScene( event )
    local group = self.view;

    -- quitar barra de estados
    display.setStatusBar( display.HiddenStatusBar );
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