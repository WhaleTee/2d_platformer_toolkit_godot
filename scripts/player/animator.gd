class_name PlayerAnimator extends AnimatedSprite2D


const animations = {
    idle = "idle",
    walk = "walk",
    jump = "jump",
    fall = "fall"
}


func _unhandled_input(event: InputEvent):
    handle_walk_input(event)


func handle_walk_input(event: InputEvent):
    if event.is_action_pressed("move_left"):
        flip_h = true
        play(animations.walk)
    elif event.is_action_pressed("move_right"):
        flip_h = false
        play(animations.walk)
    elif event.is_action_released("move_left") or event.is_action_released("move_right"):
        play(animations.idle)
    
    else:
        animation = animations.idle