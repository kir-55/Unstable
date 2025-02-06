@tool
class_name SuperscriptEffect
extends RichTextEffect



var bbcode = "sup"  # Define the BBCode tag

# Called for each character in the text
func _process_custom_fx(char_fx):
	char_fx.offset.y -= 10  # Move text up (adjust as needed)
	#char_fx.font_size *= 0.7    # Scale text smaller (adjust as needed)
	return true
