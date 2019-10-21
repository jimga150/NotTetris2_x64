function menu_load()
	--noinspection GlobalCreationOutsideO
	gamestate = "logo"
	--noinspection GlobalCreationOutsideO
	creditstext = {
		"'Tm and C2011 sy,not",
		"tetris 2 licensed to",
		"  stabyourself.net  ",
		"         and        ",
		"  sub-licensed to   ",
		"      maurice.      ",
		"                    ",
		" C2011 stabyourself ",
		"       dot net.     ",
		"                    ",
		"                    ",
		"all rights reserved.",
		"                    ",
		"  original concept, ",
		" design and program ",
		"by alexey pazhitnov#"
	}
	--noinspection GlobalCreationOutsideO
	logotime = 0
	--noinspection GlobalCreationOutsideO
	bootsoundplayed = false
	--noinspection GlobalCreationOutsideO
	oldtime = love.timer.getTime()
end

function menu_draw()
	--FULLSCREEN OFFSET
	if fullscreen then
		love.graphics.translate(fullscreenoffsetX, fullscreenoffsetY)
	end
	
	if gamestate == "logo" then
		if logotime <= logoduration then
			love.graphics.draw(stabyourselflogo, 7 * scale, math.floor(-22 * scale + 80 * (logotime / logoduration) * scale), 0, scale, scale)
		else
			love.graphics.draw(stabyourselflogo, 7 * scale, math.floor(58 * scale), 0, scale, scale)
		end
	
	elseif gamestate == "credits" then ------------
		for i, v in pairs(creditstext) do
			love.graphics.print(v, 0, i * 8 * scale, 0, scale)
		end
		love.graphics.draw(logo, 32 * scale, 80 * scale, 0, scale)
		------------------------------------------
	
	elseif gamestate == "title" then ----------
		love.graphics.draw(title, 0, 0, 0, scale)
		if playerselection == 1 then
			love.graphics.print(">", 1 * scale, 124 * scale, 0, scale)
		elseif playerselection == 2 then
			love.graphics.print(">", 47 * scale, 124 * scale, 0, scale)
		else
			love.graphics.print(">", 93 * scale, 124 * scale, 0, scale)
		end
		------------------------------------------
	
	elseif gamestate == "menu" or gamestate == "highscoreentry" then
		love.graphics.draw(gametype, 0, 0, 0, scale)
		if selection > 2 then
			if gameno == 1 then
				love.graphics.print("normal", 24 * scale, 26 * scale, 0, scale)
			else
				love.graphics.print("stack ", 88 * scale, 26 * scale, 0, scale)
			end
		else
			if musicno == 1 then
				love.graphics.print("a-type", 24 * scale, 60 * scale, 0, scale)
			elseif musicno == 2 then
				love.graphics.print("b-type", 88 * scale, 60 * scale, 0, scale)
			elseif musicno == 3 then
				love.graphics.print("c-type", 24 * scale, 76 * scale, 0, scale)
			else
				love.graphics.print(" off  ", 88 * scale, 76 * scale, 0, scale)
			end
		end
		
		if selectblink == true then
			if selection == 1 then
				love.graphics.print("normal", 24 * scale, 26 * scale, 0, scale)
			elseif selection == 2 then
				love.graphics.print("stack ", 88 * scale, 26 * scale, 0, scale)
			elseif selection == 3 then
				love.graphics.print("a-type", 24 * scale, 60 * scale, 0, scale)
			elseif selection == 4 then
				love.graphics.print("b-type", 88 * scale, 60 * scale, 0, scale)
			elseif selection == 5 then
				love.graphics.print("c-type", 24 * scale, 76 * scale, 0, scale)
			elseif selection == 6 then
				love.graphics.print(" off  ", 88 * scale, 76 * scale, 0, scale)
			end
		end
		----------------------------------------------
	
	elseif gamestate == "multimenu" then
		love.graphics.draw(mpmenu, 0, 0, 0, scale)
		if selection > 2 then
			if gameno == 1 then
				love.graphics.print("stack", 28 * scale, 47 * scale, 0, scale)
			else
				love.graphics.print("invade", 88 * scale, 47 * scale, 0, scale)
			end
		else
			if musicno == 1 then
				love.graphics.print("a-type", 24 * scale, 81 * scale, 0, scale)
			elseif musicno == 2 then
				love.graphics.print("b-type", 88 * scale, 81 * scale, 0, scale)
			elseif musicno == 3 then
				love.graphics.print("c-type", 24 * scale, 97 * scale, 0, scale)
			else
				love.graphics.print(" off  ", 88 * scale, 97 * scale, 0, scale)
			end
		end
		
		if selectblink == true then
			if selection == 1 then
				love.graphics.print("stack", 28 * scale, 47 * scale, 0, scale)
			elseif selection == 2 then
				love.graphics.print("invade", 88 * scale, 47 * scale, 0, scale)
			elseif selection == 3 then
				love.graphics.print("a-type", 24 * scale, 81 * scale, 0, scale)
			elseif selection == 4 then
				love.graphics.print("b-type", 88 * scale, 81 * scale, 0, scale)
			elseif selection == 5 then
				love.graphics.print("c-type", 24 * scale, 97 * scale, 0, scale)
			elseif selection == 6 then
				love.graphics.print(" off  ", 88 * scale, 97 * scale, 0, scale)
			end
		end
		
		--win counter
		if p1wins < 10 then
			love.graphics.print("0" .. p1wins, 15 * scale, 31 * scale, 0, scale)
		else
			love.graphics.print(p1wins, 15 * scale, 31 * scale, 0, scale)
		end
		
		if p2wins < 10 then
			love.graphics.print("0" .. p2wins, 129 * scale, 31 * scale, 0, scale)
		else
			love.graphics.print(p2wins, 129 * scale, 31 * scale, 0, scale)
		end
	end
	
	if gamestate == "menu" or gamestate == "highscoreentry" then
		for i = 1, 3 do
			if tonumber(highscore[i]) > 0 then
				--name
				love.graphics.print(string.lower(string.sub(highscorename[i], 1, 6)), 33 * scale, 110 * scale + 8 * scale * (i - 1), 0, scale)
				--score
				--noinspection GlobalCreationOutsideO
				offsetX = 0
				for i = 1, string.sub(tostring(highscore[i]), 1, 6):len() - 1 do
					--noinspection GlobalCreationOutsideO
					offsetX = offsetX - 8 * scale
				end
				love.graphics.print(string.sub(tostring(highscore[i]), 1, 6), 137 * scale + offsetX, 110 * scale + 8 * scale * (i - 1), 0, scale)
			end
		end
	end
	
	if gamestate == "highscoreentry" then
		if highscorename[highscoreno]:len() < 6 then
			--noinspection GlobalCreationOutsideO
			offsetX = 0
			for i = 1, highscorename[highscoreno]:len() do
				--noinspection GlobalCreationOutsideO
				offsetX = offsetX + 8 * scale
			end
			if cursorblink == true then
				love.graphics.print("_", 33 * scale + offsetX, 110 * scale + 8 * scale * (highscoreno - 1), 0, scale)
			else
				love.graphics.print(" ", 33 * scale + offsetX, 110 * scale + 8 * scale * (highscoreno - 1), 0, scale)
			end
		else
			if cursorblink == true then
				love.graphics.print("_", 33 * scale + 8 * scale * 5, 110 * scale + 8 * scale * (highscoreno - 1), 0, scale)
			end
		end
	end
	
	if gamestate == "options" then
		love.graphics.draw(optionsmenu, 0, 0, 0, scale, scale)
		love.graphics.draw(rainbowgradient, 73 * scale, 33 * scale, 0, scale, scale)
		
		--volume slider
		love.graphics.draw(volumeslider, 71 * scale + round(76 * volume) * scale, 15 * scale, 0, scale, scale)
		
		--hue slider
		love.graphics.draw(volumeslider, 71 * scale + round(76 * hue * scale), 31 * scale, 0, scale, scale)
		
		--blend out unavailable scales
		for i = 2, 7 do
			if i > maxscale then
				love.graphics.print(" ", 75 * scale + (i - 1) * 11 * scale, 50 * scale, 0, scale)
			end
		end
		
		--current scale
		if fullscreen == false then
			love.graphics.print(scale, 75 * scale + (scale - 1) * 11 * scale, 50 * scale, 0, scale)
		end
		
		--fullscreen
		if fullscreen then
			love.graphics.print("yes", 96 * scale, 66 * scale, 0, scale)
		else
			love.graphics.print("no", 133 * scale, 66 * scale, 0, scale)
		end
		
		
		if selectblink then
			love.graphics.print(optionschoices[optionsselection], 19 * scale, 18 * scale + (optionsselection - 1) * 16 * scale, 0, scale)
		end
	end
	------------------------------------------
end

function menu_update(dt)
	if gamestate == "logo" then
		--noinspection GlobalCreationOutsideO
		logotime = logotime + dt
		
		if logotime >= logoduration and bootsoundplayed == false then
			love.audio.stop(boot)
			love.audio.play(boot)
			--noinspection GlobalCreationOutsideO
			bootsoundplayed = true
		end
		
		if logotime >= logoduration + logodelay then
			--noinspection GlobalCreationOutsideO
			oldtime = love.timer.getTime()
			--noinspection GlobalCreationOutsideO
			gamestate = "credits"
		end
	end
	
	if gamestate == "credits" then
		--noinspection GlobalCreationOutsideO
		currenttime = love.timer.getTime()
		if currenttime - oldtime > creditsdelay then
			--noinspection GlobalCreationOutsideO
			gamestate = "title"
			love.graphics.setBackgroundColor(0, 0, 0)
			love.audio.play(musictitle)
		end
	end
	
	if gamestate == "menu" or gamestate == "multimenu" or gamestate == "options" then
		--noinspection GlobalCreationOutsideO
		currenttime = love.timer.getTime()
		if currenttime - oldtime > selectblinkrate then
			--noinspection GlobalCreationOutsideO
			selectblink = not selectblink
			--noinspection GlobalCreationOutsideO
			oldtime = currenttime
		end
	end
	
	if gamestate == "options" then
		if optionsselection == 2 then
			if love.keyboard.isDown("left") then
				if hue > 0 then
					--noinspection GlobalCreationOutsideO
					hue = hue - 0.5 * dt
					if hue < 0 then
						--noinspection GlobalCreationOutsideO
						hue = 0
					end
					--noinspection GlobalCreationOutsideO
					optionsmenu = newPaddedImage("graphics/options.png"); optionsmenu:setFilter("nearest", "nearest")
					--noinspection GlobalCreationOutsideO
					volumeslider = newPaddedImage("graphics/volumeslider.png"); volumeslider:setFilter("nearest", "nearest")
				end
			elseif love.keyboard.isDown("right") then
				if hue < 1 then
					--noinspection GlobalCreationOutsideO
					hue = hue + 0.5 * dt
					if hue > 1 then
						--noinspection GlobalCreationOutsideO
						hue = 1
					end
					--noinspection GlobalCreationOutsideO
					optionsmenu = newPaddedImage("graphics/options.png"); optionsmenu:setFilter("nearest", "nearest")
					--noinspection GlobalCreationOutsideO
					volumeslider = newPaddedImage("graphics/volumeslider.png"); volumeslider:setFilter("nearest", "nearest")
				end
			end
		end
	end
	
	if gamestate == "highscoreentry" then
		--noinspection GlobalCreationOutsideO
		currenttime = love.timer.getTime()
		if currenttime - oldtime > cursorblinkrate then
			--noinspection GlobalCreationOutsideO
			cursorblink = not cursorblink
			--noinspection GlobalCreationOutsideO
			oldtime = currenttime
		end
		if currenttime - highscoremusicstart > 1.2 then
			if musicchanged == false then
				--noinspection GlobalCreationOutsideO
				musicchanged = true
				love.audio.stop(highscoreintro)
				love.audio.play(musichighscore)
			end
		end
	end
end