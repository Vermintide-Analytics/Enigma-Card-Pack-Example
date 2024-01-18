local mod = get_mod("Enigma Card Pack Example")
local enigma = get_mod("Enigma")

local buff_templates = BuffTemplates
local new_buff_template = function(name, template)
    buff_templates[name] = template
    mod.enigma_handle.add_network_lookup(NetworkLookup.buff_templates, name)
end

local buff_function_templates = BuffFunctionTemplates.functions
local new_buff_function_template = function(name, func)
    buff_function_templates[name] = func
end

local pickup_templates = AllPickups
local new_pickup_template = function(name, template)
    pickup_templates[name] = template
    mod.enigma_handle.add_network_lookup(NetworkLookup.pickup_names, name)
end


local super_heal_buff_template = table.clone(buff_templates.health_orb)
super_heal_buff_template.buffs[1].apply_buff_func = "super_health_orb_apply_func"
super_heal_buff_template.buffs[1].granted_health = nil
new_buff_template("super_health_orb", super_heal_buff_template)

local super_health_orb_apply_func = function(unit, buff, params, world)
    if not enigma:is_server() then
        mod:warning("Not server, cannot apply super health orb effect")
        return
    end

    local health_ext = ScriptUnit.extension(unit, "health_system")
    if not health_ext then
        mod:warning("No unit health extension, cannot apply super health orb effect")
        return
    end
    local max = health_ext:get_max_health()
    local current_permanent = health_ext:current_permanent_health()
    local heal_amount = max - current_permanent

    mod:info("Super health orb healing unit for "..tostring(heal_amount))
    DamageUtils.heal_network(unit, unit, heal_amount, "buff")
end
new_buff_function_template("super_health_orb_apply_func", super_health_orb_apply_func)

local super_health_orb = table.clone(pickup_templates.health_orb)
super_health_orb.granted_buff = "super_health_orb"
super_health_orb.item_name = "super_health_orb"
new_pickup_template("super_health_orb", super_health_orb)
