@tool
extends EditorInspectorPlugin

const PROPERTY_FOLDER_PATH := 'property/';

func _can_handle( object ):
	return is_instance_of( object,
			preload('../node/command_parser.gd') );

func __add_action_component( script: GDScript, as_property: String, target_property: String, idx := -1 ):
	var node = script.new();
	node.target_property = target_property;
	if idx >= 0:
		node.idx = idx;
	add_property_editor( as_property, node );

func __add_action_sub_component( script: GDScript, idx := 0 ):
	var node = script.new();
	node.idx = idx;
	add_property_editor( '', node );

func _parse_property( object, type, name, _hint_type, _hint_string, _usage_flags, _wide ):
	match name:
		'record_size':
			return object.get('auto_record_size');
		'auto_record_size':
			add_property_editor( name, preload( PROPERTY_FOLDER_PATH + 'auto_record_size.gd' ).new() );
			return true;
		'command_action', 'quick_action', 'command_symbol', 'command_list':
			__add_action_component( preload( PROPERTY_FOLDER_PATH + 'setup_display.gd' ),
					name, name );
			for i in object.get( name ).size():
				add_custom_control( HSeparator.new() );
				__add_action_component( preload( PROPERTY_FOLDER_PATH + 'setup_input.gd' ),
						'', name, i );
				if name == 'command_action':
					__add_action_sub_component(
							preload( PROPERTY_FOLDER_PATH + 'command_action_setting.gd' ), i );
				elif name == 'quick_action':
					__add_action_component(
							preload( PROPERTY_FOLDER_PATH + 'command_action_map.gd' ),
							'', 'quick_command_map', i );
				elif name == 'command_symbol':
					__add_action_component(
							preload( PROPERTY_FOLDER_PATH + 'command_action_map.gd' ),
							'', 'command_symbol_map', i );
				add_custom_control( HSeparator.new() );
			__add_action_component( preload( PROPERTY_FOLDER_PATH + 'setup_add_btn.gd' ),
					'', name );
			return true;
		'command_priority', 'command_pair', 'quick_command_map', 'command_symbol_map':
			return true;
