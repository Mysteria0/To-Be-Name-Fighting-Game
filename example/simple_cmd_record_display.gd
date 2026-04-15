extends Label

const ToolPackedByte := preload('../addons/508_command_input/module/tool_godot_packedbyte.gd');

@export var cmd_parser: Node;
@export var key_watcher: Node;

var holding_action: Array[StringName];

func __on_holding_action_released( action_name: StringName ):
	if holding_action.is_empty():
		return;
	holding_action.erase( action_name );

func __on_command_active( command_idx: int ):
	if !holding_action.is_empty():
		return;
		# example for simple block all command while any hold
		# ( exclude action_c because action_c not add to holding_action )
	active_timer = 1.0; # for display only
	active_cmd = cmd_parser.get_cmd_str( command_idx );
	holding_action = cmd_parser.get_cmd_last_actions( command_idx );
	for action in holding_action:
		key_watcher.start_watch_action( action );

func __check_other_input():
	if Input.is_action_pressed('action_c'):
		key_watcher.start_watch_action( 'action_c' );

func __setup_coonect():
	cmd_parser.command_active.connect( __on_command_active );
	key_watcher.action_released.connect( __on_holding_action_released );
	key_watcher.action_canceled.connect( __on_holding_action_released );

#
# below code for display only
#

var cmd_list := '[ Command List ]';
var active_cmd := '-';
var active_timer := 1.0;

func _ready():
	for cmd in cmd_parser.command_list:
		cmd_list += '\n' + cmd;
	cmd_list += '\n[ Command Record ]\n%s\n%s ( without neutral )\n[ Active Command ]\n%s (%.2f)\n[ Holding Action ]\n%s';
	__setup_coonect();

func __build_text( command_record: PackedByteArray ) -> String:
	var display_text := '';
	for i in command_record.size() / cmd_parser.buffer_size:
		var bit_value := ToolPackedByte.byte_array_to_int(
				command_record.slice( i * cmd_parser.buffer_size, ( i + 1 ) * cmd_parser.buffer_size ) );
		var symbol_idx = cmd_parser.command_symbol_map.find( bit_value );
		if symbol_idx < 0:
			continue;
		display_text += cmd_parser.command_symbol[ symbol_idx ];
	return display_text;

func __build_watching_action() -> String:
	var result := '';
	for action in key_watcher.active_action:
		if !result.is_empty():
			result += ', ';
		result += action;
	return result;

func _process(delta):
	__check_other_input();
	
	active_timer -= delta;
	if active_timer <= 0.0:
		active_cmd = '-';
	
	var display_text := __build_text( cmd_parser.command_record );
	var display_text_nn := __build_text( cmd_parser.__remove_neutral( cmd_parser.command_record ) );
	if !holding_action.is_empty():
		active_timer = 1.0;
		display_text += '[ holding block ]';
		display_text_nn += '[ holding block ]';
	var hold_text := __build_watching_action();
	text = cmd_list % [
		display_text, display_text_nn,
		active_cmd, 0.0 if active_cmd == '-' else active_timer, hold_text ];
