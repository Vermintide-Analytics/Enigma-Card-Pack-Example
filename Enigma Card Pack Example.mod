return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Enigma Card Pack Example` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Enigma Card Pack Example", {
			mod_script       = "scripts/mods/Enigma Card Pack Example/Enigma Card Pack Example",
			mod_data         = "scripts/mods/Enigma Card Pack Example/Enigma Card Pack Example_data",
			mod_localization = "scripts/mods/Enigma Card Pack Example/Enigma Card Pack Example_localization",
		})
	end,
	packages = {
		"resource_packages/Enigma Card Pack Example/Enigma Card Pack Example",
	},
}
