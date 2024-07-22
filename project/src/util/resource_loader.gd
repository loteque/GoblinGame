class_name ResourceLoaderUtil
extends RefCounted

static func load_res(filepath: String):
    return load(filepath.trim_suffix(".remap"))
