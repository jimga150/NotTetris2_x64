function gameBmulti_load()
	if musicno < 4 then
		love.audio.stop(music[musicno])
	end
	
	gamestate = "gameBmulti"
	--noinspection GlobalCreationOutsideO
	gamestarted = false
	
	--noinspection GlobalCreationOutsideO
	beeped = { false, false, false }
	
	--figure out the multiplayer scale
	--noinspection GlobalCreationOutsideO
	mpscale = scale
	while game_mp_width_pixels * mpscale > desktopwidth do
		--noinspection GlobalCreationOutsideO
		mpscale = mpscale - 1
	end
	--noinspection GlobalCreationOutsideO
	physicsmpscale = mpscale / physics_scale_factor
	
	--noinspection GlobalCreationOutsideO
	mpfullscreenoffsetX = (desktopwidth - game_mp_width_pixels * mpscale) / 2
	--noinspection GlobalCreationOutsideO
	mpfullscreenoffsetY = (desktopheight - game_height_pixels * mpscale) / 2
	
	if not fullscreen then
		love.graphics.setMode(game_mp_width_pixels * mpscale, game_height_pixels * mpscale, fullscreen, vsync, fsaa)
	end
	
	--nextpieces
	--noinspection GlobalCreationOutsideO
	nextpieceimgmp = {}
	for i = 1, 7 do
		nextpieceimgmp[i] = newPaddedImage("graphics/pieces/" .. i .. ".png", mpscale)
	end
	
	--noinspection GlobalCreationOutsideO
	difficulty_speed = 100
	
	--noinspection GlobalCreationOutsideO
	p1fail = false
	--noinspection GlobalCreationOutsideO
	p2fail = false
	
	--noinspection GlobalCreationOutsideO
	p1color = { 255, 50, 50 }
	--noinspection GlobalCreationOutsideO
	p2color = { 50, 255, 50 }
	
	--p1color = {116, 92, 73}
	--p2color = {209, 174, 145}
	
	--noinspection GlobalCreationOutsideO
	scorescorep1 = 0
	--noinspection GlobalCreationOutsideO
	linesscorep1 = 0
	
	--noinspection GlobalCreationOutsideO
	scorescorep2 = 0
	--noinspection GlobalCreationOutsideO
	linesscorep2 = 0
	
	--noinspection GlobalCreationOutsideO
	counterp1 = 0 --first piece is 1
	--noinspection GlobalCreationOutsideO
	counterp2 = 0 --first piece is 1
	
	--noinspection GlobalCreationOutsideO
	tetrikindp1 = {}
	--noinspection GlobalCreationOutsideO
	tetriimagedatap1 = {}
	--noinspection GlobalCreationOutsideO
	tetriimagesp1 = {}
	
	--noinspection GlobalCreationOutsideO
	tetrikindp2 = {}
	--noinspection GlobalCreationOutsideO
	tetriimagedatap2 = {}
	--noinspection GlobalCreationOutsideO
	tetriimagesp2 = {}
	
	--noinspection GlobalCreationOutsideO
	randomtable = {}
	--noinspection GlobalCreationOutsideO
	nextpiecep1 = nil
	--noinspection GlobalCreationOutsideO
	nextpiecep2 = nil
	
	--noinspection GlobalCreationOutsideO
	nextpiecerot = 0
	
	--PHYSICS--
	--noinspection GlobalCreationOutsideO
	meter = 30 -- TODO: rename to pixelspermeter
	--noinspection GlobalCreationOutsideO
	world = love.physics.newWorld(0, -720, 960, 1050, 0, 500, true)
	
	
	--noinspection GlobalCreationOutsideO
	wallshapesp1 = {}
	--noinspection GlobalCreationOutsideO
	tetrishapesp1 = {}
	--noinspection GlobalCreationOutsideO
	tetribodiesp1 = {}
	
	--noinspection GlobalCreationOutsideO
	wallshapesp2 = {}
	--noinspection GlobalCreationOutsideO
	tetrishapesp2 = {}
	--noinspection GlobalCreationOutsideO
	tetribodiesp2 = {}
	
	--WALLS P1--
	--noinspection GlobalCreationOutsideO
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
	--noinspection GlobalCreationOutsideO
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
	--noinspection GlobalCreationOutsideO
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
			--noinspection GlobalCreationOutsideO
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
			--noinspection GlobalCreationOutsideO
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
	--noinspection GlobalCreationOutsideO
	offsetX = 0
	
	--noinspection GlobalCreationOutsideO
	scorestring = tostring(scorescorep1)
	for i = 1, scorestring:len() - 1 do
		--noinspection GlobalCreationOutsideO
		offsetX = offsetX - 8 * mpscale
	end
	love.graphics.print(scorescorep1, 36 * mpscale + offsetX, 24 * mpscale, 0, mpscale)
	
	--"tiles"--
	--noinspection GlobalCreationOutsideO
	offsetX = 0
	
	--noinspection GlobalCreationOutsideO
	scorestring = tostring(linesscorep1)
	for i = 1, scorestring:len() - 1 do
		--noinspection GlobalCreationOutsideO
		offsetX = offsetX - 8 * mpscale
	end
	love.graphics.print(linesscorep1, 28 * mpscale + offsetX, 80 * mpscale, 0, mpscale)
	-----------------------------------------------
	
	--SCORES P2---------------------------------------
	--"score"--
	--noinspection GlobalCreationOutsideO
	offsetX = 0
	
	--noinspection GlobalCreationOutsideO
	scorestring = tostring(scorescorep2)
	for i = 1, scorestring:len() - 1 do
		--noinspection GlobalCreationOutsideO
		offsetX = offsetX - 8 * mpscale
	end
	love.graphics.print(scorescorep2, 262 * mpscale + offsetX, 24 * mpscale, 0, mpscale)
	
	--"tiles"--
	--noinspection GlobalCreationOutsideO
	offsetX = 0
	
	--noinspection GlobalCreationOutsideO
	scorestring = tostring(linesscorep2)
	for i = 1, scorestring:len() - 1 do
		--noinspection GlobalCreationOutsideO
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
	--noinspection GlobalCreationOutsideO
	nextpiecerot = nextpiecerot + nextpiecerotspeed * dt
	while nextpiecerot > math.pi * 2 do
		--noinspection GlobalCreationOutsideO
		nextpiecerot = nextpiecerot - math.pi * 2
	end
	
	world:update(dt)
	--noinspection GlobalCreationOutsideO
	newtime = love.timer.getTime()
	if gamestarted == false then
		if newtime - starttimer > 3 then
			if musicno < 4 then
				love.audio.play(music[musicno])
			end
			startgame()
			--noinspection GlobalCreationOutsideO
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
		--noinspection GlobalCreationOutsideO
		timepassed = love.timer.getTime() - colorizetimer
		if timepassed > colorizeduration then
			gamestate = "failedBmulti"
			
			wallshapesp1["groundp1"]:destroy()
			wallshapesp2["groundp1"]:destroy()
			
			love.audio.stop(gameover2)
			love.audio.play(gameover2)
		end
	elseif gamestate == "failedBmulti" then
		--noinspection GlobalCreationOutsideO
		clearcheck = true
		for i, v in pairs(tetribodiesp1) do
			if v:getY() < 162 * mpscale then
				--noinspection GlobalCreationOutsideO
				clearcheck = false
			end
		end
		
		for i, v in pairs(tetribodiesp2) do
			if v:getY() < 162 * mpscale then
				--noinspection GlobalCreationOutsideO
				clearcheck = false
			end
		end
		
		if clearcheck then --RESULTS SCREEN INI!--
			gamestate = "gameBmulti_results"
			--noinspection GlobalCreationOutsideO
			jumptimer = love.timer.getTime()
			--noinspection GlobalCreationOutsideO
			crytimer = love.timer.getTime()
			
			love.audio.play(musicresults)
			
			--noinspection GlobalCreationOutsideO
			resultsfloorbody = love.physics.newBody(world, 32, -64, 0, 0)
			--noinspection GlobalCreationOutsideO
			resultsfloorshape = love.physics.newPolygonShape(resultsfloorbody, 196, 448, 196, 480, 836, 480, 836, 448)
			resultsfloorshape:setData("resultsfloor")
			
			if winner == 1 then
				--noinspection GlobalCreationOutsideO
				mariobody = love.physics.newBody(world, 388, 320, 0, 0)
				--noinspection GlobalCreationOutsideO
				marioshape = love.physics.newRectangleShape(mariobody, 0, 0, 64, 108)
				marioshape:setMask(3)
				marioshape:setData("mario")
				mariobody:setLinearDamping(0.5)
				mariobody:setMassFromShapes()
			elseif winner == 2 then
				--noinspection GlobalCreationOutsideO
				luigibody = love.physics.newBody(world, 704, 320, 0, 0)
				--noinspection GlobalCreationOutsideO
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
			--noinspection GlobalCreationOutsideO
			jumpframe = true
		end
	elseif gamestate == "gameBmulti_results" then
		--noinspection GlobalCreationOutsideO
		jumptimepassed = love.timer.getTime() - jumptimer
		if jumptimepassed > 2 then
			--noinspection GlobalCreationOutsideO
			jumptimer = love.timer.getTime()
			--noinspection GlobalCreationOutsideO
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
		
		--noinspection GlobalCreationOutsideO
		crytimepassed = love.timer.getTime() - crytimer
		if crytimepassed > 0.4 then
			--noinspection GlobalCreationOutsideO
			cryframe = not cryframe
			--noinspection GlobalCreationOutsideO
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
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = 3
	elseif randomtable[1] == 3 then
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = 2
	elseif randomtable[1] == 5 then
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = 7
	elseif randomtable[1] == 7 then
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = 5
	else
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = randomtable[1]
	end
	
	----------------
	-- FIRST "nextpiece" for p2 (Which gets immediately removed, duh)--

	--noinspection GlobalCreationOutsideO
	nextpiecep2 = randomtable[1]
	
	----------------
	game_addTetriBmultip1()
	game_addTetriBmultip2()
end

function game_addTetriBmultip1()
	--noinspection GlobalCreationOutsideO
	counterp1 = counterp1 + 1
	--NEW BLOCK--
	--noinspection GlobalCreationOutsideO
	randomblockp1 = nextpiecep1
	createtetriBmultip1(randomblockp1, counterp1, 388, blockstartY)
	tetribodiesp1[counterp1]:setLinearVelocity(0, difficulty_speed)
	
	--RANDOMIZE
	if counterp1 > #randomtable then
		table.insert(randomtable, math.random(7))
	end
	--MIRROR PIECES
	if randomtable[counterp1] == 2 then
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = 3
	elseif randomtable[counterp1] == 3 then
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = 2
	elseif randomtable[counterp1] == 5 then
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = 7
	elseif randomtable[counterp1] == 7 then
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = 5
	else
		--noinspection GlobalCreationOutsideO
		nextpiecep1 = randomtable[counterp1]
	end
end

function game_addTetriBmultip2()
	--noinspection GlobalCreationOutsideO
	counterp2 = counterp2 + 1
	--NEW BLOCK--
	--noinspection GlobalCreationOutsideO
	randomblockp2 = nextpiecep2
	createtetriBmultip2(randomblockp2, counterp2, 708, blockstartY)
	tetribodiesp2[counterp2]:setLinearVelocity(0, difficulty_speed)
	
	--RANDOMIZE
	if counterp2 > #randomtable then
		table.insert(randomtable, math.random(7))
	end
	--noinspection GlobalCreationOutsideO
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
			--noinspection GlobalCreationOutsideO
			jumpframe = false
		elseif (a == "luigi" and b == "resultsfloor") or (b == "luigi" and a == "resultsfloor") then
			--noinspection GlobalCreationOutsideO
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
		--noinspection GlobalCreationOutsideO
		p1fail = true
		
		
		if p2fail == true then --Both players have hit the top
			endgame()
		end
	else --P1 didn't hit the top yet
		love.audio.stop(blockfall)
		love.audio.play(blockfall)
		--noinspection GlobalCreationOutsideO
		linesscorep1 = linesscorep1 + 1
		--noinspection GlobalCreationOutsideO
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
		--noinspection GlobalCreationOutsideO
		p2fail = true
		
		if p1fail == true then --Both players have hit the top
			endgame()
		end
	else --P2 didn't hit the top yet
		love.audio.stop(blockfall)
		love.audio.play(blockfall)
		--noinspection GlobalCreationOutsideO
		linesscorep2 = linesscorep2 + 1
		--noinspection GlobalCreationOutsideO
		scorescorep2 = linesscorep2 * 100
		game_addTetriBmultip2()
	end
end

function endgame()
	--noinspection GlobalCreationOutsideO
	colorizetimer = love.timer.getTime()
	gamestate = "failingBmulti"
	
	if musicno < 4 then
		love.audio.stop(music[musicno])
	end
	
	love.audio.stop(gameover1)
	love.audio.play(gameover1)
	
	if scorescorep1 > scorescorep2 then
		--noinspection GlobalCreationOutsideO
		p1wins = p1wins + 1
		--noinspection GlobalCreationOutsideO
		winner = 1
	elseif scorescorep1 < scorescorep2 then
		--noinspection GlobalCreationOutsideO
		p2wins = p2wins + 1
		--noinspection GlobalCreationOutsideO
		winner = 2
	else
		--noinspection GlobalCreationOutsideO
		winner = 3
	end
	if p1wins > 99 then
		--noinspection GlobalCreationOutsideO
		p1wins = math.mod(p1wins, 100)
	end
	if p2wins > 99 then
		--noinspection GlobalCreationOutsideO
		p2wins = math.mod(p2wins, 100)
	end
end