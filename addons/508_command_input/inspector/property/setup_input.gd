@tool
extends EditorProperty
## NOTE: CANNOT use InputMap.has_action to check action, only get buildin value on inspector

const ToolEditor := preload('../../module/tool_godot_editor.gd');

@export var idx: int;
@export var target_property := '';

var input_node: LineEdit;

func __update_action_name( meh = null ):
	var new_arr = get_edited_object().get( target_property ).duplicate();
	if idx < 0 or idx >= new_arr.size():
		return;
	new_arr[ idx ] = input_node.text;
	get_edited_object().set( target_property, new_arr );
	if target_property == 'command_action' and meh:
		ToolEditor.refresh_editor();

func __create_action_name_input():
	input_node = LineEdit.new();
	input_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
	input_node.text = get_edited_object().get( target_property )[ idx ];
	if target_property == 'command_symbol':
		input_node.text_changed.connect( func( new_text: String ):
				input_node.text = new_text.left(1)
				for symbol in get_edited_object().get( target_property ):
					if !symbol.is_empty() and symbol == new_text.left(1):
						input_node.text = '';
						return;
				);
	elif target_property == 'command_list':
		input_node.text_changed.connect( func( new_text: String ):
				var before_column := input_node.caret_column;
				var symbol_list := get_edited_object().get( 'command_symbol' );
				var new_valid_cmd := '';
				for c in new_text:
					if symbol_list.find( c ) >= 0:
						new_valid_cmd += c;
					elif before_column > new_valid_cmd.length():
						before_column -= 1;
				input_node.text = new_valid_cmd;
				input_node.caret_column = min( before_column, input_node.text.length() );
				);
	input_node.focus_exited.connect( __update_action_name );
	input_node.text_submitted.connect( __update_action_name );
	return input_node;

func __create_remove_btn():
	var remove_btn = Button.new();
	remove_btn.text = '-';
	remove_btn.focus_mode = Control.FOCUS_NONE;
	remove_btn.pressed.connect( func():
			get_edited_object().get( target_property ).remove_at( idx );
			if target_property == 'command_action':
				get_edited_object().get( 'command_priority' ).remove_at( idx );
				get_edited_object().get( 'command_pair' ).remove_at( idx );
			elif target_property == 'quick_action':
				get_edited_object().get( 'quick_command_map' ).remove_at( idx );
			elif target_property == 'command_symbol':
				get_edited_object().get( 'command_symbol_map' ).remove_at( idx );
			elif target_property == 'watch_action':
				get_edited_object().get( 'intercept_action_map' ).remove_at( idx );
			ToolEditor.refresh_editor() );
	return remove_btn;

func _ready():
	label = str(idx);
	var slot = HBoxContainer.new();
	add_child.call_deferred( slot );
	slot.add_child.call_deferred( __create_action_name_input() );
	slot.add_child.call_deferred( __create_remove_btn() );
