function gameB_load()
	gamestate = "gameB"
	
	pause = false
	
	difficulty_speed = 100
	
	scorescore = 0
	levelscore = 0
	linesscore = 0
	nextpiecerot = 0
	
	--PHYSICS--
	meter = 30
	world = love.physics.newWorld(0, -720, 960, 1050, 0, 500, true)
	
	tetrikind = {}
	wallshapes = {}
	tetrishapes = {}
	tetribodies = {}
	offsetshapes = {}
	
	wallbodies = love.physics.newBody(world, 32, -64, 0, 0) --WALLS
	wallshapes[0] = love.physics.newPolygonShape(wallbodies, 0, -64, 0, 672, 32, 672, 32, -64)
	wallshapes[0]:setData("left")
	wallshapes[0]:setFriction(0.00001)
	wallshapes[1] = love.physics.newPolygonShape(wallbodies, 352, -64, 352, 672, 384, 672, 384, -64)
	wallshapes[1]:setData("right")
	wallshapes[1]:setFriction(0.00001)
	wallshapes[2] = love.physics.newPolygonShape(wallbodies, 24, 640, 24, 672, 352, 672, 352, 640)
	wallshapes[2]:setData("ground")
	wallshapes[3] = love.physics.newPolygonShape(wallbodies, -8, -96, 384, -96, 384, -64, -8, -64)
	wallshapes[3]:setData("ceiling")
	
	world:setCallbacks(collideB)
	-----------
	
	--FIRST "nextpiece"-
	nextpiece = math.random(7)
	
	game_addTetriB()
	----------------
end

function game_addTetriB()
	--NEW BLOCK--
	randomblock = nextpiece
	createtetriB(randomblock, 1, 224, blockstartY)
	tetribodies[1]:setLinearVelocity(0, difficulty_speed)
	
	--RANDOMIZE
	nextpiece = math.random(7)
end

function createtetriB(i, uniqueid, x, y)
	
	tetriimages[uniqueid] = newPaddedImage("graphics/pieces/" .. i .. ".png", scale)
	tetrikind[uniqueid] = i
	tetrishapes[uniqueid] = {}
	
	if i == 1 then --I
		tetribodies[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapes[uniqueid][1] = love.physics.newRectangleShape(tetribodies[uniqueid], -48, 0, 32, 32)
		tetrishapes[uniqueid][2] = love.physics.newRectangleShape(tetribodies[uniqueid], -16, 0, 32, 32)
		tetrishapes[uniqueid][3] = love.physics.newRectangleShape(tetribodies[uniqueid], 16, 0, 32, 32)
		tetrishapes[uniqueid][4] = love.physics.newRectangleShape(tetribodies[uniqueid], 48, 0, 32, 32)
	
	elseif i == 2 then --J
		tetribodies[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapes[uniqueid][1] = love.physics.newRectangleShape(tetribodies[uniqueid], -32, -16, 32, 32)
		tetrishapes[uniqueid][2] = love.physics.newRectangleShape(tetribodies[uniqueid], 0, -16, 32, 32)
		tetrishapes[uniqueid][3] = love.physics.newRectangleShape(tetribodies[uniqueid], 32, -16, 32, 32)
		tetrishapes[uniqueid][4] = love.physics.newRectangleShape(tetribodies[uniqueid], 32, 16, 32, 32)
	
	elseif i == 3 then --L
		tetribodies[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapes[uniqueid][1] = love.physics.newRectangleShape(tetribodies[uniqueid], -32, -16, 32, 32)
		tetrishapes[uniqueid][2] = love.physics.newRectangleShape(tetribodies[uniqueid], 0, -16, 32, 32)
		tetrishapes[uniqueid][3] = love.physics.newRectangleShape(tetribodies[uniqueid], 32, -16, 32, 32)
		tetrishapes[uniqueid][4] = love.physics.newRectangleShape(tetribodies[uniqueid], -32, 16, 32, 32)
	
	elseif i == 4 then --O
		tetribodies[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapes[uniqueid][1] = love.physics.newRectangleShape(tetribodies[uniqueid], -16, -16, 32, 32)
		tetrishapes[uniqueid][2] = love.physics.newRectangleShape(tetribodies[uniqueid], -16, 16, 32, 32)
		tetrishapes[uniqueid][3] = love.physics.newRectangleShape(tetribodies[uniqueid], 16, 16, 32, 32)
		tetrishapes[uniqueid][4] = love.physics.newRectangleShape(tetribodies[uniqueid], 16, -16, 32, 32)
	
	elseif i == 5 then --S
		tetribodies[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapes[uniqueid][1] = love.physics.newRectangleShape(tetribodies[uniqueid], -32, 16, 32, 32)
		tetrishapes[uniqueid][2] = love.physics.newRectangleShape(tetribodies[uniqueid], 0, -16, 32, 32)
		tetrishapes[uniqueid][3] = love.physics.newRectangleShape(tetribodies[uniqueid], 32, -16, 32, 32)
		tetrishapes[uniqueid][4] = love.physics.newRectangleShape(tetribodies[uniqueid], 0, 16, 32, 32)
	
	elseif i == 6 then --T
		tetribodies[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapes[uniqueid][1] = love.physics.newRectangleShape(tetribodies[uniqueid], -32, -16, 32, 32)
		tetrishapes[uniqueid][2] = love.physics.newRectangleShape(tetribodies[uniqueid], 0, -16, 32, 32)
		tetrishapes[uniqueid][3] = love.physics.newRectangleShape(tetribodies[uniqueid], 32, -16, 32, 32)
		tetrishapes[uniqueid][4] = love.physics.newRectangleShape(tetribodies[uniqueid], 0, 16, 32, 32)
	
	elseif i == 7 then --Z
		tetribodies[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapes[uniqueid][1] = love.physics.newRectangleShape(tetribodies[uniqueid], 0, 16, 32, 32)
		tetrishapes[uniqueid][2] = love.physics.newRectangleShape(tetribodies[uniqueid], 0, -16, 32, 32)
		tetrishapes[uniqueid][3] = love.physics.newRectangleShape(tetribodies[uniqueid], 32, 16, 32, 32)
		tetrishapes[uniqueid][4] = love.physics.newRectangleShape(tetribodies[uniqueid], -32, -16, 32, 32)
	end
	
	tetribodies[uniqueid]:setLinearDamping(0.5)
	tetribodies[uniqueid]:setMassFromShapes()
	tetribodies[uniqueid]:setBullet(true)
	
	for i, v in pairs(tetrishapes[uniqueid]) do
		v:setData(uniqueid)
	end
end

function gameB_draw()
	--FULLSCREEN OFFSET
	if fullscreen then
		love.graphics.translate(fullscreenoffsetX, fullscreenoffsetY)
		
		--scissor
		love.graphics.setScissor(fullscreenoffsetX, fullscreenoffsetY, game_width_pixels * scale, game_height_pixels * scale)
	end
	
	--background--
	love.graphics.draw(gamebackground, 0, 0, 0, scale)
	---------------
	-- tetrishapes--
	for i, v in pairs(tetribodies) do
		if pause == false then
			love.graphics.draw(tetriimages[i], v:getX() * physicsscale, v:getY() * physicsscale, v:getAngle(), 1, 1, piececenter[tetrikind[i]][1] * scale, piececenter[tetrikind[i]][2] * scale)
		end
	end
	
	--Next piece
	if pause == false then
		love.graphics.draw(nextpieceimg[nextpiece], 136 * scale, 120 * scale, nextpiecerot, 1, 1, piececenterpreview[nextpiece][1] * scale, piececenterpreview[nextpiece][2] * scale)
	end
	----------------
	-- start--
	if pause == true then
		love.graphics.draw(pausegraphic, 16 * scale, 0, 0, scale)
	end
	---------
	
	--SCORES---------------------------------------
	--"score"--
	offsetX = 0
	
	scorestring = tostring(scorescore)
	for i = 1, scorestring:len() - 1 do
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(scorescore, game_height_pixels * scale + offsetX, 24 * scale, 0, scale)
	
	
	--"level"--
	offsetX = 0
	
	scorestring = tostring(levelscore)
	for i = 1, scorestring:len() - 1 do
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(levelscore, 136 * scale + offsetX, 56 * scale, 0, scale)
	
	--"tiles"--
	offsetX = 0
	
	scorestring = tostring(linesscore)
	for i = 1, scorestring:len() - 1 do
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(linesscore, 136 * scale + offsetX, 80 * scale, 0, scale)
	-----------------------------------------------
	
	
	--FULLSCREEN OFFSET
	if fullscreen then
		love.graphics.translate(-fullscreenoffsetX, -fullscreenoffsetY)
		
		--scissor
		love.graphics.setScissor()
	end
end

function gameB_update(dt)
	--NEXTPIECE ROTATION (rotating allday erryday)
	nextpiecerot = nextpiecerot + nextpiecerotspeed * dt
	while nextpiecerot > math.pi * 2 do
		nextpiecerot = nextpiecerot - math.pi * 2
	end
	
	if gamestate == "gameB" then
		if love.keyboard.isDown("x") then
			if tetribodies[1]:getAngularVelocity() < 3 then
				tetribodies[1]:applyTorque(70)
			end
		end
		if love.keyboard.isDown("y") or love.keyboard.isDown("z") or love.keyboard.isDown("w") then
			if tetribodies[1]:getAngularVelocity() > -3 then
				tetribodies[1]:applyTorque(-70)
			end
		end
		
		if love.keyboard.isDown("left") then
			local x, y = tetribodies[1]:getWorldCenter()
			tetribodies[1]:applyForce(-70, 0, x, y)
		end
		if love.keyboard.isDown("right") then
			local x, y = tetribodies[1]:getWorldCenter()
			tetribodies[1]:applyForce(70, 0, x, y)
		end
		
		local x, y = tetribodies[1]:getLinearVelocity()
		if love.keyboard.isDown("down") then
			--commented part limits the blackfallspeed
			if y > difficulty_speed * 5 then
				tetribodies[1]:setLinearVelocity(x, difficulty_speed * 5)
			else
				local cx, cy = tetribodies[1]:getWorldCenter()
				tetribodies[1]:applyForce(0, 20, cx, cy)
			end
		else
			if y > difficulty_speed then
				tetribodies[1]:setLinearVelocity(x, y - 2000 * dt)
			end
		end
	end
	
	world:update(dt)
	
	if gamestate == "failingB" then
		clearcheck = true
		for i, v in pairs(tetribodies) do
			if v:getY() < 648 then
				clearcheck = false
			end
		end
		
		if clearcheck then
			failed_load()
		end
	end
end

function collideB(a, b)
	if a == 1 or b == 1 then
		if a ~= "left" and a ~= "right" and b ~= "left" and b ~= "right" then
			if gamestate == "gameB" then
				endblockB()
			end
		end
	end
end

function endblockB()
	if tetribodies[1]:getY() < losingY then
		--LOSE--
		gamestate = "failingB"
		if musicno < 4 then
			love.audio.stop(music[musicno])
		end
		love.audio.stop(gameover1)
		love.audio.play(gameover1)
		
		wallshapes[2]:destroy()
		wallshapes[2] = nil
	else
		--Transfer block from 1 to end of tetribodies
		tetrikind[highestbody() + 1] = tetrikind[1]
		
		tetriimages[highestbody() + 1] = tetriimages[1]
		tetribodies[highestbody() + 1] = tetribodies[1]
		
		tetrishapes[highestbody()] = {}
		for i, v in pairs(tetrishapes[1]) do
			tetrishapes[highestbody()][i] = tetrishapes[1][i]
			tetrishapes[highestbody()][i]:setData({ highestbody() })
			tetrishapes[1][i] = nil
		end
		
		tetribodies[1] = nil
		---------------------------
		linesscore = linesscore + 1
		scorescore = linesscore * 100
		
		love.audio.stop(blockfall)
		love.audio.play(blockfall)
		
		game_addTetriB()
	end
end