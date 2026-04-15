extends GridContainer

@export var cmd_parser: Node;

var btn_dict := {};
func __add_btn( action_name, key_name ):
	if !InputMap.has_action( action_name ):
		add_child.call_deferred( Control.new() );
		return;
	var new_btn := Button.new();
	new_btn.toggle_mode = true;
	new_btn.text = '%s (%s)' % [ action_name, key_name ];
	var new_sb := StyleBoxFlat.new();
	new_sb.bg_color = Color.LIGHT_GRAY;
	new_btn.add_theme_stylebox_override( 'pressed', new_sb );
	add_child.call_deferred( new_btn );
	btn_dict[ action_name ] = new_btn;

func _ready():
	const key_arr := [
		'', 'move_up', '', '', '', 'quick_ab',
		'move_left', 'move_down', 'move_right', '', 'action_a', 'action_b',
	]
	const display_arr := [
		'', 'up', '', '', '', 'C',
		'left', 'down', 'right', '', 'Z', 'X',
	]
	for idx in key_arr.size():
		__add_btn( key_arr[ idx ], display_arr[ idx ] );
	columns = int( float( key_arr.size() ) / 2.0 );

func _process(_delta):
	for action_name in btn_dict:
		btn_dict[ action_name ].button_pressed = Input.is_action_pressed( action_name );
