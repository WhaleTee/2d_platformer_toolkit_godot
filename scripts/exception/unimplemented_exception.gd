class_name UnimplementedException extends Exception

const NAME: String = "Unimplemented Exception"

var _message: String = "%s.%s is not implemented yet!"

func throw_exception() -> void:
    push_error(NAME, _message % [_clazz_name, _function_name])