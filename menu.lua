function menu_load()
	-- TODO: Justify global
	gamestate = "logo"
	-- TODO: Justify global
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
	-- TODO: Justify global
	logotime = 0
	-- TODO: Justify global
	bootsoundplayed = false
	-- TODO: Justify global
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
				-- TODO: Justify global
				offsetX = 0
				for i = 1, string.sub(tostring(highscore[i]), 1, 6):len() - 1 do
					-- TODO: Justify global
					offsetX = offsetX - 8 * scale
				end
				love.graphics.print(string.sub(tostring(highscore[i]), 1, 6), 137 * scale + offsetX, 110 * scale + 8 * scale * (i - 1), 0, scale)
			end
		end
	end
	
	if gamestate == "highscoreentry" then
		if highscorename[highscoreno]:len() < 6 then
			-- TODO: Justify global
			offsetX = 0
			for i = 1, highscorename[highscoreno]:len() do
				-- TODO: Justify global
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
		-- TODO: Justify global
		logotime = logotime + dt
		
		if logotime >= logoduration and bootsoundplayed == false then
			love.audio.stop(boot)
			love.audio.play(boot)
			-- TODO: Justify global
			bootsoundplayed = true
		end
		
		if logotime >= logoduration + logodelay then
			-- TODO: Justify global
			oldtime = love.timer.getTime()
			gamestate = "credits"
		end
	end
	
	if gamestate == "credits" then
		-- TODO: Justify global
		currenttime = love.timer.getTime()
		if currenttime - oldtime > creditsdelay then
			gamestate = "title"
			love.graphics.setBackgroundColor(0, 0, 0)
			love.audio.play(musictitle)
		end
	end
	
	if gamestate == "menu" or gamestate == "multimenu" or gamestate == "options" then
		-- TODO: Justify global
		currenttime = love.timer.getTime()
		if currenttime - oldtime > selectblinkrate then
			-- TODO: Justify global
			selectblink = not selectblink
			-- TODO: Justify global
			oldtime = currenttime
		end
	end
	
	if gamestate == "options" then
		if optionsselection == 2 then
			if love.keyboard.isDown("left") then
				if hue > 0 then
					-- TODO: Justify global
					hue = hue - 0.5 * dt
					if hue < 0 then
						-- TODO: Justify global
						hue = 0
					end
				end
			elseif love.keyboard.isDown("right") then
				if hue < 1 then
					-- TODO: Justify global
					hue = hue + 0.5 * dt
					if hue > 1 then
						-- TODO: Justify global
						hue = 1
					end
				end
			end
		end
	end
	
	if gamestate == "highscoreentry" then
		-- TODO: Justify global
		currenttime = love.timer.getTime()
		if currenttime - oldtime > cursorblinkrate then
			-- TODO: Justify global
			cursorblink = not cursorblink
			-- TODO: Justify global
			oldtime = currenttime
		end
		if currenttime - highscoremusicstart > 1.2 then
			if musicchanged == false then
				-- TODO: Justify global
				musicchanged = true
				love.audio.stop(highscoreintro)
				love.audio.play(musichighscore)
			end
		end
	end
end