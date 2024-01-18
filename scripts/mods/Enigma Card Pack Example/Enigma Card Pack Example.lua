local mod = get_mod("Enigma Card Pack Example")

local enigma = get_mod("Enigma")

local my_mod_enigma = enigma.managers.mod:register_mod("Enigma Card Pack Example")
mod.enigma_handle = my_mod_enigma

dofile("scripts/mods/Enigma Card Pack Example/orbs")

local card_pack_id = "my_mod_card_pack"
local card_pack_name = "my_mod_card_pack"
local my_card_pack = my_mod_enigma.register_card_pack(card_pack_id, card_pack_name)


my_card_pack.register_passive_cards({
    super_health_orbs = {
        rarity = enigma.CARD_RARITY.common,
        cost = 1,
        events_server = {
            player_damaged = function(card, self, attacker_unit, damage_amount, hit_zone_name, damage_type, hit_position, damage_direction, damage_source_name, hit_ragdoll_actor, source_attacker_unit, hit_react_type, is_critical_strike, added_dot, first_hit, total_hits, attack_type, backstab_multiplier)
                local damaged_unit = self.unit
                local us = card.context.unit

                if damaged_unit ~= us or damage_type == "temporary_health_degen" then
                    return
                end

                -- Spawn multiple orbs if the card has been played multiple times
                for i=1,card:times_played() do
                    -- "super_health_orb" is our new orb defined in orbs.lua, based on "health_orb" in the base game
                    enigma:spawn_orb("super_health_orb", us)
                end
            end
        },
        required_resource_packages = {
            -- Make sure the dlcs/morris_ingame package is loaded which enables the orb sound effects
            "resource_packages/dlcs/morris_ingame"
        },
        description_lines = {
            {
                format = "my_mod_card_pack_super_health_orbs_description"
            }
        }
    },
})

my_card_pack.register_ability_cards({
    remedy = {
        rarity = enigma.CARD_RARITY.common,
        cost = 1,
        on_play_server = function(card)
            local us = card.context.unit
            enigma:heal(us, 10, us)
        end,
        on_play_local = function(card)
            enigma.managers.game:draw_card()
        end,
        description_lines = {
            {
                format = "my_mod_card_pack_remedy_description",
                parameters = { 10 }
            }
        },
    },
})