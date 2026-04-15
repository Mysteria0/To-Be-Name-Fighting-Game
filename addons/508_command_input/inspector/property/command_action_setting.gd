@tool
extends EditorProperty

const ToolEditor := preload('../../module/tool_godot_editor.gd');

@export var idx: int;

func __lost_pair( arr_ref: Array[int], idx: int ):
	if arr_ref[ idx ] >= 0:
		var target_idx := arr_ref[ idx ];
		arr_ref[ target_idx ] = -1;
		arr_ref[ idx ] = -1;

func __change_pair( subject_idx: int, object_idx: int ):
	var priority_arr := get_edited_object().get( 'command_priority' );
	var pair_arr := get_edited_object().get( 'command_pair' );
	if object_idx >= 0:
		__lost_pair( pair_arr, object_idx );
		__lost_pair( pair_arr, subject_idx );
		pair_arr[ object_idx ] = subject_idx;
		priority_arr[ object_idx ] = priority_arr[ subject_idx ];
	pair_arr[ subject_idx ] = object_idx;
	ToolEditor.refresh_editor();

func __add_control_btn( is_move_down := false ) -> Button:
	var btn := Button.new();
	btn.focus_mode = Control.FOCUS_NONE;
	btn.text = 'v' if is_move_down else '^';
	btn.disabled = ( idx == get_edited_object().get( 'command_action' ).size()-1 ) if is_move_down else ( idx == 0 );
	btn.pressed.connect( func(): swap_order( 1 if is_move_down else -1 ) );
	return btn;

func __add_space() -> Control:
	var space := Control.new();
	space.custom_minimum_size.x = 32;
	return space;

func __swap_data( arr: Array, from_idx: int, to_idx: int, check_pair := false ):
	if check_pair:
		if arr[ from_idx ] == to_idx and from_idx == arr[ to_idx ]:
			return;
		if arr[ from_idx ] >= 0:
			arr[ arr[ from_idx ] ] = to_idx;
		if arr[ to_idx ] >= 0:
			arr[ arr[ to_idx ] ] = from_idx;
	var temp_data = arr[ from_idx ];
	arr[ from_idx ] = arr[ to_idx ];
	arr[ to_idx ] = temp_data;

func swap_order( offset := 1 ):
	var edit_node := get_edited_object();
	var target_idx := idx + offset;
	__swap_data( edit_node.get( 'command_action' ), idx, target_idx );
	__swap_data( edit_node.get( 'command_priority' ), idx, target_idx );
	__swap_data( edit_node.get( 'command_pair' ), idx, target_idx, true );
	ToolEditor.refresh_editor();

func _ready():
	var edit_node := get_edited_object();
	label = '';
	var slot := GridContainer.new();
	slot.columns = 4;
	add_child.call_deferred( slot );
	
	var priority_label := Label.new();
	priority_label.text = 'Priority';
	slot.add_child.call_deferred( priority_label );
	var priority_input := SpinBox.new();
	while idx >= edit_node.get( 'command_priority' ).size():
		edit_node.get( 'command_priority' ).append(0b0);
	priority_input.value = edit_node.get( 'command_priority' )[ idx ];
	priority_input.value_changed.connect( func( new_value: int ):
			var pair_idx = edit_node.get( 'command_pair' )[ idx ];
			if pair_idx >= 0:
				edit_node.get( 'command_priority' )[ pair_idx ] = new_value;
			edit_node.get( 'command_priority' )[ idx ] = new_value ;
			ToolEditor.refresh_editor() );
	slot.add_child.call_deferred( priority_input );
	
	slot.add_child.call_deferred( __add_space() );
	slot.add_child.call_deferred( __add_control_btn(false) );
	
	var pair_label := Label.new();
	pair_label.text = 'Pair';
	slot.add_child.call_deferred( pair_label );
	var pair_selection := OptionButton.new();
	var cmd_action_name := edit_node.get( 'command_action' );
	pair_selection.add_item( '' );
	for i in cmd_action_name.size():
		pair_selection.add_item( cmd_action_name[ i ] );
		pair_selection.set_item_disabled( i + 1, i == idx );
	while idx >= edit_node.get( 'command_pair' ).size():
		edit_node.get( 'command_pair' ).append(-1);
	pair_selection.selected = edit_node.get( 'command_pair' )[ idx ] + 1;
	pair_selection.item_selected.connect( func( new_value: int ):
			__change_pair( idx, new_value - 1 ) );
	slot.add_child.call_deferred( pair_selection );
	
	slot.add_child.call_deferred( __add_space() );
	slot.add_child.call_deferred( __add_control_btn(true) );

func _update_property():
	pass
