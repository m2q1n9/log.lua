-- created by mzq. -*- mode: lua -*-

local log = {}

local _format = function(...)
	return select("#", ...) > 1 and string.format(...) or ...
end

local _print = print

function _print1(level, ...)
	_print(_format("%s %s/%s", os.date("%F %T"), level, _format(...)))
end

function _print2(level, ...)
	local info = debug.getinfo(3, "Sl")
	local file, line = info.short_src, info.currentline
	file = file:match(".*/(.*).lua") or file
	_print1(level, "%s:%d %s", file, line, _format(...))
end

function log.init(print, dev)
	if print then _print = print end
	print = dev and _print2 or _print1

	if dev then
		log.debug = function(...) _print2("D", ...) end
	else
		log.debug = function(...) end
	end

	log.info  = function(...) print("I", ...) end
	log.warn  = function(...) print("W", ...) end
	log.error = function(...) print("E", ...) end

	log.assert = function(v, ...) return assert(v, _format(...)) end
	log.traceback = function(...) log.debug(debug.traceback(_format(...), 2)) end
end

return log
