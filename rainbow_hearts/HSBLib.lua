-- HSBLib
-- Library of functions to covert between RGB and HSB color models
-- Convert between 'rrr,ggg,bbb' and HEX forms of RGB
-- Return the luminance (perceived lightness) of an RGB color
-- Compiled and modified from various sources by JSMorley
-- October 30, 2017

--modify it a little bit for easier use for spelunky modding - Mr Auto

-- Function :		RGBtoHSB(arg)
-- Argument :		inRed, inGreen, inBlue 0 - 255
-- Returns :		Three HSB values
-- 						HSB hue as a percentage from 0.0-1.0
-- 						*	Multiply 360 with this value to obtain the degrees of hue
--							While hue is most often expressed as an integer, the fractional
--							amount can be important for precision in calculations
--						*	Note that 0.0 (0 degrees) and 1.0 (360 degrees) are the same red hue
--							It's a counter-clockwise 360 degree "cylinder" of color
--							red->purple->blue->cyan->green->yellow->orange->red
-- 						HSB saturation as a percentage from 0.0-1.0
-- 						HSB brightness as a percentage from 0.0-1.0
--						*	Note that this is the "brightness" of the color, and not the 
--							"lightness" as in the HSL model. A color, particularly in the 
--							blue range, can have 100% brightness and still be visibly quite dark.
--							Use the Luminance() function below to obtain "visible lightness"
function RGBtoHSB(inRed, inGreen, inBlue)
	
	percentR = inRed
	percentG = inGreen
	percentB = inBlue

	colorMin = math.min( percentR, percentG, percentB )
	colorMax = math.max( percentR, percentG, percentB )
	deltaMax = colorMax - colorMin

	colorBrightness = colorMax

	if (deltaMax == 0) then
		colorHue = 0
		colorSaturation = 0
	else
		colorSaturation = deltaMax / colorMax

		deltaR = (((colorMax - percentR) / 6) + (deltaMax / 2)) / deltaMax
		deltaG = (((colorMax - percentG) / 6) + (deltaMax / 2)) / deltaMax
		deltaB = (((colorMax - percentB) / 6) + (deltaMax / 2)) / deltaMax

		if (percentR == colorMax) then
			colorHue = deltaB - deltaG
		elseif (percentG == colorMax) then 
			colorHue = ( 1 / 3 ) + deltaR - deltaB
		elseif (percentB == colorMax) then 
			colorHue = ( 2 / 3 ) + deltaG - deltaR
		end

		if ( colorHue < 0 ) then colorHue = colorHue + 1 end
		if ( colorHue > 1 ) then colorHue = colorHue - 1 end
		
	end

	return colorHue, colorSaturation, colorBrightness

end

-- Function :		HSBtoRGB(arg1, arg2, arg3)
-- Argument:		Three HSB values
-- 						HSB hue as a percentage from 0.0-1.0
-- 						HSB saturation as a percentage from 0.0-1.0
-- 						HSB brightness as a percentage from 0.0-1.0
-- Returns:		Three RGB values
-- 						Red value from 0-255
-- 						Green value from 0-255
-- 						Blue value from 0-255
function HSBtoRGB(colorHue, colorSaturation, colorBrightness)
	
		degreesHue = colorHue * 6
		if (degreesHue >= 6) then degreesHue = degreesHue - 6 end
		degreesHue_int = math.floor(degreesHue)
		percentSaturation1 = colorBrightness * (1 - colorSaturation)
		percentSaturation2 = colorBrightness * (1 - colorSaturation * (degreesHue - degreesHue_int))
		percentSaturation3 = colorBrightness * (1 - colorSaturation * (1 - (degreesHue - degreesHue_int)))
		if (degreesHue_int == 0)  then
			percentR = colorBrightness
			percentG = percentSaturation3
			percentB = percentSaturation1
		elseif (degreesHue_int == 1) then
			percentR = percentSaturation2
			percentG = colorBrightness
			percentB = percentSaturation1
		elseif (degreesHue_int == 2) then
			percentR = percentSaturation1
			percentG = colorBrightness
			percentB = percentSaturation3
		elseif (degreesHue_int == 3) then
			percentR = percentSaturation1
			percentG = percentSaturation2
			percentB = colorBrightness
		elseif (degreesHue_int == 4) then
			percentR = percentSaturation3
			percentG = percentSaturation1
			percentB = colorBrightness
		else
			percentR = colorBrightness
			percentG = percentSaturation1
			percentB = percentSaturation2
		end
 
		outRed = Round(percentR * 255)
		outGreen = Round(percentG * 255)
		outBlue = Round(percentB * 255)
		
		return outRed, outGreen, outBlue
	
end


-- Function:		ColorLumens(arg)
-- Argument:		inRed, inGreen, inBlue 0 - 255
-- Returns:		Luminance (perceived lightness) as a percentage from 0.0-1.0 
--						*	A ratio of 5:1 on larger items and 10:1 on smaller text is
--							recommended as a "contrast" between foreground and
--							background colors to be comfortable to the human eye
function ColorLumens(inRed, inGreen, inBlue)

	curLumens = Round((math.sqrt(0.299 * inRed^2 + 0.587 * inGreen^2 + 0.114 * inBlue^2) / 255) * 100)
	
	return curLumens

end

-- Utility functions

function Clamp(numArg, lowArg, highArg)

	return math.max(lowArg, math.min(highArg, numArg))
	
end

function Round(numArg, decimalsArg)
	
	local mult = 10 ^ (decimalsArg or 0)
	if numArg >= 0 then
		return math.floor(numArg * mult + 0.5) / mult
	else
		return math.ceil(numArg * mult - 0.5) / mult
	end
	
end
