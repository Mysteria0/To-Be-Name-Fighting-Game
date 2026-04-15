#
# PackedByteArray Magic Convertion
# var_to_bytes int format: 2 0 0 0 (8) (16) (24) (32)
# var_to_bytes int format: 2 0 1 0 (8) (16) (24) (32) (40) (48) (56) (64)
# number inside () is bit amount
# positive number
#   from 0 0 0 0 (0, zero not positive but start from here)
#   to 255 255 255 127 (2147483647)
#   than from 0 0 0 128 0 0 0 0 (2147483648)
#   to 255 255 255 255 255 255 255 127 (9223372036854775807)
# negative number
#   from 255 255 255 255 (-1)
#   to 0 0 0 128 (-2147483648)
#   than from 255 255 255 127 255 255 255 255 (-2147483649)
#   to 0 0 0 0 0 0 0 128 (-9223372036854775808)
#

const MAX_BUFFER_SIZE := 8;

#
# non-formated PackedByteArray
# remove type byte and NOT used digi byte
#

static func int_to_fixed_size_byte_array( input: int, buffer_size := MAX_BUFFER_SIZE ) -> PackedByteArray:
	return var_to_bytes( input ).slice( 4, 4 + buffer_size );

static func int_to_min_size_byte_array( input: int ) -> PackedByteArray:
	var result := var_to_bytes( input ).slice(4);
	result.reverse();
	while !result.is_empty() and result[0] == 0:
		result.remove_at(0);
	result.reverse();
	return result;

# non-formated PackedByteArray to int
static func byte_array_to_int( input: PackedByteArray ) -> int:
	var formated: PackedByteArray = input.duplicate();
	formated.reverse();
	formated.append_array( [ 0, 0 if input.size() <= 4 else 1, 0, 2 ] );
	formated.reverse();
	# seem like godot bytes_to_var need at least 8 len to work
	if formated.size() < 8:
		formated.resize( 8 );
	return bytes_to_var( formated );
