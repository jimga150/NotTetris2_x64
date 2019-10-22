function love.load()
	--requires--
	require "gameB.lua"
	require "gameBmulti.lua"
	require "gameA.lua"
	require "menu.lua"
	require "failed.lua"
	require "rocket.lua"
	
	vsync = true
	fsaa = 16
	
	game_height_pixels = 144 --number of pixels in the game height, to be scaled by an integer factor before display
	game_sp_width_pixels = 160 --number of pixels in the game width
	game_mp_width_pixels = 274 --number of pixels in the game width for multiplayer mode
	
	physics_scale_factor = 4 -- factor by which to divide the scale by to get the physics scale, purely a visual fix
	
	heightcorrection = 0
	widthcorrection = 0
	
	max_initial_suggestedscale = 5
	
	autosize() -- sets desktopheight and desktopwidth to the first possible mode that appears
	
	calculateSuggestedScale()
	
	loadoptions()
	
	-- TODO: Justify global
	maxscale = math.min(math.floor(desktopheight / game_height_pixels), math.floor(desktopwidth / game_sp_width_pixels))
	
	if fullscreen == false then
		if scale ~= max_initial_suggestedscale then
			love.graphics.setMode(game_sp_width_pixels * scale, game_height_pixels * scale, false, vsync, fsaa)
		end
	else
		love.graphics.setMode(0, 0, true, vsync, fsaa)
		love.mouse.setVisible(false)
		-- TODO: Justify global
		desktopwidth, desktopheight = love.graphics.getWidth(), love.graphics.getHeight()
		saveoptions()
		
		calculateSuggestedScale()
	
		-- TODO: Justify global
		maxscale = math.min(math.floor(desktopheight / game_height_pixels), math.floor(desktopwidth / game_sp_width_pixels))
		
		-- TODO: Justify global
		scale = maxscale
		
		-- TODO: Justify global
		fullscreenoffsetX = (desktopwidth - game_sp_width_pixels * scale) / 2 -- divide these by two to factor in the screen centering
		-- TODO: Justify global
		fullscreenoffsetY = (desktopheight - game_height_pixels * scale) / 2
	end
	
	-- TODO: Justify global
	physicsscale = scale / physics_scale_factor
	
	--pieces--
	-- TODO: Justify global
	tetriimages = {}
	-- TODO: Justify global
	tetriimagedata = {}
	
	--SOUND--
	-- TODO: Justify global
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
	
	-- TODO: Justify global
	musictitle = love.audio.newSource("sounds/titlemusic.ogg", "stream")
	musictitle:setVolume(0.6)
	musictitle:setLooping(true)
	
	-- TODO: Justify global
	musichighscore = love.audio.newSource("sounds/highscoremusic.ogg", "stream")
	musichighscore:setVolume(0.6)
	musichighscore:setLooping(true)
	
	-- TODO: Justify global
	musicrocket4 = love.audio.newSource("sounds/rocket4.ogg", "stream")
	musicrocket4:setVolume(0.6)
	musicrocket4:setLooping(false)
	
	-- TODO: Justify global
	musicrocket1to3 = love.audio.newSource("sounds/rocket1to3.ogg", "stream")
	musicrocket1to3:setVolume(0.6)
	musicrocket1to3:setLooping(false)
	
	-- TODO: Justify global
	musicresults = love.audio.newSource("sounds/resultsmusic.ogg", "stream")
	musicresults:setVolume(1)
	musicresults:setLooping(false)
	
	-- TODO: Justify global
	highscoreintro = love.audio.newSource("sounds/highscoreintro.ogg", "stream")
	highscoreintro:setVolume(0.6)
	highscoreintro:setLooping(false)
	
	-- TODO: Justify global
	musicoptions = love.audio.newSource("sounds/musicoptions.ogg", "stream")
	musicoptions:setVolume(1)
	musicoptions:setLooping(true)
	
	-- TODO: Justify global
	boot = love.audio.newSource("sounds/boot.ogg")
	-- TODO: Justify global
	blockfall = love.audio.newSource("sounds/blockfall.ogg", "stream")
	-- TODO: Justify global
	blockturn = love.audio.newSource("sounds/turn.ogg", "stream")
	-- TODO: Justify global
	blockmove = love.audio.newSource("sounds/move.ogg", "stream")
	-- TODO: Justify global
	lineclear = love.audio.newSource("sounds/lineclear.ogg", "stream")
	-- TODO: Justify global
	fourlineclear = love.audio.newSource("sounds/4lineclear.ogg", "stream")
	-- TODO: Justify global
	gameover1 = love.audio.newSource("sounds/gameover1.ogg", "stream")
	-- TODO: Justify global
	gameover2 = love.audio.newSource("sounds/gameover2.ogg", "stream")
	-- TODO: Justify global
	pausesound = love.audio.newSource("sounds/pause.ogg", "stream")
	-- TODO: Justify global
	highscorebeep = love.audio.newSource("sounds/highscorebeep.ogg", "stream")
	-- TODO: Justify global
	newlevel = love.audio.newSource("sounds/newlevel.ogg", "stream")
	newlevel:setVolume(0.6)
	
	changevolume(volume)
	
	--IMAGES THAT WON'T CHANGE HUE:
	-- TODO: Justify global
	rainbowgradient = love.graphics.newImage("graphics/rainbow.png") rainbowgradient:setFilter("nearest", "nearest")
	
	--Whitelist for highscorenames--
	-- TODO: Justify global
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
	
	-- TODO: Justify global
	p1wins = 0
	-- TODO: Justify global
	p2wins = 0
	
	-- TODO: Justify global
	skipupdate = true
	-- TODO: Justify global
	soundenabled = true
	-- TODO: Justify global
	startdelay = 1
	-- TODO: Justify global
	logoduration = 1.5
	-- TODO: Justify global
	logodelay = 1
	-- TODO: Justify global
	creditsdelay = 2
	-- TODO: Justify global
	selectblinkrate = 0.29
	-- TODO: Justify global
	cursorblinkrate = 0.14
	-- TODO: Justify global
	selectblink = true
	-- TODO: Justify global
	cursorblink = true
	-- TODO: Justify global
	playerselection = 1
	-- TODO: Justify global
	musicno = 1 --
	-- TODO: Justify global
	gameno = 1 --
	-- TODO: Justify global
	selection = 1 --
	-- TODO: Justify global
	colorizeduration = 3 --seconds
	-- TODO: Justify global
	lineclearduration = 1.2 --seconds
	-- TODO: Justify global
	lineclearblinks = 7 --i
	-- TODO: Justify global
	lineclearthreshold = 8.1 --in blocks
	-- TODO: Justify global
	densityupdateinterval = 1 / 30 --in seconds
	-- TODO: Justify global
	nextpiecerotspeed = 1 --rad per seconnd
	-- TODO: Justify global
	minfps = 1 / 50 --dt doesn't go higher than this
	-- TODO: Justify global
	scoreaddtime = 0.5
	-- TODO: Justify global
	startdelaytime = 0
	
	-- TODO: Justify global
	blockstartY = -64 --where new blocks are created
	-- TODO: Justify global
	losingY = 0 --lose if block 1 collides above this line
	-- TODO: Justify global
	blockrot = 10
	-- TODO: Justify global
	minmass = 1
	
	-- TODO: Justify global
	optionschoices = { "volume", "color", "scale", "fullscrn" }
	
	-- TODO: Justify global
	piececenter = {}
	piececenter[1] = { 17, 5 }
	piececenter[2] = { 13, 9 }
	piececenter[3] = { 13, 9 }
	piececenter[4] = { 9, 9 }
	piececenter[5] = { 13, 9 }
	piececenter[6] = { 13, 9 }
	piececenter[7] = { 13, 9 }
	
	-- TODO: Justify global
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
	-- TODO: Justify global
	stabyourselflogo = newPaddedImage("graphics/stabyourselflogo.png")
	-- TODO: Justify global
	logo = newPaddedImage("graphics/logo.png")
	-- TODO: Justify global
	title = newPaddedImage("graphics/title.png")
	-- TODO: Justify global
	gametype = newPaddedImage("graphics/gametype.png")
	-- TODO: Justify global
	mpmenu = newPaddedImage("graphics/mpmenu.png")
	-- TODO: Justify global
	optionsmenu = newPaddedImage("graphics/options.png")
	-- TODO: Justify global
	volumeslider = newPaddedImage("graphics/volumeslider.png")

	--game--
	-- TODO: Justify global
	gamebackground = newPaddedImage("graphics/gamebackground.png")
	-- TODO: Justify global
	gamebackgroundcutoff = newPaddedImage("graphics/gamebackgroundgamea.png")
	-- TODO: Justify global
	gamebackgroundmulti = newPaddedImage("graphics/gamebackgroundmulti.png")
	-- TODO: Justify global
	multiresults = newPaddedImage("graphics/multiresults.png")
	
	-- TODO: Justify global
	number1 = newPaddedImage("graphics/versus/number1.png")
	-- TODO: Justify global
	number2 = newPaddedImage("graphics/versus/number2.png")
	-- TODO: Justify global
	number3 = newPaddedImage("graphics/versus/number3.png")
	
	-- TODO: Justify global
	gameover = newPaddedImage("graphics/gameover.png")
	-- TODO: Justify global
	gameovercutoff = newPaddedImage("graphics/gameovercutoff.png")
	-- TODO: Justify global
	pausegraphic = newPaddedImage("graphics/pause.png")
	-- TODO: Justify global
	pausegraphiccutoff = newPaddedImage("graphics/pausecutoff.png")
	
	--figures--
	-- TODO: Justify global
	marioidle = newPaddedImage("graphics/versus/marioidle.png")
	-- TODO: Justify global
	mariojump = newPaddedImage("graphics/versus/mariojump.png")
	-- TODO: Justify global
	mariocry1 = newPaddedImage("graphics/versus/mariocry1.png")
	-- TODO: Justify global
	mariocry2 = newPaddedImage("graphics/versus/mariocry2.png")
	
	-- TODO: Justify global
	luigiidle = newPaddedImage("graphics/versus/luigiidle.png")
	-- TODO: Justify global
	luigijump = newPaddedImage("graphics/versus/luigijump.png")
	-- TODO: Justify global
	luigicry1 = newPaddedImage("graphics/versus/luigicry1.png")
	-- TODO: Justify global
	luigicry2 = newPaddedImage("graphics/versus/luigicry2.png")
	
	--rockets--
	-- TODO: Justify global
	rocket1 = newPaddedImage("graphics/rocket1.png")
	-- TODO: Justify global
	rocket2 = newPaddedImage("graphics/rocket2.png")
	-- TODO: Justify global
	rocket3 = newPaddedImage("graphics/rocket3.png")
	-- TODO: Justify global
	spaceshuttle = newPaddedImage("graphics/spaceshuttle.png")
	
	-- TODO: Justify global
	rocketbackground = newPaddedImage("graphics/rocketbackground.png")
	-- TODO: Justify global
	bigrocketbackground = newPaddedImage("graphics/bigrocketbackground.png")
	-- TODO: Justify global
	bigrockettakeoffbackground = newPaddedImage("graphics/bigrockettakeoffbackground.png")
	
	-- TODO: Justify global
	smoke1left = newPaddedImage("graphics/smoke1left.png")
	-- TODO: Justify global
	smoke1right = newPaddedImage("graphics/smoke1right.png")
	-- TODO: Justify global
	smoke2left = newPaddedImage("graphics/smoke2left.png")
	-- TODO: Justify global
	smoke2right = newPaddedImage("graphics/smoke2right.png")
	
	-- TODO: Justify global
	fire1 = newPaddedImage("graphics/fire1.png")
	-- TODO: Justify global
	fire2 = newPaddedImage("graphics/fire2.png")
	-- TODO: Justify global
	firebig1 = newPaddedImage("graphics/firebig1.png")
	-- TODO: Justify global
	firebig2 = newPaddedImage("graphics/firebig2.png")
	
	-- TODO: Justify global
	congratsline = newPaddedImage("graphics/congratsline.png")
	
	--nextpiece
	-- TODO: Justify global
	nextpieceimg = {}
	for i = 1, 7 do
		nextpieceimg[i] = newPaddedImage("graphics/pieces/" .. i .. ".png", scale)
	end
	
	--font--
	-- TODO: Justify global
	tetrisfont = newPaddedImageFont("graphics/font.png", "0123456789abcdefghijklmnopqrstTuvwxyz.,'C-#_>:<! ")
	-- TODO: Justify global
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
	rocket1:setFilter("nearest", "nearest")
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
		-- TODO: Justify global
		startdelaytime = startdelaytime + dt
		if startdelaytime >= startdelay then
			menu_load()
		end
	end
	
	if skipupdate then
		-- TODO: Justify global
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
				
				-- TODO: Justify global
				volume = v
			
			elseif split2[1] == "hue" then
				-- TODO: Justify global
				hue = tonumber(split2[2])
			
			elseif split2[1] == "scale" then
				-- TODO: Justify global
				scale = tonumber(split2[2])
			
			elseif split2[1] == "fullscreen" then
				if split2[2] == "true" then
					-- TODO: Justify global
					fullscreen = true
				else
					-- TODO: Justify global
					fullscreen = false
				end
			end
		end
		
		if volume == nil then
			-- TODO: Justify global
			volume = 1
		end
		if hue == nil then
			-- TODO: Justify global
			hue = 0.08
		end
		if fullscreen == nil then
			-- TODO: Justify global
			fullscreen = false
		end
		
		if scale == nil then
			scale = suggestedscale
		end
	
	
	else
		-- TODO: Justify global
		volume = 1
		-- TODO: Justify global
		hue = 0.08
	
		autosize()
	
		scale = suggestedscale
		-- TODO: Justify global
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
	-- TODO: Justify global
	desktopwidth, desktopheight = modes[1]["width"], modes[1]["height"]
end

function togglefullscreen(fullscr)
	-- TODO: Justify global
	fullscreen = fullscr
	love.mouse.setVisible(not fullscreen)
	if fullscr == false then
		scale = suggestedscale
		-- TODO: Justify global
		physicsscale = scale / physics_scale_factor
		love.graphics.setMode(game_sp_width_pixels * scale, game_height_pixels * scale, false, vsync, fsaa)
	else
		love.graphics.setMode(0, 0, true, vsync, fsaa)
		-- TODO: Justify global
		desktopwidth, desktopheight = love.graphics.getWidth(), love.graphics.getHeight()
		
		calculateSuggestedScale()
		
		-- TODO: Justify global
		maxscale = math.min(math.floor(desktopheight / game_height_pixels), math.floor(desktopwidth / game_sp_width_pixels))
		
		-- TODO: Justify global
		scale = maxscale
		-- TODO: Justify global
		physicsscale = scale / physics_scale_factor
		
		-- TODO: Justify global
		fullscreenoffsetX = (desktopwidth - game_sp_width_pixels * scale) / 2
		-- TODO: Justify global
		fullscreenoffsetY = (desktopheight - game_height_pixels * scale) / 2
	end
end

function loadhighscores()
	if gameno == 1 then
		-- TODO: Justify global
		fileloc = "highscoresA.txt"
	else
		-- TODO: Justify global
		fileloc = "highscoresB.txt"
	end
	
	if love.filesystem.exists(fileloc) then
		-- TODO: Justify global
		highdata = love.filesystem.read(fileloc)
		-- TODO: Justify global
		highdata = highdata:split(";")
		-- TODO: Justify global
		highscore = {}
		-- TODO: Justify global
		highscorename = {}
		for i = 1, 3 do
			highscore[i] = tonumber(highdata[i * 2])
			highscorename[i] = string.lower(highdata[i * 2 - 1])
		end
	else
		-- TODO: Justify global
		highscore = {}
		-- TODO: Justify global
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
	-- TODO: Justify global
	highscore = {}
	-- TODO: Justify global
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
		-- TODO: Justify global
		fileloc = "highscoresA.txt"
	else
		-- TODO: Justify global
		fileloc = "highscoresB.txt"
	end
	
	-- TODO: Justify global
	highdata = ""
	for i = 1, 3 do
		-- TODO: Justify global
		highdata = highdata .. highscorename[i] .. ";" .. highscore[i] .. ";"
	end
	love.filesystem.write(fileloc, highdata .. "\n")
end

function changescale(i)
	love.graphics.setMode(game_sp_width_pixels * i, game_height_pixels * i, false, vsync, fsaa)
	-- TODO: Justify global
	nextpieceimg = {}
	for j = 1, 7 do
		nextpieceimg[j] = newPaddedImage("graphics/pieces/" .. j .. ".png", i)
	end
	-- TODO: Justify global
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
			gamestate = "title"
			love.graphics.setBackgroundColor(0, 0, 0)
			love.audio.play(musictitle)
		end
	
	elseif gamestate == "logo" then
		if key == "return" then
			gamestate = "title"
			love.graphics.setBackgroundColor(0, 0, 0)
			love.audio.play(musictitle)
		end
	
	elseif gamestate == "credits" then
		if key == "return" then
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
				gamestate = "menu"
			elseif playerselection == 2 then
				gamestate = "multimenu"
			else
				gamestate = "options"
				if soundenabled then
					love.audio.stop(musictitle)
					love.audio.play(musicoptions)
				end
				-- TODO: Justify global
				optionsselection = 1
			end
		elseif key == "escape" then
			love.event.push("q")
		elseif key == "left" and playerselection > 1 then
			-- TODO: Justify global
			playerselection = playerselection - 1
		elseif key == "right" and playerselection < 3 then
			-- TODO: Justify global
			playerselection = playerselection + 1
		end
	
	elseif gamestate == "menu" then
		-- TODO: Justify global
		oldmusicno = musicno
		if key == "escape" then
			if musicno < 4 then
				love.audio.stop(music[musicno])
			end
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
				-- TODO: Justify global
				selection = selection - 1
				-- TODO: Justify global
				selectblink = true
				oldtime = love.timer.getTime()
			end
		elseif key == "right" then
			if selection == 1 or selection == 3 or selection == 5 then
				-- TODO: Justify global
				selection = selection + 1
				-- TODO: Justify global
				selectblink = true
				oldtime = love.timer.getTime()
			end
		elseif key == "up" then
			if selection == 3 or selection == 4 or selection == 5 or selection == 6 then
				-- TODO: Justify global
				selection = selection - 2
				-- TODO: Justify global
				selectblink = true
				oldtime = love.timer.getTime()
				if selection < 3 then
					-- TODO: Justify global
					selection = gameno
					-- TODO: Justify global
					selectblink = false
					oldtime = love.timer.getTime()
				end
			elseif selection == 1 or selection == 2 then
				-- TODO: Justify global
				selection = musicno + 2
				-- TODO: Justify global
				selectblink = false
				oldtime = love.timer.getTime()
			end
		elseif key == "down" then
			if selection == 1 or selection == 2 or selection == 3 or selection == 4 then
				-- TODO: Justify global
				selection = selection + 2
				-- TODO: Justify global
				selectblink = true
				oldtime = love.timer.getTime()
				if selection > 2 and selection < 5 then
					-- TODO: Justify global
					selection = musicno + 2
					-- TODO: Justify global
					selectblink = false
					oldtime = love.timer.getTime()
				end
			elseif selection == 5 or selection == 6 then
				-- TODO: Justify global
				selection = gameno
				-- TODO: Justify global
				selectblink = false
				oldtime = love.timer.getTime()
			end
		end
		if selection > 2 and key ~= "escape" then
			-- TODO: Justify global
			musicno = selection - 2
			if oldmusicno ~= musicno and oldmusicno ~= 4 then
				love.audio.stop(music[oldmusicno])
			end
			if musicno < 4 then
				love.audio.play(music[musicno])
			end
		elseif key ~= "escape" then
			-- TODO: Justify global
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
			gamestate = "title"
		elseif key == "down" then
			-- TODO: Justify global
			optionsselection = optionsselection + 1
			if optionsselection > #optionschoices then
				-- TODO: Justify global
				optionsselection = 1
			end
			-- TODO: Justify global
			selectblink = true
			oldtime = love.timer.getTime()
		
		elseif key == "up" then
			-- TODO: Justify global
			optionsselection = optionsselection - 1
			if optionsselection == 0 then
				-- TODO: Justify global
				optionsselection = #optionschoices
			end
			-- TODO: Justify global
			selectblink = true
			oldtime = love.timer.getTime()
		
		elseif key == "left" then
			if optionsselection == 1 then
				if volume >= 0.1 then
					-- TODO: Justify global
					volume = volume - 0.1
					if volume < 0.1 then
						-- TODO: Justify global
						volume = 0
					end
					changevolume(volume)
				end
			
			elseif optionsselection == 3 then
				if fullscreen == false then
					if scale > 1 then
						-- TODO: Justify global
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
					-- TODO: Justify global
					volume = volume + 0.1
					changevolume(volume)
				end
			
			elseif optionsselection == 3 then
				if fullscreen == false then
					if scale < maxscale then
						-- TODO: Justify global
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
				-- TODO: Justify global
				volume = 1
				changevolume(volume)
			elseif optionsselection == 2 then
				-- TODO: Justify global
				hue = 0.08
			elseif optionsselection == 3 then
				if fullscreen == false then
					if scale ~= suggestedscale then
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
		-- TODO: Justify global
		oldmusicno = musicno
		if key == "escape" then
			if musicno < 4 then
				love.audio.stop(music[musicno])
			end
			gamestate = "title"
			love.audio.stop(musictitle)
			love.audio.play(musictitle)
		elseif key == "return" then
			gameBmulti_load()
		elseif key == "left" or key == "a" then
			if selection == 2 or selection == 4 or selection == 6 then
				-- TODO: Justify global
				selection = selection - 1
				-- TODO: Justify global
				selectblink = true
				oldtime = love.timer.getTime()
			end
		elseif key == "right" or key == "d" then
			if selection == 1 or selection == 3 or selection == 5 then
				-- TODO: Justify global
				selection = selection + 1
				-- TODO: Justify global
				selectblink = true
				oldtime = love.timer.getTime()
			end
		elseif key == "up" or key == "w" then
			if selection == 3 or selection == 4 or selection == 5 or selection == 6 then
				-- TODO: Justify global
				selection = selection - 2
				-- TODO: Justify global
				selectblink = true
				oldtime = love.timer.getTime()
				if selection < 3 then
					-- TODO: Justify global
					selection = gameno
					-- TODO: Justify global
					selectblink = false
					oldtime = love.timer.getTime()
				end
			elseif selection == 1 or selection == 2 then
				-- TODO: Justify global
				selection = musicno + 2
				-- TODO: Justify global
				selectblink = false
				oldtime = love.timer.getTime()
			end
		elseif key == "down" or key == "s" then
			if selection == 1 or selection == 2 or selection == 3 or selection == 4 then
				-- TODO: Justify global
				selection = selection + 2
				-- TODO: Justify global
				selectblink = true
				oldtime = love.timer.getTime()
				if selection > 2 and selection < 5 then
					-- TODO: Justify global
					selection = musicno + 2
					-- TODO: Justify global
					selectblink = false
					oldtime = love.timer.getTime()
				end
			elseif selection == 5 or selection == 6 then
				-- TODO: Justify global
				selection = gameno
				-- TODO: Justify global
				selectblink = false
				oldtime = love.timer.getTime()
			end
		end
		if selection > 2 and key ~= "return" and key ~= "escape" then
			-- TODO: Justify global
			musicno = selection - 2
			if oldmusicno ~= musicno and oldmusicno ~= 4 then
				love.audio.stop(music[oldmusicno])
			end
			if musicno < 4 then
				love.audio.play(music[musicno])
			end
		elseif key ~= "return" and key ~= "escape" then
			-- TODO: Justify global
			gameno = selection
			loadhighscores()
		end
	
	elseif gamestate == "gameA" or gamestate == "gameB" or gamestate == "failingA" or gamestate == "failingB" then
		
		if key == "return" then
			-- TODO: Justify global
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
				oldtime = love.timer.getTime()
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
			gamestate = "multimenu"
		end
	
	elseif gamestate == "failed" then
		if key == "return" or key == "y" or key == "z" or key == "x" or key == "w" or key == "left" or key == "down" or key == "up" or key == "right" then
			love.audio.stop(gameover2)
			rocket_load()
		end
	elseif gamestate == "highscoreentry" then
		if key == "return" then
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
				-- TODO: Justify global
				cursorblink = true
				highscorename[highscoreno] = string.sub(highscorename[highscoreno], 1, highscorename[highscoreno]:len() - 1)
			end
		
		elseif whitelist[unicode] == true then
			if highscorename[highscoreno]:len() < 6 then
				-- TODO: Justify global
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

function calculateSuggestedScale()
	suggestedscale = math.floor((desktopheight - heightcorrection) / game_height_pixels)
	if suggestedscale > max_initial_suggestedscale then
		suggestedscale = max_initial_suggestedscale
	end
end