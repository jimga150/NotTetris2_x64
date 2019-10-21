function gameBmulti_load()
	if musicno < 4 then
		love.audio.stop(music[musicno])
	end
	
	gamestate = "gameBmulti"
	-- TODO: Justify global
	gamestarted = false
	
	-- TODO: Justify global
	beeped = { false, false, false }
	
	--figure out the multiplayer scale
	-- TODO: Justify global
	mpscale = scale
	while game_mp_width_pixels * mpscale > desktopwidth do
		-- TODO: Justify global
		mpscale = mpscale - 1
	end
	-- TODO: Justify global
	physicsmpscale = mpscale / physics_scale_factor
	
	-- TODO: Justify global
	mpfullscreenoffsetX = (desktopwidth - game_mp_width_pixels * mpscale) / 2
	-- TODO: Justify global
	mpfullscreenoffsetY = (desktopheight - game_height_pixels * mpscale) / 2
	
	if not fullscreen then
		love.graphics.setMode(game_mp_width_pixels * mpscale, game_height_pixels * mpscale, fullscreen, vsync, fsaa)
	end
	
	--nextpieces
	-- TODO: Justify global
	nextpieceimgmp = {}
	for i = 1, 7 do
		nextpieceimgmp[i] = newPaddedImage("graphics/pieces/" .. i .. ".png", mpscale)
	end
	
	-- TODO: Justify global
	difficulty_speed = 100
	
	-- TODO: Justify global
	p1fail = false
	-- TODO: Justify global
	p2fail = false
	
	-- TODO: Justify global
	p1color = { 255, 50, 50 }
	-- TODO: Justify global
	p2color = { 50, 255, 50 }
	
	--p1color = {116, 92, 73}
	--p2color = {209, 174, 145}
	
	-- TODO: Justify global
	scorescorep1 = 0
	-- TODO: Justify global
	linesscorep1 = 0
	
	-- TODO: Justify global
	scorescorep2 = 0
	-- TODO: Justify global
	linesscorep2 = 0
	
	-- TODO: Justify global
	counterp1 = 0 --first piece is 1
	-- TODO: Justify global
	counterp2 = 0 --first piece is 1
	
	-- TODO: Justify global
	tetrikindp1 = {}
	-- TODO: Justify global
	tetriimagedatap1 = {}
	-- TODO: Justify global
	tetriimagesp1 = {}
	
	-- TODO: Justify global
	tetrikindp2 = {}
	-- TODO: Justify global
	tetriimagedatap2 = {}
	-- TODO: Justify global
	tetriimagesp2 = {}
	
	-- TODO: Justify global
	randomtable = {}
	-- TODO: Justify global
	nextpiecep1 = nil
	-- TODO: Justify global
	nextpiecep2 = nil
	
	-- TODO: Justify global
	nextpiecerot = 0
	
	--PHYSICS--
	-- TODO: Justify global
	meter = 30 -- TODO: rename to pixelspermeter
	-- TODO: Justify global
	world = love.physics.newWorld(0, -720, 960, 1050, 0, 500, true)
	
	
	-- TODO: Justify global
	wallshapesp1 = {}
	-- TODO: Justify global
	tetrishapesp1 = {}
	-- TODO: Justify global
	tetribodiesp1 = {}
	
	-- TODO: Justify global
	wallshapesp2 = {}
	-- TODO: Justify global
	tetrishapesp2 = {}
	-- TODO: Justify global
	tetribodiesp2 = {}
	
	--WALLS P1--
	-- TODO: Justify global
	wallbodiesp1 = love.physics.newBody(world, 32, -64, 0, 0)

	wallshapesp1["leftp1"] = love.physics.newPolygonShape(wallbodiesp1, 164, 0, 164, 672, 196, 672, 196, 0)
	wallshapesp1["leftp1"]:setData("leftp1")
	wallshapesp1["leftp1"]:setFriction(0.0001)
	
	wallshapesp1["rightp1"] = love.physics.newPolygonShape(wallbodiesp1, 516, 0, 516, 672, 548, 672, 548, 0)
	wallshapesp1["rightp1"]:setData("rightp1")
	wallshapesp1["rightp1"]:setCategory(2)
	wallshapesp1["rightp1"]:setFriction(0.0001)
	
	wallshapesp1["groundp1"] = love.physics.newPolygonShape(wallbodiesp1, 196, 640, 196, 672, 516, 672, 516, 640)
	wallshapesp1["groundp1"]:setData("groundp1")
	
	--WALLS P2--
	-- TODO: Justify global
	wallbodiesp2 = love.physics.newBody(world, 32, -64, 0, 0)

	wallshapesp2["leftp2"] = love.physics.newPolygonShape(wallbodiesp2, 484, 0, 484, 672, 516, 672, 516, 0)
	wallshapesp2["leftp2"]:setData("leftp2")
	wallshapesp2["leftp2"]:setCategory(3)
	wallshapesp2["leftp2"]:setFriction(0.0001)
	
	wallshapesp2["rightp2"] = love.physics.newPolygonShape(wallbodiesp2, 836, 0, 836, 672, 868, 672, 868, 0)
	wallshapesp2["rightp2"]:setData("rightp2")
	wallshapesp2["rightp2"]:setFriction(0.0001)
	
	wallshapesp2["groundp2"] = love.physics.newPolygonShape(wallbodiesp2, 516, 640, 516, 672, 836, 672, 836, 640)
	wallshapesp2["groundp2"]:setData("groundp2")
	-----------
	world:setCallbacks(collideBmulti)
	-----------
	
	randomtable[1] = math.random(7)
	-- TODO: Justify global
	starttimer = love.timer.getTime()
	--first piece! hooray.
end

function gameBmulti_draw()
	if fullscreen then
		love.graphics.translate(mpfullscreenoffsetX, mpfullscreenoffsetY)
		
		love.graphics.setScissor(mpfullscreenoffsetX, mpfullscreenoffsetY, game_mp_width_pixels * mpscale, game_height_pixels * mpscale)
	end
	
	--background--
	if gamestate ~= "gameBmulti_results" then
		love.graphics.draw(gamebackgroundmulti, 0, 0, 0, mpscale)
	else
		love.graphics.draw(multiresults, 0, 0, 0, mpscale)
	end
	---------------
	if gamestarted == false then
		if newtime - starttimer > 2 then
			love.graphics.draw(number1, 73 * mpscale, 48 * mpscale, 0, mpscale)
			love.graphics.draw(number1, 153 * mpscale, 48 * mpscale, 0, mpscale)
		elseif newtime - starttimer > 1 then
			love.graphics.draw(number2, 73 * mpscale, 48 * mpscale, 0, mpscale)
			love.graphics.draw(number2, 153 * mpscale, 48 * mpscale, 0, mpscale)
		elseif newtime - starttimer > 0 then
			love.graphics.draw(number3, 73 * mpscale, 48 * mpscale, 0, mpscale)
			love.graphics.draw(number3, 153 * mpscale, 48 * mpscale, 0, mpscale)
		end
	end
	--tetrishapes P1--
	
	for i, v in pairs(tetribodiesp1) do
		love.graphics.setColor(255, 255, 255)
		--set color:
		if gamestate == "failingBmulti" or gamestate == "failedBmulti" then
			-- TODO: Justify global
			timepassed = love.timer.getTime() - colorizetimer
			if v:getY() > 576 - (576 * (timepassed / colorizeduration)) then
				love.graphics.setColor(unpack(p1color))
			end
		end
		
		love.graphics.draw(tetriimagesp1[i], v:getX() * physicsmpscale, v:getY() * physicsmpscale, v:getAngle(), 1, 1, piececenter[tetrikindp1[i]][1] * mpscale, piececenter[tetrikindp1[i]][2] * mpscale)
	end
	
	if p1fail == false and nextpiecep1 then
		--Next piece
		love.graphics.draw(nextpieceimgmp[nextpiecep1], 24 * mpscale, 120 * mpscale, -nextpiecerot, 1, 1, piececenterpreview[nextpiecep1][1] * mpscale, piececenterpreview[nextpiecep1][2] * mpscale)
	end
	
	----------------
	-- tetrishapes P2--
	for i, v in pairs(tetribodiesp2) do
		love.graphics.setColor(255, 255, 255)
		--set color:
		if gamestate == "failingBmulti" or gamestate == "failedBmulti" then
			-- TODO: Justify global
			timepassed = love.timer.getTime() - colorizetimer
			if v:getY() > 576 - (576 * (timepassed / colorizeduration)) then
				love.graphics.setColor(unpack(p2color))
			end
		end
		love.graphics.draw(tetriimagesp2[i], v:getX() * physicsmpscale, v:getY() * physicsmpscale, v:getAngle(), 1, 1, piececenter[tetrikindp2[i]][1] * mpscale, piececenter[tetrikindp2[i]][2] * mpscale)
	end
	----------------
	love.graphics.setColor(255, 255, 255)
	
	if p2fail == false and nextpiecep2 then
		--Next piece
		love.graphics.draw(nextpieceimgmp[nextpiecep2], 250 * mpscale, 120 * mpscale, nextpiecerot, 1, 1, piececenterpreview[nextpiecep2][1] * mpscale, piececenterpreview[nextpiecep2][2] * mpscale)
	end
	--SCORES P1---------------------------------------
	
	--"score"--
	-- TODO: Justify global
	offsetX = 0
	
	-- TODO: Justify global
	scorestring = tostring(scorescorep1)
	for i = 1, scorestring:len() - 1 do
		-- TODO: Justify global
		offsetX = offsetX - 8 * mpscale
	end
	love.graphics.print(scorescorep1, 36 * mpscale + offsetX, 24 * mpscale, 0, mpscale)
	
	--"tiles"--
	-- TODO: Justify global
	offsetX = 0
	
	-- TODO: Justify global
	scorestring = tostring(linesscorep1)
	for i = 1, scorestring:len() - 1 do
		-- TODO: Justify global
		offsetX = offsetX - 8 * mpscale
	end
	love.graphics.print(linesscorep1, 28 * mpscale + offsetX, 80 * mpscale, 0, mpscale)
	-----------------------------------------------
	
	--SCORES P2---------------------------------------
	--"score"--
	-- TODO: Justify global
	offsetX = 0
	
	-- TODO: Justify global
	scorestring = tostring(scorescorep2)
	for i = 1, scorestring:len() - 1 do
		-- TODO: Justify global
		offsetX = offsetX - 8 * mpscale
	end
	love.graphics.print(scorescorep2, 262 * mpscale + offsetX, 24 * mpscale, 0, mpscale)
	
	--"tiles"--
	-- TODO: Justify global
	offsetX = 0
	
	-- TODO: Justify global
	scorestring = tostring(linesscorep2)
	for i = 1, scorestring:len() - 1 do
		-- TODO: Justify global
		offsetX = offsetX - 8 * mpscale
	end
	love.graphics.print(linesscorep2, 254 * mpscale + offsetX, 80 * mpscale, 0, mpscale)
	-----------------------------------------------
	
	if gamestate == "gameBmulti_results" then
		--win counter
		if p1wins < 10 then
			love.graphics.print("0" .. p1wins, 111 * mpscale, 128 * mpscale, 0, mpscale)
		else
			love.graphics.print(p1wins, 111 * mpscale, 128 * mpscale, 0, mpscale)
		end
		
		if p2wins < 10 then
			love.graphics.print("0" .. p2wins, 193 * mpscale, 128 * mpscale, 0, mpscale)
		else
			love.graphics.print(p2wins, 193 * mpscale, 128 * mpscale, 0, mpscale)
		end
		
		if winner == 1 then
			--mario
			if jumpframe == false then
				love.graphics.draw(marioidle, mariobody:getX() * physicsmpscale, mariobody:getY() * physicsmpscale, mariobody:getAngle(), mpscale, mpscale, 12, 13.5)
			else
				love.graphics.draw(mariojump, mariobody:getX() * physicsmpscale, mariobody:getY() * physicsmpscale, mariobody:getAngle(), mpscale, mpscale, 12, 13.5)
			end
			
			--luigi
			if cryframe == false then
				love.graphics.draw(luigicry1, 162 * mpscale, 66 * mpscale, 0, mpscale, mpscale)
			else
				love.graphics.draw(luigicry2, 162 * mpscale, 66 * mpscale, 0, mpscale, mpscale)
				love.graphics.print("mario", 93 * mpscale, 20 * mpscale, 0, mpscale)
				love.graphics.print("wins!", 141 * mpscale, 20 * mpscale, 0, mpscale)
				for i = 1, 5 do
					love.graphics.draw(congratsline, (86 + (8 * i - 1)) * mpscale, 28 * mpscale, 0, mpscale, mpscale)
					love.graphics.draw(congratsline, (134 + (8 * i - 1)) * mpscale, 28 * mpscale, 0, mpscale, mpscale)
				end
			end
		elseif winner == 2 then
			--luigi
			if jumpframe == false then
				love.graphics.draw(luigiidle, luigibody:getX() * physicsmpscale, luigibody:getY() * physicsmpscale, luigibody:getAngle(), mpscale, mpscale, 14, 15.5)
			else
				love.graphics.draw(luigijump, luigibody:getX() * physicsmpscale, luigibody:getY() * physicsmpscale, luigibody:getAngle(), mpscale, mpscale, 14, 15.5)
			end
			
			--mario
			if cryframe == false then
				love.graphics.draw(mariocry1, 83 * mpscale, 66 * mpscale, 0, mpscale, mpscale)
			else
				love.graphics.draw(mariocry2, 83 * mpscale, 66 * mpscale, 0, mpscale, mpscale)
				love.graphics.print("luigi", 93 * mpscale, 20 * mpscale, 0, mpscale)
				love.graphics.print("wins!", 141 * mpscale, 20 * mpscale, 0, mpscale)
				for i = 1, 5 do
					love.graphics.draw(congratsline, (86 + (8 * i - 1)) * mpscale, 28 * mpscale, 0, mpscale, mpscale)
					love.graphics.draw(congratsline, (134 + (8 * i - 1)) * mpscale, 28 * mpscale, 0, mpscale, mpscale)
				end
			end
		else --draw
			--mario
			love.graphics.draw(marioidle, 84 * mpscale, 69 * mpscale, 0, mpscale, mpscale)
			if cryframe == false then
				love.graphics.print("draw", game_sp_width_pixels * mpscale, 40 * mpscale, 0, mpscale)
			end
			
			--luigi
			love.graphics.draw(luigiidle, 162 * mpscale, 65 * mpscale, 0, mpscale, mpscale)
			if cryframe == false then
				love.graphics.print("draw", 80 * mpscale, 40 * mpscale, 0, mpscale)
			end
		end
	end
	
	if fullscreen then
		love.graphics.translate(-mpfullscreenoffsetX, -mpfullscreenoffsetY)
		
		love.graphics.setScissor()
	end
end

function gameBmulti_update(dt)
	
	--NEXTPIECE ROTATION (rotating allday erryday)
	-- TODO: Justify global
	nextpiecerot = nextpiecerot + nextpiecerotspeed * dt
	while nextpiecerot > math.pi * 2 do
		-- TODO: Justify global
		nextpiecerot = nextpiecerot - math.pi * 2
	end
	
	world:update(dt)
	-- TODO: Justify global
	newtime = love.timer.getTime()
	if gamestarted == false then
		if newtime - starttimer > 3 then
			if musicno < 4 then
				love.audio.play(music[musicno])
			end
			startgame()
			-- TODO: Justify global
			gamestarted = true
		elseif newtime - starttimer > 2 and beeped[3] == false then
			beeped[3] = true
			love.audio.stop(highscorebeep)
			love.audio.play(highscorebeep)
		elseif newtime - starttimer > 1 and beeped[2] == false then
			beeped[2] = true
			love.audio.stop(highscorebeep)
			love.audio.play(highscorebeep)
		elseif newtime - starttimer > 0 and beeped[1] == false then
			beeped[1] = true
			love.audio.stop(highscorebeep)
			love.audio.play(highscorebeep)
		end
	
	elseif gamestate == "gameBmulti" then
		--PLAYER 1--
		if p1fail == false then
			if love.keyboard.isDown("h") then --clockwise
				if tetribodiesp1[counterp1]:getAngularVelocity() < 3 then
					tetribodiesp1[counterp1]:applyTorque(70)
				end
			end
			if love.keyboard.isDown("g") then --counterclockwise
				if tetribodiesp1[counterp1]:getAngularVelocity() > -3 then
					tetribodiesp1[counterp1]:applyTorque(-70)
				end
			end
			
			if love.keyboard.isDown("a") then --left
				local x, y = tetribodiesp1[counterp1]:getWorldCenter()
				tetribodiesp1[counterp1]:applyForce(-70, 0, x, y)
			end
			if love.keyboard.isDown("d") then --right
				local x, y = tetribodiesp1[counterp1]:getWorldCenter()
				tetribodiesp1[counterp1]:applyForce(70, 0, x, y)
			end
			
			local x, y = tetribodiesp1[counterp1]:getLinearVelocity()
			if love.keyboard.isDown("s") then --down
				if y > difficulty_speed * 5 then
					tetribodiesp1[counterp1]:setLinearVelocity(x, difficulty_speed * 5)
				else
					local cx, cy = tetribodiesp1[counterp1]:getWorldCenter()
					tetribodiesp1[counterp1]:applyForce(0, 20, cx, cy)
				end
			else
				if y > difficulty_speed then
					tetribodiesp1[counterp1]:setLinearVelocity(x, y - 2000 * dt)
				end
			end
		end
		--PLAYER 2--
		if p2fail == false then
			if love.keyboard.isDown("kp2") then --clockwise
				if tetribodiesp2[counterp2]:getAngularVelocity() < 3 then
					tetribodiesp2[counterp2]:applyTorque(70)
				end
			end
			if love.keyboard.isDown("kp1") then --counterclockwise
				if tetribodiesp2[counterp2]:getAngularVelocity() > -3 then
					tetribodiesp2[counterp2]:applyTorque(-70)
				end
			end
			
			if love.keyboard.isDown("left") then --left
				local x, y = tetribodiesp2[counterp2]:getWorldCenter()
				tetribodiesp2[counterp2]:applyForce(-70, 0, x, y)
			end
			if love.keyboard.isDown("right") then --right
				local x, y = tetribodiesp2[counterp2]:getWorldCenter()
				tetribodiesp2[counterp2]:applyForce(70, 0, x, y)
			end
			
			local x, y = tetribodiesp2[counterp2]:getLinearVelocity()
			if love.keyboard.isDown("down") then --down
				if y > difficulty_speed * 5 then
					tetribodiesp2[counterp2]:setLinearVelocity(x, difficulty_speed * 5)
				else
					local cx, cy = tetribodiesp2[counterp2]:getWorldCenter()
					tetribodiesp2[counterp2]:applyForce(0, 20, cx, cy)
				end
			else
				if y > difficulty_speed then
					tetribodiesp2[counterp2]:setLinearVelocity(x, y - 2000 * dt)
				end
			end
		end
	elseif gamestate == "failingBmulti" then
		-- TODO: Justify global
		timepassed = love.timer.getTime() - colorizetimer
		if timepassed > colorizeduration then
			gamestate = "failedBmulti"
			
			wallshapesp1["groundp1"]:destroy()
			wallshapesp2["groundp1"]:destroy()
			
			love.audio.stop(gameover2)
			love.audio.play(gameover2)
		end
	elseif gamestate == "failedBmulti" then
		-- TODO: Justify global
		clearcheck = true
		for i, v in pairs(tetribodiesp1) do
			if v:getY() < 162 * mpscale then
				-- TODO: Justify global
				clearcheck = false
			end
		end
		
		for i, v in pairs(tetribodiesp2) do
			if v:getY() < 162 * mpscale then
				-- TODO: Justify global
				clearcheck = false
			end
		end
		
		if clearcheck then --RESULTS SCREEN INI!--
			gamestate = "gameBmulti_results"
			-- TODO: Justify global
			jumptimer = love.timer.getTime()
			-- TODO: Justify global
			crytimer = love.timer.getTime()
			
			love.audio.play(musicresults)
			
			-- TODO: Justify global
			resultsfloorbody = love.physics.newBody(world, 32, -64, 0, 0)
			-- TODO: Justify global
			resultsfloorshape = love.physics.newPolygonShape(resultsfloorbody, 196, 448, 196, 480, 836, 480, 836, 448)
			resultsfloorshape:setData("resultsfloor")
			
			if winner == 1 then
				-- TODO: Justify global
				mariobody = love.physics.newBody(world, 388, 320, 0, 0)
				-- TODO: Justify global
				marioshape = love.physics.newRectangleShape(mariobody, 0, 0, 64, 108)
				marioshape:setMask(3)
				marioshape:setData("mario")
				mariobody:setLinearDamping(0.5)
				mariobody:setMassFromShapes()
			elseif winner == 2 then
				-- TODO: Justify global
				luigibody = love.physics.newBody(world, 704, 320, 0, 0)
				-- TODO: Justify global
				luigishape = love.physics.newRectangleShape(luigibody, 0, 0, 64, 124)
				luigishape:setMask(2)
				luigishape:setData("luigi")
				luigibody:setLinearDamping(0.5)
				luigibody:setMassFromShapes()
			end
			
			if winner == 1 then
				mariobody:setY(mariobody:getY() - 1)
				local x, y = mariobody:getLinearVelocity()
				mariobody:setLinearVelocity(x, -300)
			elseif winner == 2 then
				luigibody:setY(luigibody:getY() - 1)
				local x, y = luigibody:getLinearVelocity()
				luigibody:setLinearVelocity(x, -300)
			end
			-- TODO: Justify global
			jumpframe = true
		end
	elseif gamestate == "gameBmulti_results" then
		-- TODO: Justify global
		jumptimepassed = love.timer.getTime() - jumptimer
		if jumptimepassed > 2 then
			-- TODO: Justify global
			jumptimer = love.timer.getTime()
			-- TODO: Justify global
			jumpframe = true
			if winner == 1 then
				mariobody:setY(mariobody:getY() - 1)
				local x, y = mariobody:getLinearVelocity()
				mariobody:setLinearVelocity(x, -300)
			elseif winner == 2 then
				luigibody:setY(luigibody:getY() - 1)
				local x, y = luigibody:getLinearVelocity()
				luigibody:setLinearVelocity(x, -300)
			end
		end
		
		-- TODO: Justify global
		crytimepassed = love.timer.getTime() - crytimer
		if crytimepassed > 0.4 then
			-- TODO: Justify global
			cryframe = not cryframe
			-- TODO: Justify global
			crytimer = love.timer.getTime()
		end
		
		if winner == 1 then
			if love.keyboard.isDown("a") then
				local x, y = mariobody:getWorldCenter()
				mariobody:applyForce(-30, 0, x, y - 8)
			end
			if love.keyboard.isDown("d") then
				local x, y = mariobody:getWorldCenter()
				mariobody:applyForce(30, 0, x, y - 8)
			end
		elseif winner == 2 then
			if love.keyboard.isDown("left") then
				local x, y = luigibody:getWorldCenter()
				luigibody:applyForce(-30, 0, x, y - 8)
			end
			if love.keyboard.isDown("right") then
				local x, y = luigibody:getWorldCenter()
				luigibody:applyForce(30, 0, x, y - 8)
			end
		end
	end
end

function startgame()
	--FIRST "nextpiece" for p1 (Which gets immediately removed, duh)--
	if randomtable[1] == 2 then
		-- TODO: Justify global
		nextpiecep1 = 3
	elseif randomtable[1] == 3 then
		-- TODO: Justify global
		nextpiecep1 = 2
	elseif randomtable[1] == 5 then
		-- TODO: Justify global
		nextpiecep1 = 7
	elseif randomtable[1] == 7 then
		-- TODO: Justify global
		nextpiecep1 = 5
	else
		-- TODO: Justify global
		nextpiecep1 = randomtable[1]
	end
	
	----------------
	-- FIRST "nextpiece" for p2 (Which gets immediately removed, duh)--

	-- TODO: Justify global
	nextpiecep2 = randomtable[1]
	
	----------------
	game_addTetriBmultip1()
	game_addTetriBmultip2()
end

function game_addTetriBmultip1()
	-- TODO: Justify global
	counterp1 = counterp1 + 1
	--NEW BLOCK--
	-- TODO: Justify global
	randomblockp1 = nextpiecep1
	createtetriBmultip1(randomblockp1, counterp1, 388, blockstartY)
	tetribodiesp1[counterp1]:setLinearVelocity(0, difficulty_speed)
	
	--RANDOMIZE
	if counterp1 > #randomtable then
		table.insert(randomtable, math.random(7))
	end
	--MIRROR PIECES
	if randomtable[counterp1] == 2 then
		-- TODO: Justify global
		nextpiecep1 = 3
	elseif randomtable[counterp1] == 3 then
		-- TODO: Justify global
		nextpiecep1 = 2
	elseif randomtable[counterp1] == 5 then
		-- TODO: Justify global
		nextpiecep1 = 7
	elseif randomtable[counterp1] == 7 then
		-- TODO: Justify global
		nextpiecep1 = 5
	else
		-- TODO: Justify global
		nextpiecep1 = randomtable[counterp1]
	end
end

function game_addTetriBmultip2()
	-- TODO: Justify global
	counterp2 = counterp2 + 1
	--NEW BLOCK--
	-- TODO: Justify global
	randomblockp2 = nextpiecep2
	createtetriBmultip2(randomblockp2, counterp2, 708, blockstartY)
	tetribodiesp2[counterp2]:setLinearVelocity(0, difficulty_speed)
	
	--RANDOMIZE
	if counterp2 > #randomtable then
		table.insert(randomtable, math.random(7))
	end
	-- TODO: Justify global
	nextpiecep2 = randomtable[counterp2]
end

function createtetriBmultip1(i, uniqueid, x, y)
	tetriimagesp1[uniqueid] = newPaddedImage("graphics/pieces/" .. i .. ".png", mpscale)
	tetrikindp1[uniqueid] = i
	tetrishapesp1[uniqueid] = {}
	if i == 1 then --I
		tetribodiesp1[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp1[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -48, 0, 32, 32)
		tetrishapesp1[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -16, 0, 32, 32)
		tetrishapesp1[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 16, 0, 32, 32)
		tetrishapesp1[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 48, 0, 32, 32)
	
	elseif i == 2 then --J
		tetribodiesp1[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp1[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -32, -16, 32, 32)
		tetrishapesp1[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 0, -16, 32, 32)
		tetrishapesp1[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 32, -16, 32, 32)
		tetrishapesp1[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 32, 16, 32, 32)
	
	elseif i == 3 then --L
		tetribodiesp1[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp1[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -32, -16, 32, 32)
		tetrishapesp1[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 0, -16, 32, 32)
		tetrishapesp1[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 32, -16, 32, 32)
		tetrishapesp1[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -32, 16, 32, 32)
	
	elseif i == 4 then --O
		tetribodiesp1[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp1[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -16, -16, 32, 32)
		tetrishapesp1[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -16, 16, 32, 32)
		tetrishapesp1[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 16, 16, 32, 32)
		tetrishapesp1[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 16, -16, 32, 32)
	
	elseif i == 5 then --S
		tetribodiesp1[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp1[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -32, 16, 32, 32)
		tetrishapesp1[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 0, -16, 32, 32)
		tetrishapesp1[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 32, -16, 32, 32)
		tetrishapesp1[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 0, 16, 32, 32)
	
	elseif i == 6 then --T
		tetribodiesp1[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp1[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -32, -16, 32, 32)
		tetrishapesp1[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 0, -16, 32, 32)
		tetrishapesp1[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 32, -16, 32, 32)
		tetrishapesp1[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 0, 16, 32, 32)
	
	elseif i == 7 then --Z
		tetribodiesp1[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp1[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 0, 16, 32, 32)
		tetrishapesp1[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 0, -16, 32, 32)
		tetrishapesp1[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], 32, 16, 32, 32)
		tetrishapesp1[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp1[uniqueid], -32, -16, 32, 32)
	end
	
	tetribodiesp1[uniqueid]:setLinearDamping(0.5)
	tetribodiesp1[uniqueid]:setMassFromShapes()
	tetribodiesp1[uniqueid]:setBullet(true)
	
	for i, v in pairs(tetrishapesp1[uniqueid]) do
		v:setData("p1-" .. uniqueid)
		v:setMask(3)
	end
end

function createtetriBmultip2(i, uniqueid, x, y)
	tetriimagesp2[uniqueid] = newPaddedImage("graphics/pieces/" .. i .. ".png", mpscale)
	tetrikindp2[uniqueid] = i
	tetrishapesp2[uniqueid] = {}
	if i == 1 then --I
		tetribodiesp2[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp2[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -48, 0, 32, 32)
		tetrishapesp2[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -16, 0, 32, 32)
		tetrishapesp2[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 16, 0, 32, 32)
		tetrishapesp2[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 48, 0, 32, 32)
	
	elseif i == 2 then --J
		tetribodiesp2[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp2[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -32, -16, 32, 32)
		tetrishapesp2[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 0, -16, 32, 32)
		tetrishapesp2[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 32, -16, 32, 32)
		tetrishapesp2[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 32, 16, 32, 32)
	
	elseif i == 3 then --L
		tetribodiesp2[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp2[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -32, -16, 32, 32)
		tetrishapesp2[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 0, -16, 32, 32)
		tetrishapesp2[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 32, -16, 32, 32)
		tetrishapesp2[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -32, 16, 32, 32)
	
	elseif i == 4 then --O
		tetribodiesp2[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp2[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -16, -16, 32, 32)
		tetrishapesp2[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -16, 16, 32, 32)
		tetrishapesp2[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 16, 16, 32, 32)
		tetrishapesp2[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 16, -16, 32, 32)
	
	elseif i == 5 then --S
		tetribodiesp2[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp2[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -32, 16, 32, 32)
		tetrishapesp2[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 0, -16, 32, 32)
		tetrishapesp2[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 32, -16, 32, 32)
		tetrishapesp2[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 0, 16, 32, 32)
	
	elseif i == 6 then --T
		tetribodiesp2[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp2[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -32, -16, 32, 32)
		tetrishapesp2[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 0, -16, 32, 32)
		tetrishapesp2[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 32, -16, 32, 32)
		tetrishapesp2[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 0, 16, 32, 32)
	
	elseif i == 7 then --Z
		tetribodiesp2[uniqueid] = love.physics.newBody(world, x, y, 0, blockrot)
		tetrishapesp2[uniqueid][1] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 0, 16, 32, 32)
		tetrishapesp2[uniqueid][2] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 0, -16, 32, 32)
		tetrishapesp2[uniqueid][3] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], 32, 16, 32, 32)
		tetrishapesp2[uniqueid][4] = love.physics.newRectangleShape(tetribodiesp2[uniqueid], -32, -16, 32, 32)
	end
	
	tetribodiesp2[uniqueid]:setLinearDamping(0.5)
	tetribodiesp2[uniqueid]:setMassFromShapes()
	tetribodiesp2[uniqueid]:setBullet(true)
	
	for i, v in pairs(tetrishapesp2[uniqueid]) do
		v:setData("p2-" .. uniqueid)
		v:setMask(2)
	end
end

function collideBmulti(a, b)
	if (a == "p1-" .. counterp1 and b ~= "p2-" .. counterp2) or (b == "p1-" .. counterp1 and b ~= "p2-" .. counterp2) then --One of the pieces is the current piece and the other isn't the other player's one
		if p1fail == false and a ~= "leftp1" and a ~= "rightp1" and b ~= "leftp1" and b ~= "rightp1" then
			endblockp1()
		end
	elseif (a == "p2-" .. counterp2 and b ~= "p1-" .. counterp1) or (b == "p2-" .. counterp2 and a ~= "p1-" .. counterp1) then
		if p2fail == false and a ~= "leftp2" and a ~= "rightp2" and b ~= "leftp2" and b ~= "rightp2" then
			endblockp2()
		end
	elseif gamestate == "gameBmulti_results" then
		if (a == "mario" and b == "resultsfloor") or (b == "mario" and a == "resultsfloor") then
			-- TODO: Justify global
			jumpframe = false
		elseif (a == "luigi" and b == "resultsfloor") or (b == "luigi" and a == "resultsfloor") then
			-- TODO: Justify global
			jumpframe = false
		end
	end
end

function endblockp1()
	if gameno == 2 then
		for i, v in pairs(tetrishapesp1[counterp1]) do --make shapes pass through the center
			v:setMask(3, 2)
		end
	end
	
	if tetribodiesp1[counterp1]:getY() < losingY then --P1 hit the top
		--FAIL P1--
		-- TODO: Justify global
		p1fail = true
		
		
		if p2fail == true then --Both players have hit the top
			endgame()
		end
	else --P1 didn't hit the top yet
		love.audio.stop(blockfall)
		love.audio.play(blockfall)
		-- TODO: Justify global
		linesscorep1 = linesscorep1 + 1
		-- TODO: Justify global
		scorescorep1 = linesscorep1 * 100
		game_addTetriBmultip1()
	end
end

function endblockp2()
	if gameno == 2 then
		for i, v in pairs(tetrishapesp2[counterp2]) do --make shapes pass through the center
			v:setMask(2, 3)
		end
	end
	
	if tetribodiesp2[counterp2]:getY() < losingY then --P2 hit the top
		--FAIL P2--
		-- TODO: Justify global
		p2fail = true
		
		if p1fail == true then --Both players have hit the top
			endgame()
		end
	else --P2 didn't hit the top yet
		love.audio.stop(blockfall)
		love.audio.play(blockfall)
		-- TODO: Justify global
		linesscorep2 = linesscorep2 + 1
		-- TODO: Justify global
		scorescorep2 = linesscorep2 * 100
		game_addTetriBmultip2()
	end
end

function endgame()
	-- TODO: Justify global
	colorizetimer = love.timer.getTime()
	gamestate = "failingBmulti"
	
	if musicno < 4 then
		love.audio.stop(music[musicno])
	end
	
	love.audio.stop(gameover1)
	love.audio.play(gameover1)
	
	if scorescorep1 > scorescorep2 then
		-- TODO: Justify global
		p1wins = p1wins + 1
		-- TODO: Justify global
		winner = 1
	elseif scorescorep1 < scorescorep2 then
		-- TODO: Justify global
		p2wins = p2wins + 1
		-- TODO: Justify global
		winner = 2
	else
		-- TODO: Justify global
		winner = 3
	end
	if p1wins > 99 then
		-- TODO: Justify global
		p1wins = math.mod(p1wins, 100)
	end
	if p2wins > 99 then
		-- TODO: Justify global
		p2wins = math.mod(p2wins, 100)
	end
end