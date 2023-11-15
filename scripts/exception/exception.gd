class_name Exception extends Object

var _clazz_name: String
var _function_name: String


func _init(clazz_name: String, function_name: String) -> void:
    _clazz_name = clazz_name
    _function_name = function_name


func throw_exception() -> void:
    pass