extends Control

func _unhandled_input(event: InputEvent) -> void:
    if event.is_pressed() and event.is_action("ui_accept"):
        get_tree().change_scene_to_file("res://scenes/splash.tscn")
