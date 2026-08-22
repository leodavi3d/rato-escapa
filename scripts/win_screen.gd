extends Control

@onready var about_panel: Control = $AboutPanel
@onready var BGVitoria: TextureRect = $BGVitoria
@onready var escapou_label: Label = $EscapouLabel


func _ready() -> void:
	await get_tree().create_timer(5.0).timeout	
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(about_panel, "modulate:a", 1.0, 2.0)
	tween.tween_property(BGVitoria, "modulate:a", 0.0, 2.0)
	tween.tween_property(escapou_label, "modulate:a", 0.0, 2.0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event.is_action("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/splash.tscn")
