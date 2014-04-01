local storyboard = require "storyboard";
local scene = storyboard.newScene();
local widget = require( "widget" );

local tamanyo_width = display.actualContentWidth ;
local tamanyo_height = display.actualContentHeight;

local puntuaciones = display.newText( "Puntuaciones", tamanyo_width / 2, 30, native.systemFont, 24 );
puntuaciones:setFillColor( 1, 0, 0 )

local function onRowRender( event )
	local row = event.row;

	local rowHeight = row.contentHeight;
	local rowWidth = row.contentWidth;

	local rowTitle = display.newText(row, "Fila " .. row.index, 0, 0, nil, 14);
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

for i = 1, 10 do
	tableView:insertRow{};
end

return scene;