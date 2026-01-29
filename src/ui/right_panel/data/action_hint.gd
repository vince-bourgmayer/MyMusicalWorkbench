# -----------------------------------------------------------------------------
# action_hint.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name ActionHint

var id : String
var atlas_x : int
var atlas_y : int
var text: String

static func from_dict(data: Dictionary) -> ActionHint:
	var hint := ActionHint.new()
	hint.id = str(data.get("id", ""))
	hint.atlas_x = int(data.get("x", -1))
	hint.atlas_y = int(data.get("y", -1))
	hint.text = str(data.get("text", ""))

	if hint.id.is_empty():
		push_error("ActionHint: missing 'id'")
	if hint.atlas_x < 0 or hint.atlas_y < 0:
		push_error("ActionHint('%s'): invalid x/y" % hint.id)

	return hint
