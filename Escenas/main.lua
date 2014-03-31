-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local storyboard = require "storyboard"

local options =
{
    effect = "slideLeft",
    time = 800,
    params = { var1 = "custom", myVar = "another" }
}

storyboard.gotoScene( "scene1", options )