function love.load()
	--requires--
	require "gameB.lua"
	require "gameBmulti.lua"
	require "gameA.lua"
	require "menu.lua"
	require "failed.lua"
	require "rocket.lua"
	
	--noinspection GlobalCreationOutsideO
	oldtime = love.timer.getTime()
	
	--noinspection GlobalCreationOutsideO
	vsync = true
	
	--noinspection GlobalCreationOutsideO
	fsaa = 16
	
	--noinspection GlobalCreationOutsideO
	game_height_pixels = 144 --number of pixels in the game height, to be scaled by an integer factor before display
	--noinspection GlobalCreationOutsideO
	game_sp_width_pixels = 160 --number of pixels in the game width
	--noinspection GlobalCreationOutsideO
	game_mp_width_pixels = 274 --number of pixels in the game width for multiplayer mode
	
	--noinspection GlobalCreationOutsideO
	physics_scale_factor = 4 -- factor by which to divide the scale by to get the physics scale, purely a visual fix
	
	--noinspection GlobalCreationOutsideO
	heightcorrection = 0
	--noinspection GlobalCreationOutsideO
	widthcorrection = 0
	
	--noinspection GlobalCreationOutsideO
	max_initial_suggestedscale = 5
	
	autosize() -- sets desktopheight and desktopwidth to the first possible mode that appears

	-- scale to default to, based on the desktop width and height
	--noinspection GlobalCreationOutsideO
	suggestedscale = math.min(math.floor((desktopheight - heightcorrection) / game_height_pixels), math.floor((desktopwidth - widthcorrection) / game_sp_width_pixels))
	if suggestedscale > max_initial_suggestedscale then
		--noinspection GlobalCreationOutsideO
		suggestedscale = max_initial_suggestedscale
	end
	
	loadoptions()
	
	--noinspection GlobalCreationOutsideO
	maxscale = math.min(math.floor(desktopheight / game_height_pixels), math.floor(desktopwidth / game_sp_width_pixels))
	--noinspection GlobalCreationOutsideO
	maxmpscale = math.min(math.floor(desktopheight / game_height_pixels), math.floor(desktopwidth / game_mp_width_pixels))
	
	if fullscreen == false then
		if scale ~= max_initial_suggestedscale then
			love.graphics.setMode(game_sp_width_pixels * scale, game_height_pixels * scale, false, vsync, fsaa)
		end
	else
		love.graphics.setMode(0, 0, true, vsync, fsaa)
		love.mouse.setVisible(false)
		--noinspection GlobalCreationOutsideO
		desktopwidth, desktopheight = love.graphics.getWidth(), love.graphics.getHeight()
		saveoptions()
		
		--noinspection GlobalCreationOutsideO
		suggestedscale = math.floor((desktopheight - heightcorrection) / game_height_pixels)
		if suggestedscale > max_initial_suggestedscale then
			--noinspection GlobalCreationOutsideO
			suggestedscale = max_initial_suggestedscale
		end
		--noinspection GlobalCreationOutsideO
		maxscale = math.min(math.floor(desktopheight / game_height_pixels), math.floor(desktopwidth / game_sp_width_pixels))
		
		--noinspection GlobalCreationOutsideO
		scale = maxscale
		
		--noinspection GlobalCreationOutsideO
		fullscreenoffsetX = (desktopwidth - game_sp_width_pixels * scale) / 2 -- divide these by two to factor in the screen centering
		--noinspection GlobalCreationOutsideO
		fullscreenoffsetY = (desktopheight - game_height_pixels * scale) / 2
	end
	
	--noinspection GlobalCreationOutsideO
	physicsscale = scale / physics_scale_factor
	
	--pieces--
	--noinspection GlobalCreationOutsideO
	tetriimages = {}
	--noinspection GlobalCreationOutsideO
	tetriimagedata = {}
	
	--SOUND--
	--noinspection GlobalCreationOutsideO
	music = {}
	
	music[1] = love.audio.newSource("sounds/themeA.ogg", "stream")
	music[1]:setVolume(0.6)
	music[1]:setLooping(true)
	
	music[2] = love.audio.newSource("sounds/themeB.ogg", "stream")
	music[2]:setVolume(0.6)
	music[2]:setLooping(true)
	
	music[3] = love.audio.newSource("sounds/themeC.ogg", "stream")
	music[3]:setVolume(0.6)
	music[3]:setLooping(true)
	
	--noinspection GlobalCreationOutsideO
	musictitle = love.audio.newSource("sounds/titlemusic.ogg", "stream")
	musictitle:setVolume(0.6)
	musictitle:setLooping(true)
	
	--noinspection GlobalCreationOutsideO
	musichighscore = love.audio.newSource("sounds/highscoremusic.ogg", "stream")
	musichighscore:setVolume(0.6)
	musichighscore:setLooping(true)
	
	--noinspection GlobalCreationOutsideO
	musicrocket4 = love.audio.newSource("sounds/rocket4.ogg", "stream")
	musicrocket4:setVolume(0.6)
	musicrocket4:setLooping(false)
	
	--noinspection GlobalCreationOutsideO
	musicrocket1to3 = love.audio.newSource("sounds/rocket1to3.ogg", "stream")
	musicrocket1to3:setVolume(0.6)
	musicrocket1to3:setLooping(false)
	
	--noinspection GlobalCreationOutsideO
	musicresults = love.audio.newSource("sounds/resultsmusic.ogg", "stream")
	musicresults:setVolume(1)
	musicresults:setLooping(false)
	
	--noinspection GlobalCreationOutsideO
	highscoreintro = love.audio.newSource("sounds/highscoreintro.ogg", "stream")
	highscoreintro:setVolume(0.6)
	highscoreintro:setLooping(false)
	
	--noinspection GlobalCreationOutsideO
	musicoptions = love.audio.newSource("sounds/musicoptions.ogg", "stream")
	musicoptions:setVolume(1)
	musicoptions:setLooping(true)
	
	--noinspection GlobalCreationOutsideO
	boot = love.audio.newSource("sounds/boot.ogg")
	--noinspection GlobalCreationOutsideO
	blockfall = love.audio.newSource("sounds/blockfall.ogg", "stream")
	--noinspection GlobalCreationOutsideO
	blockturn = love.audio.newSource("sounds/turn.ogg", "stream")
	--noinspection GlobalCreationOutsideO
	blockmove = love.audio.newSource("sounds/move.ogg", "stream")
	--noinspection GlobalCreationOutsideO
	lineclear = love.audio.newSource("sounds/lineclear.ogg", "stream")
	--noinspection GlobalCreationOutsideO
	fourlineclear = love.audio.newSource("sounds/4lineclear.ogg", "stream")
	--noinspection GlobalCreationOutsideO
	gameover1 = love.audio.newSource("sounds/gameover1.ogg", "stream")
	--noinspection GlobalCreationOutsideO
	gameover2 = love.audio.newSource("sounds/gameover2.ogg", "stream")
	--noinspection GlobalCreationOutsideO
	pausesound = love.audio.newSource("sounds/pause.ogg", "stream")
	--noinspection GlobalCreationOutsideO
	highscorebeep = love.audio.newSource("sounds/highscorebeep.ogg", "stream")
	--noinspection GlobalCreationOutsideO
	newlevel = love.audio.newSource("sounds/newlevel.ogg", "stream")
	newlevel:setVolume(0.6)
	
	changevolume(volume)
	
	--IMAGES THAT WON'T CHANGE HUE:
	--noinspection GlobalCreationOutsideO
	rainbowgradient = love.graphics.newImage("graphics/rainbow.png") rainbowgradient:setFilter("nearest", "nearest")
	
	--Whitelist for highscorenames--
	--noinspection GlobalCreationOutsideO
	whitelist = {}
	for i = 48, 57 do -- 0 - 9
		whitelist[i] = true
	end
	for i = 65, 90 do -- A - Z
		whitelist[i] = true
	end
	for i = 97, 122 do --a - z
		whitelist[i] = true
	end
	whitelist[32] = true -- space
	whitelist[44] = true -- ,
	whitelist[45] = true -- -
	whitelist[46] = true -- .
	whitelist[95] = true -- _
	
	-----------------------------
	
	math.randomseed(os.time())
	math.random(); math.random(); math.random() --discarding some as they seem to tend to unrandomness.
	
	love.graphics.setBackgroundColor(255, 255, 255)
	
	--noinspection GlobalCreationOutsideO
	p1wins = 0
	--noinspection GlobalCreationOutsideO
	p2wins = 0
	
	--noinspection GlobalCreationOutsideO
	skipupdate = true
	--noinspection GlobalCreationOutsideO
	soundenabled = true
	--noinspection GlobalCreationOutsideO
	startdelay = 1
	--noinspection GlobalCreationOutsideO
	logoduration = 1.5
	--noinspection GlobalCreationOutsideO
	logodelay = 1
	--noinspection GlobalCreationOutsideO
	creditsdelay = 2
	--noinspection GlobalCreationOutsideO
	selectblinkrate = 0.29
	--noinspection GlobalCreationOutsideO
	cursorblinkrate = 0.14
	--noinspection GlobalCreationOutsideO
	selectblink = true
	--noinspection GlobalCreationOutsideO
	cursorblink = true
	--noinspection GlobalCreationOutsideO
	playerselection = 1
	--noinspection GlobalCreationOutsideO
	musicno = 1 --
	--noinspection GlobalCreationOutsideO
	gameno = 1 --
	--noinspection GlobalCreationOutsideO
	selection = 1 --
	--noinspection GlobalCreationOutsideO
	colorizeduration = 3 --seconds
	--noinspection GlobalCreationOutsideO
	lineclearduration = 1.2 --seconds
	--noinspection GlobalCreationOutsideO
	lineclearblinks = 7 --i
	--noinspection GlobalCreationOutsideO
	lineclearthreshold = 8.1 --in blocks
	--noinspection GlobalCreationOutsideO
	densityupdateinterval = 1 / 30 --in seconds
	--noinspection GlobalCreationOutsideO
	nextpiecerotspeed = 1 --rad per seconnd
	--noinspection GlobalCreationOutsideO
	minfps = 1 / 50 --dt doesn't go higher than this
	--noinspection GlobalCreationOutsideO
	scoreaddtime = 0.5
	--noinspection GlobalCreationOutsideO
	startdelaytime = 0
	
	--noinspection GlobalCreationOutsideO
	blockstartY = -64 --where new blocks are created
	--noinspection GlobalCreationOutsideO
	losingY = 0 --lose if block 1 collides above this line
	--noinspection GlobalCreationOutsideO
	blockrot = 10
	--noinspection GlobalCreationOutsideO
	minmass = 1
	
	--noinspection GlobalCreationOutsideO
	optionschoices = { "volume", "color", "scale", "fullscrn" }
	
	--noinspection GlobalCreationOutsideO
	piececenter = {}
	piececenter[1] = { 17, 5 }
	piececenter[2] = { 13, 9 }
	piececenter[3] = { 13, 9 }
	piececenter[4] = { 9, 9 }
	piececenter[5] = { 13, 9 }
	piececenter[6] = { 13, 9 }
	piececenter[7] = { 13, 9 }
	
	--noinspection GlobalCreationOutsideO
	piececenterpreview = {}
	piececenterpreview[1] = { 17, 5 }
	piececenterpreview[2] = { 15, 7 }
	piececenterpreview[3] = { 11, 7 }
	piececenterpreview[4] = { 9, 9 }
	piececenterpreview[5] = { 13, 9 }
	piececenterpreview[6] = { 13, 7 }
	piececenterpreview[7] = { 13, 9 }
	
	loadhighscores()
	
	loadimages()
	
	--all done!
	if startdelay == 0 then
		menu_load()
	end
end

function loadimages()
	--IMAGES--

	--menu--
	--noinspection GlobalCreationOutsideO
	stabyourselflogo = newPaddedImage("graphics/stabyourselflogo.png")
	--noinspection GlobalCreationOutsideO
	logo = newPaddedImage("graphics/logo.png")
	--noinspection GlobalCreationOutsideO
	title = newPaddedImage("graphics/title.png")
	--noinspection GlobalCreationOutsideO
	gametype = newPaddedImage("graphics/gametype.png")
	--noinspection GlobalCreationOutsideO
	mpmenu = newPaddedImage("graphics/mpmenu.png")
	--noinspection GlobalCreationOutsideO
	optionsmenu = newPaddedImage("graphics/options.png")
	--noinspection GlobalCreationOutsideO
	volumeslider = newPaddedImage("graphics/volumeslider.png")

	--game--
	--noinspection GlobalCreationOutsideO
	gamebackground = newPaddedImage("graphics/gamebackground.png")
	--noinspection GlobalCreationOutsideO
	gamebackgroundcutoff = newPaddedImage("graphics/gamebackgroundgamea.png")
	--noinspection GlobalCreationOutsideO
	gamebackgroundmulti = newPaddedImage("graphics/gamebackgroundmulti.png")
	--noinspection GlobalCreationOutsideO
	multiresults = newPaddedImage("graphics/multiresults.png")
	
	--noinspection GlobalCreationOutsideO
	number1 = newPaddedImage("graphics/versus/number1.png")
	--noinspection GlobalCreationOutsideO
	number2 = newPaddedImage("graphics/versus/number2.png")
	--noinspection GlobalCreationOutsideO
	number3 = newPaddedImage("graphics/versus/number3.png")
	
	--noinspection GlobalCreationOutsideO
	gameover = newPaddedImage("graphics/gameover.png")
	--noinspection GlobalCreationOutsideO
	gameovercutoff = newPaddedImage("graphics/gameovercutoff.png")
	--noinspection GlobalCreationOutsideO
	pausegraphic = newPaddedImage("graphics/pause.png")
	--noinspection GlobalCreationOutsideO
	pausegraphiccutoff = newPaddedImage("graphics/pausecutoff.png")
	
	--figures--
	--noinspection GlobalCreationOutsideO
	marioidle = newPaddedImage("graphics/versus/marioidle.png")
	--noinspection GlobalCreationOutsideO
	mariojump = newPaddedImage("graphics/versus/mariojump.png")
	--noinspection GlobalCreationOutsideO
	mariocry1 = newPaddedImage("graphics/versus/mariocry1.png")
	--noinspection GlobalCreationOutsideO
	mariocry2 = newPaddedImage("graphics/versus/mariocry2.png")
	
	--noinspection GlobalCreationOutsideO
	luigiidle = newPaddedImage("graphics/versus/luigiidle.png")
	--noinspection GlobalCreationOutsideO
	luigijump = newPaddedImage("graphics/versus/luigijump.png")
	--noinspection GlobalCreationOutsideO
	luigicry1 = newPaddedImage("graphics/versus/luigicry1.png")
	--noinspection GlobalCreationOutsideO
	luigicry2 = newPaddedImage("graphics/versus/luigicry2.png")
	
	--rockets--
	--noinspection GlobalCreationOutsideO
	rocket1 = newPaddedImage("graphics/rocket1.png"); rocket1:setFilter("nearest", "nearest")
	--noinspection GlobalCreationOutsideO
	rocket2 = newPaddedImage("graphics/rocket2.png")
	--noinspection GlobalCreationOutsideO
	rocket3 = newPaddedImage("graphics/rocket3.png")
	--noinspection GlobalCreationOutsideO
	spaceshuttle = newPaddedImage("graphics/spaceshuttle.png")
	
	--noinspection GlobalCreationOutsideO
	rocketbackground = newPaddedImage("graphics/rocketbackground.png")
	--noinspection GlobalCreationOutsideO
	bigrocketbackground = newPaddedImage("graphics/bigrocketbackground.png")
	--noinspection GlobalCreationOutsideO
	bigrockettakeoffbackground = newPaddedImage("graphics/bigrockettakeoffbackground.png")
	
	--noinspection GlobalCreationOutsideO
	smoke1left = newPaddedImage("graphics/smoke1left.png")
	--noinspection GlobalCreationOutsideO
	smoke1right = newPaddedImage("graphics/smoke1right.png")
	--noinspection GlobalCreationOutsideO
	smoke2left = newPaddedImage("graphics/smoke2left.png")
	--noinspection GlobalCreationOutsideO
	smoke2right = newPaddedImage("graphics/smoke2right.png")
	
	--noinspection GlobalCreationOutsideO
	fire1 = newPaddedImage("graphics/fire1.png")
	--noinspection GlobalCreationOutsideO
	fire2 = newPaddedImage("graphics/fire2.png")
	--noinspection GlobalCreationOutsideO
	firebig1 = newPaddedImage("graphics/firebig1.png")
	--noinspection GlobalCreationOutsideO
	firebig2 = newPaddedImage("graphics/firebig2.png")
	
	--noinspection GlobalCreationOutsideO
	congratsline = newPaddedImage("graphics/congratsline.png")
	
	--nextpiece
	--noinspection GlobalCreationOutsideO
	nextpieceimg = {}
	for i = 1, 7 do
		nextpieceimg[i] = newPaddedImage("graphics/pieces/" .. i .. ".png", scale)
	end
	
	--font--
	--noinspection GlobalCreationOutsideO
	tetrisfont = newPaddedImageFont("graphics/font.png", "0123456789abcdefghijklmnopqrstTuvwxyz.,'C-#_>:<! ")
	--noinspection GlobalCreationOutsideO
	whitefont = newPaddedImageFont("graphics/fontwhite.png", "0123456789abcdefghijklmnopqrstTuvwxyz.,'C-#_>:<!+ ")
	love.graphics.setFont(tetrisfont)
	
	--filters!
	stabyourselflogo:setFilter("nearest", "nearest")
	logo:setFilter("nearest", "nearest")
	title:setFilter("nearest", "nearest")
	gametype:setFilter("nearest", "nearest")
	mpmenu:setFilter("nearest", "nearest")
	optionsmenu:setFilter("nearest", "nearest")
	volumeslider:setFilter("nearest", "nearest")
	gamebackground:setFilter("nearest", "nearest")
	gamebackgroundcutoff:setFilter("nearest", "nearest")
	gamebackgroundmulti:setFilter("nearest", "nearest")
	multiresults:setFilter("nearest", "nearest")
	number1:setFilter("nearest", "nearest")
	number2:setFilter("nearest", "nearest")
	number3:setFilter("nearest", "nearest")
	gameover:setFilter("nearest", "nearest")
	gameovercutoff:setFilter("nearest", "nearest")
	pausegraphic:setFilter("nearest", "nearest")
	pausegraphiccutoff:setFilter("nearest", "nearest")
	marioidle:setFilter("nearest", "nearest")
	mariojump:setFilter("nearest", "nearest")
	mariocry1:setFilter("nearest", "nearest")
	mariocry2:setFilter("nearest", "nearest")
	luigiidle:setFilter("nearest", "nearest")
	luigijump:setFilter("nearest", "nearest")
	luigicry1:setFilter("nearest", "nearest")
	luigicry2:setFilter("nearest", "nearest")
	rocket2:setFilter("nearest", "nearest")
	rocket3:setFilter("nearest", "nearest")
	spaceshuttle:setFilter("nearest", "nearest")
	rocketbackground:setFilter("nearest", "nearest")
	bigrocketbackground:setFilter("nearest", "nearest")
	bigrockettakeoffbackground:setFilter("nearest", "nearest")
	smoke1left:setFilter("nearest", "nearest")
	smoke1right:setFilter("nearest", "nearest")
	smoke2left:setFilter("nearest", "nearest")
	smoke2right:setFilter("nearest", "nearest")
	fire1:setFilter("nearest", "nearest")
	fire2:setFilter("nearest", "nearest")
	firebig1:setFilter("nearest", "nearest")
	firebig2:setFilter("nearest", "nearest")
	congratsline:setFilter("nearest", "nearest")
end

function love.update(dt)
	if gamestate == nil then
		--noinspection GlobalCreationOutsideO
		startdelaytime = startdelaytime + dt
		if startdelaytime >= startdelay then
			menu_load()
		end
	end
	
	if skipupdate then
		--noinspection GlobalCreationOutsideO
		skipupdate = false
		return
	end
	
	if cuttingtimer ~= 0 then
		dt = math.min(dt, minfps)
	end
	
	if gamestate == "logo" or gamestate == "credits" or gamestate == "title" or gamestate == "menu" or gamestate == "multimenu" or gamestate == "highscoreentry" or gamestate == "options" then
		menu_update(dt)
	elseif gamestate == "gameA" or gamestate == "failingA" then
		if pause == false then
			gameA_update(dt)
		end
	elseif gamestate == "gameB" or gamestate == "failingB" then
		if pause == false then
			gameB_update(dt)
		end
	elseif gamestate == "gameBmulti" or gamestate == "failingBmulti" or gamestate == "failedBmulti" or gamestate == "gameBmulti_results" then
		gameBmulti_update(dt)
	elseif gamestate == "rocket1" or gamestate == "rocket2" or gamestate == "rocket3" or gamestate == "rocket4" then
		rocket_update()
	end
end

function love.draw()
	if gamestate == "logo" or gamestate == "credits" or gamestate == "title" or gamestate == "menu" or gamestate == "multimenu" or gamestate == "highscoreentry" or gamestate == "options" then
		menu_draw()
	elseif gamestate == "gameA" or gamestate == "failingA" then
		gameA_draw()
	elseif gamestate == "gameB" or gamestate == "failingB" then
		gameB_draw()
	elseif gamestate == "gameBmulti" or gamestate == "failingBmulti" or gamestate == "failedBmulti" or gamestate == "gameBmulti_results" then
		gameBmulti_draw()
	elseif gamestate == "failed" then
		failed_draw()
	elseif gamestate == "rocket1" or gamestate == "rocket2" or gamestate == "rocket3" or gamestate == "rocket4" then
		rocket_draw()
	end
end

function newImageData(path, s)
	local imagedata = love.image.newImageData(path)
	
	if s then
		imagedata = scaleImagedata(imagedata, s)
	end
	
	local width, height = imagedata:getWidth(), imagedata:getHeight()
	
	local rr, rg, rb = unpack(getrainbowcolor(hue))
	
	for y = 0, height - 1 do
		for x = 0, width - 1 do
			local oldr, oldg, oldb, olda = imagedata:getPixel(x, y)
			
			if olda ~= 0 then
				if oldr > 203 and oldr < 213 then --lightgrey
					local r = 145 + rr * 64
					local g = 145 + rg * 64
					local b = 145 + rb * 64
					imagedata:setPixel(x, y, r, g, b, olda)
				elseif oldr > 107 and oldr < 117 then --darkgrey
					local r = 73 + rr * 43
					local g = 73 + rg * 43
					local b = 73 + rb * 43
					imagedata:setPixel(x, y, r, g, b, olda)
				end
			end
		end
	end
	
	return imagedata
end

function newPaddedImage(filename, s)
	local source = newImageData(filename)
	
	if s then
		source = scaleImagedata(source, s)
	end
	
	local w, h = source:getWidth(), source:getHeight()
	
	-- Find closest power-of-two.
	local wp = math.pow(2, math.ceil(math.log(w) / math.log(2)))
	local hp = math.pow(2, math.ceil(math.log(h) / math.log(2)))
	
	-- Only pad if needed:
	if wp ~= w or hp ~= h then
		local padded = love.image.newImageData(wp, hp)
		padded:paste(source, 0, 0)
		return love.graphics.newImage(padded)
	end
	
	return love.graphics.newImage(source)
end

function padImagedata(source) --returns image, not imagedata!
	local w, h = source:getWidth(), source:getHeight()
	
	-- Find closest power-of-two.
	local wp = math.pow(2, math.ceil(math.log(w) / math.log(2)))
	local hp = math.pow(2, math.ceil(math.log(h) / math.log(2)))
	
	-- Only pad if needed:
	if wp ~= w or hp ~= h then
		local padded = love.image.newImageData(wp, hp)
		padded:paste(source, 0, 0)
		return love.graphics.newImage(padded)
	end
	
	return love.graphics.newImage(source)
end

function newPaddedImageFont(filename, glyphs)
	local source = newImageData(filename)
	local w, h = source:getWidth(), source:getHeight()
	
	-- Find closest power-of-two.
	local wp = math.pow(2, math.ceil(math.log(w) / math.log(2)))
	local hp = math.pow(2, math.ceil(math.log(h) / math.log(2)))
	
	-- Only pad if needed:
	if wp ~= w or hp ~= h then
		local padded = love.image.newImageData(wp, hp)
		padded:paste(source, 0, 0)
		local image = love.graphics.newImage(padded)
		image:setFilter("nearest", "nearest")
		return love.graphics.newImageFont(image, glyphs)
	end
	
	return love.graphics.newImageFont(source, glyphs)
end

function scaleImagedata(imagedata, i)
	local width, height = imagedata:getWidth(), imagedata:getHeight()
	local scaled = love.image.newImageData(width * i, height * i)
	
	for y = 0, height * i - 1 do
		for x = 0, width * i - 1 do
			local r, g, b, a = imagedata:getPixel(math.floor(x / i), math.floor(y / i))
			scaled:setPixel(x, y, r, g, b, a)
		end
	end
	
	return scaled
end

function changevolume(i)
	music[1]:setVolume(0.6 * i)
	music[2]:setVolume(0.6 * i)
	music[3]:setVolume(0.6 * i)
	musictitle:setVolume(0.6 * i)
	musichighscore:setVolume(0.6 * i)
	musicrocket4:setVolume(0.6 * i)
	musicrocket1to3:setVolume(0.6 * i)
	musicresults:setVolume(i)
	highscoreintro:setVolume(0.6 * i)
	musicoptions:setVolume(i)
	boot:setVolume(i)
	blockfall:setVolume(i)
	blockturn:setVolume(i)
	blockmove:setVolume(i)
	lineclear:setVolume(i)
	fourlineclear:setVolume(i)
	gameover1:setVolume(i)
	gameover2:setVolume(i)
	pausesound:setVolume(i)
	highscorebeep:setVolume(i)
	newlevel:setVolume(0.6 * i)
end

function loadoptions()
	if love.filesystem.exists("options.txt") then
		local s = love.filesystem.read("options.txt")
		local split1 = s:split("\n")
		for i = 1, #split1 do
			local split2 = split1[i]:split("=")
			if split2[1] == "volume" then
				local v = tonumber(split2[2])
				--clamp and round
				if v < 0 then
					v = 0
				elseif v > 1 then
					v = 1
				end
				v = math.floor(v * 10) / 10
				
				--noinspection GlobalCreationOutsideO
				volume = v
			
			elseif split2[1] == "hue" then
				--noinspection GlobalCreationOutsideO
				hue = tonumber(split2[2])
			
			elseif split2[1] == "scale" then
				--noinspection GlobalCreationOutsideO
				scale = tonumber(split2[2])
			
			elseif split2[1] == "fullscreen" then
				if split2[2] == "true" then
					--noinspection GlobalCreationOutsideO
					fullscreen = true
				else
					--noinspection GlobalCreationOutsideO
					fullscreen = false
				end
			end
		end
		
		if volume == nil then
			--noinspection GlobalCreationOutsideO
			volume = 1
		end
		if hue == nil then
			--noinspection GlobalCreationOutsideO
			hue = 0.08
		end
		if fullscreen == nil then
			--noinspection GlobalCreationOutsideO
			fullscreen = false
		end
		
		if scale == nil then
			--noinspection GlobalCreationOutsideO
			scale = suggestedscale
		end
	
	
	else
		--noinspection GlobalCreationOutsideO
		volume = 1
		--noinspection GlobalCreationOutsideO
		hue = 0.08
	
		autosize()
	
		--noinspection GlobalCreationOutsideO
		scale = suggestedscale
		--noinspection GlobalCreationOutsideO
		fullscreen = false
	end
	
	saveoptions()
end

function saveoptions()
	local s = ""
	
	s = s .. "volume=" .. volume .. "\n"
	s = s .. "hue=" .. hue .. "\n"
	s = s .. "scale=" .. scale .. "\n"
	s = s .. "fullscreen=" .. tostring(fullscreen) .. "\n"
	
	love.filesystem.write("options.txt", s)
end

function autosize()
	local modes = love.graphics.getModes()
	--noinspection GlobalCreationOutsideO
	desktopwidth, desktopheight = modes[1]["width"], modes[1]["height"]
end

function togglefullscreen(fullscr)
	--noinspection GlobalCreationOutsideO
	fullscreen = fullscr
	love.mouse.setVisible(not fullscreen)
	if fullscr == false then
		--noinspection GlobalCreationOutsideO
		scale = suggestedscale
		--noinspection GlobalCreationOutsideO
		physicsscale = scale / physics_scale_factor
		love.graphics.setMode(game_sp_width_pixels * scale, game_height_pixels * scale, false, vsync, fsaa)
	else
		love.graphics.setMode(0, 0, true, vsync, fsaa)
		--noinspection GlobalCreationOutsideO
		desktopwidth, desktopheight = love.graphics.getWidth(), love.graphics.getHeight()
		--noinspection GlobalCreationOutsideO
		suggestedscale = math.min(math.floor((desktopheight - heightcorrection) / game_height_pixels), math.floor((desktopwidth - widthcorrection) / game_sp_width_pixels))
		--noinspection GlobalCreationOutsideO
		suggestedscale = math.min(math.floor((desktopheight - heightcorrection) / game_height_pixels), math.floor((desktopwidth - widthcorrection) / game_sp_width_pixels))
		if suggestedscale > max_initial_suggestedscale then
			--noinspection GlobalCreationOutsideO
			suggestedscale = max_initial_suggestedscale
		end
		--noinspection GlobalCreationOutsideO
		maxscale = math.min(math.floor(desktopheight / game_height_pixels), math.floor(desktopwidth / game_sp_width_pixels))
		
		--noinspection GlobalCreationOutsideO
		scale = maxscale
		--noinspection GlobalCreationOutsideO
		physicsscale = scale / physics_scale_factor
		
		--noinspection GlobalCreationOutsideO
		fullscreenoffsetX = (desktopwidth - game_sp_width_pixels * scale) / 2
		--noinspection GlobalCreationOutsideO
		fullscreenoffsetY = (desktopheight - game_height_pixels * scale) / 2
	end
end

function loadhighscores()
	if gameno == 1 then
		--noinspection GlobalCreationOutsideO
		fileloc = "highscoresA.txt"
	else
		--noinspection GlobalCreationOutsideO
		fileloc = "highscoresB.txt"
	end
	
	if love.filesystem.exists(fileloc) then
		--noinspection GlobalCreationOutsideO
		highdata = love.filesystem.read(fileloc)
		--noinspection GlobalCreationOutsideO
		highdata = highdata:split(";")
		--noinspection GlobalCreationOutsideO
		highscore = {}
		--noinspection GlobalCreationOutsideO
		highscorename = {}
		for i = 1, 3 do
			highscore[i] = tonumber(highdata[i * 2])
			highscorename[i] = string.lower(highdata[i * 2 - 1])
		end
	else
		--noinspection GlobalCreationOutsideO
		highscore = {}
		--noinspection GlobalCreationOutsideO
		highscorename = {}
		highscore[1] = 0
		highscorename[1] = ""
		highscore[2] = 0
		highscorename[2] = ""
		highscore[3] = 0
		highscorename[3] = ""
		savehighscores()
	end
end

function newhighscores()
	--noinspection GlobalCreationOutsideO
	highscore = {}
	--noinspection GlobalCreationOutsideO
	highscorename = {}
	highscore[1] = 0
	highscorename[1] = ""
	highscore[2] = 0
	highscorename[2] = ""
	highscore[3] = 0
	highscorename[3] = ""
	savehighscores()
end

function savehighscores()
	if gameno == 1 then
		--noinspection GlobalCreationOutsideO
		fileloc = "highscoresA.txt"
	else
		--noinspection GlobalCreationOutsideO
		fileloc = "highscoresB.txt"
	end
	
	--noinspection GlobalCreationOutsideO
	highdata = ""
	for i = 1, 3 do
		--noinspection GlobalCreationOutsideO
		highdata = highdata .. highscorename[i] .. ";" .. highscore[i] .. ";"
	end
	love.filesystem.write(fileloc, highdata .. "\n")
end

function changescale(i)
	love.graphics.setMode(game_sp_width_pixels * i, game_height_pixels * i, false, vsync, fsaa)
	--noinspection GlobalCreationOutsideO
	nextpieceimg = {}
	for j = 1, 7 do
		nextpieceimg[j] = newPaddedImage("graphics/pieces/" .. j .. ".png", i)
	end
	--noinspection GlobalCreationOutsideO
	physicsscale = i / physics_scale_factor
end

function string:split(delimiter)
	local result = {}
	local from = 1
	local delim_from, delim_to = string.find(self, delimiter, from)
	while delim_from do
		table.insert(result, string.sub(self, from, delim_from - 1))
		from = delim_to + 1
		delim_from, delim_to = string.find(self, delimiter, from)
	end
	table.insert(result, string.sub(self, from))
	return result
end

function pythagoras(a, b)
	local c = math.sqrt(a ^ 2 + b ^ 2)
	if a < 0 or b < 0 then
		c = -c
	end
	return c
end

function round(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function table2string(mytable)
	local output = {}
	for i, v in pairs(mytable) do
		output[i] = mytable[i]
	end
	return output
end

function getPoints2table(shape)
	local x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8 = shape:getPoints()
	if x4 == nil then
		return { x1, y1, x2, y2, x3, y3 }
	end
	if x5 == nil then
		return { x1, y1, x2, y2, x3, y3, x4, y4 }
	end
	if x6 == nil then
		return { x1, y1, x2, y2, x3, y3, x4, y4, x5, y5 }
	end
	if x7 == nil then
		return { x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6 }
	end
	if x8 == nil then
		return { x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7 }
	end
	return { x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8 }
end

function getrainbowcolor(i)
	local r, g, b
	if i < 1 / 6 then
		r = 1
		g = i * 6
		b = 0
	elseif i >= 1 / 6 and i < 2 / 6 then
		r = (1 / 6 - (i - 1 / 6)) * 6
		g = 1
		b = 0
	elseif i >= 2 / 6 and i < 3 / 6 then
		r = 0
		g = 1
		b = (i - 2 / 6) * 6
	elseif i >= 3 / 6 and i < 4 / 6 then
		r = 0
		g = (1 / 6 - (i - 3 / 6)) * 6
		b = 1
	elseif i >= 4 / 6 and i < 5 / 6 then
		r = (i - 4 / 6) * 6
		g = 0
		b = 1
	else
		r = 1
		g = 0
		b = (1 / 6 - (i - 5 / 6)) * 6
	end
	
	return { r, g, b }
end

function love.keypressed(key, unicode)
	if gamestate == nil then
		if key == "return" then
			--noinspection GlobalCreationOutsideO
			gamestate = "title"
			love.graphics.setBackgroundColor(0, 0, 0)
			love.audio.play(musictitle)
		end
	
	elseif gamestate == "logo" then
		if key == "return" then
			--noinspection GlobalCreationOutsideO
			gamestate = "title"
			love.graphics.setBackgroundColor(0, 0, 0)
			love.audio.play(musictitle)
		end
	
	elseif gamestate == "credits" then
		if key == "return" then
			--noinspection GlobalCreationOutsideO
			gamestate = "title"
			love.graphics.setBackgroundColor(0, 0, 0)
			love.audio.play(musictitle)
		end
	
	elseif gamestate == "title" then
		if key == "return" then
			if playerselection ~= 3 then
				if soundenabled then
					love.audio.stop(musictitle)
					if musicno < 4 then
						love.audio.play(music[musicno])
					end
				end
			end
			if playerselection == 1 then
				--noinspection GlobalCreationOutsideO
				gamestate = "menu"
			elseif playerselection == 2 then
				--noinspection GlobalCreationOutsideO
				gamestate = "multimenu"
			else
				--noinspection GlobalCreationOutsideO
				gamestate = "options"
				if soundenabled then
					love.audio.stop(musictitle)
					love.audio.play(musicoptions)
				end
				--noinspection GlobalCreationOutsideO
				optionsselection = 1
			end
		elseif key == "escape" then
			love.event.push("q")
		elseif key == "left" and playerselection > 1 then
			--noinspection GlobalCreationOutsideO
			playerselection = playerselection - 1
		elseif key == "right" and playerselection < 3 then
			--noinspection GlobalCreationOutsideO
			playerselection = playerselection + 1
		end
	
	elseif gamestate == "menu" then
		--noinspection GlobalCreationOutsideO
		oldmusicno = musicno
		if key == "escape" then
			if musicno < 4 then
				love.audio.stop(music[musicno])
			end
			--noinspection GlobalCreationOutsideO
			gamestate = "title"
			if soundenabled then
				love.audio.stop(musictitle)
				love.audio.play(musictitle)
			end
		elseif key == "backspace" then
			newhighscores()
		elseif key == "return" then
			if gameno == 1 then
				gameA_load()
			else
				gameB_load()
			end
		elseif key == "left" then
			if selection == 2 or selection == 4 or selection == 6 then
				--noinspection GlobalCreationOutsideO
				selection = selection - 1
				--noinspection GlobalCreationOutsideO
				selectblink = true
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
			end
		elseif key == "right" then
			if selection == 1 or selection == 3 or selection == 5 then
				--noinspection GlobalCreationOutsideO
				selection = selection + 1
				--noinspection GlobalCreationOutsideO
				selectblink = true
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
			end
		elseif key == "up" then
			if selection == 3 or selection == 4 or selection == 5 or selection == 6 then
				--noinspection GlobalCreationOutsideO
				selection = selection - 2
				--noinspection GlobalCreationOutsideO
				selectblink = true
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
				if selection < 3 then
					--noinspection GlobalCreationOutsideO
					selection = gameno
					--noinspection GlobalCreationOutsideO
					selectblink = false
					--noinspection GlobalCreationOutsideO
					oldtime = love.timer.getTime()
				end
			elseif selection == 1 or selection == 2 then
				--noinspection GlobalCreationOutsideO
				selection = musicno + 2
				--noinspection GlobalCreationOutsideO
				selectblink = false
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
			end
		elseif key == "down" then
			if selection == 1 or selection == 2 or selection == 3 or selection == 4 then
				--noinspection GlobalCreationOutsideO
				selection = selection + 2
				--noinspection GlobalCreationOutsideO
				selectblink = true
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
				if selection > 2 and selection < 5 then
					--noinspection GlobalCreationOutsideO
					selection = musicno + 2
					--noinspection GlobalCreationOutsideO
					selectblink = false
					--noinspection GlobalCreationOutsideO
					oldtime = love.timer.getTime()
				end
			elseif selection == 5 or selection == 6 then
				--noinspection GlobalCreationOutsideO
				selection = gameno
				--noinspection GlobalCreationOutsideO
				selectblink = false
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
			end
		end
		if selection > 2 and key ~= "escape" then
			--noinspection GlobalCreationOutsideO
			musicno = selection - 2
			if oldmusicno ~= musicno and oldmusicno ~= 4 then
				love.audio.stop(music[oldmusicno])
			end
			if musicno < 4 then
				love.audio.play(music[musicno])
			end
		elseif key ~= "escape" then
			--noinspection GlobalCreationOutsideO
			gameno = selection
			loadhighscores()
		end
	
	elseif gamestate == "options" then
		if key == "escape" then
			if soundenabled then
				love.audio.stop(musicoptions)
				love.audio.stop(musictitle)
				love.audio.play(musictitle)
			end
			saveoptions()
			loadimages()
			--noinspection GlobalCreationOutsideO
			gamestate = "title"
		elseif key == "down" then
			--noinspection GlobalCreationOutsideO
			optionsselection = optionsselection + 1
			if optionsselection > #optionschoices then
				--noinspection GlobalCreationOutsideO
				optionsselection = 1
			end
			--noinspection GlobalCreationOutsideO
			selectblink = true
			--noinspection GlobalCreationOutsideO
			oldtime = love.timer.getTime()
		
		elseif key == "up" then
			--noinspection GlobalCreationOutsideO
			optionsselection = optionsselection - 1
			if optionsselection == 0 then
				--noinspection GlobalCreationOutsideO
				optionsselection = #optionschoices
			end
			--noinspection GlobalCreationOutsideO
			selectblink = true
			--noinspection GlobalCreationOutsideO
			oldtime = love.timer.getTime()
		
		elseif key == "left" then
			if optionsselection == 1 then
				if volume >= 0.1 then
					--noinspection GlobalCreationOutsideO
					volume = volume - 0.1
					if volume < 0.1 then
						--noinspection GlobalCreationOutsideO
						volume = 0
					end
					changevolume(volume)
				end
			
			elseif optionsselection == 3 then
				if fullscreen == false then
					if scale > 1 then
						--noinspection GlobalCreationOutsideO
						scale = scale - 1
						changescale(scale)
					end
				end
			
			elseif optionsselection == 4 then
				if fullscreen == false then
					togglefullscreen(true)
				end
			end
		
		elseif key == "right" then
			if optionsselection == 1 then
				if volume <= 0.9 then
					--noinspection GlobalCreationOutsideO
					volume = volume + 0.1
					changevolume(volume)
				end
			
			elseif optionsselection == 3 then
				if fullscreen == false then
					if scale < maxscale then
						--noinspection GlobalCreationOutsideO
						scale = scale + 1
						changescale(scale)
					end
				end
			
			elseif optionsselection == 4 then
				if fullscreen == true then
					togglefullscreen(false)
				end
			end
		
		elseif key == "return" then
			if optionsselection == 1 then
				--noinspection GlobalCreationOutsideO
				volume = 1
				changevolume(volume)
			elseif optionsselection == 2 then
				--noinspection GlobalCreationOutsideO
				hue = 0.08
			elseif optionsselection == 3 then
				if fullscreen == false then
					if scale ~= suggestedscale then
						--noinspection GlobalCreationOutsideO
						scale = suggestedscale
						changescale(scale)
					end
				end
			elseif optionsselection == 4 then
				if fullscreen == true then
					togglefullscreen(false)
				end
			end
		end
	
	elseif gamestate == "multimenu" then
		--noinspection GlobalCreationOutsideO
		oldmusicno = musicno
		if key == "escape" then
			if musicno < 4 then
				love.audio.stop(music[musicno])
			end
			--noinspection GlobalCreationOutsideO
			gamestate = "title"
			love.audio.stop(musictitle)
			love.audio.play(musictitle)
		elseif key == "return" then
			gameBmulti_load()
		elseif key == "left" or key == "a" then
			if selection == 2 or selection == 4 or selection == 6 then
				--noinspection GlobalCreationOutsideO
				selection = selection - 1
				--noinspection GlobalCreationOutsideO
				selectblink = true
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
			end
		elseif key == "right" or key == "d" then
			if selection == 1 or selection == 3 or selection == 5 then
				--noinspection GlobalCreationOutsideO
				selection = selection + 1
				--noinspection GlobalCreationOutsideO
				selectblink = true
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
			end
		elseif key == "up" or key == "w" then
			if selection == 3 or selection == 4 or selection == 5 or selection == 6 then
				--noinspection GlobalCreationOutsideO
				selection = selection - 2
				--noinspection GlobalCreationOutsideO
				selectblink = true
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
				if selection < 3 then
					--noinspection GlobalCreationOutsideO
					selection = gameno
					--noinspection GlobalCreationOutsideO
					selectblink = false
					--noinspection GlobalCreationOutsideO
					oldtime = love.timer.getTime()
				end
			elseif selection == 1 or selection == 2 then
				--noinspection GlobalCreationOutsideO
				selection = musicno + 2
				--noinspection GlobalCreationOutsideO
				selectblink = false
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
			end
		elseif key == "down" or key == "s" then
			if selection == 1 or selection == 2 or selection == 3 or selection == 4 then
				--noinspection GlobalCreationOutsideO
				selection = selection + 2
				--noinspection GlobalCreationOutsideO
				selectblink = true
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
				if selection > 2 and selection < 5 then
					--noinspection GlobalCreationOutsideO
					selection = musicno + 2
					--noinspection GlobalCreationOutsideO
					selectblink = false
					--noinspection GlobalCreationOutsideO
					oldtime = love.timer.getTime()
				end
			elseif selection == 5 or selection == 6 then
				--noinspection GlobalCreationOutsideO
				selection = gameno
				--noinspection GlobalCreationOutsideO
				selectblink = false
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
			end
		end
		if selection > 2 and key ~= "return" and key ~= "escape" then
			--noinspection GlobalCreationOutsideO
			musicno = selection - 2
			if oldmusicno ~= musicno and oldmusicno ~= 4 then
				love.audio.stop(music[oldmusicno])
			end
			if musicno < 4 then
				love.audio.play(music[musicno])
			end
		elseif key ~= "return" and key ~= "escape" then
			--noinspection GlobalCreationOutsideO
			gameno = selection
			loadhighscores()
		end
	
	elseif gamestate == "gameA" or gamestate == "gameB" or gamestate == "failingA" or gamestate == "failingB" then
		
		if key == "return" then
			--noinspection GlobalCreationOutsideO
			pause = not pause
			
			if pause == true then
				if musicno < 4 then
					love.audio.pause(music[musicno])
				end
				love.audio.stop(pausesound)
				love.audio.play(pausesound)
			else
				if musicno < 4 then
					love.audio.resume(music[musicno])
				end
			end
		end
		if gamestate == "gameA" or gamestate == "gameB" then
			if key == "escape" then
				--noinspection GlobalCreationOutsideO
				oldtime = love.timer.getTime()
				--noinspection GlobalCreationOutsideO
				gamestate = "menu"
			end
			
			if pause == false and (cuttingtimer == lineclearduration or gamestate == "gameB") then
				--if key == "up" then --STOP ROTATION OF BLOCK (makes it too easy..)
				--	tetribodies[counter]:setAngularVelocity(0)
				--end
				if key == "left" or key == "right" then
					love.audio.stop(blockmove)
					love.audio.play(blockmove)
				elseif key == "y" or key == "z" or key == "w" or key == "x" then
					love.audio.stop(blockturn)
					love.audio.play(blockturn)
				end
			end
		end
	elseif gamestate == "gameBmulti" and gamestarted == false then
		if key == "escape" then
			if not fullscreen then
				love.graphics.setMode(game_sp_width_pixels * scale, game_height_pixels * scale, false, vsync, 0)
			end
			--noinspection GlobalCreationOutsideO
			gamestate = "multimenu"
			if musicno < 4 then
				love.audio.play(music[musicno])
			end
		end
	elseif gamestate == "gameBmulti" and gamestarted == true then
		if key == "escape" then
			if not fullscreen then
				love.graphics.setMode(game_sp_width_pixels * scale, game_height_pixels * scale, false, vsync, 0)
			end
			--noinspection GlobalCreationOutsideO
			gamestate = "multimenu"
		end
		if key == "a" or key == "d" then
			love.audio.stop(blockmove)
			love.audio.play(blockmove)
		elseif key == "left" or key == "right" then
			love.audio.stop(blockmove)
			love.audio.play(blockmove)
		elseif key == "g" or key == "h" then
			love.audio.stop(blockturn)
			love.audio.play(blockturn)
		elseif key == "kp1" or key == "kp2" then
			love.audio.stop(blockturn)
			love.audio.play(blockturn)
		end
	
	elseif gamestate == "gameBmulti_results" then
		if key == "return" or key == "escape" then
			if musicno < 4 then
				love.audio.stop(musicresults)
				love.audio.play(music[musicno])
			end
			if not fullscreen then
				love.graphics.setMode(game_sp_width_pixels * scale, game_height_pixels * scale, false, vsync, 0)
			end
			--noinspection GlobalCreationOutsideO
			gamestate = "multimenu"
		end
	
	elseif gamestate == "failed" then
		if key == "return" or key == "y" or key == "z" or key == "x" or key == "w" or key == "left" or key == "down" or key == "up" or key == "right" then
			love.audio.stop(gameover2)
			rocket_load()
		end
	elseif gamestate == "highscoreentry" then
		if key == "return" then
			--noinspection GlobalCreationOutsideO
			gamestate = "menu"
			savehighscores()
			if musicchanged == true then
				love.audio.stop(musichighscore)
			else
				love.audio.stop(highscoreintro)
			end
			if musicno < 4 then
				love.audio.play(music[musicno])
			end
		elseif key == "backspace" then
			if highscorename[highscoreno]:len() > 0 then
				--noinspection GlobalCreationOutsideO
				cursorblink = true
				highscorename[highscoreno] = string.sub(highscorename[highscoreno], 1, highscorename[highscoreno]:len() - 1)
			end
		
		elseif whitelist[unicode] == true then
			if highscorename[highscoreno]:len() < 6 then
				--noinspection GlobalCreationOutsideO
				cursorblink = true
				highscorename[highscoreno] = highscorename[highscoreno] .. string.char(unicode)
				love.audio.stop(highscorebeep)
				love.audio.play(highscorebeep)
			end
		end
	elseif string.sub(gamestate, 1, 6) == "rocket" then
		if key == "return" then
			love.audio.stop(musicrocket1to3)
			love.audio.stop(musicrocket4)
			failed_checkhighscores()
		end
	end
end