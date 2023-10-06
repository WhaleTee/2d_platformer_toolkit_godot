class_name DataHolder extends Resource

@export var can_update_data_after_load: bool

var data_info:= {}:
    get:
        return data_info
    set(_new_data_info):
        pass

func put_data_info(key: String, value: DataHolderVarInfo) -> void:
    data_info[key] = value

func get_data_info(key: String) -> DataHolderVarInfo:
    return data_info.get(key)

func has_data_info(key: String) -> bool:
    return data_info.has(key)

func remove_data_info(key: String) -> void:
    data_info.erase(key)