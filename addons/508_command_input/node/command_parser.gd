## command parser only check and emit active signal while success input command [br]
## when need holding check, you need to use other node or handle by script receive this signal [br]
## P.S. DO NOT add a command simple extend another command, this make longer one never fire. [br]
## like 1236A with 1236A46A is not positble to active [br]
## but 1236A with 23641236A is Okay
extends Node

const ToolPackedByte := preload('../module/tool_godot_packedbyte.gd');

## emit when command fire [br]
## value is command list index, can call get_cmd_str func to receive cmd
signal command_active( command_idx: int );

@export_group('Command Action Setup')

## action name use in command input. [br]
## use enter to refresh action name while using inspector plugin mode
@export var command_action: Array[StringName];

## priority of command input. [br]
## higher priority input override all lower priority input state [br]
## so only input have same priority can overlap each other. [br]
## [br]
## basically, direct input have same priority
## and action input have higher priority to block direct input
@export var command_priority: Array[int];

## idx to other command input. [br]
## pairing input CANNOT press on same time, basically use in direct input.
@export var command_pair: Array[int];

@export_group('Quick Action Setup')

## action name for quick input. [br]
## quick input action [color=lightgray][b] DOES NOT [/b][/color] actural use in command input, [br]
## but trigger single or multiple command action while pressing. [br]
## [br]
## skip action not on InputMap while process.
@export var quick_action: Array[StringName];

## flag int ref to command action idx
@export var quick_command_map: Array[int];

@export_group('Command Symbol Setup')

## command representation symbol, map symbol to single or multiple command action. [br]
## [br]
## e.g. [br]
## when [br]
## symbol [1] refer left + down, [br]
## symbol [2] refer down, [br]
## symbol [3] refer right + down [br]
## than command [123] represent input start from left_down than down final shift to right_down 
@export var command_symbol: Array[StringName];

@export var command_symbol_map: Array[int];

@export_group('Command List')

@export var command_list: Array[StringName];

@export_group('Config')

## record lost time while holding same input too long.
@export var record_lost_time: float = 0.2;

## allow Node auto calculate record_size on readable_command_list changed [br]
## while this option is [color=lightcoral][b] true [/b][/color].
@export var auto_record_size := true;

## limit max record size [br]
## auto set on setting available command, [br]
## only use if you want record have specific size. [br]
## NOTE that command may have neutral state between input, [br]
## so actural size must be N*2-1 where N is longest command size without neutral
@export var record_size: int = 23;

## use print method to show which cmd send command_active signal. [br]
## only work for editor or debug export. [br]
## [br]
## print method is heavy but easy use method, [br]
## consider to use a label node receive signal and printout result for long term debug.
@export var debug_print := false;

var buffer_size: int = 1;

var command_byte_list: Array[ PackedByteArray ];
var command_idx: Array[ int ];

var command_record: PackedByteArray;
var record_timer: float = 0.0;

var mirroring_idx: Array[int];

#
# setup
#

func __setup_debug_print():
	if OS.is_debug_build() and debug_print:
		command_active.connect( func(cmd_idx):
				print( 'command active: ', get_cmd_str( cmd_idx ) ) );

func __calculate_buffer_size():
	buffer_size = ceili( float( command_action.size() ) / 8.0 );

func __convert_and_sort_command_list_to_byte_list():
	command_byte_list.clear();
	command_idx.clear();
	for command_str: String in command_list:
		var command: PackedByteArray;
		for c in command_str:
			var symbol_idx := command_symbol.find(c);
			if symbol_idx < 0:
				continue;
			command.append_array( ToolPackedByte.int_to_fixed_size_byte_array(
					command_symbol_map[ symbol_idx ], buffer_size ) );
		command_byte_list.append( command );
		command_idx.append( command_idx.size() );
	command_idx.sort_custom( func(a,b):
			return command_byte_list[a].size() > command_byte_list[b].size() );
	command_byte_list.sort_custom( func(a,b): return a.size() > b.size() );

func __calculate_record_size():
	if !auto_record_size:
		return;
	var longest_command_size := 0;
	for command in command_byte_list:
		var cmd_size_without_neutral := __remove_neutral( command ).size();
		longest_command_size = max( longest_command_size, cmd_size_without_neutral / buffer_size );
	record_size = longest_command_size * 2 + 1;

#
# short func
#

func ipow( base_value: float, exp_value: float ) -> int:
	return int( pow( base_value, exp_value ) );

#
# convert action to code
#

func __get_quick_input_code() -> int:
	var quick_input_code := 0b0;
	for idx in quick_action.size():
		if !InputMap.has_action( quick_action[ idx ] ): continue;
		if Input.is_action_pressed( quick_action[ idx ] ):
			quick_input_code = quick_input_code | quick_command_map[ idx ];
	return quick_input_code;

func __calculate_same_priority_input_code( input_code: int, idx: int ) -> int:
	var bit_value: int = ipow( 2, idx );
	input_code += bit_value;
	
	var pair_idx: int = command_pair[ idx ];
	var pair_bit_value: int = ipow( 2, pair_idx );
	if pair_idx != -1 and input_code & pair_bit_value:
		input_code -= bit_value;
		input_code -= pair_bit_value;
	return input_code;

func __get_cur_input_code() -> int:
	var quick_input_code := __get_quick_input_code();
	var cur_priority_level := 0;
	var input_code := 0b0;
	
	for idx in command_action.size():
		if !InputMap.has_action( command_action[ idx ] ): continue;
		var bit_value: int = ipow( 2, idx );
		if Input.is_action_pressed( command_action[ idx ] ) or bit_value & quick_input_code:
			if command_priority[ idx ] > cur_priority_level:
				input_code = bit_value;
				cur_priority_level = command_priority[ idx ];
			else:
				input_code = __calculate_same_priority_input_code( input_code, idx );
	
	return input_code;

#
# command process
#

func __lost_command():
	command_record.clear();
	record_timer = 0.0;

func __check_command():
	for idx in range( command_byte_list.size() ):
		if __is_command_equal( command_record.duplicate(), command_byte_list[ idx ] ):
			command_active.emit( command_idx[ idx ] );
			__lost_command();
			return;

func __check_any_just_pressed() -> bool:
	for idx in command_action.size():
		if !InputMap.has_action( command_action[ idx ] ):
			continue;
		if Input.is_action_just_pressed( command_action[ idx ] ):
			return true;
		if Input.is_action_just_released( command_action[ idx ] ):
			return true;
	return false;

func __add_buffer_to_record( cur_buffer: PackedByteArray ):
	command_record.append_array( cur_buffer );
	for byte in cur_buffer:
		if byte > 0:
			__check_command();
			break;
	var max_size := buffer_size * record_size;
	if command_record.size() > max_size:
		command_record = command_record.slice( command_record.size() - max_size );
	record_timer = 0.0;

func __process_command( delta: float ):
	var cur_code := __get_cur_input_code();
	var cur_buffer := __mirror_command(
			ToolPackedByte.int_to_fixed_size_byte_array( cur_code, buffer_size ) );
	
	if record_timer >= record_lost_time * 0.5:
		command_record = ____remove_neutral_before_last( command_record );
	if __check_any_just_pressed() and cur_code != 0b0 and __get_last_bit( command_record ) == cur_buffer:
		__add_buffer_to_record( [0] );
	if __get_last_bit( command_record ) == cur_buffer:
		record_timer += delta;
		if record_timer >= record_lost_time:
			__lost_command();
	else:
		__add_buffer_to_record( cur_buffer );

#
# command manipulation
#

func __get_pos_bit_arr( command: PackedByteArray, pos: int ) -> PackedByteArray:
	return command.slice( pos * buffer_size, ( pos + 1 ) * buffer_size );

func __get_last_bit( command: PackedByteArray ) -> PackedByteArray:
	return command.slice( command.size() - buffer_size );

## a equal b ( b has prority, a must fullfil b length ) [br]
## inner neutral can skip, but head neutral can't skip [br]
## because of need to check step / dash command like 66 [br]
## 
func __is_command_equal( command_a: PackedByteArray, command_b: PackedByteArray ) -> bool:
	if command_a.is_empty() or command_b.is_empty():
		return false;
	var bit_count_a: int = command_a.size() / buffer_size;
	var bit_count_b: int = command_b.size() / buffer_size;
	var bit_cursor_a := 0;
	var bit_cursor_b := 0;
	while bit_cursor_a < bit_count_a and bit_cursor_b < bit_count_b:
		var bit_a := ToolPackedByte.byte_array_to_int(
				__get_pos_bit_arr( command_a, bit_count_a - 1 - bit_cursor_a ) );
		var bit_b := ToolPackedByte.byte_array_to_int(
				__get_pos_bit_arr( command_b, bit_count_b - 1 - bit_cursor_b ) );
		if bit_b == 0b0 and bit_cursor_b == bit_count_b-1 and bit_a != 0b0:
			return false;
		elif bit_a == 0b0 or bit_b == 0b0:
			if bit_a == 0b0: bit_cursor_a += 1;
			if bit_b == 0b0: bit_cursor_b += 1;
		elif bit_a != bit_b:
			return false;
		else:
			bit_cursor_a += 1;
			bit_cursor_b += 1;
	return bit_cursor_b >= bit_count_b;

func __remove_neutral( command: PackedByteArray ) -> PackedByteArray:
	var result_command: PackedByteArray;
	var bit_count: int = command.size() / buffer_size;
	for i in range( bit_count ):
		var bit_arr := __get_pos_bit_arr( command, i );
		var bit := ToolPackedByte.byte_array_to_int( bit_arr );
		if bit != 0b0:
			result_command.append_array( bit_arr );
	return result_command;

func ____remove_neutral_before_last( command: PackedByteArray ) -> PackedByteArray:
	if command.size() < 2:
		return command;
	var result_command := command.duplicate();
	var bit_count: int = command.size() / buffer_size;
	var bit := ToolPackedByte.byte_array_to_int( __get_pos_bit_arr( command, bit_count - 2 ) );
	if bit != 0b0:
		return result_command;
	for i in range( buffer_size ):
		result_command.remove_at( command.size() - buffer_size - 1 - i );
	return result_command;

#
# mirror manipulation
#

## simple substract value that bit contain and add pair value [br]
## change copyed bit and check remain bit to provent [br]
## flip before value than another value switch back to original one
func __mirror_command( command: PackedByteArray ) -> PackedByteArray:
	if mirroring_idx.is_empty():
		return command;
	var result_command: PackedByteArray;
	for i in range( command.size() / buffer_size ):
		var bit := ToolPackedByte.byte_array_to_int( __get_pos_bit_arr( command, i ) );
		var new_bit := bit;
		for mirror_idx in mirroring_idx:
			var idx_value: int = ipow( 2, mirror_idx );
			if bit & idx_value:
				var pair_idx_value: int = ipow( 2, command_pair[ mirror_idx ] );
				new_bit -= idx_value;
				new_bit += pair_idx_value;
		result_command.append_array( ToolPackedByte.int_to_fixed_size_byte_array( new_bit, buffer_size ) );
	return result_command;

func __is_same_state( idx: int, mirror_state: bool ) -> bool:
	return ( mirroring_idx.find( idx ) >= 0 ) == mirror_state;

func mirror_input( action_idx: int, mirror_state: bool ) -> bool:
	if action_idx < 0 or action_idx >= command_action.size():
		return false;
	if mirror_state and command_pair[ action_idx ] < 0:
		mirror_state = false;
	if __is_same_state( action_idx, mirror_state ):
		return false;
	if command_pair[ action_idx ] != -1 and ( mirroring_idx.find( command_pair[ action_idx ] ) < 0 ) == mirror_state:
		if mirror_state:
			mirroring_idx.append( command_pair[ action_idx ] );
		else:
			mirroring_idx.erase( command_pair[ action_idx ] );
	if ( mirroring_idx.find( action_idx ) < 0 ) == mirror_state:
		if mirror_state:
			mirroring_idx.append( action_idx );
		else:
			mirroring_idx.erase( action_idx );
	return true;

#
# getter method
#

func get_cmd_str( cmd_idx: int ) -> String:
	if cmd_idx < 0 or cmd_idx >= command_list.size():
		return '';
	return command_list[ cmd_idx ];

func get_cmd_last_actions( cmd_idx: int ) -> Array[StringName]:
	var result: Array[StringName];
	var last_symbol = get_cmd_str( cmd_idx ).right(1);
	if last_symbol.is_empty():
		return result;
	var symbol_idx: int = command_symbol.find( last_symbol );
	for idx in command_action.size():
		if ipow( 2, idx ) & command_symbol_map[ symbol_idx ]:
			result.append( command_action[ idx ] );
	return result;

#
# engine call
#

func _ready():
	__setup_debug_print();
	__calculate_buffer_size();
	__convert_and_sort_command_list_to_byte_list();
	__calculate_record_size();

func _process( delta ):
	__process_command( delta );
