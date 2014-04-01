local widget = require("widget");
local storyboard = require "storyboard";

local fondo = display.newImageRect( "fondo.jpg", 320, 480 )
fondo.x = 160
fondo.y = 240

local function eventoJuego( event )

    if ( "ended" == event.phase ) then
        storyboard.gotoScene( "juego");
    end
end

local tamanyo_width = display.actualContentWidth ;
local tamanyo_height = display.actualContentHeight;

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

local function eventoPuntos( event )

    if ( "ended" == event.phase ) then
        storyboard.gotoScene( "puntuaciones");
    end
end

local btn_puntos = widget.newButton{
    width = 150,
    height = 30,
    left = tamanyo_width / 4,
    top = tamanyo_height - 250,
    id = "btn_puntos",
    label = "Puntuaciones",
    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    defaultFile = "defaultButton.png",
    overFile = "overButton.png",
    onEvent = eventoPuntos
}
