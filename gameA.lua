function gameA_load()
    --noinspection GlobalCreationOutsideO
    gamestate = "gameA"
    
    --noinspection GlobalCreationOutsideO
	pause = false
    --noinspection GlobalCreationOutsideO
	skipupdate = true
    
    --noinspection GlobalCreationOutsideO
	difficulty_speed = 100
    
    --noinspection GlobalCreationOutsideO
	cuttingtimer = lineclearduration
    
    --noinspection GlobalCreationOutsideO
	scorescore = 0
    --noinspection GlobalCreationOutsideO
	levelscore = 0
    --noinspection GlobalCreationOutsideO
	linesscore = 0
    
    --noinspection GlobalCreationOutsideO
	linescleared = 0
    --noinspection GlobalCreationOutsideO
	lastscoreadd = 0
	--noinspection GlobalCreationOutsideO
	scoreaddtimer = scoreaddtime
	--noinspection GlobalCreationOutsideO
	densityupdatetimer = 0
	--noinspection GlobalCreationOutsideO
	nextpiecerot = 0
	--noinspection GlobalCreationOutsideO
	newlevelbeep = false
	
	--PHYSICS--
	--noinspection GlobalCreationOutsideO
	meter = 30 --TODO: set this in main.lua and rename to pixelspermeter
	--noinspection GlobalCreationOutsideO
	world = love.physics.newWorld(0, 500, true)
	-- world = love.physics.newWorld(0, -720, 960, 1050, 0, 500, true )
	
	--noinspection GlobalCreationOutsideO
	tetrikind = {}
	--noinspection GlobalCreationOutsideO
	wallshapes = {}
	--noinspection GlobalCreationOutsideO
	tetrifixtures = {}
	--noinspection GlobalCreationOutsideO
	tetribodies = {}
	--noinspection GlobalCreationOutsideO
	offsetshapes = {}
	--noinspection GlobalCreationOutsideO
	tetrifixturescopy = {}
	--noinspection GlobalCreationOutsideO
	data = {}
	
	--noinspection GlobalCreationOutsideO
	wallbodies = love.physics.newBody(world, 32, -64, "static") --WALLS
	wallshapes["left"] = love.physics.newFixture(wallbodies,
		love.physics.newPolygonShape(-8, -64, -8, 672, 24, 672, 24, -64),
		1)
	wallshapes["left"]:setUserData({ "left" })
	wallshapes["left"]:setFriction(0.00001)
	wallshapes["right"] = love.physics.newFixture(wallbodies,
		love.physics.newPolygonShape(352, -64, 352, 672, 384, 672, 384, -64),
		1)
	wallshapes["right"]:setUserData({ "right" })
	wallshapes["right"]:setFriction(0.00001)
	wallshapes["ground"] = love.physics.newFixture(wallbodies,
		love.physics.newPolygonShape(24, 640, 24, 672, 352, 672, 352, 640),
		1)
	wallshapes["ground"]:setUserData({ "ground" })
	wallshapes["ceiling"] = love.physics.newFixture(wallbodies,
		love.physics.newPolygonShape(-8, -96, 384, -96, 384, -64, -8, -64),
		1)
	wallshapes["ceiling"]:setUserData({ "ceiling" })
	
	world:setCallbacks(collideA)
	-----------
	
	--FIRST "nextpiece"-
	--noinspection GlobalCreationOutsideO
	nextpiece = math.random(7)
	
	checklinedensity(false)
	game_addTetriA()

	--noinspection GlobalCreationOutsideO
	nextpiece = math.random(7)
	----------------
end

function game_addTetriA() --creates new block (using createtetriA) at 1 and sets its velocity
	--NEW BLOCK--
	local randomblock = nextpiece
	createtetriA(randomblock, 1, 224, blockstartY)
	tetribodies[1]:setLinearVelocity(0, difficulty_speed)
end

function createtetriA(i, uniqueid, x, y) --creates block, including body, shapes, image, imagedata and whatnot.
	
	tetriimagedata[uniqueid] = newImageData("graphics/pieces/" .. i .. ".png", scale)
	tetriimages[uniqueid] = padImagedata(tetriimagedata[uniqueid])
	tetrikind[uniqueid] = i
	tetrifixtures[uniqueid] = {}
	tetribodies[uniqueid] = love.physics.newBody(world, x, y, "dynamic")
	
	if i == 1 then --I
		tetrifixtures[uniqueid][1] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-48, 0, 32, 32), 1)
		tetrifixtures[uniqueid][2] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-16, 0, 32, 32), 1)
		tetrifixtures[uniqueid][3] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(16, 0, 32, 32), 1)
		tetrifixtures[uniqueid][4] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(48, 0, 32, 32), 1)
	
	elseif i == 2 then --J
		tetrifixtures[uniqueid][1] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-32, -16, 32, 32), 1)
		tetrifixtures[uniqueid][2] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(0, -16, 32, 32), 1)
		tetrifixtures[uniqueid][3] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(32, -16, 32, 32), 1)
		tetrifixtures[uniqueid][4] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(32, 16, 32, 32), 1)
	
	elseif i == 3 then --L
		tetrifixtures[uniqueid][1] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-32, -16, 32, 32), 1)
		tetrifixtures[uniqueid][2] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(0, -16, 32, 32), 1)
		tetrifixtures[uniqueid][3] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(32, -16, 32, 32), 1)
		tetrifixtures[uniqueid][4] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-32, 16, 32, 32), 1)
	
	elseif i == 4 then --O
		tetrifixtures[uniqueid][1] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-16, -16, 32, 32), 1)
		tetrifixtures[uniqueid][2] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-16, 16, 32, 32), 1)
		tetrifixtures[uniqueid][3] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(16, 16, 32, 32), 1)
		tetrifixtures[uniqueid][4] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(16, -16, 32, 32), 1)
	
	elseif i == 5 then --S
		tetrifixtures[uniqueid][1] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-32, 16, 32, 32), 1)
		tetrifixtures[uniqueid][2] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(0, -16, 32, 32), 1)
		tetrifixtures[uniqueid][3] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(32, -16, 32, 32), 1)
		tetrifixtures[uniqueid][4] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(0, 16, 32, 32), 1)
	
	elseif i == 6 then --T
		tetrifixtures[uniqueid][1] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-32, -16, 32, 32), 1)
		tetrifixtures[uniqueid][2] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(0, -16, 32, 32), 1)
		tetrifixtures[uniqueid][3] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(32, -16, 32, 32), 1)
		tetrifixtures[uniqueid][4] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(0, 16, 32, 32), 1)
	
	elseif i == 7 then --Z
		tetrifixtures[uniqueid][1] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(0, 16, 32, 32), 1)
		tetrifixtures[uniqueid][2] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(0, -16, 32, 32), 1)
		tetrifixtures[uniqueid][3] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(32, 16, 32, 32), 1)
		tetrifixtures[uniqueid][4] = love.physics.newFixture(tetribodies[uniqueid], love.physics.newRectangleShape(-32, -16, 32, 32), 1)
	end
	tetribodies[uniqueid]:setLinearDamping(0.5)
	-- tetribodies[uniqueid]:setMassFromShapes()
	tetribodies[uniqueid] = calcMassInertia(tetrifixtures[uniqueid], tetribodies[uniqueid])
	tetribodies[uniqueid]:setBullet(true)
	
	for i, v in pairs(tetrifixtures[uniqueid]) do
		v:setUserData({ 1 })
	end
end

function calcMassInertia(fixtureArray, body)
	local totalInertia = 0
	local totalMass = 0
	local center_x = 0
	local center_y = 0
	
	for i, fixture in pairs(fixtureArray) do
		-- print(shape)
		local x, y, mass, inertia = fixture:getShape():computeMass(1)
		totalInertia = totalInertia + inertia + mass * math.sqrt(x * x, y * y)
		totalMass = totalMass + mass
		center_x = center_x + mass * x
		center_y = center_y + mass * y
	end
	
	center_x = center_x / totalMass
	center_y = center_y / totalMass
	
	-- adjust inertia for true center of mass
	totalInertia = totalInertia - totalMass * (center_x * center_x + center_y * center_y)
	
	body:setMassData(center_x, center_y, totalMass, totalInertia)
	return body
end

function gameA_draw()
	--FULLSCREEN OFFSET
	if fullscreen then
		love.graphics.translate(fullscreenoffsetX, fullscreenoffsetY)
		
		--scissor
		love.graphics.setScissor(fullscreenoffsetX, fullscreenoffsetY, 160 * scale, 144 * scale)
	end
	
	--background--
	love.graphics.draw(gamebackgroundcutoff, 0, 0, 0, scale, scale)
	---------------
	-- tetrifixtures--
	if cuttingtimer == lineclearduration then
		for i, v in pairs(tetribodies) do
			if pause == false then
				love.graphics.draw(tetriimages[i], v:getX() * physicsscale, v:getY() * physicsscale, v:getAngle(), 1, 1, piececenter[tetrikind[i]][1] * scale, piececenter[tetrikind[i]][2] * scale)
			end
		end
	else
		for i = 1, #tetricutimg do
			if pause == false then
				love.graphics.draw(tetricutimg[i], tetricutpos[i * 2 - 1] * physicsscale, tetricutpos[i * 2] * physicsscale, tetricutang[i], 1, 1, piececenter[tetricutkind[i]][1] * scale, piececenter[tetricutkind[i]][2] * scale)
			end
		end
		
		--blinky lines
		
		local section = math.ceil(cuttingtimer / (lineclearduration / lineclearblinks))
		if math.mod(section, 2) == 1 or cuttingtimer == 0 then
			
			local rr, rg, rb = unpack(getrainbowcolor(hue))
			local r = 145 + rr * 64
			local g = 145 + rg * 64
			local b = 145 + rb * 64
			
			for i = 1, 18 do
				if linesremoved[i] == true then
					love.graphics.setColor(r, g, b)
					
					love.graphics.rectangle("fill", 14 * scale, (i - 1) * 8 * scale, 82 * scale, 8 * scale)
				end
			end
		end
	end
	
	love.graphics.setColor(255, 255, 255)
	--Next piece
	if pause == false then
		love.graphics.draw(nextpieceimg[nextpiece], 136 * scale, 120 * scale, nextpiecerot, 1, 1, piececenterpreview[nextpiece][1] * scale, piececenterpreview[nextpiece][2] * scale)
	end
	
	----------------
	-- Last score
	if scoreaddtimer < scoreaddtime then
		if fullscreen then
			love.graphics.setScissor(105 * scale + fullscreenoffsetX, 35 * scale + fullscreenoffsetY, 55 * scale, 9 * scale)
		else
			love.graphics.setScissor(105 * scale, 35 * scale, 55 * scale, 9 * scale)
		end
		
		love.graphics.setFont(whitefont)
		
		local offsetX = 0
		for i = 1, tostring(lastscoreadd):len() - 1 do
			offsetX = offsetX - 8 * scale
		end
		
		love.graphics.print("+" .. lastscoreadd, 136 * scale + offsetX, 36 * scale - scoreaddtimer / scoreaddtime * 8 * scale, 0, scale)
		
		love.graphics.setFont(tetrisfont)
		
		if fullscreen then
			love.graphics.setScissor(fullscreenoffsetX, fullscreenoffsetY, 160 * scale, 144 * scale)
		else
			love.graphics.setScissor()
		end
	end
	
	
	--line density counter
	for i = 1, 18 do
		local fullness = linearea[i] / 1024 / linecleartreshold
		if fullness > 1 then
			fullness = 1
		end
		
		local color
		if fullness == 1 then
			color = 0
		else
			color = 235 - (fullness / 1) * 180
		end
		
		love.graphics.setColor(color, color, color)
		love.graphics.rectangle("fill", 0, (i - 1) * 8 * scale, math.floor(6 * scale * fullness), 8 * scale)
	end
	
	love.graphics.setColor(255, 255, 255)
	
	---------
	-- start--
	if pause == true then
		love.graphics.draw(pausegraphiccutoff, 14 * scale, 0, 0, scale, scale)
	end
	---------
	
	--SCORES---------------------------------------
	--"score"--
	local offsetX = 0
	
	local scorestring = tostring(scorescore)
	for i = 1, scorestring:len() - 1 do
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(scorescore, 144 * scale + offsetX, 24 * scale, 0, scale, scale)
	
	
	--"level"--
	offsetX = 0
	
	scorestring = tostring(levelscore)
	for i = 1, scorestring:len() - 1 do
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(levelscore, 136 * scale + offsetX, 56 * scale, 0, scale, scale)
	
	--"tiles"--
	offsetX = 0
	
	scorestring = tostring(linesscore)
	for i = 1, scorestring:len() - 1 do
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(linesscore, 136 * scale + offsetX, 80 * scale, 0, scale, scale)
	-----------------------------------------------
	
	
	--FULLSCREEN OFFSET
	if fullscreen then
		love.graphics.translate(-fullscreenoffsetX, -fullscreenoffsetY)
		
		--scissor
		love.graphics.setScissor()
	end
end

function gameA_update(dt)
	--NEXTPIECE ROTATION (rotating allday erryday)
	if cuttingtimer == lineclearduration then
		--noinspection GlobalCreationOutsideO
		nextpiecerot = nextpiecerot + nextpiecerotspeed * dt
		while nextpiecerot > math.pi * 2 do
			--noinspection GlobalCreationOutsideO
			nextpiecerot = nextpiecerot - math.pi * 2
		end
	end
	
	--CUTTING TIMER
	if cuttingtimer < lineclearduration then
		--noinspection GlobalCreationOutsideO
		cuttingtimer = cuttingtimer + dt
		if cuttingtimer >= lineclearduration then
			--RANDOMIZE NEXT PIECE
			--noinspection GlobalCreationOutsideO
			nextpiece = math.random(7)
			
			--noinspection GlobalCreationOutsideO
			cuttingtimer = lineclearduration
			--noinspection GlobalCreationOutsideO
			skipupdate = true
			--noinspection GlobalCreationOutsideO
			scoreaddtimer = 0
			
			if newlevelbeep then
				love.audio.stop(newlevel)
				love.audio.play(newlevel)
				--noinspection GlobalCreationOutsideO
				newlevelbeep = false
			end
		end
		return
	end
	
	--SCOREADD TIMER
	if cuttingtimer == lineclearduration then
		if scoreaddtimer < scoreaddtime then
			--noinspection GlobalCreationOutsideO
			scoreaddtimer = scoreaddtimer + dt
			if scoreaddtimer > scoreaddtime then
				--noinspection GlobalCreationOutsideO
				scoreaddtimer = scoreaddtime
			end
		end
	end
	
	if gamestate == "gameA" then
		if love.keyboard.isDown("x") then
			if tetribodies[1]:getAngularVelocity() < 3 then
				tetribodies[1]:applyTorque(blocktorque)
			end
		end
		if love.keyboard.isDown("y") or love.keyboard.isDown("z") or love.keyboard.isDown("w") then
			if tetribodies[1]:getAngularVelocity() > -3 then
				tetribodies[1]:applyTorque(-blocktorque)
			end
		end
		
		if love.keyboard.isDown("left") then
			local x, y = tetribodies[1]:getWorldCenter()
			tetribodies[1]:applyForce(-blocklatforce, 0, x, y)
		end
		if love.keyboard.isDown("right") then
			local x, y = tetribodies[1]:getWorldCenter()
			tetribodies[1]:applyForce(blocklatforce, 0, x, y)
		end
		
		local x, y = tetribodies[1]:getLinearVelocity()
		if love.keyboard.isDown("down") then
			--commented part limits the blackfallspeed
			if y > 500 then
				tetribodies[1]:setLinearVelocity(x, 500)
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
	
	--get updated by world:update
	--noinspection GlobalCreationOutsideO
	endblock = false
	
	world:update(dt)
	
	if endblock then
		endblockA()
	end
	
	
	--DENSITY UPDATE TIMER
	if densityupdatetimer >= densityupdateinterval then
		while densityupdatetimer >= densityupdateinterval and cuttingtimer == lineclearduration do
			checklinedensity(false)
			--noinspection GlobalCreationOutsideO
			densityupdatetimer = densityupdatetimer - densityupdateinterval
		end
	end
	--noinspection GlobalCreationOutsideO
	densityupdatetimer = densityupdatetimer + dt
	
	if gamestate == "failingA" then
		local clearcheck = true
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

function getintersectX(shape, y) --returns left and right collision points to a certain shape on a Y coordinate (or -1, -0.9 if no collision)
	local xn, yn, leftfraction = shape:rayCast(55, y, 385, y, 1, 0, 0, 0)
	local xn, yn, rightfraction = shape:rayCast(55, y, 385, y, 1, 0, 0, 0)
	
	if leftfraction ~= nil and rightfraction ~= nil then
		local leftx = 330 * leftfraction + 55
		local rightx = 385 - 330 * rightfraction
		return leftx, rightx
	else
		return -1, -0.9
	end
end

function removeline(lineno) --Does all necessary things to clear a line. Refineshape and cutimage included.
	local upperline = (lineno - 1) * 32
	local lowerline = lineno * 32
	local coordinateproperties = {}
	local numberofbodies = highestbody()
	local ioffset = 0
	tetribodies[1] = "dummy :D"
	for i = 2, numberofbodies do --every body
		local v = tetribodies[i - ioffset] --TODO: rename this
		if i - ioffset > numberofbodies then
			print("oh yeah")
			break
		end
		if i - ioffset > 1 then
			local refined = false
			coordinateproperties[i - ioffset] = {}
			--noinspection GlobalCreationOutsideO
			tetrifixturescopy = {}
			
			local upperleftx = 640
			local lowerleftx = 640
			
			local upperrightx = 0
			local lowerrightx = 0
			for j, w in pairs(tetrifixtures[i - ioffset]) do
				local x1, x2 = getintersectX(tetrifixtures[i - ioffset][j]:getShape(), upperline)
				
				if x1 < upperleftx and x1 ~= -1 then
					upperleftx = x1
				end
				if x2 > upperrightx then
					upperrightx = x2
				end
				
				x1, x2 = getintersectX(tetrifixtures[i - ioffset][j]:getShape(), lowerline)
				
				if x1 < lowerleftx and x1 ~= -1 then
					lowerleftx = x1
				end
				if x2 > lowerrightx then
					lowerrightx = x2
				end
			end
			
			for j, w in pairs(tetrifixtures[i - ioffset]) do --Every shape
				local above = false
				local inside = false
				local below = false
				coordinateproperties[i - ioffset][j] = {}
				local coordinates = getPoints2table(w:getShape())
				
				for y = 1, #coordinates, 2 do --Every Point
					if coordinates[y + 1] < upperline then --POINT ABOVE CUTRECT
						coordinateproperties[i - ioffset][j][math.ceil(y / 2)] = 1
						above = true
					elseif coordinates[y + 1] >= upperline and coordinates[y + 1] <= lowerline then --POINT INSIDE CUTRECT!
						coordinateproperties[i - ioffset][j][math.ceil(y / 2)] = 2
						inside = true
					elseif coordinates[y + 1] > lowerline then --POINT BELOW CUTRECT
						coordinateproperties[i - ioffset][j][math.ceil(y / 2)] = 3
						below = true
					end
				end
				if above == true and inside == true and below == false then
					tetrifixturescopy[#tetrifixturescopy + 1] = refineshape(upperline, 1, i - ioffset, v, j, w:getShape())
					refined = true
				elseif above == true and inside == true and below == true then
					tetrifixturescopy[#tetrifixturescopy + 1] = refineshape(upperline, 1, i - ioffset, v, j, w:getShape())
					tetrifixturescopy[#tetrifixturescopy + 1] = refineshape(lowerline, -1, i - ioffset, v, j, w:getShape())
					refined = true
				elseif above == false and inside == true and below == false then
					--nothing because it'll get removed (don't delete the elseif though cause it'll go though the "else")
					refined = true
				elseif above == false and inside == true and below == true then
					tetrifixturescopy[#tetrifixturescopy + 1] = refineshape(lowerline, -1, i - ioffset, v, j, w:getShape())
					refined = true
				elseif above == true and inside == false and below == true then
					tetrifixturescopy[#tetrifixturescopy + 1] = refineshape(upperline, 1, i - ioffset, v, j, w:getShape())
					tetrifixturescopy[#tetrifixturescopy + 1] = refineshape(lowerline, -1, i - ioffset, v, j, w:getShape())
					refined = true
				else
					local cotable = getPoints2table(tetrifixtures[i - ioffset][j]:getShape())
					for var = 1, #cotable, 2 do
						cotable[var], cotable[var + 1] = tetribodies[i - ioffset]:getLocalPoint(cotable[var], cotable[var + 1])
					end
					tetrifixturescopy[#tetrifixturescopy + 1] = love.physics.newFixture(tetribodies[i - ioffset], love.physics.newPolygonShape(unpack(cotable)), 1)
				end
			end
			if refined == true then
				
				--create for either above our below; or both if body is cut in center.
				--gotta set the bodyids here and reuse them in the "check for disconnect shapes" further down
				for a, b in pairs(tetrifixtures[i - ioffset]) do --remove all shapes
					tetrifixtures[i - ioffset][a]:destroy()
					tetrifixtures[i - ioffset][a] = nil
				end
				
				tetrifixtures[i - ioffset] = {}
				
				if #tetrifixturescopy == 0 then --body empty
					tetribodies[i - ioffset]:destroy()
					table.remove(tetribodies, i - ioffset)
					table.remove(tetrifixtures, i - ioffset)
					table.remove(tetrikind, i - ioffset)
					table.remove(tetriimages, i - ioffset)
					table.remove(tetriimagedata, i - ioffset)
					numberofbodies = numberofbodies - 1
					ioffset = ioffset + 1
				else
					
					--- -check for disconnected shapes
					-- apply group numbers to shapes then loop through each existing value, creating a new body for everything > 1 (max should be 3 I think).
					local shapegroups = {}
					local numberofgroups = 0
					for a, b in pairs(tetrifixturescopy) do --through all shapes
						shapegroups[a] = 0
						local currentcoords = getPoints2table(b:getShape())
						for shapecounter = 1, a - 1 do --Through all previously set groups
                            --print("accessing fixture at ", shapecounter)
							local coords = getPoints2table(tetrifixturescopy[shapecounter]:getShape())
                            --print("Does exist")
							for currentcoordsvar = 1, #currentcoords / 2 do --through all coords in the current shape
								for coordsvar = 1, #coords / 2 do --through all coords in all previously set groups (Holy shit 6 stacked "for" loops; I code like an asshole!)
									if math.abs(currentcoords[currentcoordsvar * 2 - 1] - coords[coordsvar * 2 - 1]) < 2 and math.abs(currentcoords[currentcoordsvar * 2] - coords[coordsvar * 2]) < 2 then
										shapegroups[a] = shapegroups[shapecounter]
									end
								end
							end
						end
						
						if shapegroups[a] == 0 then --create new group
							numberofgroups = numberofgroups + 1
							shapegroups[a] = numberofgroups
						end
					end
					
					--All shapes have now an assigned group number in "shapegroups[shape] = groupnumber" :) yay.
					
					for a = 1, numberofgroups do
						if a == 1 then --reassign the old bodyid
							local rotation = tetribodies[i - ioffset]:getAngle()
							local bodyx, bodyy, bodymass = tetribodies[i - ioffset]:getX(), tetribodies[i - ioffset]:getY(), tetribodies[i - ioffset]:getMass()
							tetribodies[i - ioffset]:destroy()
							tetribodies[i - ioffset] = love.physics.newBody(world, bodyx, bodyy, "dynamic")
							tetribodies[i - ioffset]:setAngle(rotation)
							tetribodies[i - ioffset]:setMass(bodymass)
							tetrifixtures[i - ioffset] = {}
							for b, c in pairs(tetrifixturescopy) do
								if shapegroups[b] == a then
                                    --print("accessing fixture at ", b)
									local cotable = getPoints2table(tetrifixturescopy[b]:getShape()) -- TODO: destroyed fixture here
                                    --print("does exist")
									for var = 1, #cotable, 2 do
										cotable[var], cotable[var + 1] = tetribodies[i - ioffset]:getLocalPoint(cotable[var], cotable[var + 1])
									end
									tetrifixtures[i - ioffset][#tetrifixtures[i - ioffset] + 1] = love.physics.newFixture(tetribodies[i - ioffset],
										love.physics.newPolygonShape(unpack(cotable)),
										1)
									tetrifixtures[i - ioffset][#tetrifixtures[i - ioffset]]:setUserData({ i - ioffset }) --set the shape name for collision
								end
							end
							
							--TODO: figure out the max scope that this variable is needed
							--save old imagedata to local var first in case we create a new bodyid..
							backupimagedata = love.image.newImageData(tetriimagedata[i - ioffset]:getWidth(), tetriimagedata[i - ioffset]:getHeight())
							backupimagedata:paste(tetriimagedata[i - ioffset], 0, 0, 0, 0, tetriimagedata[i - ioffset]:getWidth(), tetriimagedata[i - ioffset]:getHeight())
							
							--cut the image.
							cutimage(i - ioffset, numberofgroups)
							
							--mass confusion
							tetribodies[i - ioffset]:setMassFromShapes()
							
							local mass = tetribodies[i - ioffset]:getMass()
							if mass < minmass then
								for i, v in pairs(tetrifixtures[i - ioffset]) do
									v:setDensity(minmass / mass)
								end
								
								tetribodies[i - ioffset]:setMassFromShapes()
								
								for i, v in pairs(tetrifixtures[i - ioffset]) do
									v:setDensity(1)
								end
							end
						
						else --create new bodyid
							tetribodies[highestbody() + 1] = love.physics.newBody(world, tetribodies[i - ioffset]:getX(), tetribodies[i - ioffset]:getY(), tetribodies[i - ioffset]:getMass(), blockrot)
							tetribodies[highestbody()]:setAngle(tetribodies[i - ioffset]:getAngle())
							tetrifixtures[highestbody()] = {}
							
							for b, c in pairs(tetrifixturescopy) do
								if shapegroups[b] == a then
									local cotable = getPoints2table(tetrifixturescopy[b]:getShape())
									for var = 1, #cotable, 2 do
										cotable[var], cotable[var + 1] = tetribodies[i - ioffset]:getLocalPoint(cotable[var], cotable[var + 1])
									end
									tetrifixtures[highestbody()][#tetrifixtures[highestbody()] + 1] = love.physics.newFixture(tetribodies[highestbody()],
										love.physics.newPolygonShape(unpack(cotable)),
										1)
									tetrifixtures[highestbody()][#tetrifixtures[highestbody()]]:setUserData({ highestbody() }) --set the shape name for collision
								end
							end
							
							local linearspeedX, linearspeedY = tetribodies[i - ioffset]:getLinearVelocity()
							tetribodies[highestbody()]:setLinearVelocity(linearspeedX, linearspeedY)
							tetribodies[highestbody()]:setLinearDamping(0.5)
							tetribodies[highestbody()]:setBullet(true)
							tetribodies[highestbody()]:setAngularVelocity(tetribodies[i - ioffset]:getAngularVelocity())
							
							tetriimagedata[highestbody()] = love.image.newImageData(backupimagedata:getWidth(), backupimagedata:getHeight())
							tetriimagedata[highestbody()]:paste(backupimagedata, 0, 0, 0, 0, backupimagedata:getWidth(), backupimagedata:getHeight())
							tetriimages[highestbody()] = padImagedata(tetriimagedata[highestbody()])
							tetrikind[highestbody()] = tetrikind[i - ioffset]
							
							local debugimagedata = love.image.newImageData(backupimagedata:getWidth(), backupimagedata:getHeight())
							debugimagedata:paste(backupimagedata, 0, 0, 0, 0, backupimagedata:getWidth(), backupimagedata:getHeight())
							debugimage = padImagedata(debugimagedata) --TODO: do we even need this?
							
							--cut the image
							cutimage(highestbody(), numberofgroups)
							
							--mass confusion
							tetribodies[highestbody()]:setMassFromShapes()
							
							local mass = tetribodies[highestbody()]:getMass()
							if mass < minmass then
								for i, v in pairs(tetrifixtures[highestbody()]) do
									v:setDensity(minmass / mass)
								end
								
								tetribodies[highestbody()]:setMassFromShapes()
								
								for i, v in pairs(tetrifixtures[highestbody()]) do
									v:setDensity(1)
								end
							end
						end
					end
				end --if body empty
			end --if refined
			
			--clean up the tables..
			for a, b in pairs(tetrifixturescopy) do
				tetrifixturescopy[a]:destroy()
				tetrifixturescopy[a] = nil
			end
			
			--noinspection GlobalCreationOutsideO
			tetrifixturescopy = {}
		end --if i-ioffset > 1
	end
end

function cutimage(bodyid, numberofgroups) --cuts the image of a body based on its shapes (2nd argument might be obsolete)
	
	local width = tetriimagedata[bodyid]:getWidth()
	local height = tetriimagedata[bodyid]:getHeight()
	
	for y = 0, height - 1 do
		for x = 0, width - 1 do
			
			local dummy1, dummy2 = tetribodies[bodyid]:getWorldPoint((x - width / 2 + .5) * (4 / scale), (y - height / 2 + .5) * (4 / scale))
			local deletepixel = true
			
			for i, v in pairs(tetrifixtures[bodyid]) do
				if v:testPoint(dummy1, dummy2) then
					deletepixel = false
					break
				end
			end
			
			if deletepixel then
				tetriimagedata[bodyid]:setPixel(x, y, 255, 255, 255, 0)
			end
		end
	end
	
	tetriimages[bodyid] = padImagedata(tetriimagedata[bodyid])
end

function refineshape(line, mult, bodyid, body, shapeid, shape) --refines a shape using the old coordinates and the cutting line
	local leftx, rightx = getintersectX(tetrifixtures[bodyid][shapeid]:getShape(), line)
	if leftx ~= -1 then --Not sure what to do if not
		local coords = getPoints2table(tetrifixtures[bodyid][shapeid]:getShape())
		
		--remove all points inside the cutting zone
		local lastcutoff
		local i = 2
		while i <= #coords do
			if coords[i] * mult > line * mult then
				table.remove(coords, i)
				table.remove(coords, i - 1)
				lastcutoff = i
				i = 0
			end
			i = i + 2
		end
		
		--add new points (Only if they aren't identical to existing points)
		if lastcutoff then
			if mult == 1 then
				if samepos(coords, line, leftx) == false then
					table.insert(coords, lastcutoff - 1, leftx)
					table.insert(coords, lastcutoff, line)
				end
				
				if samepos(coords, line, rightx) == false then
					table.insert(coords, lastcutoff - 1, rightx)
					table.insert(coords, lastcutoff, line)
				end
			else
				if samepos(coords, line, rightx) == false then
					table.insert(coords, lastcutoff - 1, rightx)
					table.insert(coords, lastcutoff, line)
				end
				
				if samepos(coords, line, leftx) == false then
					table.insert(coords, lastcutoff - 1, leftx)
					table.insert(coords, lastcutoff, line)
				end
			end
		end
		
		--create the new shape
		if #coords / 2 >= 3 and #coords / 2 <= 8 then --shape still has 3 or more points, and not over 8.
			if largeenough(coords) then
				local newcoords = {}
				for i = 1, #coords, 2 do
					newcoords[i], newcoords[i + 1] = body:getLocalPoint(coords[i], coords[i + 1])
				end
				return love.physics.newPolygonShape(body, unpack(newcoords))
			end
		else
			print("#coords")
		end
	else
		local coords = getPoints2table(tetrifixtures[bodyid][shapeid]:getShape())
		local newcoords = {}
		for i = 1, #coords, 2 do
			newcoords[i], newcoords[i + 1] = body:getLocalPoint(coords[i], coords[i + 1])
		end
		return love.physics.newFixture(body, love.physics.newPolygonShape(unpack(newcoords)), 1)
	end
end

function checklinedensity(active) --checks all 18 lines and, if active == true, calls removeline. Also does scoring, sounds and stuff.
	--loop through every shape and add each area to a nax
	
	linearea = {} --TODO: scope of this one is fucked
	
	for i = 1, 18 do
		linearea[i] = 0
	end
	
	for i = 2, #tetribodies do
		for j, k in pairs(tetrifixtures[i]) do
			local coords = getPoints2table(k:getShape())
			--Get first and last involved line
			local firstline = 19
			local lastline = 0
			
			for point = 2, #coords, 2 do
				if math.ceil(round(coords[point]) / 32) < firstline then
					firstline = math.ceil(round(coords[point]) / 32)
				elseif math.ceil(round(coords[point]) / 32) > lastline then
					lastline = math.ceil(round(coords[point]) / 32)
				end
			end
			
			for line = firstline, lastline do
				if line >= 1 and line <= 18 then
					coords = getPoints2table(k:getShape())
					
					local leftx = 0
					local rightx = 0
				
					if line > firstline then
						local offset = 0
						
						repeat
							leftx, rightx = getintersectX(tetrifixtures[i][j]:getShape(), (line - 1) * 32 + offset)
							offset = offset + 1
						until leftx ~= -1 or offset >= 32
						
						--remove all points above the line
						local coi = 2
						local lastcutoff
                        while coi <= #coords do
							if coords[coi] <= (line - 1) * 32 then
								table.remove(coords, coi)
								table.remove(coords, coi - 1)
								lastcutoff = coi
								coi = 0
							end
							coi = coi + 2
						end
						
						--add points of top line (if points were cut off)
						if lastcutoff then
							table.insert(coords, lastcutoff - 1, rightx)
							table.insert(coords, lastcutoff, (line - 1) * 32)
							
							table.insert(coords, lastcutoff - 1, leftx)
							table.insert(coords, lastcutoff, (line - 1) * 32)
						end
					end
					
					if line < lastline then
						local offset = 0
						repeat
							leftx, rightx = getintersectX(tetrifixtures[i][j]:getShape(), (line) * 32 - offset)
							offset = offset + 1
						until leftx ~= -1 or offset >= 32
						
						--remove all points below the line
						local coi = 2
						local lastcutoff
						while coi <= #coords do
							if coords[coi] >= (line) * 32 then
								table.remove(coords, coi)
								table.remove(coords, coi - 1)
								lastcutoff = coi
								coi = 0
							end
							coi = coi + 2
						end
						
						--add points of bottom line (if points were cut off)
						if lastcutoff then
							table.insert(coords, lastcutoff - 1, leftx)
							table.insert(coords, lastcutoff, (line) * 32)
							
							table.insert(coords, lastcutoff - 1, rightx)
							table.insert(coords, lastcutoff, (line) * 32)
						end
					end
					
					linearea[line] = linearea[line] + polygonarea(coords)
				end
			end
		end
	end
	
	if active then
		local removedlines = false
		local numberoflines = 0
		linesremoved = {} --TODO: scope
		
		for i = 1, 18 do
			if linearea[i] > 1024 * linecleartreshold then
				if removedlines == false then
					--noinspection GlobalCreationOutsideO
					cuttingtimer = 0
					removedlines = true
					
					--Save position, image, kind and image of each kind so I can draw them even after changing the actual parts.
					--TODO: scope on all four of these clowns
					tetricutpos = {}
					tetricutang = {}
					tetricutkind = {}
					tetricutimg = {}
					
					for i, v in pairs(tetribodies) do -- = 2, #tetribodies do
						if tetribodies[i].getX then
							table.insert(tetricutpos, tetribodies[i]:getX())
							table.insert(tetricutpos, tetribodies[i]:getY())
							table.insert(tetricutang, tetribodies[i]:getAngle())
							table.insert(tetricutkind, tetrikind[i])
							table.insert(tetricutimg, padImagedata(tetriimagedata[i]))
						end
					end
					
					for j, k in pairs(tetribodies) do
						if k.setLinearVelocity then
							k:setLinearVelocity(0, 0)
							k:setAngularVelocity(0, 0)
						end
					end
				end
				
				linesremoved[i] = true
				numberoflines = numberoflines + 1
				--noinspection GlobalCreationOutsideO
				linesscore = linesscore + 1
			end
		end
		
		if removedlines then
			if numberoflines >= 4 then
				love.audio.stop(fourlineclear)
				love.audio.play(fourlineclear)
			else
				love.audio.stop(lineclear)
				love.audio.play(lineclear)
			end
			
			--Possible scoring functions:
			-- (numberoflines^2*40)+(numberoflines*50)* averagearea^8 (mine)
			-- (NUMOFLINES*3)^(AREA^10)*20+NUMOFLINES^2*40 (murks)
			--old scoring
			--[[
			if numberoflines == 1 then
				scorescore = scorescore + 40
			elseif numberoflines == 2 then
				scorescore = scorescore + 100
			elseif numberoflines == 3 then
				scorescore = scorescore + 300
			elseif numberoflines == 4 then
				scorescore = scorescore + 800
			else
				scorescore = scorescore + numberoflines*300
			end
			]]
			
			--calculate average area
			local averagearea = 0
			for i = 1, 18 do
				if linesremoved[i] then
					averagearea = averagearea + linearea[i]
				end
			end
			averagearea = averagearea / numberoflines / 10240
			
			local scoreadd = math.ceil((numberoflines * 3) ^ (averagearea ^ 10) * 20 + numberoflines ^ 2 * 40)
			--noinspection GlobalCreationOutsideO
			scorescore = scorescore + scoreadd
			
			--noinspection GlobalCreationOutsideO
			lastscoreadd = scoreadd
			--noinspection GlobalCreationOutsideO
			scoreaddtimer = 0
			
			--Level
			--noinspection GlobalCreationOutsideO
			linescleared = linescleared + numberoflines
			
			if math.floor(linescleared / 10) > levelscore then
				--noinspection GlobalCreationOutsideO
				levelscore = levelscore + 1
				--noinspection GlobalCreationOutsideO
				difficulty_speed = 100 + levelscore * 7
				--noinspection GlobalCreationOutsideO
				newlevelbeep = true
			end
			
			--Draw the screen before removing lines.
			love.graphics.clear()
			gameA_draw()
			love.graphics.present()
			
			for i = 1, 18 do
				if linesremoved[i] then
					removeline(i)
				end
			end
		else
			love.audio.stop(blockfall)
			love.audio.play(blockfall)
		end
		
		return removedlines
	end
end

function polygonarea(coords) --calculates the area of a polygon
	--Also written by Adam (see below)
	local anchorX = coords[1]
	local anchorY = coords[2]
	
	local firstX = coords[3]
	local firstY = coords[4]
	
	local area = 0
	
	for i = 5, #coords - 1, 2 do
		local x = coords[i]
		local y = coords[i + 1]
		
		area = area + (math.abs(anchorX * firstY + firstX * y + x * anchorY
				- anchorX * y - firstX * anchorY - x * firstY) / 2)
		
		firstX = x
		firstY = y
	end
	return area
end

function largeenough(coords) --checks if a polygon is good enough for box2d's snobby standards.
	--Written by Adam/earthHunter
	
	-- Calculation of centroids of each triangle
	
	local centroids = {}
	
	local anchorX = coords[1]
	local anchorY = coords[2]
	
	local firstX = coords[3]
	local firstY = coords[4]
	
	for i = 5, #coords - 1, 2 do
		
		local x = coords[i]
		local y = coords[i + 1]
		
		local centroidX = (anchorX + firstX + x) / 3
		local centroidY = (anchorY + firstY + y) / 3
		
		local area = math.abs(anchorX * firstY + firstX * y + x * anchorY
				- anchorX * y - firstX * anchorY - x * firstY) / 2
		
		local index = 3 * (i - 3) / 2 - 2
		
		centroids[index] = area
		centroids[index + 1] = centroidX * area
		centroids[index + 2] = centroidY * area
		
		firstX = x
		firstY = y
	end
	
	-- Calculation of polygon's centroid
	
	local totalArea = 0
	local centroidX = 0
	local centroidY = 0
	
	for i = 1, #centroids - 2, 3 do
		
		totalArea = totalArea + centroids[i]
		centroidX = centroidX + centroids[i + 1]
		centroidY = centroidY + centroids[i + 2]
	end
	
	centroidX = centroidX / totalArea
	centroidY = centroidY / totalArea
	
	-- Calculation of normals
	
	local normals = {}
	
	for i = 1, #coords - 1, 2 do
		
		local i2 = i + 2
		
		if (i2 > #coords) then
			
			i2 = 1
		end
		
		local tangentX = coords[i2] - coords[i]
		local tangentY = coords[i2 + 1] - coords[i + 1]
		local tangentLen = math.sqrt(tangentX * tangentX + tangentY * tangentY)
		
		tangentX = tangentX / tangentLen
		tangentY = tangentY / tangentLen
		
		normals[i] = tangentY
		normals[i + 1] = -tangentX
	end
	
	-- Projection of vertices in the normal directions
	-- in order to obtain the distance from the centroid
	-- to each side
	
	-- If a side is too close, the polygon will crash the game
	
	for i = 1, #coords - 1, 2 do
		
		local projection = (coords[i] - centroidX) * normals[i]
				+ (coords[i + 1] - centroidY) * normals[i + 1]
		
		if (projection < 0.04 * meter) then
			
			return false
		end
	end
	
	return true
end

function highestbody() --returns the highest body in tetribodies. Because without the 1 body, #tetribodies sometimes fails or something
	i = 2
	while tetribodies[i] ~= nil do
		i = i + 1
	end
	return i - 1
end

function samepos(coords, y, x) --checks if any point in a table is identical to another point (THIS SEEMS FISHY, CHECK THIS OUT)
	for j = 1, #coords, 2 do
		if math.abs(coords[j + 1] - y) + math.abs(coords[j] - x) == 0 then
			return true
		end
	end
	return false
end

function collideA(a, b, coll) --box2d callback. calls endblock.
	--Sometimes a is nil or something I have no idea why.
	if a == nil or b == nil then
		return
	end
	
	print(a:getUserData(), b:getUserData())
	print(a:getUserData()[1], b:getUserData()[1])
	
	if a:getUserData()[1] == 1 or b:getUserData()[1] == 1 then
		if a:getUserData()[1] ~= "left" and a:getUserData()[1] ~= "right" and b:getUserData()[1] ~= "left" and b:getUserData()[1] ~= "right" then
			if gamestate == "gameA" then
				if tetribodies[1]:getY() < losingY then
					--noinspection GlobalCreationOutsideO
					gamestate = "failingA"
					if musicno < 4 then
						love.audio.stop(music[musicno])
					end
					love.audio.stop(gameover1)
					love.audio.play(gameover1)
					
					wallshapes["ground"]:destroy()
					wallshapes["ground"] = nil
				else
					tetrikind[highestbody() + 1] = tetrikind[1]
					
					tetriimagedata[highestbody() + 1] = tetriimagedata[1]
					tetriimages[highestbody() + 1] = padImagedata(tetriimagedata[highestbody() + 1])
					
					tetribodies[highestbody() + 1] = tetribodies[1]
					tetribodies[highestbody()]:setLinearDamping(0.5)
					
					tetrifixtures[highestbody()] = {}
					for i, v in pairs(tetrifixtures[1]) do
						tetrifixtures[highestbody()][i] = tetrifixtures[1][i]
						tetrifixtures[highestbody()][i]:setUserData({ highestbody() })
						tetrifixtures[1][i] = nil
					end
					
					tetribodies[1] = nil
					
					--noinspection GlobalCreationOutsideO
					endblock = true
				end
			end
		end
	end
end

function endblockA() --handles failing, moving the current block to the end of the tables and calls checklinedensity in active mode
	if checklinedensity(true) then
		game_addTetriA()
	else
		game_addTetriA()
		--RANDOMIZE NEXT PIECE
		--noinspection GlobalCreationOutsideO
		nextpiece = math.random(7)
	end
end