@tool
extends EditorProperty

const NAME := 'auto_record_size';
const ToolEditor := preload('../../module/tool_godot_editor.gd');

var input_box: CheckBox;
func _ready():
	input_box = CheckBox.new();
	input_box.text = 'On';
	input_box.toggled.connect( _on_check_box_toggled );
	add_child.call_deferred( input_box );

func _update_property():
	if input_box.button_pressed:
		ToolEditor.refresh_editor();
	input_box.button_pressed = get_edited_object().get( NAME );

func _on_check_box_toggled( toggled_on ):
	if get_edited_object().get( NAME ) == toggled_on:
		return;
	get_edited_object().set( NAME, toggled_on );
	ToolEditor.refresh_editor();
