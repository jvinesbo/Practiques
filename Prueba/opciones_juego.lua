local widget = require("widget");
local storyboard = require "storyboard";
local scene = storyboard.newScene();

local tamanyo_width = display.actualContentWidth ;
local tamanyo_height = display.actualContentHeight;

local function eventoJuego( event )

    if ( "ended" == event.phase ) then
        storyboard.gotoScene( "juego");
    end
end

local function eventoPuntos( event )

    if ( "ended" == event.phase ) then
        storyboard.gotoScene( "puntuaciones");
    end
end

function scene:createScene( event )
    local group = self.view

    local fondo = display.newImageRect( "fondo.jpg", 320, 480 )
	fondo.x = 160
	fondo.y = 240

	group:insert(fondo)

    local btn_juego = widget.newButton{
	    width = 150,
	    height = 30,
	    left = tamanyo_width / 4,
	    top = tamanyo_height / 2,
	    id = "btn_juego",
	    label = "Iniciar Juego",
	    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	    defaultFile = "defaultButton.png",
	    overFile = "overButton.png",
	    onEvent = eventoJuego
	}

	group:insert(btn_juego)

	local btn_puntos = widget.newButton{
	    width = 150,
	    height = 30,
	    left = tamanyo_width / 4,
	    top = tamanyo_height - 200,
	    id = "btn_puntos",
	    label = "Puntuaciones",
	    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	    defaultFile = "defaultButton.png",
	    overFile = "overButton.png",
	    onEvent = eventoPuntos
	}

	group:insert(btn_puntos)
end

function scene:enterScene( event )
    local group = self.view
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