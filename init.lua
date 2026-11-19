plugin = {
    name = "cheat-checks",
    displayName = "Cheat Checks",
    command = "cheats",
    prefix = "§5CC",
    version = "0.1.4",
    minStarfishVersion = "0.1.0-beta.16",
    description = "Beta. Flags cheaters in Bed Wars games and replays.",
    dependencies = {
        { name = "hypixel-mod-api" },
    },
}

-- engine.lua holds the checks; this file feeds it Starfish's events and
-- says who got flagged.

require("jsrt")
local Engine = require("engine").Engine
local BLOCK_IDS = require("blocknames")

-- Checks ------------------------------------------------------------------

local CHECKS = {
    { "Eagle", "Eagle", "Crouching for 1-3 ticks at every block while bridging." },
    { "Scaffold", "Scaffold", "Keep-Y, towering, a block every tick, fast backwards bridging, safewalk, or a pitch locked at 85." },
    { "FastMine", "FastMine", "Breaking blocks faster than possible." },
    { "AutoTool", "Auto Tool", "The right tool comes into their hand the tick they start mining." },
    { "BreakDelay", "No Break Delay", "Starting the next block straight after a break." },
    { "Timer", "Timer", "Frozen in mid-air, then carrying on from the same spot." },
    { "Stasis", "Stasis", "Hanging still in mid-air while still turning, placing or swinging." },
    { "Displace", "KB Displace", "Head turns away for a moment at a hit and straight back." },
    { "KillAura", "Kill Aura", "Head snaps from one player in reach to another while hitting." },
    { "AntiFireball", "Anti Fireball", "Head snaps onto a fireball and hits it back at once." },
    { "AutoBlock", "AutoBlock", "Sword unblocked for one tick at each hit." },
    { "BlockHit", "Auto Block-Hit", "Blocking right after nearly every hit, same timing each time." },
    { "AutoDefend", "Auto Defend", "Covering a bed faster than by hand, or in an auto defense's order." },
    { "AutoClutch", "Auto Clutch", "Knocked off, then saved by a head snap and blocks every tick." },
    { "AutoBlockIn", "Auto Block-In", "Walls round themselves faster than by hand." },
    { "JumpReset", "Jump Reset", "Jumping the exact tick knockback lands on nearly every hit." },
}
local CHECK = {}
for i, c in ipairs(CHECKS) do CHECK[c[1]] = { order = i, label = c[2], description = c[3] } end

-- Evidence needed per level, as a share of the normal amount.
local SENSITIVITY = {
    low = { Eagle = 2, JumpReset = 2, AutoClutch = 2, Scaffold = 1.5 },
    medium = {},
    high = { all = 0.5 },
}
-- A player's flag line for one check repeats at most every 5 s once it has flagged 3+ times in 5 min.
local REPEAT = { n = 3, windowMs = 300000, gapMs = 5000 }
-- Modes whose items look like cheats (auto bridges, dashes, double jumps): no flags there.
local NO_CHECK_MODES = { "ULTIMATE", "RUSH", "LUCKY", "ARMED", "SWAP" }
local GAME_START = { "Protect your bed and destroy the enemy beds", "powerful upgrades" }
local GAME_END_TITLES = { "VICTORY", "GAME OVER" }
local NPC_NAME = "^[a-z0-9]+$"

-- Settings ----------------------------------------------------------------

starfish.schema.section({
    key = "general",
    label = "Cheat Checks",
    description = "Flags cheaters in Bed Wars games and replays.",
    settings = {
        { key = "general.enabled", type = "toggle", default = true, label = "Enabled", description = "Turns all checks on or off." },
        { key = "sound", type = "soundToggle", default = true, label = "Sound", description = "Sound on a flag." },
        { key = "sensitivity", type = "cycle", default = "medium", label = "Sensitivity", description = "Low: blatant only. Medium: recommended. High: more catches, more false flags.", values = {
            { text = "Low", value = "low" },
            { text = "Medium", value = "medium" },
            { text = "High", value = "high" },
        } },
    },
})
do
    local settings = {}
    for _, c in ipairs(CHECKS) do
        settings[#settings + 1] = { key = "checks." .. c[1], type = "toggle", default = true, label = c[2], description = c[3] }
    end
    starfish.schema.section({ key = "checks", label = "Checks", description = "Turn single checks on or off.", settings = settings })
end

local cfgCache, cfgAt = {}, -1e9
local function cfg(key)
    local now = starfish.time.monotonic()
    if now - cfgAt > 1000 then cfgCache = {}; cfgAt = now end
    local v = cfgCache[key]
    if v == nil then
        v = starfish.config.get(key)
        if v == nil then v = false end
        cfgCache[key] = v
    end
    return v
end
starfish.events.on("config:changed", function() cfgAt = -1e9 end)

-- Blocks ------------------------------------------------------------------

local PASSABLE = {}
for _, id in ipairs({ 0, 6, 8, 9, 10, 11, 27, 28, 30, 31, 32, 37, 38, 39, 40, 50, 51, 55, 59, 63, 66, 68, 69, 70, 72, 75, 76, 77, 83, 90, 104, 105, 106, 115, 119, 131, 132, 141, 142, 143, 147, 148, 157, 171, 175, 176, 177 }) do PASSABLE[id] = true end
local BED = 26

-- Newer names Starfish might use, by ending.
local SUFFIX = { { "_bed$", 26 }, { "_wool$", 35 }, { "_carpet$", 171 }, { "_stained_glass_pane$", 160 }, { "_stained_glass$", 95 }, { "_terracotta$", 159 }, { "_planks$", 5 }, { "_slab$", 44 }, { "_stairs$", 53 }, { "_fence$", 85 }, { "_wall$", 139 }, { "_sapling$", 6 }, { "_tulip$", 38 } }
local ALIAS = { cave_air = 0, void_air = 0, short_grass = 31, tall_grass = 175, cobweb = 30, terracotta = 172, end_stone_bricks = 121, grass_block = 2, oak_log = 17 }
local unknownNames = {}
local nameCache = {}
local function blockType(name)
    local id = nameCache[name]
    if id then return id end
    local n = tostring(name):gsub("^minecraft:", "")
    id = BLOCK_IDS[n] or ALIAS[n]
    if not id then for _, s in ipairs(SUFFIX) do if n:find(s[1]) then id = s[2]; break end end end
    if not id then
        id = 1 -- unknown: count it as a solid block
        if not unknownNames[n] then unknownNames[n] = true; starfish.log.debug("Cheat Checks: unknown block " .. n) end
    end
    nameCache[name] = id
    return id
end

-- Ids may come as numbers (1.8.9) or names: always give the engine numbers.
local function numId(v)
    if type(v) == "number" then return v end
    if type(v) == "string" then return tonumber(v) or blockType(v) end
    return nil
end

local function key(x, y, z) return x .. "," .. y .. "," .. z end

-- The world the checks look at: Starfish's blocks, plus the meta of blocks
-- that changed (Starfish has no meta on 1.8.9).
local World = {}
World.__index = World
function World.new() return setmetatable({ shadow = {}, n = 0, seen = {}, seenN = 0, booms = {}, forced = nil, beds = {}, bedsAt = -1e9 }, World) end
function World:raw(x, y, z)
    if not starfish.world.isChunkLoaded(x // 16, z // 16) then return -1 end
    local b = starfish.world.block({ x = x, y = y, z = z })
    if not b then return 0 end
    return blockType(b.id) << 4
end
function World:get(x, y, z)
    if y < 0 or y > 255 then return 0 end
    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    local k = key(x, y, z)
    local f = self.forced
    if f and f.k == k then return f.v end
    local r = self:raw(x, y, z)
    if r >= 0 then self:remember(k, r) end
    if r <= 0 then return r end
    local s = self.shadow[k]
    if s and (s >> 4) == (r >> 4) then return s end
    return r
end
-- What Starfish showed at a spot, for telling what a block change replaced.
function World:remember(k, r)
    if self.seen[k] == nil then
        self.seenN = self.seenN + 1
        if self.seenN > 100000 then self.seen = {}; self.seenN = 1 end
    end
    self.seen[k] = r
end
function World:set(x, y, z, state)
    if y < 0 or y > 255 then return end
    local k = key(x, y, z)
    if self.shadow[k] == nil then
        self.n = self.n + 1
        if self.n > 200000 then self.shadow = {}; self.n = 1 end
    end
    self.shadow[k] = state
    if (state >> 4) == BED then self.beds = {} end
end
function World:known(x, z) return starfish.world.isChunkLoaded(math.floor(x) // 16, math.floor(z) // 16) end
function World:solidAt(x, y, z) local s = self:get(x, y, z); return s > 0 and not PASSABLE[s >> 4] end
function World:clear() self.shadow = {}; self.n = 0; self.seen = {}; self.seenN = 0; self.booms = {}; self.beds = {}; self.forced = nil end
function World:chunk() end
function World:bulk() end
-- Beds near a spot (feet within r, bed from 3 below to 1 above), foot first.
local DIRS = { { 0, 1, 0 }, { -1, 0, 1 }, { 0, -1, 2 }, { 1, 0, 3 } } -- dx, dz, dir (foot to head)
function World:bedsNear(x, z, r, y)
    local now = starfish.time.monotonic()
    if now - self.bedsAt > 3000 then self.beds = {}; self.bedsAt = now end
    local fx, fz, fy = math.floor(x), math.floor(z), math.floor(y or 64)
    local ck = fx .. "," .. fz .. "," .. fy .. "," .. r
    local hit = self.beds[ck]
    if hit then return hit end
    local out, seen = A(), {}
    for by = fy - 3, fy + 1 do
        for bx = fx - r - 1, fx + r + 1 do
            for bz = fz - r - 1, fz + r + 1 do
                local s = self:get(bx, by, bz)
                if s > 0 and (s >> 4) == BED and not seen[key(bx, by, bz)] then
                    local meta = self.shadow[key(bx, by, bz)]
                    meta = meta and (meta >> 4) == BED and (meta & 15) or nil
                    local foot, head, dir
                    if meta then
                        local d = DIRS[(meta & 3) + 1]
                        if meta & 8 ~= 0 then foot = { bx - d[1], bz - d[2] }; head = { bx, bz } else foot = { bx, bz }; head = { bx + d[1], bz + d[2] } end
                        dir = d[3]
                    else
                        for _, d in ipairs(DIRS) do
                            local o = self:get(bx + d[1], by, bz + d[2])
                            if o > 0 and (o >> 4) == BED then foot = { bx, bz }; head = { bx + d[1], bz + d[2] }; dir = d[3]; break end
                        end
                    end
                    if foot then
                        seen[key(foot[1], by, foot[2])] = true; seen[key(head[1], by, head[2])] = true
                        out:push({ x = foot[1], y = by, z = foot[2], hx = head[1], hz = head[2], dir = dir, k = foot[1] .. "," .. by .. "," .. foot[2] })
                    end
                end
            end
        end
    end
    self.beds[ck] = out
    return out
end

-- Replay clock --------------------------------------------------------------
-- Hypixel /replay: at 0.25x packets come four times slower, at 2x twice as fast, and a jump
-- along the timeline starts everyone's timing fresh instead of looking like a freeze.

local ReplayClock = {}
ReplayClock.__index = ReplayClock
function ReplayClock.new(now) return setmetatable({ t = now, real = now, speed = 1, paused = false, at = nil }, ReplayClock) end
function ReplayClock:now(real)
    local dt = math.max(0, real - self.real)
    self.real = real
    if not self.paused then
        self.t = self.t + dt * self.speed
        if self.at then self.at = self.at + dt * self.speed end
    end
    return self.t
end
local function clockSecs(s)
    local total = 0
    for part in s:gmatch("%d+") do total = total * 60 + tonumber(part) end
    return total
end
function ReplayClock:bar(text, real)
    local state, pos, speed = text:match("(%a+)%s+([%d:]+)%s*/.-([%d.]+)x")
    if not state or (state ~= "Playing" and state ~= "Paused" and state ~= "Finished") then return nil end
    self:now(real)
    self.paused = state ~= "Playing"
    self.speed = math.max(0.05, tonumber(speed) or 1)
    local at = clockSecs(pos) * 1000
    if not self.at then self.at = at; return nil end
    if at < self.at - 2500 or at > self.at + 3500 then
        local from = self.t
        self.t = self.t + 15000; self.at = at
        return { from = from, to = self.t + 1500 }
    end
    -- The bar only shows whole seconds: keep our guess inside it.
    if self.at < at then self.at = at end
    if self.at > at + 1000 then self.at = at + 1000 end
    return nil
end
function ReplayClock:label()
    local s = math.floor((self.at or 0) / 1000)
    local h, m, sec = s // 3600, (s // 60) % 60, s % 60
    if h > 0 then return string.format("%d:%02d:%02d", h, m, sec) end
    return string.format("%02d:%02d", m, sec)
end
local function isReplayBar(text)
    local state = text:match("^(%a+)%s+[%d:]+%s*/%s*[%d:]+")
    return state == "Playing" or state == "Paused" or state == "Finished"
end

-- State ---------------------------------------------------------------------

local world = World.new()
local engine = NEW(Engine, { world = world })
local S = {
    inGame = false, inLobby = false, mode = nil, clock = nil, myEid = nil, myHealth = nil, muted = {},
    flagged = {}, flaggedOrder = {}, seen = {}, errorAt = -1e9, errors = 0, lastError = nil, votes = { first = 0, after = 0 },
}

local function plain(s) return (tostring(s or ""):gsub("§.", "")) end

local function nowT()
    local real = starfish.time.monotonic()
    if S.clock then return S.clock:now(real) end
    return real
end

local function uuidVersion(u) return type(u) == "string" and tonumber(u:sub(15, 15), 16) or nil end

local function playerByUuid(u) return u and starfish.players.byUuid(u) or nil end

local function nameOf(p)
    if not p.name and p.uuid then
        local tab = playerByUuid(p.uuid)
        p.name = tab and tab.name or nil
    end
    return p.name
end

local function teamOfName(name, uuid)
    local tab = playerByUuid(uuid) or (name and starfish.players.byName(plain(name)))
    return tab and tab.team or nil
end

-- Team colour: hitting a teammate does nothing, so it can't be knockback on them.
engine.teamOf = function(_, q)
    local team
    if q and q.name == "you" then
        local me = starfish.players.me()
        team = me and me.team
    elseif q then
        team = teamOfName(nameOf(q), q.uuid)
    end
    local pre = team and team.prefix
    return pre and pre:match("§([0-9a-fA-F])") or nil
end

-- Sensitivity: the evidence a check needs before it flags.
local baseAdd = engine.add
engine.add = function(this, p, check, amount, reason, t, limit)
    local s = SENSITIVITY[cfg("sensitivity") or "medium"] or {}
    local m = s[check] or s.all or 1
    return baseAdd(this, p, check, amount, reason, t, limit * m)
end

local function feed(kind, d)
    if not cfg("general.enabled") then return end
    -- Hypixel lobbies: nothing to check (a world change resets everything anyway).
    if S.inLobby and not S.clock then return end
    engine.inferGround = S.clock ~= nil
    local ok, err = pcall(engine.feed, engine, kind, d, nowT())
    if not ok then
        S.errors = S.errors + 1; S.lastError = kind .. ": " .. tostring(err)
        local now = starfish.time.monotonic()
        if now - S.errorAt > 60000 then
            S.errorAt = now
            starfish.log.warn("Cheat Checks: " .. kind .. ": " .. tostring(err))
        end
    end
end

local function reset()
    world.forced = nil
    engine:reset()
    S.flagged, S.flaggedOrder, S.seen, S.muted = {}, {}, {}, {}
end

-- Flags ---------------------------------------------------------------------

local function noCheckMode()
    local m = S.mode
    if not m then return false end
    m = m:upper()
    for _, w in ipairs(NO_CHECK_MODES) do if m:find(w, 1, true) then return true end end
    return false
end

local function repeatOk(k, t)
    local r = S.seen[k]
    if not r or t < (r.at[#r.at] or t) then r = { at = {}, shown = nil }; S.seen[k] = r end
    r.at[#r.at + 1] = t
    while t - r.at[1] > REPEAT.windowMs do table.remove(r.at, 1) end
    if #r.at > REPEAT.n and r.shown and t - r.shown < REPEAT.gapMs then return false end
    r.shown = t
    return true
end

local function displayName(name, uuid)
    local team = teamOfName(name, uuid)
    if team then return (team.prefix or "") .. name .. (team.suffix or "") end
    return "§7" .. name
end

local function cap(s) s = tostring(s or ""); return s:sub(1, 1):upper() .. s:sub(2) end

local function say(name, uuid, check, vl, reason)
    local c = CHECK[check]
    local vlText = JSSTR(vl)
    local where = S.clock and ("§8[Replay " .. S.clock:label() .. "] ") or ""
    local hover = "§f" .. name .. " §7- §5" .. c.label .. " §8(VL " .. vlText .. ")"
        .. (reason and reason ~= "" and ("\n§7" .. cap(reason)) or "")
        .. "\n\n§8" .. c.description
    local line = where .. displayName(name, uuid) .. " §7flagged §5" .. c.label .. " §8(VL " .. vlText .. ")"
    starfish.chat.info(starfish.text.of(line):hover(hover))
    if cfg("sound") then pcall(starfish.client.world.playSound, "note.pling", { volume = 1.0, pitch = 1.0 }) end
end

engine.onFlag = function(_, f)
    if not CHECK[f.check] or cfg("checks." .. f.check) == false then return end
    if not S.inGame or (not S.clock and noCheckMode()) then return end
    local p = f.player
    local raw = nameOf(p)
    -- (NPCs and Watchdog's fake players have scrambled §k names.)
    if not raw or raw:sub(1, 3) == "§k" then return end
    local replay = S.clock ~= nil
    local name = replay and plain(raw) or raw
    if (replay and #name == 10 and name:match(NPC_NAME)) or (not replay and uuidVersion(p.uuid) == 2) then return end
    local rec = S.flagged[name]
    if not rec then
        rec = { uuid = (not replay) and p.uuid or nil, checks = {}, vl = {} }
        S.flagged[name] = rec
        S.flaggedOrder[#S.flaggedOrder + 1] = name
    end
    rec.checks[f.check] = true
    rec.vl[f.check] = f.vl
    starfish.log.debug("Flagging " .. name .. " for " .. f.check .. " (VL " .. JSSTR(f.vl) .. "): " .. tostring(f.reason))
    starfish.events.emit("cheatchecks:flag", { name = plain(name), uuid = rec.uuid, check = f.check, label = CHECK[f.check].label, vl = f.vl, reason = tostring(f.reason), replay = replay })
    if S.muted[plain(name):lower()] then return end
    if not repeatOk(name .. "|" .. f.check, f.t) then return end
    say(name, rec.uuid, f.check, f.vl, f.reason)
end

-- For other plugins: getFlags(name) -> { {check, label, vl}, ... } or nil;
-- getAllFlags() -> { {name, uuid, checks = {...}}, ... } for this game.
local function flagList(rec)
    local out = {}
    for check in pairs(rec.checks) do out[#out + 1] = { check = check, label = CHECK[check].label, vl = rec.vl[check] } end
    table.sort(out, function(a, b) return CHECK[a.check].order < CHECK[b.check].order end)
    return out
end
starfish.plugin.export("getFlags", function(name)
    if type(name) ~= "string" then return nil end
    local want = plain(name):lower()
    for n, rec in pairs(S.flagged) do
        if plain(n):lower() == want then return flagList(rec) end
    end
    return nil
end)
starfish.plugin.export("getAllFlags", function()
    local out = {}
    for _, n in ipairs(S.flaggedOrder) do
        local rec = S.flagged[n]
        out[#out + 1] = { name = plain(n), uuid = rec.uuid, checks = flagList(rec) }
    end
    return out
end)

-- Events --------------------------------------------------------------------

local function on(name, fn)
    starfish.events.on(name, function(d)
        if d == nil then return end
        local ok, err = pcall(fn, d)
        if not ok then
            S.errors = S.errors + 1; S.lastError = name .. ": " .. tostring(err)
            local now = starfish.time.monotonic()
            if now - S.errorAt > 60000 then S.errorAt = now; starfish.log.warn("Cheat Checks: " .. name .. ": " .. tostring(err)) end
        end
    end)
end

local function entId(d) local e = d.entity; return e and e.entityId end
local function myEid()
    if S.myEid == nil then local me = starfish.players.me(); S.myEid = me and me.entityId end
    return S.myEid
end

-- A new world: everyone starts fresh.
on("session:join", function(d)
    S.myEid = d.entityId
    S.inGame, S.inLobby, S.clock, S.mode, S.myHealth = false, false, nil, nil, nil
    reset()
end)
on("world:respawn", function()
    S.inGame, S.inLobby, S.clock, S.myHealth = false, false, nil, nil
    reset()
end)
on("hypixel:location", function(d)
    if d.success and d.location then
        S.mode = d.location.mode
        S.inLobby = d.location.lobbyName ~= nil
    end
end)

-- Game over: winners fly, ride and dance; checks stop until the next game.
local function gameOver()
    if S.inGame and not S.clock then S.inGame = false end
end
on("chat:title", function(d)
    local text = plain(starfish.text.plain(d.text or d.title or d.message or ""))
    for _, w in ipairs(GAME_END_TITLES) do if text:find(w, 1, true) then gameOver() return end end
end)

on("chat:receive", function(d)
    local text = plain(starfish.text.plain(d.message or ""))
    if d.kind == "actionBar" then
        -- Hypixel /replay: its bar ("Playing 00:31 / 30:33 1.0x") turns the checks on, on the replay's clock.
        text = text:match("^%s*(.-)%s*$")
        if not isReplayBar(text) then return end
        if not S.clock then
            S.clock = ReplayClock.new(starfish.time.monotonic())
            S.inGame = true
            S.flagged, S.flaggedOrder, S.seen = {}, {}, {}
        end
        local jump = S.clock:bar(text, starfish.time.monotonic())
        if jump then
            engine:addStall(jump.from, jump.to)
            S.seen = {} -- watching a bit again: say its flags again too
        end
        return
    end
    if text:find("1st Killer - ", 1, true) and not text:find(": ", 1, true) then gameOver() return end
    if text:find(":", 1, true) then return end
    for _, phrase in ipairs(GAME_START) do
        if text:find(phrase, 1, true) then
            if not S.inGame or not S.clock then
                S.inGame = true
                S.flagged, S.flaggedOrder, S.seen = {}, {}, {}
                engine:clearScores()
            end
            return
        end
    end
end)

-- Your teleports: a pearl keeps your head turned (relative rotation) and reloads nothing.
on("player:positionUpdate", function(d)
    if d.yaw == 0 and d.pitch == 0 then return end
    feed("selfTeleport", {})
end)

-- Blocks. The checks need the block that was there before; Starfish may
-- already have the new one, so remember what changed.
-- Blocks players can place in Bed Wars (wool, clay, glass, end stone, ladder, wood, obsidian, TNT, sponge).
local PLACEABLE = { [35] = true, [159] = true, [172] = true, [20] = true, [95] = true, [121] = true, [65] = true, [5] = true, [49] = true, [46] = true, [19] = true }
-- Starfish already shows the new block and we never saw this spot: guess
-- what was there. Same-type resends (map blocks in bursts) change nothing.
local function guessBefore(k, x, y, z, newType, state)
    local seen = world.seen[k]
    if seen ~= nil and (seen >> 4) ~= newType then return seen end
    if newType == 0 then
        -- Broken: only where someone was mining, or an explosion went off.
        local now = starfish.time.monotonic()
        for _, b in ipairs(world.booms) do
            if now - b.t < 1500 and math.abs(b.x - x) <= 8 and math.abs(b.y - y) <= 8 and math.abs(b.z - z) <= 8 then return 1 << 4 end
        end
        return state
    end
    if PLACEABLE[newType] then return 0 end
    return state
end
on("world:blockChange", function(d)
    local x, y, z = d.x, d.y, d.z
    local state = ((numId(d.blockId) or 0) << 4) | ((d.meta or 0) & 15)
    local k = key(x, y, z)
    local raw = world:raw(x, y, z)
    local s = world.shadow[k]
    local newType = state >> 4
    local before
    if raw < 0 then
        before = -1
    elseif (raw >> 4) ~= newType then
        -- Starfish hasn't changed it yet.
        before = (s and (s >> 4) == (raw >> 4)) and s or raw
        S.votes.after = S.votes.after + 1
    elseif s and (s >> 4) ~= newType then
        before = s
        S.votes.first = S.votes.first + 1
    elseif S.votes.after <= S.votes.first then
        -- Starfish changes its world first: guess what was there.
        before = s or guessBefore(k, x, y, z, newType, state)
    else
        before = s or raw
    end
    world.forced = { k = k, v = before }
    feed("block", { x = x, y = y, z = z, state = state })
    world.forced = nil
    world:set(x, y, z, state)
end)
on("world:explosion", function(d)
    local p = d.position
    if p then
        table.insert(world.booms, { t = starfish.time.monotonic(), x = p.x, y = p.y, z = p.z })
        if #world.booms > 10 then table.remove(world.booms, 1) end
        feed("explosion", { x = p.x, y = p.y, z = p.z })
    end
end)

-- Players and objects.
local OBJECT_IDS = { boat = 1, item = 2, minecart = 10, tnt = 50, ender_crystal = 51, arrow = 60, snowball = 61,
    egg = 62, fireball = 63, small_fireball = 64, ender_pearl = 65, wither_skull = 66, falling_block = 70,
    potion = 73, experience_bottle = 75, firework_rocket = 76, fireworks_rocket = 76, armor_stand = 78, fishing_bobber = 90 }
on("entity:spawn", function(d)
    if d.kind ~= "object" and type(d.kind) == "string" and tonumber(d.type) == nil then
        local id = OBJECT_IDS[d.kind:gsub("^minecraft:", "")]
        if id then d = setmetatable({ kind = "object", type = id }, { __index = d }) end
    end
    if d.kind == "object" or (d.uuid == nil and d.kind ~= "player" and d.kind ~= "minecraft:player") then
        if d.kind == "object" then
            feed("object", { id = d.entityId, type = d.type, x = d.x, y = d.y, z = d.z })
            local v = d.velocity
            if type(v) == "table" and (v.x or 0) ~= 0 then feed("velocity", { id = d.entityId, vx = v.x, vy = v.y, vz = v.z }) end
        end
        return
    end
    local tab = playerByUuid(d.uuid)
    local item = d.currentItem or d.heldItem or d.item
    if type(item) == "table" then item = item.id end
    item = numId(item)
    feed("spawn", { id = d.entityId, uuid = d.uuid, name = tab and tab.name or nil, x = d.x, y = d.y, z = d.z,
        yaw = d.yaw or 0, pitch = d.pitch or 0, item = item or 0 })
end)
on("entity:despawn", function(d)
    local ids = A()
    for _, id in ipairs(d.entityIds or {}) do ids:push(id) end
    if ids.length > 0 then feed("destroy", { ids = ids }) end
end)
on("entity:move", function(d)
    local id = entId(d)
    if not id then return end
    local r = d.rotation
    local yaw, pitch
    if r then yaw, pitch = r.yaw, r.pitch end
    if d.position then
        local p = d.position
        feed("teleport", { id = id, x = p.x, y = p.y, z = p.z, onGround = d.onGround, yaw = yaw, pitch = pitch })
    elseif d.delta then
        local m = d.delta
        feed("move", { id = id, dx = m.x, dy = m.y, dz = m.z, onGround = d.onGround, yaw = yaw, pitch = pitch })
    elseif r then
        feed("look", { id = id, yaw = yaw, pitch = pitch, onGround = d.onGround })
    end
end)
on("entity:headLook", function(d)
    local id = entId(d)
    if id then feed("head", { id = id, yaw = d.headYaw }) end
end)
on("entity:velocity", function(d)
    local id, v = entId(d), d.velocity
    if id and v then feed("velocity", { id = id, vx = v.x, vy = v.y, vz = v.z }) end
end)
on("entity:metadata", function(d)
    local id = entId(d)
    if not id or type(d.metadata) ~= "table" then return end
    for _, m in ipairs(d.metadata) do
        -- Only a packet with nothing but these flags means they toggled something.
        if m.key == 0 then feed("meta", { id = id, flags = m.value, only0 = #d.metadata == 1 }); return end
    end
end)
-- You getting hurt counts as a hit for AutoBlock (a cheater fighting you).
local function hurt(id)
    if id == myEid() then feed("selfHurt", {}) else feed("hurt", { id = id }) end
end
on("entity:animation", function(d)
    local id = entId(d)
    if not id then return end
    if d.animation == 0 then feed("swing", { id = id }) elseif d.animation == 1 then hurt(id) end
end)
on("entity:status", function(d)
    local id = entId(d)
    if id and d.status == 2 then hurt(id) end
end)
on("player:healthUpdate", function(d)
    if type(d.health) == "number" and S.myHealth and d.health < S.myHealth then feed("selfHurt", {}) end
    S.myHealth = d.health
end)
-- Invisibility: a potion runs out, a dead player's never does.
on("entity:effectAdd", function(d)
    local id = entId(d)
    if id and d.effect and tostring(d.effect):find("invisibility", 1, true) then
        feed("effect", { id = id, effectId = 14, duration = d.duration })
    end
end)
local GAMEMODES = { survival = 0, creative = 1, adventure = 2, spectator = 3 }
local function gamemode(p)
    local m = p and (GAMEMODES[p.gamemode] or (type(p.gamemode) == "number" and p.gamemode))
    if p and p.uuid and m then feed("gamemode", { uuid = p.uuid, mode = m }) end
end
on("player:join", gamemode)
on("player:listUpdate", function(d) for _, p in ipairs(d.players or {}) do gamemode(p) end end)
local SLOTS = { held = 0, hand = 0, boots = 1, leggings = 2, chestplate = 3, helmet = 4 }
on("entity:equipmentChange", function(d)
    local id = entId(d)
    local slot = SLOTS[d.slot] or d.slot
    if not id or slot ~= 0 then return end
    local item = d.item
    feed("equip", { id = id, slot = 0, itemId = item and numId(item.id) or -1, meta = item and item.damage or 0 })
end)
on("entity:attributes", function(d)
    local id = entId(d)
    if not id then return end
    for _, a in ipairs(d.properties or d.attributes or {}) do
        local k = a.key or a.name or a.id
        if k == "generic.movementSpeed" or k == "minecraft:generic.movement_speed" or k == "generic.movement_speed" then
            -- The Speed potion's modifier (0.2 per level).
            local amp = 0
            for _, m in ipairs(a.modifiers or {}) do
                local mu = m.uuid or m.id
                if type(mu) == "string" and mu:lower():gsub("-", ""):sub(1, 8) == "91aeaa56" then amp = math.floor((m.amount or 0) / 0.2 + 0.5) end
            end
            feed("attr", { id = id, speedAmp = amp })
            return
        end
    end
end)
on("world:blockBreakAnimation", function(d)
    if type(d.x) == "number" then world:get(d.x, d.y, d.z) end -- remember what is being mined
    feed("breakAnim", { id = d.entityId, x = d.x, y = d.y, z = d.z, stage = d.destroyStage })
end)

-- You: where you are and when you place, so your blocks aren't someone else's.
on("player:move", function(d)
    local p = d.position
    if p and type(p.x) == "number" then feed("self", { x = p.x, y = p.y, z = p.z }) end
end)
on("entity:useItemStart", function(d)
    if d.face ~= nil and d.face ~= 255 and d.face ~= -1 then feed("selfPlace", {}) end
end)

-- Commands ------------------------------------------------------------------

local LIMITS = {}
do
    local C = require("engine").CFG
    LIMITS = { Eagle = C.eagleVL, Scaffold = C.keepYVL, FastMine = C.fastMineVL, BreakDelay = C.breakDelayVL,
        Timer = C.freezeVL, Stasis = C.stasisVL + 1, Displace = C.displaceVL, KillAura = C.auraVL, AntiFireball = C.fbVL,
        AutoTool = C.autoToolVL, AutoBlock = C.abVL, BlockHit = C.blockHitVL, AutoDefend = C.defendVL,
        AutoClutch = C.clutchVL, AutoBlockIn = C.blockInVL, JumpReset = C.jumpResetVL }
end

local function labels(set)
    local out = {}
    for _, c in ipairs(CHECKS) do if set[c[1]] then out[#out + 1] = c[2] end end
    return table.concat(out, ", ")
end

starfish.commands.register("mute", {
    description = "Hide or show a player's flags",
    arguments = { { name = "player", type = "string", description = "Player name" } },
}, function(ctx)
    local k = plain(ctx.args.player):lower()
    if S.muted[k] then S.muted[k] = nil; return "§7Showing flags for §f" .. ctx.args.player .. "§7 again." end
    S.muted[k] = true
    return "§7Hiding flags for §f" .. ctx.args.player .. "§7 until you leave."
end)

starfish.commands.register("flags", { description = "Who flagged this game", default = true }, function()
    if #S.flaggedOrder == 0 then return "§7No flags this game." end
    local lines = { "§fFlags this game:" }
    for _, name in ipairs(S.flaggedOrder) do
        local rec = S.flagged[name]
        lines[#lines + 1] = "§8- " .. displayName(name, rec.uuid) .. " §7" .. labels(rec.checks)
    end
    return starfish.ui.lines(lines)
end)

starfish.commands.register("status", { description = "Show what the checks see" }, function()
    local unknown = {}
    for n in pairs(unknownNames) do unknown[#unknown + 1] = n end
    local players = 0
    for _ in ITER(engine.players:values()) do players = players + 1 end
    return starfish.ui.lines({
        "§7Checks " .. (cfg("general.enabled") and "§aon" or "§coff") .. "§7, " .. (S.clock and "replay" or S.inGame and "in a game" or "not in a game") .. (S.mode and (" §8(" .. S.mode .. ")") or ""),
        "§7Players tracked: §f" .. players,
        "§7Block order: §f" .. S.votes.first .. " first / " .. S.votes.after .. " after",
        "§7Unknown blocks: §f" .. (#unknown > 0 and table.concat(unknown, ", ") or "none"),
        "§7Errors: " .. (S.errors == 0 and "§anone" or ("§c" .. S.errors .. " §8(" .. tostring(S.lastError):sub(1, 120) .. ")")),
    })
end)

local function findPlayer(name)
    local lower = name:lower()
    local found
    local function look(_, p)
        local n = nameOf(p)
        if n and plain(n):lower() == lower then found = p end
    end
    for _, p in ITER(engine.byUuid:values()) do look(nil, p) end
    if not found then for _, p in ITER(engine.players:values()) do look(nil, p) end end
    return found
end

starfish.commands.register("check", {
    description = "Show a player's check levels",
    arguments = { { name = "player", type = "string", description = "Player name" } },
}, function(ctx)
    local name = ctx.args.player
    local p = findPlayer(name)
    if not p then return "§7Nothing seen from §f" .. name .. " §7yet." end
    local lines = { "§7Checks on §f" .. plain(nameOf(p)) }
    local clean = {}
    for _, c in ipairs(CHECKS) do
        local n = c[1]
        if cfg("checks." .. n) ~= false then
            local vl = p.vl[n] or 0
            if vl > 0 then
                local v = JSSTR(math.floor(vl * 10 + 0.5) / 10)
                local state = p.alertAt[n] and ("§cflagged §8(VL " .. v .. ")") or ("§eVL " .. v .. "§8/" .. JSSTR(LIMITS[n] * ((SENSITIVITY[cfg("sensitivity") or "medium"] or {})[n] or (SENSITIVITY[cfg("sensitivity") or "medium"] or {}).all or 1)))
                lines[#lines + 1] = " §7" .. c[2] .. ": " .. state .. (p.why[n] and ("§8 - " .. p.why[n]) or "")
            else
                clean[#clean + 1] = c[2]
            end
        end
    end
    if #clean > 0 then lines[#lines + 1] = " §7Nothing on: §a" .. table.concat(clean, "§8, §a") end
    return starfish.ui.lines(lines)
end)


-- Loaded mid-game (a reload): count it as a game.
do
    local api = starfish.plugins.optional("hypixel-mod-api")
    local loc = api and api.getLocation()
    if loc then
        S.mode = loc.mode
        if loc.mode and loc.serverType == "BEDWARS" then S.inGame = true end
    end
end
