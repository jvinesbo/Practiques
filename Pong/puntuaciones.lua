local storyboard = require "storyboard";
local scene = storyboard.newScene();
local myData = require "myData"
storyboard.purgeOnSceneChange = true
local widget = require( "widget" );

-- incluimos una variable y el sqlite3
local db;
local sqlite3 = require "sqlite3"

-- conexiones sqlite para guardar puntuaciones del juego.
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path ) ;

local tamanyo_width = display.actualContentWidth ;
local tamanyo_height = display.actualContentHeight;

local string;

local function eventoJuego( event )

    if ( "ended" == event.phase ) then
		if (myData.name_player_one == nil or myData.name_player_two == nil) then
	        storyboard.gotoScene( "nombre_jugador" );
	    else
	         storyboard.gotoScene( "juego");
	    end
    end
end

local function dialogo( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then

        end
    end
end

function scene:createScene( event )
    local group = self.view

    audio.play( sonido_app );

    local fondo = display.newImageRect( "puntuaciones.png", 480, 320 )
	fondo.x = 240
	fondo.y = 160

	group:insert(fondo);

	display.setDefault( "background", 1, 1, 1 );

	local function onRowRender( event )
		local row = event.row;

		local rowHeight = row.contentHeight;
		local rowWidth = row.contentWidth;

		local rowTitle = display.newText(row, string , 0, 0, nil, 14);
		rowTitle:setFillColor( gray )

		rowTitle.anchorX = 0;
		rowTitle.x = 0;
		rowTitle.y = rowHeight * 0.5;
	end

	local tableView = widget.newTableView
	{
		top = 80,
	 	onRowRender = onRowRender; 
	}

	for row in db:nrows("SELECT * FROM datos ORDER BY puntos DESC LIMIT 5") do
		string = row.username .. " Puntos: " .. " " .. row.puntos;
		tableView:insertRow{};
	end

	group:insert(tableView);

	local btn_juego = widget.newButton{
	    width = 150,
	    height = 30,
	    left = display.contentHeight / 2,
	    top = tamanyo_height - 40,
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