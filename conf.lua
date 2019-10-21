function love.conf(t)
	t.title = "Not Tetris 2"
	t.author = "Maurice & jimga150"
	t.identity = "not_tetris_2"
	t.screen.width = 800
	t.screen.height = 720
	t.screen.fsaa = 16
	t.screen.vsync = true
	
	t.modules.audio = true -- Enable the audio module
	t.modules.sound = true -- Enable the sound module
	
	t.modules.keyboard = true -- Enable the keyboard module
	t.modules.mouse = false -- Disable the mouse module
	
	t.modules.image = true -- Enable the image module
	t.modules.graphics = true -- Enable the graphics module
	
	t.modules.physics = true -- Enable the physics module
	
	t.modules.event = true -- Enable the event module
	
	t.modules.timer = true -- Enable the timer module
end