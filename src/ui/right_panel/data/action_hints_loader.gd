# -----------------------------------------------------------------------------
# action_hint_loader.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name ActionHintsLoader

static func load_from_file(path: String) -> Dictionary:
	# returns: Dictionary[String, Array[ActionHint]]
	var json_root := JsonLoader.read_dict(path)
	var result: Dictionary = {}

	for gamemode in json_root.keys():
		var raw_list = json_root[gamemode]
		var gamemode_key = str(gamemode)
		
		if typeof(raw_list) != TYPE_ARRAY:
			push_error("ActionHintsLoader: '%s' must be an Array" % gamemode_key)
			continue

		var hints: Array[ActionHint] = []
		for raw_item in raw_list as Array:
			if typeof(raw_item) != TYPE_DICTIONARY:
				push_error("ActionHintsLoader: item in '%s' must be a Dictionary" % gamemode_key)
				continue
			hints.append(ActionHint.from_dict(raw_item as Dictionary))

		result[gamemode_key] = hints

	return result
