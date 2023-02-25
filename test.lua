local hey = [[ 

-- hooks
do
    local oldCall; oldCall = hookfunction(call, upvalueFix(function(name, ...)
        local args = {...};

        if (name == "bigaward") then
            local class = contentDatabase.getWeaponClass(args[3]);
            local selectedWeapon = selecedWeapons[weaponClassType[class]]

    .. [[

            if (selectedWeapon) then
                args[3] = selectedWeapon;
            end
        elseif (name == "killfeed" and args[1] == localPlayer) then
            local class = contentDatabase.getWeaponClass(args[4]);
            local selectedWeapon = selecedWeapons[weaponClassType[class]]
    .. [[

            if (selectedWeapon) then
                args[4] = selectedWeapon;
            end
        end

        return oldCall(name, unpack(args));
    end));

    local oldNetworkSend = network.send; network.send = function(self, name, ...)
        local args = {...};

        if (name == "newbullets") then
            local gunName = gamelogic.currentgun.name;
            local class = contentDatabase.getWeaponClass(gunName);
            local weaponData = contentDatabase.getWeaponData((typeof(defaultWeaponCache[class]) == "table" and defaultWeaponCache[class][gunName] or defaultWeaponCache[class]));

            for _, bullet in next, args[1].bullets do
                bullet[1] = bullet[1].Unit * weaponData.bulletspeed;
            end
        end

        if (name == "changeWeapon") then
            local class = contentDatabase.getWeaponClass(args[2]);
            selecedWeapons[args[1]] .. [[= args[2];
            args[3] = (typeof(defaultWeaponCache[class]) == "table" and defaultWeaponCache[class][args[2]] ..
    [[ or defaultWeaponCache[class]);
        elseif (name == "changeAttachment") then
            local name = selecedWeapons[args[1]] .. [[ or "NONE";

            if (not selectedAttachments[name]) then
                selectedAttachments[name] = {};
            end

            selectedAttachments[name][args[2]] .. [[ = args[3] or "";
            return
        end

        return oldNetworkSend(self, name, unpack(args));
    end

    setreadonly(particle, false); local oldParticleNew = particle.new; particle.new = function(data)
        if (data and data.onplayerhit and data.ontouch) then
            local currentGun = gamelogic.currentgun;

            if (currentGun) then
                local gunName = gamelogic.currentgun.name;
                local class = contentDatabase.getWeaponClass(gunName);
                local weaponData = contentDatabase.getWeaponData((typeof(defaultWeaponCache[class]) == "table" and defaultWeaponCache[class][gunName] or defaultWeaponCache[class]));

                if (weaponData) then
                    data.velocity = data.velocity.Unit * weaponData.bulletspeed;
                end
            end
        end

        return oldParticleNew(data);
    end

    local oldLoadGrenade = char.loadgrenade; char.loadgrenade = function(self, name, ...)
        local class = contentDatabase.getWeaponClass(name);
        local selectedWeapon = selecedWeapons[weaponClassType[class]] .. [[

        if (selectedWeapon) then
            name = selectedWeapon;
        end

        return oldLoadGrenade(self, name, ...);
    end

    local loadgun, loadknife; do
        for index, object in next, debug.getupvalues(networkCalls.spawn) do
            if (typeof(object) == "function") then
                local info = debug.getinfo(object);

                if (info.name == "loadgun") then
                    loadgun = index;
                elseif (info.name == "loadknife") then
                    loadknife = index;
                end
            end
        end

        local oldLoadgun = debug.getupvalue(networkCalls.spawn, loadgun); debug.setupvalue(networkCalls.spawn, loadgun, function(name, magsize, sparerounds, attachments, ...)
            local class = contentDatabase.getWeaponClass(name);
            local gunType = weaponClassType[class]
            local selectedWeapon = selecedWeapons[gunType];
            local attachmentData = selectedAttachments[selectedWeapon];

            if (selectedWeapon) then
                name = selectedWeapon;
            end

            if (attachmentData) then
                attachments = attachmentData;
            end

            return oldLoadgun(name, magsize, sparerounds, attachments, ...);
        end);

        local oldLoadknife = debug.getupvalue(networkCalls.spawn, loadknife); debug.setupvalue(networkCalls.spawn, loadknife, function(name, ...)
            local class = contentDatabase.getWeaponClass(name);
            local selectedWeapon = selecedWeapons[weaponClassType[class]] .. [[

            if (selectedWeapon) then
                name = selectedWeapon;
            end

            return oldLoadknife(name, ...);
        end);
    end
end

-- inits
do
    for _, name in next, contentDatabase.getAllWeaponsList() do
        local weaponData = contentDatabase.getWeaponData(name);
        setreadonly(weaponData, false);

        weaponData.unlockrank = 0;
        weaponData.exclusiveunlock = false;
        weaponData.hideunlessowned = false;
        weaponData.supertest = false;
        weaponData.adminonly = false;
    end

    for _, instance in next, categories:GetDescendants() do
        if (instance:IsA("ModuleScript") and instance.Name == "AttachmentData") then
            local attachmentData = require(instance);
            setreadonly(attachmentData, false);

            attachmentData.unlockkills = 0;
        end
    end
end
]]
