meta.name = "Rainbow heart color"
meta.version = "1.0"
meta.description = "Changes the heart color for players in a rainbow effect"
meta.author = "Mr Auto"

require "HSBLib"

local h_colors = {{},{},{},{}}
local speed = 0.002
local saturation = 1.0
local brightness = 1.0

register_option_int("speed", "Speed", "Speed of the color change, slower also means more colors", 20, 1, 100)
register_option_bool("change", "Ranbow effect", "If set to false it will only set random colors at the start of a run", true)
register_option_int("zsaturation", "Saturation", "Just addition color setting, can leave at default", 1000, 0, 1000)
register_option_int("zbrightness", "Brightness", "Just addition color setting, can leave at default", 1000, 0, 1000)

set_callback(function()

	if not options.speed or options.speed > 100 or options.speed < 1 then
		speed = 0.002
	else
		speed = options.speed / 10000.0
	end
	if options.zsaturation >= 0 and options.zsaturation < 1000 then
		saturation = options.zsaturation / 1000.0
	end
	if options.zbrightness >= 0 and options.zbrightness < 1000 then
		brightness = options.zbrightness / 1000.0
	end
--initial random heart colors
	for i = 1, 4, 1 do
	
		h_colors[i].hue = math.random()
		h_colors[i][1], h_colors[i][2], h_colors[i][3] = HSBtoRGB(h_colors[i].hue, saturation, brightness)
		if players[i] then
			local color = Color.new()
			color.r = h_colors[i][1]/255
			color.g = h_colors[i][2]/255
			color.b = h_colors[i][3]/255
			players[i]:as_player():set_heart_color(color)
		end
	end
end, ON.START)

set_callback(function()

	if options.change then
		for i, player in pairs(players) do
		
			h_colors[i].hue = h_colors[i].hue + speed
			if h_colors[i].hue > 1.0 then
				h_colors[i].hue = h_colors[i].hue - 1.0
			end
			
			h_colors[i][1], h_colors[i][2], h_colors[i][3] = HSBtoRGB(h_colors[i].hue, saturation, brightness)
			
			local color = Color.new()
			color.r = h_colors[i][1]/255
			color.g = h_colors[i][2]/255
			color.b = h_colors[i][3]/255
			player:as_player():set_heart_color(color)
		end
	end

end, ON.FRAME)