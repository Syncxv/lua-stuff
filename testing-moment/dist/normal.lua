local util = {}
do
util_module = {}

function util_module.log(...)
    print("[util]", ...)
end


util = util_module
end

util.log("HI")
