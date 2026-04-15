@tool
extends EditorProperty

@export var idx: int;
@export var target_property := '';
@export var lookup_property := 'command_action';

func _ready():
	var edit_node := get_edited_object();
	label = '';
	var slot := GridContainer.new();
	slot.columns = 4;
	add_child.call_deferred( slot );
	while idx >= edit_node.get( target_property ).size():
		edit_node.get( target_property ).append(0b0);
	var cur_cmd_map: int = edit_node.get( target_property )[ idx ];
	for i in edit_node.get( lookup_property ).size():
		var btn = CheckBox.new();
		var cmd_action_name: String = edit_node.get( lookup_property )[ i ];
		btn.text = str(i);
		if !cmd_action_name.is_empty():
			var display_name := '';
			var split := cmd_action_name.split( '_', false );
			while display_name.length() < 2 and !split.is_empty():
				if display_name.is_empty():
					display_name += split[0].left(1);
				else:
					display_name += split[0].capitalize().left(1);
				split.remove_at(0);
			if !display_name.is_empty():
				btn.text = display_name;
		btn.button_pressed = cur_cmd_map & int( pow( 2, i ) );
		btn.pressed.connect( func():
				var code_bit := 0b0;
				for node: CheckBox in slot.get_children():
					if node.button_pressed:
						if lookup_property != 'command_action' and node.get_index() == idx:
							node.button_pressed = false;
							continue;
						code_bit += pow( 2, node.get_index() );
				edit_node.get( target_property )[ idx ] = code_bit;
				);
		slot.add_child.call_deferred( btn );
