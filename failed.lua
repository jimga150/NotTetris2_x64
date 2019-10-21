function failed_load()
	--noinspection GlobalCreationOutsideO
	gamestate = "failed"
	--noinspection GlobalCreationOutsideO
	tetribodies = {} -- CLEAR ALL
	--noinspection GlobalCreationOutsideO
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
	--noinspection GlobalCreationOutsideO
	offsetX = 0
	
	--noinspection GlobalCreationOutsideO
	scorestring = tostring(scorescore)
	for i = 1, scorestring:len() - 1 do
		--noinspection GlobalCreationOutsideO
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(scorescore, game_height_pixels * scale + offsetX, 24 * scale, 0, scale)
	
	
	--"level"--
	--noinspection GlobalCreationOutsideO
	offsetX = 0
	
	--noinspection GlobalCreationOutsideO
	scorestring = tostring(levelscore)
	for i = 1, scorestring:len() - 1 do
		--noinspection GlobalCreationOutsideO
		offsetX = offsetX - 8 * scale
	end
	love.graphics.print(levelscore, 136 * scale + offsetX, 56 * scale, 0, scale)
	
	--"tiles"--
	--noinspection GlobalCreationOutsideO
	offsetX = 0
	
	--noinspection GlobalCreationOutsideO
	scorestring = tostring(linesscore)
	for i = 1, scorestring:len() - 1 do
		--noinspection GlobalCreationOutsideO
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
	--noinspection GlobalCreationOutsideO
	highscoreno = 0
	--noinspection GlobalCreationOutsideO
	selectblink = true
	--noinspection GlobalCreationOutsideO
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
			
			--noinspection GlobalCreationOutsideO
			highscoreno = i
			highscorename[i] = ""
			highscore[i] = scorescore
			--noinspection GlobalCreationOutsideO
			cursorblink = true
			love.audio.play(highscoreintro)
			--noinspection GlobalCreationOutsideO
			highscoremusicstart = love.timer.getTime()
			--noinspection GlobalCreationOutsideO
			musicchanged = false
			--noinspection GlobalCreationOutsideO
			gamestate = "highscoreentry"
			break
		end
	end
	if highscoreno == 0 then --no new highscore
		--noinspection GlobalCreationOutsideO
		gamestate = "menu"
		if musicno < 4 then
			love.audio.play(music[musicno])
		end
	end
end