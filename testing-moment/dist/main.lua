
    -- esp
    -- c3d545d224dae651ac00456638dd3fe73dbbafa41ea375687e06b6d61dba059e

    syn.run_on_actor(getactors()[1], [[
        local util = {}
do
util_module = {}

function util_module.log(...)
    print("[util]", ...)
end


util = util_module
end

util.log("HI")

    ]]);
    
