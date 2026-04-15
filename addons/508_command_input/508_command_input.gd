@tool
extends EditorPlugin

const PLUGIN_PATH: StringName = &'res://addons/508_command_input/';
const NODE_LIST := [

	[ 'CommandParser', 'Node',
			preload( PLUGIN_PATH + 'node/command_parser.gd' ),
			preload( PLUGIN_PATH + 'icon/command_parser.png' ) ],

	[ 'InputWatcher', 'Node',
			preload( PLUGIN_PATH + 'node/input_watcher.gd' ),
			preload( PLUGIN_PATH + 'icon/input_watcher.png' ) ],

]

static var ToolConfigFile := preload( PLUGIN_PATH + 'module/tool_configfile.gd' );
static var inspector_plugin_obj_cp;
static var inspector_plugin_obj_iw;

func __add_inspector_plugin():
	const InspectorPlugin_CP = preload( PLUGIN_PATH + 'inspector/command_parser_interface.gd' );
	inspector_plugin_obj_cp = InspectorPlugin_CP.new()
	add_inspector_plugin( inspector_plugin_obj_cp );
	const InspectorPlugin_IW = preload( PLUGIN_PATH + 'inspector/input_watcher_interface.gd' );
	inspector_plugin_obj_iw = InspectorPlugin_IW.new()
	add_inspector_plugin( inspector_plugin_obj_iw );

func _enter_tree():
	var config_file := FileAccess.open( PLUGIN_PATH + 'config.ini', FileAccess.READ );
	if config_file:
		var cfg_data := ToolConfigFile.read_config_string( config_file.get_as_text(), TYPE_BOOL );
		if !cfg_data.light_weight_mode[0]:
			__add_inspector_plugin();
		config_file.close();
	
	for item in NODE_LIST:
		add_custom_type( item[0], item[1], item[2], item[3] );

func _exit_tree():
	if inspector_plugin_obj_cp:
		remove_inspector_plugin( inspector_plugin_obj_cp );
	if inspector_plugin_obj_iw:
		remove_inspector_plugin( inspector_plugin_obj_iw );
	for item in NODE_LIST:
		remove_custom_type( item[0] );
