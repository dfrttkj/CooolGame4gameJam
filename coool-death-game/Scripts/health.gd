extends ProgressBar

@onready var status = get_parent()

@onready var gHealth = $CanvasLayer/GhostHealth
@onready var pHealth = $CanvasLayer/PlayerHealth
@onready var timer := $status/Health/Timer

func _ready() -> void:
	timer.start

func _on_timer_timeout() -> void:
	if status.isGhost:
		gHealth -= 1
	else:
		pHealth -= 1
		
	timer.start
