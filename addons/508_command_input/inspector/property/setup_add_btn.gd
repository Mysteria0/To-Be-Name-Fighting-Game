@tool
extends EditorProperty

const ToolEditor := preload('../../module/tool_godot_editor.gd');

@export var target_property := '';

func __add_size( property: String, default_value = null ):
	var ref = get_edited_object().get( property ).duplicate();
	ref.resize( ref.size() + 1 );
	if default_value:
		ref[ ref.size()-1 ] = default_value;
	get_edited_object().set( property, ref );

func __add_slot():
	__add_size( target_property );
	if target_property == 'command_action':
		__add_size( 'command_priority' );
		__add_size( 'command_pair', -1 );
	elif target_property == 'quick_action':
		__add_size( 'quick_command_map' );
	elif target_property == 'command_symbol':
		__add_size( 'command_symbol_map' );
	elif target_property == 'watch_action':
		__add_size( 'intercept_action_map' );
	ToolEditor.refresh_editor();

func _ready():
	label = '';
	var add_btn := Button.new();
	add_btn.text = 'Add Input';
	add_btn.pressed.connect( __add_slot );
	add_child.call_deferred( add_btn );
