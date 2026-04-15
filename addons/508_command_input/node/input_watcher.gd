## a Custom Node to keep tracking action or key is still holding [br]
## and emit a signal while action or key losted [br]
## [br]
## action and key use different logic, and call different func to start [br]
## action call start_watch_action to start and emit action_released or action_canceled [br]
## key call start_watch_key to start and emit key_released or key_canceled [br]
## key include mouse and joy button
## [br]
## NOTE: key pending, add later
extends Node

signal action_released( action_name: StringName );
signal action_canceled( action_name: StringName );

@export_group('Action Setup')

## action not on this array can intercept by any input include mouse btn
@export var watch_action: Array[StringName];

## idx refer to watch_action
@export var intercept_action_map: Array[int];

@export_group('Key Setup')

@export var watch_key: Array[Key];
@export var watch_btn: Array[MouseButton];
@export var watch_joy: Array[JoyButton];

@export_group('Config')

## while [color=lightcoral][b] True [/b][/color],
## player can holding more than one key at the same time [br]
## if they DO NOT intercept each other
@export var multi_active_mode := false;

## while [color=lightcoral][b] True [/b][/color],
## action NOT inside watch_action can intercept by any action exclude ui_ action and theirself [br]
## otherwise, they can only intercept by action inside watch_action [br]
## [br]
## NOTE: simple check Input.is_action_pressed() if you DO NOT want action intercept by other action
@export var unknown_action_intercept_by_all := true;

var all_action_list: Array[StringName];

var active_action: Array[StringName];
var active_setting_idx: Array[int];

#
# setup
#

func __check_all_action( ):
	for action in InputMap.get_actions():
		if action.begins_with('ui_'):
			continue;
		all_action_list.append( action );

#
# action process
#

func __register_action( action_name: StringName ):
	active_action.append( action_name );
	active_setting_idx.append( watch_action.find( action_name ) );

func __release_action( active_idx: int ):
	if active_idx < 0 or active_idx >= active_action.size():
		return;
	action_released.emit( active_action[ active_idx ] );
	active_action.remove_at( active_idx );
	active_setting_idx.remove_at( active_idx );

func __process_watch_action():
	if active_action.is_empty():
		return;
	var queue_release_list: Array[int];
	for active_idx in active_action.size():
		if !Input.is_action_pressed( active_action[ active_idx ] ):
			queue_release_list.append( active_idx );
			continue;
		var action_idx := active_setting_idx[ active_idx ];
		var intercept_bit := ( intercept_action_map[ action_idx ] if action_idx >= 0 else
				0b111111111111111111111111111111111111111111111111111111111111 );
				# do you think you need more than 60 bit ?
				# at least I won't use more than 1x
		var is_unknow_by_all := unknown_action_intercept_by_all and action_idx < 0;
		var search_list := all_action_list if is_unknow_by_all else watch_action;
		for action in search_list:
			if action == active_action[ active_idx ]:
				continue;
			var check_idx := watch_action.find( action );
			if !is_unknow_by_all and check_idx >= 0 and !( int( pow( 2, check_idx ) ) & intercept_bit ):
				continue;
			if Input.is_action_pressed( action ):
				queue_release_list.append( active_idx );
				break;
	if queue_release_list.is_empty():
		return;
	queue_release_list.reverse();
	for active_idx in queue_release_list:
		__release_action( active_idx );

func start_watch_action( action_name: StringName ):
	if active_action.find( action_name ) >= 0:
		return; # already start watch same action
	if !multi_active_mode and !active_action.is_empty():
		# single active mode OVERRIDE active action
		# ( NOT emit release, BUT cancel )
		action_canceled.emit( active_action.front() );
		active_action.clear();
		active_setting_idx.clear();
	__register_action( action_name );

#
# key process
#

#
# engine call
#

func _ready():
	__check_all_action();

func _process( _delta ):
	__process_watch_action();
