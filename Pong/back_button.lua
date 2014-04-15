Back = {};
local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )

   if ( "back" == keyName and phase == "up" ) then
      if ( storyboard.currentScene == "opciones_juego" ) then
         native.requestExit()
      else
         if ( storyboard.isOverlay ) then
               storyboard.hideOverlay()
         else
            local lastScene = storyboard.returnTo
            print( "previous scene", lastScene )
            if ( lastScene ) then
               storyboard.gotoScene( lastScene, { effect="crossFade", time=500 } )
            else
               native.requestExit()
            end
         end
      end
   end
end

return Back;