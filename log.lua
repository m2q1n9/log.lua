-- created by mzq. -*- mode: lua -*-

local log = {}

local _print = print

local _format = function(...)
	return select("#", ...) > 1 and string.format(...) or ...
end

function log.print(level, ...)
	_print(_format("%s %s/%s", os.date("%F %T"), level, _format(...)))
end

function log.print1(level, ...)
	local info = debug.getinfo(3, "Sl")
	local file, line = info.short_src, info.currentline
	file = file:match(".*/(.*).lua") or file
	log.print(level, "%s:%d %s", file, line, _format(...))
end

function log.init(print, dev)
	if print then _print = print end

	if dev then
		log.debug = function(...) log.print1("D", ...) end
	else
		log.debug = function(...) end
	end

	local log_print = dev and log.print1 or log.print
	log.info  = function(...) log_print("I", ...) end
	log.warn  = function(...) log_print("W", ...) end
	log.error = function(...) log_print("E", ...) end

	log.assert = function(v, ...) return assert(v, _format(...)) end
	log.traceback = function(...) log.debug(debug.traceback(_format(...), 2)) end
end

return log
