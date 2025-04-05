extends Node

# Variables
var url : String = "https://api.openai.com/v1/chat/completions"
var temperature : float = 0.5
var max_tokens : int = 1020
var headers = ["Content-Type: application/json", "Authorization: Bearer " + api_key]
var model : String = "gpt-4o"
var messages = [
	{
		"role": "system",
		"content": "You are two characters: Logic (responds logically, with no emotional influence)
		 and Emotion (responds emotionally). Respond to the user in two separate paragraphs, 
		with the logical one first and the emotional one second."
	}
]

var request : HTTPRequest

func _ready():
	request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", Callable(self, "_on_request_completed"))
	$SendButton.pressed.connect(_on_send_button_pressed)

func _on_send_button_pressed():
	var player_dialogue = $PlayerInput.text.strip_edges()
	if player_dialogue == "":
		return

	if player_dialogue.to_lower() == "done":
		get_tree().quit()
		return

	dialogue_request(player_dialogue)

func dialogue_request(player_dialogue: String):
	messages.append({"role": "user", "content": player_dialogue})

	var json = JSON.new()
	var body = json.stringify({
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	})

	var send_request = request.request(url, headers, HTTPClient.METHOD_POST, body)
	if send_request != OK:
		print("Request failed. Code:", send_request)

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	var json = JSON.new()
	if json.parse(body.get_string_from_utf8()) != OK:
		print("Error parsing response")
		return

	var response = json.get_data()
	var message = response["choices"][0]["message"]["content"]
	var logic = ""
	var emotion = ""

	if message.begins_with("Logic:"):
		var split_response = message.split("Emotion:", false)
		if split_response.size() >= 2:
			logic = split_response[0].replace("Logic:", "").strip_edges()
			emotion = split_response[1].strip_edges()
		else:
			logic = message.strip_edges()
	else:
		logic = message.strip_edges()

	# Output to RichTextLabel instead of just printing
	var final_output = "[b]Logic:[/b]\n" + logic + "\n\n[b]Emotion:[/b]\n" + emotion
	$ResponseDisplay.text = ""  # Clear previous
	$ResponseDisplay.modulate = Color.BLACK
	$ResponseDisplay.append_text(final_output)
