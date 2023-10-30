class_name FollowObject extends Node2D

@export var target_object: Node2D


func _process(_delta: float):
    if target_object:
        global_position = target_object.global_position