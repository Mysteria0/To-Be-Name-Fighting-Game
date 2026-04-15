static func refresh_editor():
	var cur_obj := EditorInterface.get_inspector().get_edited_object();
	EditorInterface.edit_node.call_deferred( null );
	EditorInterface.edit_node.call_deferred( cur_obj );
