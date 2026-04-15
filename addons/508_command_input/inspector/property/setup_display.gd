@tool
extends EditorProperty

const ToolEditor := preload('../../module/tool_godot_editor.gd');

@export var target_property := '';

var display : Label;
func _ready():
	display = Label.new();
	display.text = 'Size: ' + str( get_edited_object().get( target_property ).size() );
	add_child.call_deferred( display );

func _update_property():
	if display.text.to_int() != get_edited_object().get( target_property ).size():
		if target_property == 'command_action':
			get_edited_object().get( 'command_priority' ).clear();
			get_edited_object().get( 'command_pair' ).clear();
		elif target_property == 'quick_action':
			get_edited_object().get( 'quick_command_map' ).clear();
		elif target_property == 'command_symbol':
			get_edited_object().get( 'command_symbol_map' ).clear();
		elif target_property == 'watch_action':
			get_edited_object().get( 'intercept_action_map' ).clear();
		ToolEditor.refresh_editor();
