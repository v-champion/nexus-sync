return {
	["Connect"] = {
		[true] = {
			["TextButton"] = {
				["BackgroundColor3"] = Color3.fromRGB(43, 43, 43);
			},

			["TextLabel"] = {
				["TextColor3"] = Color3.fromRGB(255, 255, 255);
				["TextTransparency"] = 0
			},

			["UIStroke"] = {
				["Color"] = Color3.fromRGB(97, 97, 97),
				["Transparency"] = 0
			}	
		},
		
		[false] = {
			["TextButton"] = {
				["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
			},

			["TextLabel"] = {
				["TextColor3"] = Color3.fromRGB(255, 255, 255);
				["TextTransparency"] = 0.5;
			},

			["UIStroke"] = {
				["Color"] = Color3.fromRGB(33, 33, 33),
				["Transparency"] = 0
			}	
		}
	},
	
	["Disconnected"] = {
		["TextLabel"] = {
			["TextColor3"] = Color3.fromRGB(111, 111, 111)
		},

		["UIStroke"] = {
			["Color"] = Color3.fromRGB(255, 255, 255),
			["Transparency"] = 0.88
		}
	},
	
	["Connecting"] = {
		["TextLabel"] = {
			["TextColor3"] = Color3.fromRGB(218, 171, 53)
		},

		["UIStroke"] = {
			["Color"] = Color3.fromRGB(255, 195, 42),
			["Transparency"] = 0.88
		}
	},
	
	["Connected"] = {
		["TextLabel"] = {
			["TextColor3"] = Color3.fromRGB(104, 218, 102)
		},

		["UIStroke"] = {
			["Color"] = Color3.fromRGB(71, 255, 83),
			["Transparency"] = 0.88
		}
	},
}