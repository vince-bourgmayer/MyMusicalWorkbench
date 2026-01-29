# -----------------------------------------------------------------------------
# json_loader.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name JsonLoader

static func read_dict(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("JsonFile: cannot open %s" % path)
		return {}

	var json_text := file.get_as_text()
	var json := JSON.new()
	var err := json.parse(json_text)
	if err != OK:
		push_error("JsonFile: parse error in %s (line %d): %s"
			% [path, json.get_error_line(), json.get_error_message()])
		return {}

	if typeof(json.data) != TYPE_DICTIONARY:
		push_error("JsonFile: root must be a Dictionary in %s" % path)
		return {}

	return json.data as Dictionary
