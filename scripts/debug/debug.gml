///	@function	debug(message)
///	@description	Posts a debug message to the console of debugging is active
/// @param message {string}	The message to output to console
function debug() {

	var _message = argument[0];

	if (global.__debugging == true) {
		show_debug_message(_message);
	}


}
