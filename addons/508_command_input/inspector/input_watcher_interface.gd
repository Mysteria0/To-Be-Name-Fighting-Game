@tool
extends EditorInspectorPlugin

const PROPERTY_FOLDER_PATH := 'property/';

func _can_handle( object ):
	return is_instance_of( object,
			preload('../node/input_watcher.gd') );

func __add_action_component( script: GDScript, as_property: String, target_property: String, idx := -1 ):
	var node = script.new();
	node.target_property = target_property;
	if idx >= 0:
		node.idx = idx;
	add_property_editor( as_property, node );

func __add_action_sub_component( script: GDScript, target_property: String, lookup_property: String, idx := 0 ):
	var node = script.new();
	node.target_property = target_property;
	node.lookup_property = lookup_property;
	node.idx = idx;
	add_property_editor( '', node );

func _parse_property( object, type, name, _hint_type, _hint_string, _usage_flags, _wide ):
	match name:
		'watch_action':
			__add_action_component( preload( PROPERTY_FOLDER_PATH + 'setup_display.gd' ),
					name, name );
			for i in object.get( name ).size():
				add_custom_control( HSeparator.new() );
				__add_action_component( preload( PROPERTY_FOLDER_PATH + 'setup_input.gd' ),
						'', name, i );
				__add_action_sub_component(
						preload( PROPERTY_FOLDER_PATH + 'command_action_map.gd' ),
						'intercept_action_map', 'watch_action', i );
				add_custom_control( HSeparator.new() );
			__add_action_component( preload( PROPERTY_FOLDER_PATH + 'setup_add_btn.gd' ),
					'', name );
			return true;
		'intercept_action_map':
			return true;
