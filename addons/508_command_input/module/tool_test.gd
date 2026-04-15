static func test( call_func: Callable, laps: int, times: int ):
	print( '===== ===== ===== ===== ===== ===== ===== ===== ===== =====');
	print( 'Test ', call_func );
	var avg_time := 0.0;
	for l in laps:
		var start_time := Time.get_unix_time_from_system();
		for i in times:
			call_func.call();
		var time_elapsed := Time.get_unix_time_from_system() - start_time;
		avg_time += time_elapsed;
		print( 'Laps ', l, ': execute ', times, ' times in ', time_elapsed );
	avg_time /= float(laps);
	print( 'Total avager time is ', avg_time );
