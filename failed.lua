function failed_load()
	gamestate = "failed"
	-- TODO: Justify global
	tetribodies = {} -- CLEAR ALL
	-- TODO: Justify global
	tetrishapes = {} -- PIECES
	love.audio.play(gameover2)
end

function failed_draw()
	--FULLSCREEN OFFSET
	if fullscreen then
		love.graphics.translate(fullscreenoffsetX, fullscreenoffsetY)
		
		--scissor
		love.graphics.setScissor(fullscreenoffsetX, fullscreenoffsetY, game_sp_width_pixels * scale, game_height_pixels * scale)
	end
	
	if gameno == 1 then
		love.graphics.draw(gamebackgroundcutoff, 0, 0, 0, scale)
		love.graphics.draw(gameovercutoff, 14 * scale, 0, 0, scale)
	else
		love.graphics.draw(gamebackground, 0, 0, 0, scale)
		love.graphics.draw(gameover, 16 * scale, 0, 0, scale)
	end
	
	--SCORES---------------------------------------
	--"score"--
	-- TODO: Justify global
	offsetX = 0
	
	-- TODO: Justify global
	scorestring = tostring(scorescore)
	for i = 1, scorestring:len() - 1 do
		-- TODO: Justify global
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(scorescore, game_height_pixels * scale + offsetX, 24 * scale, 0, scale)
	
	
	--"level"--
	-- TODO: Justify global
	offsetX = 0
	
	-- TODO: Justify global
	scorestring = tostring(levelscore)
	for i = 1, scorestring:len() - 1 do
		-- TODO: Justify global
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(levelscore, 136 * scale + offsetX, 56 * scale, 0, scale)
	
	--"tiles"--
	-- TODO: Justify global
	offsetX = 0
	
	-- TODO: Justify global
	scorestring = tostring(linesscore)
	for i = 1, scorestring:len() - 1 do
		-- TODO: Justify global
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

function failed_update()
end

function failed_checkhighscores()
	-- TODO: Justify global
	highscoreno = 0
	-- TODO: Justify global
	selectblink = true
	oldtime = love.timer.getTime()
	for i = 1, 3 do
		if scorescore > highscore[i] then
			if i == 1 then
				highscore[3] = highscore[2]
				highscore[2] = highscore[1]
				highscorename[3] = highscorename[2]
				highscorename[2] = highscorename[1]
			elseif i == 2 then
				highscore[3] = highscore[2]
				highscorename[3] = highscorename[2]
			end
			
			-- TODO: Justify global
			highscoreno = i
			highscorename[i] = ""
			highscore[i] = scorescore
			-- TODO: Justify global
			cursorblink = true
			love.audio.play(highscoreintro)
			-- TODO: Justify global
			highscoremusicstart = love.timer.getTime()
			-- TODO: Justify global
			musicchanged = false
			gamestate = "highscoreentry"
			break
		end
	end
	if highscoreno == 0 then --no new highscore
		-- TODO: Justify global
		gamestate = "menu"
		if musicno < 4 then
			love.audio.play(music[musicno])
		end
	end
end