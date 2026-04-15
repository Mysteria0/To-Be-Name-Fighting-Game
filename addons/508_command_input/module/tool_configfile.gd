#
# tool to make a file with "string key = variant value" format
# format different to ConfigFile and have indent output, which is more readable for me
# maybe much slower than ConfigFile but readability is key
# use other format if need faster read and write speed
# NOTE: need add group header
#

#
# indent
#

static func __check_indent_area_length( content_str: String, sperate_char := '=' ) -> int:
	var max_input_length := 0;
	
	for line_str in content_str.split('\n'):
		var property_str = line_str.split( sperate_char, true, 1 )[0];
		max_input_length = max( max_input_length, property_str.length() );
	
	return max_input_length;

static func insert_indent( content_str: String, sperate_char := '=', indent_char := 4 ) -> String:
	var result_str := '';
	var max_length = __check_indent_area_length( content_str );
	var max_indent := ceili( max_length / indent_char );
	
	for line_str in content_str.split('\n'):
		var property_str := '';
		var indent_str := '';
		var value_str := '';
		if !line_str.is_empty():
			var line_sp = line_str.split( sperate_char, true, 1 );
			property_str = line_sp[0];
			value_str = line_sp[1];
			indent_str = '';
			var indent_extra_need := max_indent - floori( property_str.length() / indent_char );
			for i in range( 1 + indent_extra_need ):
				indent_str += '\t';
		
		if !result_str.is_empty(): result_str += '\n';
		if !( property_str + indent_str + value_str ).is_empty():
			result_str += property_str + indent_str + '=' + value_str;
	
	return result_str;


#
# make config string
#

static func __get_apply_format( value_format: Variant, idx := 0 ) -> int:
	if value_format is int:
		return value_format;
	elif value_format is Array and value_format.size() > idx:
		return value_format[ idx ];
	else:
		return TYPE_STRING;

static func __correct_format( input, type: int ) -> String:
	if type == typeof( input ):
		if type == TYPE_STRING:	return input;
		else:					return var_to_str( input );
	
	if typeof( input ) == TYPE_STRING and type == TYPE_INT:
		return var_to_str( input.to_int() );
	elif typeof( input ) == TYPE_STRING and type == TYPE_FLOAT:
		return var_to_str( input.to_float() );
	elif typeof( input ) == TYPE_FLOAT and type == TYPE_INT:
		return '%d' % input;
	
	return var_to_str( input );

static func __make_array_value_str( value_array: Array, value_format: Variant ) -> String:
	var value_str = '';
	for idx in value_array.size():
		if !value_str.is_empty():
			value_str += ',';
		value_str += ' ' + __correct_format( value_array[idx], __get_apply_format( value_format, idx ) );
	return value_str;

static func make_config_string( content_dict: Dictionary, value_format: Variant ) -> String:
	var content_str := '';
	
	for key in content_dict:
		var line_str = __correct_format( key, TYPE_STRING ) + '=';
		if content_dict[ key ] is Dictionary:
			continue;
		elif content_dict[ key ] is Array:
			line_str += __make_array_value_str( content_dict[ key ], value_format );
		else:
			line_str += ' ' + __correct_format( content_dict[ key ], __get_apply_format( value_format ) );
		
		if !content_str.is_empty(): content_str += '\n';
		content_str += line_str;
	
	return insert_indent( content_str );

#
# read config string
#

static func __read_data( data_str: String, type: int ) -> Variant:
	if type == TYPE_STRING:
		return data_str;
	elif type == TYPE_INT:
		return data_str.to_int();
	elif type == TYPE_FLOAT:
		return data_str.to_float();
	elif type == TYPE_BOOL:
		var value = str_to_var( data_str );
		if value == null: value = false;
		return value;
	else:
		return str_to_var( data_str );

static func __read_line_data( dict_ref: Dictionary, line_content: String, value_format: Variant ):
	var line_sp := line_content.split('=',true,2);
	var line_key: String = __read_data( line_sp[0], TYPE_STRING );
	var line_data: Array;
	if line_sp.size() > 1:
		var value_sp := line_sp[1].split(',');
		for i in value_sp.size():
			var cur_format: int = TYPE_STRING;
			if value_format is int:
				cur_format = value_format;
			elif value_format is Array and i < value_format.size():
				cur_format = value_format[i];
			line_data.append( __read_data( value_sp[i], cur_format ) );
	dict_ref[ line_key ] = line_data;

static func read_config_string( content_str: String, value_format: Variant ) -> Dictionary:
	content_str = content_str.replace(' ','').replace('\t','');
	var content_data: Dictionary;
	for line_content in content_str.split('\n'):
		var cmt_split := line_content.find('//');
		if cmt_split == 0:
			continue;
		elif cmt_split > 0:
			line_content.substr( 0, cmt_split );
		if line_content.is_empty():
			continue;
		__read_line_data( content_data, line_content, value_format );
	return content_data;
