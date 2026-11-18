-- Cheat Checks engine (compiled to Lua, build aca580f6). Do not edit by hand.
local __exports = {}
local TICK, DEG, PASSABLE, CLIMB_OR_SLOW, SWORDS, FOOD, BOW, TOOLS, BED, LADDER, TALL, FALL, solid, isBlockItem, wrap, adiff, yawTo, CFG, Player, Engine, myauIndex, FACES, raycast, BLOCK_NAMES, blockName
TICK = 50
DEG = (180 / Math.PI)
PASSABLE = NEW(Set, AN(47, 0, 6, 8, 9, 10, 11, 27, 28, 30, 31, 32, 37, 38, 39, 40, 50, 51, 55, 59, 63, 66, 68, 69, 70, 72, 75, 76, 77, 83, 90, 104, 105, 106, 115, 119, 131, 132, 141, 142, 143, 147, 148, 157, 171, 175, 176, 177))
CLIMB_OR_SLOW = NEW(Set, AN(8, 8, 9, 10, 11, 30, 65, 106, 88))
SWORDS = NEW(Set, AN(5, 267, 268, 272, 276, 283))
FOOD = NEW(Set, AN(28, 260, 282, 297, 319, 320, 322, 335, 349, 350, 357, 360, 363, 364, 365, 366, 367, 373, 391, 392, 393, 394, 396, 400, 411, 412, 413, 423, 424))
BOW = 261
TOOLS = NEW(Set, AN(11, 270, 274, 257, 278, 285, 271, 275, 258, 279, 286, 359))
BED = 26
LADDER = 65
TALL = NEW(Set, AN(14, 85, 113, 107, 139, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192))
FALL = AN(1, 0)
local v = 0; local d = 0;
do local i = 1; while (i <= 400) do do v = ((v - 0.08) * 0.98);
d = (d - v);
FALL:push(d); end  i = i + 1; end end
solid = function(_, state)  return ((state > 0) and (not T(PASSABLE:has(SAR(state, 4))))) end
isBlockItem = function(_, id)  return ((id > 0) and (id < 256)) end
wrap = function(_, a)  a = MOD(a, 360);
if (a > 180) then a = (a - 360); end
if (a < (-180)) then a = (a + 360); end
do return a end end
adiff = function(_, a, b)  return Math.abs(wrap(nil, (a - b))) end
yawTo = function(_, dx, dz)  return (Math.atan2((-dx), dz) * DEG) end
CFG = {alertGapMs = 1000, eagleWindow = 2500, eagleMinCrouches = 4, eagleShortMs = 125, eagleSlowMs = 175, eagleSlowAmount = 0.5, eagleSlowSpread = 0.35, eagleLateShare = 0.3, eagleOneTickMs = 75, eagleShortShare = 0.75, eagleHeldShare = 0.4, eagleMinPitch = 50, eagleVL = 3, eagleWaitMs = 1000, displaceMinDist = 1.2, eagleFadePerSec = 0.25, eagleFadeAfterMs = 2000, skipMinBlocks = 6, skipMinCrouches = 2, skipMaxShare = 1, skipStepMs = 120, skipMinSkipped = 2, skipShortMs = 125, skipGapMs = 700, skipAmount = 1.5, eagleFallCool = 1.5, eagleEdgeSpread = 0.55, eagleEdgeWindow = 10000, eagleEdgeN = 12, eagleNeedEdges = true, keepYMinBlocks = 6, keepYMinSpeed = 3.5, keepYMidAirShare = 0.7, keepYVL = 2, keepYGapMs = 700, backMinSpeed = 5.2, backMinBlocks = 5, backVL = 2, rotFailRun = 5, rotVL = 2, rotCrouchMs = 1500, ravenPitchByte = 60, ravenMinBlocks = 10, ravenMinYaws = 8, ravenVL = 2, fastMineVL = 4, fastMineDonePct = 95, breakDelayShortMs = 175, breakDelayMinRun = 4, breakDelayVL = 1.5, breakDelayQuickMs = 120, stasisMinMs = 600, stasisVL = 1, hitHangMs = 1000, hitHangHitMs = 2500, freezeSlackMs = 250, freezeRate = 0.8, freezeMargin = 1, freezeMinTicks = 4, freezeVL = 1, freezeQuietMs = 2000, freezeWetMs = 1000, displaceAt = 60, displaceAround = 40, displaceMaxUpdates = 3, displaceLongAt = 120, displaceVL = 2, displaceOneAt = 75, abWindow = 6000, abMinCycles = 5, abShare = 0.7, abVL = 2, defendRadius = 3, defendBlocks = 13, defendMs = 1000, defendOrder = 6, defendOrderMs = 1600, defendVL = 1, defendSwaps = 3, defendSwapGap = 110, defendSwapMs = 1500, towerRise = 3, towerRate = 3.5, tellyWindow = 3500, tellyPlaces = 5, tellyTurn = 60, tellyRepeat = 3, clutchVL = 2, clutchMinScore = 1, fastPlaceRun = 7, fastPlaceSecond = 15, blockInMs = 400, blockInMin = 4, blockInQuickTurns = 2, blockInFast = 6, blockInFastMs = 600, blockInVL = 2, blockInSteady = 0.25, blockInRing = 5, blockInRingMs = 300, blockInRingSides = 3, auraReach = 4.5, auraAim = 25, auraTurn = 60, auraWindowMs = 2000, auraSwitches = 3, auraVL = 2, auraGapMs = 160, auraFlickMs = 600, auraFlickDeg = 75, auraFlicks = 4, auraFlickAim = 35, auraFlickRange = 10, auraEnemyNear = 6, displaceOtherAim = 40, displaceBusyMs = 1500, snapBackDeg = 15, snapHurtMs = 250, auraAimReplay = 35, auraGapMsReplay = 250, auraFlickMsReplay = 900, autoToolMs = 60, autoToolMin = 6, autoToolShare = 0.3, autoToolVL = 2, fbReach = 6, fbAim = 15, fbSnapMs = 300, fbSnap = 45, fbVL = 2, jumpResetMinHits = 8, jumpResetShare = 0.8, jumpResetVL = 2, jumpResetStandMs = 150, blockHitHits = 10, blockHitMin = 8, blockHitSpanMs = 15000, blockHitAfterMs = 400, blockHitBand = 0.75, blockHitVL = 2, hitClutchMs = 3000, hitClutchBlocks = 8, hitClutchHits = 3, hitClutchLevels = 2, safeMinBlocks = 8, safeMinMs = 2000, safeGapMs = 700, safeHeadDeg = 5, safeMinSpeed = 2, safeBack = 110, safeMaxDiag = 0.6, safeVL = 2, diagMinBlocks = 16, diagMinMs = 3000, diagMinSpeed = 3.7, diagHeadDeg = 3}
Player = CLASS("Player")
Player.constructor = function(this, id, uuid, t)  this.id = id;
this.uuid = uuid;
this.seen = t;
this.x = 0;
this.y = 0;
this.z = 0;
this.yaw = 0;
this.pitch = 0;
this.onGround = true;
this.lastMove = 0;
this.lastUpdate = 0;
this.track = AN(0);
this.rots = AN(0);
this.flags = 0;
this.sneak = false;
this.sprint = false;
this.use = false;
this.sneakStart = 0;
this.crouches = AN(0);
this.useEnd = 0;
this.unblocks = AN(0);
this.held = (-1);
this.heldMeta = 0;
this.heldChanged = 0;
this.swings = AN(0);
this.hurtAt = (-1000000000);
this.knockAt = (-1000000000);
this.velAt = (-1000000000);
this.speedAmp = 0;
this.places = AN(0);
this.breaks = AN(0);
this.dig = nil;
this.vl = {};
this.alertAt = {};
this.why = {};
this.count = {};
this.towerUntil = 0; end
Engine = CLASS("Engine")
Engine.constructor = function(this, opts) if opts == nil then opts = {} end this.onFlag = ORF(opts.onFlag, function() return function(_)   end end);
this.cfg = Object.assign({}, CFG, OR(opts.cfg, {}));
this.world = opts.world;
this.players = NEW(Map);
this.byUuid = NEW(Map);
this.objects = NEW(Map);
this.self = nil;
this.selfPlaceAt = (-1000000000);
this.selfHurtAt = (-1000000000);
this.explosions = AN(0);
this.pending = AN(0);
this.stalls = AN(0);
this.choppy = AN(0);
this.eggs = AN(0);
this.placedAt = NEW(Map);
this.slowAt = NEW(Map);
this.clearedAt = NEW(Map);
this.debug = OR(opts.debug, nil); end
Engine.reset = function(this)  this.world:clear();
this.players:clear();
this.byUuid:clear();
this.objects:clear();
this.explosions = AN(0);
this.pending = AN(0);
this.eggs = AN(0);
this.stalls = AN(0);
this.choppy = AN(0);
this.placedAt:clear();
this.slowAt:clear();
this.clearedAt:clear();
this.selfTrack = AN(0);
this.eagleWaiting = NEW(Set); end
Engine.clearScores = function(this)  for __i2, p in ITER(NEW(Set, ACAT(this.byUuid:values(), this.players:values()))) do do p.vl = {};
p.alertAt = {};
p.why = {};
p.count = {};
p.displaceHits = 0;
p.clutches = 0;
p.clutchPend = nil;
p.fastMine = AN(0);
p.gaps = AN(0);
p.jrN = 0;
p.jrR = 0;
p.jrFlagged = false;
p.jr = nil;
p.eaglePend = AN(0);
p.eagleLastAdd = 0;
p.bhPend = AN(0);
p.bhHits = AN(0);
p.safeRun = nil; end   end end
Engine.feed = function(this, type, d, t)  if (T(this.eagleWaiting) and T(this.eagleWaiting.size)) then for __i4, p in ITER(this.eagleWaiting) do do if (T(p.eaglePend) and T(p.eaglePend.length)) then this:flushEagle(p, t); end
if ((not T(p.eaglePend)) or (not T(p.eaglePend.length))) then this.eagleWaiting:delete(p); end end   end end
if (((t - OR(this.prunedAt, 0)) >= 1000) or (t < OR(this.prunedAt, 0))) then this:prune(t); end
if (((type == "move") or (type == "look")) or (type == "teleport")) then if ((T(this.lastMoveAt) and ((t - this.lastMoveAt) > 250)) and GE(this.players.size, 2)) then this:addStall(this.lastMoveAt, t); end
if ((T(this.lastMoveAt) and ((t - this.lastMoveAt) >= 180)) and GE(this.players.size, 2)) then this.choppy:push({from = this.lastMoveAt, to = t});
if GT(this.choppy.length, 30) then this.choppy:shift(); end end
this.lastMoveAt = t; end
repeat local __s6 = type; if __s6 == "selfTeleport" then this:addStall(t, (t + 1500), true);
break elseif __s6 == "chunk" then this.world:chunk(d);
break elseif __s6 == "bulk" then this.world:bulk(d);
break elseif __s6 == "spawn" then this:spawn(d, t);
break elseif __s6 == "move" then this:move(d, t);
break elseif __s6 == "teleport" then this:move(Object.assign({abs = true}, d), t);
break elseif __s6 == "look" then this:look(d.id, d.yaw, d.pitch, t, d.onGround);
break elseif __s6 == "head" then this:look(d.id, d.yaw, nil, t);
break elseif __s6 == "velocity" then local p = this.players:get(d.id);
if T(p) then p.velAt = t;
p.fall = nil;
break end
local o = this.objects:get(d.id);
if (T(o) and (d.vx ~= nil)) then o.v = AN(3, d.vx, d.vy, d.vz);
if T(o.egg) then o.egg.v = o.v; end
if (o.type == 63) then local big = (Math.hypot(d.vx, d.vz) > 500); local prev = ANDF(big, function() return OR(o.vh, AN(0)):filter(function(_, e)  return (Math.hypot(e[0], e[1]) > 500) end):pop() end);
(function() o.vh = OR(o.vh, AN(0)); return o.vh end)():push(AN(4, d.vx, d.vz, t, d.vy));
if GT(o.vh.length, 40) then o.vh:shift(); end
if (T(prev) and (((prev[0] * d.vx) + (prev[1] * d.vz)) < 0)) then this:fireballFlip(o, prev, t); end end end
break elseif __s6 == "meta" then this:meta(d, t);
break elseif __s6 == "swing" then local p = this.players:get(d.id);
if T(p) then p.swings:push(t);
if GT(p.swings.length, 60) then p.swings:shift(); end
this:onSwing(p, t);
this:stasisLife(p, t, "swing"); end
break elseif __s6 == "hurt" then this:hurt(d.id, t);
break elseif __s6 == "equip" then this:equip(d, t);
break elseif __s6 == "attr" then local p = this.players:get(d.id);
if T(p) then p.speedAmp = d.speedAmp; end
break elseif __s6 == "effect" then this:effect(d, t);
break elseif __s6 == "gamemode" then local p = ANDF(d.uuid, function() return this.byUuid:get(d.uuid) end);
if T(p) then p.gamemode = d.mode;
if ((d.mode == 3) and T(p.invis)) then p.invisKind = "dead"; end end
break elseif __s6 == "breakAnim" then this:breakAnim(d, t);
break elseif __s6 == "block" then this:block(d.x, d.y, d.z, d.state, t);
break elseif __s6 == "multi" then for __i7, r in ITER(d.records) do do this:block((SHL(d.chunkX, 4) + SAR(r.horizontalPos, 4)), r.y, (SHL(d.chunkZ, 4) + BAND(r.horizontalPos, 15)), r.blockId, t); end   end
break elseif __s6 == "explosion" then this.explosions:push({t = t, x = d.x, y = d.y, z = d.z});
if GT(this.explosions.length, 30) then this.explosions:shift(); end
break elseif __s6 == "object" then local o = {type = d.type, x = d.x, y = d.y, z = d.z, t = t, path = AN(1, AN(4, d.x, d.y, d.z, t))};
this.objects:set(d.id, o);
if (d.type == 62) then o.egg = {t = t, x = d.x, y = d.y, z = d.z, v = nil};
this.eggs:push(o.egg);
if GT(this.eggs.length, 20) then this.eggs:shift(); end end
if (d.type == 65) then local best = nil; local bd = 2.5;
for __i9, q in ITER(this.players:values()) do do local dd = Math.hypot((q.x - d.x), ((q.y + 1.5) - d.y), (q.z - d.z));
if (dd < bd) then bd = dd;
best = q; end end   end
if T(best) then this:stasisLife(best, t, "pearl"); end end
break elseif __s6 == "destroy" then for __i11, id in ITER(d.ids) do do this.players:delete(id);
this.objects:delete(id); end   end
break elseif __s6 == "self" then this.self = {x = d.x, y = d.y, z = d.z, t = t};
(function() this.selfTrack = OR(this.selfTrack, AN(0)); return this.selfTrack end)():push(this.self);
if GT(this.selfTrack.length, 60) then this.selfTrack:shift(); end
break elseif __s6 == "selfPlace" then this.selfPlaceAt = t;
break elseif __s6 == "selfHurt" then this.selfHurtAt = t;
(function() this.selfHurts = OR(this.selfHurts, AN(0)); return this.selfHurts end)():push(t);
if GT(this.selfHurts.length, 30) then this.selfHurts:shift(); end
break else break end until true
if T(this.pending.length) then this:flushPending(t); end end
Engine.addStall = function(this, from, to, tp)  this.stalls:push((T(tp) and {from = from, to = to, tp = true} or {from = from, to = to}));
while (GT(this.stalls.length, 1) and (((to - this.stalls[0].to) > 30000) or GT(this.stalls.length, 1000))) do do this.stalls:shift(); end   end end
Engine.prune = function(this, t)  this.prunedAt = t;
for __i14, k, v in ITER2(this.placedAt) do do if ((t - v) > 5000) then this.placedAt:delete(k); end end   end
for __i16, k, v in ITER2(this.clearedAt) do do if ((t - v) > 10000) then this.clearedAt:delete(k); end end   end
for __i18, k, v in ITER2(this.slowAt) do do if ((t - v) > 60000) then this.slowAt:delete(k); end end   end end
Engine.spawn = function(this, d, t)  local p = ANDF(d.uuid, function() return this.byUuid:get(d.uuid) end);
if T(p) then for __i20, id, q in ITER2(this.players) do do if (q == p) then this.players:delete(id); end end   end
p.id = d.id;
p.track = AN(0);
p.rots = AN(0);
p.dig = nil;
p.fall = nil;
p.climb = nil;
p.hang = nil;
p.jr = nil;
p.clutchPend = nil;
p.safeRun = nil;
p.bhPend = AN(0); else p = NEW(Player, d.id, d.uuid, t);
if T(d.uuid) then this.byUuid:set(d.uuid, p); end end
p.name = ORF(d.name, function() return p.name end);
this.players:set(d.id, p);
p.x = d.x;
p.y = d.y;
p.z = d.z;
p.yaw = OR(d.yaw, 0);
p.pitch = OR(d.pitch, 0);
p.lastMove = t;
p.lastUpdate = t;
p.spawnAt = t;
if (d.item ~= nil) then p.held = d.item; end
p.track:push({t = t, x = p.x, y = p.y, z = p.z, g = true, spawn = true}); end
Engine.move = function(this, d, t)  local p = this.players:get(d.id);
if ((d.id ~= nil) and (not T(p))) then local o = this.objects:get(d.id);
if T(o) then if T(d.abs) then o.x = d.x;
o.y = d.y;
o.z = d.z; else o.x = (o.x + d.dx);
o.y = (o.y + d.dy);
o.z = (o.z + d.dz); end
o.path:push(AN(4, o.x, o.y, o.z, t));
if GT(o.path.length, 80) then o.path:shift(); end end
do return end end
if (not T(p)) then do return end end
if (T(p.eaglePend) and T(p.eaglePend.length)) then this:flushEagle(p, t); end
local ox = p.x; local oy = p.y; local oz = p.z;
if T(d.abs) then p.x = d.x;
p.y = d.y;
p.z = d.z; else p.x = (p.x + d.dx);
p.y = (p.y + d.dy);
p.z = (p.z + d.dz); end
local wasGround = p.onGround;
if (d.onGround ~= nil) then p.onGround = ORF(d.onGround, function() return this:standing(p) end); end
if T(p.invis) then this:invisMove(p, t); end
local gap = (t - p.lastUpdate);
if (not T(d.abs)) then this:checkTower(p, t, gap, (p.y - oy)); else p.climb = nil; end
if T(p.jr) then this:trackJumpReset(p, t, (not (not T(d.abs))), oy); end
p.lastUpdate = t;
local moved = (((p.x ~= ox) or (p.y ~= oy)) or (p.z ~= oz));
if T(moved) then this:checkHitHang(p, t, wasGround, ox, oy, oz); end
if T(moved) then p.lastMove = t; end
local e = {t = t, x = p.x, y = p.y, z = p.z, g = p.onGround, tp = (not (not T(d.abs))), gap = gap};
p.track:push(e);
if GT(p.track.length, 120) then p.track:shift(); end
if (d.yaw ~= nil) then this:look(d.id, d.yaw, d.pitch, t); end
if T(moved) then this:checkStasisEnd(p, t, ox, oy, oz); end
this:trackFall(p, t, (not (not T(d.abs))), ox, oy, oz, gap);
if (LT(p.y, oy) and (not T(d.abs))) then this:checkBridgeFall(p, t); end
if T(p.clutchPend) then this:checkClutchLanded(p, t); end end
Engine.standing = function(this, p)  if ((not T(this.inferGround)) or (Math.abs((p.y - Math.round(p.y))) > 0.001)) then do return false end end
local y = (Math.round(p.y) - 1); local w = this.world;
do return ORF(ORF(ORF(w:solidAt(Math.floor((p.x - 0.3)), y, Math.floor((p.z - 0.3))), function() return w:solidAt(Math.floor((p.x - 0.3)), y, Math.floor((p.z + 0.3))) end), function() return w:solidAt(Math.floor((p.x + 0.3)), y, Math.floor((p.z - 0.3))) end), function() return w:solidAt(Math.floor((p.x + 0.3)), y, Math.floor((p.z + 0.3))) end) end end
Engine.look = function(this, id, yaw, pitch, t, onGround)  local p = this.players:get(id);
if (not T(p)) then do return end end
if (pitch == nil) then pitch = p.pitch; end
local changed = ((yaw ~= p.yaw) or (pitch ~= p.pitch));
p.yaw = yaw;
p.pitch = pitch;
if (onGround ~= nil) then p.onGround = ORF(onGround, function() return this:standing(p) end);
if T(p.clutchPend) then this:checkClutchLanded(p, t); end end
local lr = p.rots[(p.rots.length - 1)];
if (T(lr) and ((t - lr.t) <= 5)) then lr.yaw = yaw;
lr.pitch = pitch; else p.rots:push({t = t, yaw = yaw, pitch = pitch});
if GT(p.rots.length, 80) then p.rots:shift(); end end
if T(changed) then this:stasisLife(p, t, "look"); end
if (T(changed) and T(p.swings.length)) then this:checkAura(p, t); end
if (T(p.swingQ) and T(p.swingQ.length)) then this:checkDisplaceSwings(p); end end
Engine.meta = function(this, d, t)  local p = this.players:get(d.id);
if ((not T(p)) or (d.flags == nil)) then do return end end
local f = d.flags; local old = p.flags;
p.flags = f;
local sneak = (not (not T(BAND(f, 2)))); local sprint = (not (not T(BAND(f, 8)))); local use = (not (not T(BAND(f, 16))));
if (T(BAND(f, 16)) and (not T(p.use))) then p.useOn = t; end
if ((not T(BAND(f, 16))) and T(p.use)) then p.lastUse = {["end"] = t, ms = (t - OR(p.useOn, t))}; end
local invis = (not (not T(BAND(f, 32))));
if (T(invis) and (not T(p.invis))) then this:invisOn(p, t); end
if ((not T(invis)) and T(p.invis)) then p.invisKind = nil; end
p.invis = invis;
if (((f == old) and T(p.metaSeen)) and (d.only0 ~= false)) then local prev = OR(p.lastSameAt, (-1000000000));
p.lastSameAt = t;
if ((t - prev) < 160) then p.streamUntil = (t + 300);
p.unblocks = p.unblocks:filter(function(_, u)  return (not ((u.ms == 0) and ((t - u.t) < 500))) end);
local split = p.crouches:filter(function(_, c)  return ANDF(c.split, function() return ((t - c.t) < 500) end) end);
if T(split.length) then p.crouches = p.crouches:filter(function(_, c)  return (not T(split:includes(c))) end);
if T(p.sneak) then p.sneakStart = (split[0].t - split[0].ms);
p.sneakEdge = split[0].edge; end end elseif (t > OR(p.streamUntil, 0)) then if (T(p.use) and T(SWORDS:has(p.held))) then this:unblock(p, t, 0); elseif T(p.sneak) then this:crouch(p, t, (t - p.sneakStart));
p.crouches[(p.crouches.length - 1)].split = true;
p.sneakStart = t;
p.sneakEdge = this:edgeTicks(p, t); end end end
p.metaSeen = true;
if (T(sneak) and (not T(p.sneak))) then p.sneakStart = t;
p.sneakEdge = this:edgeTicks(p, t); end
if ((not T(sneak)) and T(p.sneak)) then this:crouch(p, t, (t - p.sneakStart)); end
if (((T(use) and (not T(p.use))) and T(p.useEnd)) and T(SWORDS:has(p.held))) then this:unblock(p, t, (t - p.useEnd)); end
if ((T(use) and (not T(p.use))) and T(SWORDS:has(p.held))) then this:bhBlock(p, t); end
if ((not T(use)) and T(p.use)) then p.useEnd = t; end
if (T(use) and (not T(p.use))) then p.useStart = t;
p.useItem = p.held;
p.useMeta = p.heldMeta; end
if (T(use) and T(sprint)) then if (not T(p.sprintUseFrom)) then p.sprintUseFrom = t; end else p.sprintUseFrom = 0; end
p.sneak = sneak;
p.sprint = sprint;
p.use = use; end
Engine.equip = function(this, d, t)  local p = this.players:get(d.id);
if ((not T(p)) or (d.slot ~= 0)) then do return end end
local id = (((d.itemId == nil) or (d.itemId == nil)) and (-1) or d.itemId);
if (id ~= p.held) then p.heldChanged = t;
p.heldHistory = OR(p.heldHistory, AN(0));
p.heldHistory:push({t = t, id = id, prev = p.held});
if GT(p.heldHistory.length, 30) then p.heldHistory:shift(); end end
p.held = id;
p.heldMeta = OR(d.meta, 0); end
Engine.hurt = function(this, id, t)  local p = this.players:get(id);
if (not T(p)) then do return end end
if ((t - p.hurtAt) < 40) then do return end end
if ((T(p.invis) and (p.invisKind ~= "dead")) and ((t - OR(p.invisSince, 0)) >= 300)) then p.invisKind = "potion"; end
local fall = this:fallHurt(p, t);
if (not T(fall)) then p.knockAt = t; end
(function() p.hurts = OR(p.hurts, AN(0)); return p.hurts end)():push({t = t, fall = fall});
if GT(p.hurts.length, 30) then p.hurts:shift(); end
this:startJumpReset(p, t, fall);
p.hurtAt = t;
p.fall = nil; end
Engine.hidden = function(this, p)  do return ((not (not T(p.invis))) and (p.invisKind ~= "potion")) end end
Engine.invisOn = function(this, p, t)  p.invisSince = t;
p.invisY = p.y;
p.invisKind = nil;
if (p.gamemode == 3) then p.invisKind = "dead";
do return end end
local e = p.invisEff;
if (T(e) and (Math.abs((t - e.t)) < 1500)) then p.invisKind = (GT(e.dur, 1200) and "dead" or "potion");
do return end end
local u = p.lastUse;
if ((((T(u) and ((t - u["end"]) <= 2500)) and GE(u.ms, 1400)) and LE(u.ms, 1900)) and ((t - p.hurtAt) > 1500)) then p.invisKind = "potion"; end end
Engine.invisMove = function(this, p, t)  if GE(p.y, (p.invisY + 15)) then p.invisKind = "dead"; end end
Engine.effect = function(this, d, t)  local p = this.players:get(d.id);
if ((not T(p)) or (d.effectId ~= 14)) then do return end end
p.invisEff = {t = t, dur = d.duration};
if T(p.invis) then p.invisKind = ((GT(d.duration, 1200) or (p.invisKind == "dead")) and "dead" or "potion"); end end
Engine.posAt = function(this, p, t)  local best = nil;
do local i = (p.track.length - 1); while (i >= 0) do do if LE(p.track[i].t, t) then best = p.track[i];
break end end  i = i - 1; end end
do return ORF(ORF(best, function() return p.track[0] end), function() return {x = p.x, y = p.y, z = p.z, g = p.onGround} end) end end
Engine.rotAt = function(this, p, t)  local best = nil;
do local i = (p.rots.length - 1); while (i >= 0) do do if LE(p.rots[i].t, (t + 5)) then best = p.rots[i];
break end end  i = i - 1; end end
do return ORF(best, function() return {yaw = p.yaw, pitch = p.pitch, t = 0} end) end end
Engine.recentSwing = function(this, p, t, before, after)  do local i = (p.swings.length - 1); while (i >= 0) do do local s = p.swings[i];
if (s < (t - before)) then break end
if (s <= (t + after)) then do return s end end end  i = i - 1; end end
do return 0 end end
Engine.nearExplosion = function(this, p, t, ms, r) if ms == nil then ms = 3000 end if r == nil then r = 9 end for __i25, e in ITER(this.explosions) do do if (((t - e.t) < ms) and (Math.hypot((e.x - p.x), (e.y - p.y), (e.z - p.z)) < r)) then do return true end end end   end
do return false end end
Engine.speedMul = function(this, p, t)  do return (1 + (0.2 * IFX(GT(p.speedAmp, 0), function() return p.speedAmp end, function() return 0 end))) end end
Engine.supportBelow = function(this, x, y, z, depth) if depth == nil then depth = 0.6 end local w = this.world;
for __i27, ox in ITER(AN(2, (-0.3), 0.3)) do do for __i29, oz in ITER(AN(2, (-0.3), 0.3)) do do local bx = Math.floor((x + ox)); local bz = Math.floor((z + oz));
if (not T(w:known(bx, bz))) then do return true end end
do local yy = Math.floor((y - 0.001)); while (yy >= Math.floor((y - depth))) do do if T(w:solidAt(bx, yy, bz)) then do return true end end end  yy = yy - 1; end end end   end end   end
do return false end end
Engine.voidBelow = function(this, x, y, z, depth, placedSince) if depth == nil then depth = 6 end local w = this.world;
for __i32, ox in ITER(AN(2, (-0.3), 0.3)) do do for __i34, oz in ITER(AN(2, (-0.3), 0.3)) do do local bx = Math.floor((x + ox)); local bz = Math.floor((z + oz));
if (not T(w:known(bx, bz))) then do return false end end
do local yy = Math.floor((y - 0.001)); while (yy >= Math.floor((y - depth))) do do if (not T(w:solidAt(bx, yy, bz))) then goto __c36 end
if (placedSince ~= nil) then local at = this.placedAt:get((JSSTR((JSSTR((JSSTR((JSSTR(bx) .. JSSTR(","))) .. JSSTR(yy))) .. JSSTR(","))) .. JSSTR(bz)));
if ((at ~= nil) and (at >= placedSince)) then goto __c36 end end
do return false end end ::__c36:: yy = yy - 1; end end end   end end   end
do return true end end
Engine.couldStand = function(this, x, y, z, placedBefore, goneSince)  local w = this.world;
for __i37, ox in ITER(AN(2, (-0.3), 0.3)) do do for __i39, oz in ITER(AN(2, (-0.3), 0.3)) do do local bx = Math.floor((x + ox)); local bz = Math.floor((z + oz));
if (not T(w:known(bx, bz))) then do return true end end
do local yy = Math.floor((y - 0.001)); while (yy >= Math.floor((y - 1))) do do local k = (JSSTR((JSSTR((JSSTR((JSSTR(bx) .. JSSTR(","))) .. JSSTR(yy))) .. JSSTR(","))) .. JSSTR(bz));
local s = w:get(bx, yy, bz);
if ((s > 0) and T(solid(nil, s))) then local at = this.placedAt:get(k);
if ((at == nil) or (at <= placedBefore)) then do return true end end end
local gone = this.clearedAt:get(k);
if ((gone ~= nil) and (gone >= goneSince)) then do return true end end end  yy = yy - 1; end end
local under = w:get(bx, Math.floor((y - 0.6)), bz);
if ((under > 0) and T(TALL:has(SAR(under, 4)))) then do return true end end end   end end   end
do return false end end
Engine.laggy = function(this, p, from, to)  local bunched = 0;
for __i42, e in ITER(p.track) do do if (LT(e.t, (from - 300)) or GT(e.t, to)) then goto __c43 end
if GT(e.gap, 250) then do return true end end
if (LT(e.gap, 20) and ((function() bunched = bunched + 1; return bunched end)() >= 2)) then do return true end end end ::__c43::  end
do return false end end
Engine.stalled = function(this, from, to)  do return this.stalls:some(function(_, s)  return (GE(s.to, (from - 300)) and LE(s.from, to)) end) end end
Engine.webNear = function(this, x, y, z)  for __i44, dy in ITER(AN(3, 0, 1, (-1))) do do for __i46, ox in ITER(AN(3, (-0.6), 0, 0.6)) do do for __i48, oz in ITER(AN(3, (-0.6), 0, 0.6)) do do local s = this.world:get(Math.floor((x + ox)), Math.floor((y + dy)), Math.floor((z + oz)));
if ((s > 0) and (SAR(s, 4) == 30)) then do return true end end end   end end   end end   end
do return false end end
Engine.climbOrSlow = function(this, x, y, z, before)  local w = this.world;
for __i50, dy in ITER(AN(3, 0, 1, (-1))) do do for __i52, ox in ITER(AN(2, (-0.31), 0.31)) do do for __i54, oz in ITER(AN(2, (-0.31), 0.31)) do do local bx = Math.floor((x + ox)); local by = Math.floor((y + dy)); local bz = Math.floor((z + oz));
local s = w:get(bx, by, bz);
if (not ((s > 0) and T(CLIMB_OR_SLOW:has(SAR(s, 4))))) then goto __c55 end
if (before ~= nil) then local at = this.slowAt:get((JSSTR((JSSTR((JSSTR((JSSTR(bx) .. JSSTR(","))) .. JSSTR(by))) .. JSSTR(","))) .. JSSTR(bz)));
if ((at ~= nil) and (at > before)) then goto __c55 end end
do return true end end ::__c55::  end end   end end   end
do return false end end
Engine.checkTower = function(this, p, t, gap, dy)  local c = this.cfg;
local ticks = Math.max(1, Math.round((gap / 50)));
if ((dy < (-0.04)) or (gap > 400)) then p.climb = nil;
do return end end
if ((dy <= 0) and (not T(p.climb))) then do return end end
local cl = ORF(p.climb, function() return (function() p.climb = {t0 = (t - gap), y0 = (p.y - dy), step = 0, at = 0}; return p.climb end)() end);
if (dy > 0) then cl.step = Math.max(cl.step, (dy / ticks)); end
local rise = (p.y - cl.y0); local ms = (t - cl.t0);
if (LT(rise, c.towerRise) or T(cl.at)) then do return end end
local rate = ((rise / ms) * 1000);
if (T(this.debug) and (not T(cl.dbg))) then cl.dbg = 1;
this:debug(p, "TowerRate", 0, (JSSTR(TOFIXED(rate, 2)) .. " b/s step " .. JSSTR(TOFIXED(cl.step, 2)) .. " rise " .. JSSTR(TOFIXED(rise, 1)) .. " hurt " .. JSSTR(((t - p.hurtAt) < 1500)) .. " blocks " .. JSSTR(p.places:filter(function(_, b)  return ANDF((GE(b.t, (cl.t0 - 100)) and LE(b.t, (t + 50))), function() return b.under end) end).length) .. " any " .. JSSTR(p.places:filter(function(_, b)  return (GE(b.t, (cl.t0 - 100)) and LE(b.t, (t + 50))) end).length) .. " climb " .. JSSTR(this:climbOrSlow(p.x, p.y, p.z)) .. " ms " .. JSSTR(ms) .. " y " .. JSSTR(TOFIXED(p.y, 1))), t); end
if (LT(rate, c.towerRate) or GT(cl.step, 0.45)) then do return end end
if (T(p.towerAt) and ((t - p.towerAt) < 5000)) then do return end end
if ((((t - p.hurtAt) < 1500) or T(this:nearExplosion(p, t, 2000))) or T(this:stalled(cl.t0, t))) then do return end end
if T(this:climbOrSlow(p.x, p.y, p.z)) then do return end end
if (t < OR(p.towerUntil, 0)) then do return end end
local blocks = p.places:filter(function(_, b)  return ANDF((GE(b.t, (cl.t0 - 100)) and LE(b.t, (t + 50))), function() return b.under end) end).length;
if (blocks < (Math.floor(rise) - 1)) then do return end end
cl.at = t;
p.towerAt = t;
this:add(p, "Scaffold", 2, ("towered up " .. JSSTR(TOFIXED(rise, 1)) .. " blocks in " .. JSSTR(TOFIXED((ms / 1000), 2)) .. "s (" .. JSSTR(TOFIXED(rate, 1)) .. " blocks/s) without coming down between blocks - jumping by hand tops out at about 2.5 blocks/s"), t, c.keepYVL); end
Engine.add = function(this, p, check, amount, reason, t, limit)  p.vl[check] = (OR(p.vl[check], 0) + amount);
p.count[check] = (OR(p.count[check], 0) + 1);
if T(reason) then p.why[check] = reason; end
if T(this.debug) then this:debug(p, check, amount, reason, t); end
if (GE(p.vl[check], limit) and ((not T(p.alertAt[check])) or GE((t - p.alertAt[check]), this.cfg.alertGapMs))) then p.alertAt[check] = t;
this:onFlag({player = p, check = check, vl = (Math.round((p.vl[check] * 10)) / 10), reason = p.why[check], t = t}); end end
Engine.cool = function(this, p, check, amount)  if T(p.vl[check]) then p.vl[check] = Math.max(0, (p.vl[check] - amount)); end end
Engine.addEagle = function(this, p, amount, reason, t, limit)  (function() p.eaglePend = OR(p.eaglePend, AN(0)); return p.eaglePend end)():push({amount = amount, reason = reason, t = t, limit = limit});
(function() this.eagleWaiting = OR(this.eagleWaiting, NEW(Set)); return this.eagleWaiting end)():add(p);
this:flushEagle(p, t); end
Engine.flushEagle = function(this, p, t)  while (T(p.eaglePend.length) and GE((t - p.eaglePend[0].t), this.cfg.eagleWaitMs)) do do local e = p.eaglePend:shift();
if (T(p.eagleLastAdd) and T(this.cfg.eagleFadePerSec)) then this:cool(p, "Eagle", ((Math.max(0, ((e.t - p.eagleLastAdd) - this.cfg.eagleFadeAfterMs)) / 1000) * this.cfg.eagleFadePerSec)); end
p.eagleLastAdd = e.t;
this:add(p, "Eagle", e.amount, e.reason, e.t, e.limit); end   end end
Engine.block = function(this, x, y, z, state, t)  local before = this.world:get(x, y, z);
this.world:set(x, y, z, state);
if (before == (-1)) then do return end end
local was = ANDF((before > 0), function() return solid(nil, before) end); local now = ANDF((state > 0), function() return solid(nil, state) end);
if ((not T(was)) and T(now)) then this.pending:push({x = x, y = y, z = z, state = state, t = t, at = t});
this.placedAt:set((JSSTR((JSSTR((JSSTR((JSSTR(x) .. JSSTR(","))) .. JSSTR(y))) .. JSSTR(","))) .. JSSTR(z)), t); end
if (T(was) and (not T(now))) then this:blockGone(x, y, z, before, t); end
if ((state == 0) or (T(was) and (not T(now)))) then this.clearedAt:set((JSSTR((JSSTR((JSSTR((JSSTR(x) .. JSSTR(","))) .. JSSTR(y))) .. JSSTR(","))) .. JSSTR(z)), t); end
if (((state > 0) and T(CLIMB_OR_SLOW:has(SAR(state, 4)))) and (not ((before > 0) and T(CLIMB_OR_SLOW:has(SAR(before, 4)))))) then this.slowAt:set((JSSTR((JSSTR((JSSTR((JSSTR(x) .. JSSTR(","))) .. JSSTR(y))) .. JSSTR(","))) .. JSSTR(z)), t); end end
Engine.flushPending = function(this, t)  local keep = AN(0);
for __i57, b in ITER(this.pending) do do if (((t - b.t) < 60) and GE(t, b.t)) then keep:push(b); else this:placed(b); end end   end
this.pending = keep; end
Engine.placer = function(this, b)  local cx = (b.x + 0.5); local cy = (b.y + 0.5); local cz = (b.z + 0.5);
local best = nil; local bestScore = 1000000000; local second = 1000000000;
for __i59, p in ITER(this.players:values()) do do local pos = this:posAt(p, b.t);
local d = Math.hypot((pos.x - cx), ((pos.y + 1.5) - cy), (pos.z - cz));
if (d > 6) then goto __c60 end
local swung = this:recentSwing(p, b.t, 160, 80);
local holds = ANDF(isBlockItem(nil, p.held), function() return (p.held == SAR(b.state, 4)) end);
if ((not T(swung)) and (not T(holds))) then goto __c60 end
local score = ((d - (T(holds) and 1.5 or 0)) - (T(swung) and 0.8 or 0));
if (score < bestScore) then second = bestScore;
bestScore = score;
best = p; elseif (score < second) then second = score; end end ::__c60::  end
if (T(this.self) and ((b.t - this.selfPlaceAt) < 250)) then local d = Math.hypot((this.self.x - cx), ((this.self.y + 1.5) - cy), (this.self.z - cz));
if ((d < 6) and ((d - 2.3) < bestScore)) then do return nil end end end
do return best end end
Engine.placed = function(this, b)  local p = this:placer(b);
if (not T(p)) then do return end end
this:stasisLife(p, b.t, "block");
local id = SAR(b.state, 4);
if (id == LADDER) then p.towerUntil = (b.t + 4000); end
if LT(b.t, p.towerUntil) then do return end end
if T(this:eggNear(b)) then do return end end
if (T(OR(p.heldHistory, AN(0)):some(function(_, h)  return ((((h.id == 344) or (h.prev == 344)) and ((b.t - h.t) < 3500)) and GE(b.t, h.t)) end)) or ((p.held == 344) and ((b.t - p.heldChanged) < 3500))) then do return end end
local pos = this:posAt(p, b.t);
local rot = this:rotAt(p, b.t);
local feetY = pos.y;
local under = (((LE(b.y, (Math.floor((feetY + 0.01)) - 1)) and GE(b.y, (Math.floor(feetY) - 3))) and (Math.abs(((b.x + 0.5) - pos.x)) <= 1.6)) and (Math.abs(((b.z + 0.5) - pos.z)) <= 1.6));
local air = ((not T(pos.g)) and ((feetY - (b.y + 1)) > 0.15));
local belowAt = this.placedAt:get((JSSTR((JSSTR((JSSTR((JSSTR(b.x) .. JSSTR(","))) .. JSSTR((b.y - 1)))) .. JSSTR(","))) .. JSSTR(b.z)));
local onto = ANDF(this.world:solidAt(b.x, (b.y - 1), b.z), function() return (not ((belowAt ~= nil) and ((b.t - belowAt) < 3000))) end);
local pl = {t = b.t, x = b.x, y = b.y, z = b.z, state = b.state, under = under, air = air, onto = onto, feetY = feetY, px = pos.x, pz = pos.z, yaw = rot.yaw, pitch = rot.pitch};
p.places:push(pl);
if GT(p.places.length, 60) then p.places:shift(); end
this:checkEagle(p, b.t);
this:checkSkippedShifts(p, pl);
this:checkBlockIn(p, pl, pos);
if T(under) then this:checkScaffold(p, pl); end
this:checkDefend(p, pl);
this:checkClutch(p, pl);
if (T(under) and T(air)) then this:checkHitClutch(p, pl); end
this:checkSafewalk(p, pl);
this:checkFastPlace(p, pl);
if T(air) then this:checkTelly(p, b.t); end end
Engine.checkTelly = function(this, p, t)  local c = this.cfg;
if (T(p.tellyLook) and ((t - p.tellyLook) < 1000)) then do return end end
if (T(p.tellyAt) and ((t - p.tellyAt) < 8000)) then do return end end
local from = (t - c.tellyWindow);
if LT(p.places:filter(function(_, b)  return ANDF(GE(b.t, from), function() return b.air end) end).length, c.tellyPlaces) then do return end end
if (((not T(p.rots.length)) or GT(p.rots[0].t, from)) or T(this:stalled(from, t))) then do return end end
p.tellyLook = t;
local ys = AN(0); local ps = AN(0);
local prev = nil; local acc = 0;
do local k = from; while (k <= t) do do local r = this:rotAt(p, k);
acc = ((prev == nil) and 0 or (acc + wrap(nil, (r.yaw - prev))));
prev = r.yaw;
ys:push(acc);
ps:push(r.pitch); end  k = (k + 50); end end
local n = ys.length; local range = (Math.max(SPREAD(ys)) - Math.min(SPREAD(ys)));
if LT(range, c.tellyTurn) then do return end end
local best = 1000000000; local bestL = 0;
do local L = 8; while ((L * 3) <= n) do do local sum = 0;
do local k = 0; while ((k + L) < n) do do sum = (sum + (Math.abs(wrap(nil, (ys[(k + L)] - ys[k]))) + Math.abs((ps[(k + L)] - ps[k])))); end  k = k + 1; end end
local d = (sum / (n - L));
if (d < best) then best = d;
bestL = L; end end  L = L + 1; end end
if T(this.debug) then this:debug(p, "TellyLoop", 0, ("repeat every " .. JSSTR(bestL) .. " ticks, off by " .. JSSTR(TOFIXED(best, 1)) .. " deg (turning " .. JSSTR(Math.round(range)) .. " deg)"), t); end
if GT(best, c.tellyRepeat) then do return end end
do local k = 0; while ((k + bestL) <= n) do do local w = ys:slice(k, ((k + bestL) + 1));
if ((Math.max(SPREAD(w)) - Math.min(SPREAD(w))) < (c.tellyTurn / 2)) then do return end end end  k = (k + bestL); end end
p.tellyAt = t;
this:add(p, "Scaffold", 2, ("telly bridged with the exact same head turns every " .. JSSTR(bestL) .. " ticks (off by only " .. JSSTR(TOFIXED(best, 1)) .. "° on average, turning " .. JSSTR(Math.round(range)) .. "°) - a replayed loop, hands vary far more"), t, c.keepYVL); end
Engine.checkBlockIn = function(this, p, pl, pos)  local c = this.cfg; local t = pl.t;
local fx = Math.floor(pos.x); local fy = Math.floor((pos.y + 0.01)); local fz = Math.floor(pos.z);
local dx = (pl.x - fx); local dy = (pl.y - fy); local dz = (pl.z - fz);
if T(this:checkBlockInRing(p, pl, pos, fy)) then do return end end
local side = (((Math.abs(dx) + Math.abs(dz)) == 1) and ((dy == 0) or (dy == 1)));
local top = (((dx == 0) and (dz == 0)) and (dy == 2));
if ((not T(side)) and (not T(top))) then do return end end
local cell = (JSSTR((JSSTR((JSSTR((JSSTR(fx) .. JSSTR(","))) .. JSSTR(fy))) .. JSSTR(","))) .. JSSTR(fz));
local L = (function() p.shell = OR(p.shell, AN(0)):filter(function(_, e)  return (((t - e.t) <= 1000) and (e.cell == cell)) end); return p.shell end)();
L:push({t = t, cell = cell, dir = (T(top) and "top" or (JSSTR((JSSTR(dx) .. JSSTR(","))) .. JSSTR(dz)))});
if (T(p.blockInAt) and ((t - p.blockInAt) < 3000)) then do return end end
local win = L:filter(function(_, e)  return LE((t - e.t), c.blockInMs) end);
local quick = 0;
do local i = 1; while LT(i, win.length) do do if ((win[i].dir ~= win[(i - 1)].dir) and ((win[i].t - win[(i - 1)].t) <= 75)) then quick = quick + 1; end end  i = i + 1; end end
if ((GE(win.length, c.blockInMin) and GE(quick, c.blockInQuickTurns)) and ((t - win[0].t) >= 100)) then p.blockInAt = t;
this:add(p, "AutoBlockIn", 2, ("blocked themselves in with " .. JSSTR(win.length) .. " blocks in " .. JSSTR(TOFIXED(((t - win[0].t) / 1000), 2)) .. "s, turning to a new side between two ticks " .. JSSTR(quick) .. " times (by hand a new side takes 2+ ticks)"), t, c.blockInVL);
do return end end
local a = L[(L.length - 2)];
if ((T(a) and (a.dir ~= L[(L.length - 1)].dir)) and ((t - a.t) <= 800)) then local rs = p.rots:filter(function(_, r)  return (GT(r.t, (a.t - 5)) and LE(r.t, (t + 5))) end); local steps = AN(0);
do local i = 1; while LT(i, rs.length) do do local dt = ((rs[i].t - rs[(i - 1)].t) / 50);
if ((dt >= 0.5) and (dt <= 1.5)) then steps:push((Math.abs(wrap(nil, (rs[i].yaw - rs[(i - 1)].yaw))) + Math.abs((rs[i].pitch - rs[(i - 1)].pitch)))); end end  i = i + 1; end end
local mv = steps:filter(function(_, x)  return ((x >= 3) and (x <= 40)) end);
if (GE(mv.length, 3) and GE(mv.length, (steps.length - 2))) then local m = (mv:reduce(function(_, x, y)  return (x + y) end, 0) / mv.length); local sd = Math.sqrt((mv:reduce(function(_, x, y)  return (x + POW((y - m), 2)) end, 0) / mv.length));
if LE((sd / m), c.blockInSteady) then p.robotTurns = OR(p.robotTurns, AN(0)):filter(function(_, x)  return ((t - x) <= 2500) end);
p.robotTurns:push(t); end end end
local robot = OR(p.robotTurns, AN(0)):filter(function(_, x)  return ((t - x) <= 2500) end).length;
if (((robot >= 2) and GE(L.length, 4)) and GE(NEW(Set, L:map(function(_, e)  return e.dir end)).size, 3)) then p.blockInAt = t;
this:add(p, "AutoBlockIn", 2, ("blocked themselves in with " .. JSSTR(L.length) .. " blocks, turning from side to side " .. JSSTR(robot) .. " times at a machine-steady speed (hands flick there unevenly)"), t, c.blockInVL);
do return end end
local fast = L:filter(function(_, e)  return LE((t - e.t), c.blockInFastMs) end);
if (GE(fast.length, c.blockInFast) and GE(NEW(Set, fast:map(function(_, e)  return e.dir end)).size, 3)) then p.blockInAt = t;
this:add(p, "AutoBlockIn", 1, ("placed " .. JSSTR(fast.length) .. " blocks around themselves in " .. JSSTR(TOFIXED(((t - fast[0].t) / 1000), 1)) .. "s"), t, c.blockInVL); end end
Engine.checkBlockInRing = function(this, p, pl, pos, fy)  local c = this.cfg; local t = pl.t;
local xs = AN(2, Math.floor((pos.x - 0.3)), Math.floor((pos.x + 0.3))); local zs = AN(2, Math.floor((pos.z - 0.3)), Math.floor((pos.z + 0.3)));
local inX = xs:includes(pl.x); local inZ = zs:includes(pl.z);
local nearX = xs:some(function(_, x)  return (Math.abs((pl.x - x)) <= 1) end); local nearZ = zs:some(function(_, z)  return (Math.abs((pl.z - z)) <= 1) end);
local dy = (pl.y - fy);
local body = ANDF(ANDF(AND(nearX, nearZ), function() return (not (T(inX) and T(inZ))) end), function() return ((dy == 0) or (dy == 1)) end);
local top = ANDF(AND(inX, inZ), function() return (dy == 2) end);
if ((not T(body)) and (not T(top))) then do return false end end
local spot = (JSSTR((JSSTR((JSSTR((JSSTR(pl.x) .. JSSTR(","))) .. JSSTR(pl.y))) .. JSSTR(","))) .. JSSTR(pl.z));
local dir = (T(top) and "top" or (JSSTR((JSSTR(Math.sign((pl.x - Math.floor(pos.x)))) .. JSSTR(","))) .. JSSTR(Math.sign((pl.z - Math.floor(pos.z))))));
local R = (function() p.ring = OR(p.ring, AN(0)):filter(function(_, e)  return (LE((t - e.t), c.blockInRingMs) and (e.spot ~= spot)) end); return p.ring end)();
R:push({t = t, spot = spot, dir = dir});
if (T(p.blockInAt) and ((t - p.blockInAt) < 3000)) then do return false end end
local sides = NEW(Set, R:map(function(_, e)  return e.dir end)).size;
if ((LT(R.length, c.blockInRing) or LT(sides, c.blockInRingSides)) or T(this:stalled((R[0].t - 300), t))) then do return false end end
p.blockInAt = t;
this:add(p, "AutoBlockIn", 2, ("placed " .. JSSTR(R.length) .. " blocks right round their body in " .. JSSTR(TOFIXED(((t - R[0].t) / 1000), 2)) .. "s on " .. JSSTR(sides) .. " sides (by hand that takes about a second)"), t, c.blockInVL);
do return true end end
Engine.checkAutoTool = function(this, p, t)  local c = this.cfg; local h = ANDF(p.heldHistory, function() return p.heldHistory[(p.heldHistory.length - 1)] end);
if ((((not T(h)) or ((t - h.t) > 1000)) or (not T(TOOLS:has(h.id)))) or T(TOOLS:has(h.prev))) then do return end end
local a = (function() p.autoTool = OR(p.autoTool, {fast = 0, all = 0}); return p.autoTool end)();
a.all = a.all + 1;
if GT((t - h.t), c.autoToolMs) then do return end end
a.fast = a.fast + 1;
if ((GE(a.fast, c.autoToolMin) and GE((a.fast / a.all), c.autoToolShare)) and (not (T(p.autoToolAt) and ((t - p.autoToolAt) < 60000)))) then p.autoToolAt = t;
this:add(p, "AutoTool", 2, ("switched to a tool on the same tick they started mining " .. JSSTR(a.fast) .. " times out of " .. JSSTR(a.all) .. " (by hand the hotbar key comes a tick or more before the click)"), t, c.autoToolVL); end end
Engine.fireballAt = function(this, o, t)  local last = o.path[(o.path.length - 1)];
local x = last[0]; local y = last[1]; local z = last[2]; local at = last[3];
local vh = OR(o.vh, AN(0));
do local i = 0; while LT(i, vh.length) do do local from = Math.max(at, vh[i][2]); local to = Math.min(t, IFX(LT((i + 1), vh.length), function() return vh[(i + 1)][2] end, function() return t end));
if (to <= from) then goto __c67 end
local k = (((to - from) / 50) / 8000);
x = (x + (vh[i][0] * k));
y = (y + (OR(vh[i][3], 0) * k));
z = (z + (vh[i][1] * k)); end ::__c67:: i = i + 1; end end
do return {x = x, y = y, z = z} end end
Engine.fireballFlip = function(this, o, prev, t)  local c = this.cfg; local fp = this:fireballAt(o, t); local dir = yawTo(nil, o.v[0], o.v[2]); local came = yawTo(nil, (-prev[0]), (-prev[1]));
for __i68, p in ITER(this.players:values()) do do if (T(this:hidden(p)) or (not T(p.swings:some(function(_, s)  return (((t - s) >= (-20)) and ((t - s) <= 300)) end)))) then goto __c69 end
local ap = this:posAt(p, t);
if GT(Math.hypot((fp.x - ap.x), ((fp.y - ap.y) - 1.6), (fp.z - ap.z)), c.fbReach) then goto __c69 end
local rs = p.rots:filter(function(_, r)  return (LE(r.t, (t + 20)) and GE(r.t, (t - c.fbSnapMs))) end);
local k = (-1);
do local i = (rs.length - 1); while (i >= 0) do do if LE(adiff(nil, rs[i].yaw, dir), c.fbAim) then k = i;
break end end  i = i - 1; end end
if (GT(adiff(nil, p.yaw, dir), c.fbAim) and (k < 0)) then goto __c69 end
if (k < 0) then goto __c69 end
local land = rs[k]; local before = IFX((k > 0), function() return rs[(k - 1)] end, function() return this:rotAt(p, (land.t - 10)) end);
if ((not T(before)) or ((land.t - OR(before.t, 0)) > 160)) then goto __c69 end
local step = adiff(nil, before.yaw, land.yaw); local off = adiff(nil, before.yaw, came);
if T(this.debug) then this:debug(p, "AntiFireballSeen", 0, ("sent a fireball back, last head step " .. JSSTR(Math.round(step)) .. "°"), t); end
if (LT(step, c.fbSnap) or T(this:stalled((t - 1000), t))) then goto __c69 end
p.fbDeflects = (OR(p.fbDeflects, 0) + 1);
this:add(p, "AntiFireball", 1, ("hit a fireball back right as their head snapped " .. JSSTR(Math.round(step)) .. "° onto it in one update" .. JSSTR(((off >= 100) and " (it was coming from behind them)" or "")) .. "; " .. JSSTR(p.fbDeflects) .. " like this"), t, c.fbVL);
do return end end ::__c69::  end end
Engine.slippery = function(this, p, from, t)  for __i71, e in ITER(p.track) do do if (LT(e.t, (from - 1000)) or GT(e.t, t)) then goto __c72 end
for __i73, ox in ITER(AN(2, (-0.3), 0.3)) do do for __i75, oz in ITER(AN(2, (-0.3), 0.3)) do do local s = SAR(this.world:get(Math.floor((e.x + ox)), Math.floor((e.y - 0.1)), Math.floor((e.z + oz))), 4);
if (((s == 79) or (s == 174)) or (s == 165)) then do return true end end end   end end   end end ::__c72::  end
do return false end end
Engine.auraTarget = function(this, p, yaw, t, ap)  local best = nil; local bd = IFX(T(this.inferGround), function() return this.cfg.auraAimReplay end, function() return this.cfg.auraAim end);
for __i77, q, qp in ITER2(this:nearAt(p, t)) do do local d = Math.hypot((qp.x - ap.x), (qp.y - ap.y), (qp.z - ap.z));
if (GT(d, this.cfg.auraReach) or LT(d, this.cfg.displaceMinDist)) then goto __c78 end
local off = adiff(nil, yaw, yawTo(nil, (qp.x - ap.x), (qp.z - ap.z)));
if (off < bd) then bd = off;
best = q; end end ::__c78::  end
do return best end end
Engine.flickTarget = function(this, p, yaw, t)  local ap = this:posAt(p, t); local c = this.cfg;
for __i79, q, qp in ITER2(this:nearAt(p, t)) do do local d = Math.hypot((qp.x - ap.x), (qp.y - ap.y), (qp.z - ap.z));
if (GT(d, c.auraFlickRange) or LT(d, c.displaceMinDist)) then goto __c80 end
if LE(adiff(nil, yaw, yawTo(nil, (qp.x - ap.x), (qp.z - ap.z))), c.auraFlickAim) then do return q end end end ::__c80::  end
do return nil end end
Engine.sameTeam = function(this, a, q)  if ((not T(this.teamOf)) or (q.name == "you")) then do return false end end
local __ok81, __e82, __r83 = pcall(function() local x = this:teamOf(a); local y = this:teamOf(q);
do return ((not (not T(x))) and (x == y)) end end) if not __ok81 then local e = __e82; do return false end end if __ok81 and __e82 ~= nil then return __e82 end end
Engine.nearAt = function(this, a, t)  local near = AN(0);
for __i84, q in ITER(this.players:values()) do do if ((q ~= a) and (not T(this:hidden(q)))) then near:push(AN(2, q, this:posAt(q, t))); end end   end
if (T(this.self) and (Math.abs((t - this.self.t)) < 1500)) then local sp = this.self;
for __i86, e in ITER(OR(this.selfTrack, AN(0))) do do if (Math.abs((e.t - t)) < Math.abs((sp.t - t))) then sp = e; end end   end
near:push(AN(2, ORF(this.selfQ, function() return (function() this.selfQ = {name = "you"}; return this.selfQ end)() end), sp)); end
do return near end end
Engine.checkAura = function(this, p, t)  local c = this.cfg; local rs = p.rots; local n = rs.length;
if (n < 2) then do return end end
local a = rs[(n - 2)]; local b = rs[(n - 1)];
if (((b.t - a.t) > IFX(T(this.inferGround), function() return c.auraGapMsReplay end, function() return c.auraGapMs end)) or LT(adiff(nil, a.yaw, b.yaw), c.auraTurn)) then do return end end
if (not T(p.swings:some(function(_, s)  return (Math.abs((s - b.t)) <= 300) end))) then do return end end
if (T(this:stalled((a.t - 1000), b.t)) or T(this.choppy:some(function(_, g)  return (GE(g.to, (a.t - 1500)) and LE(g.from, b.t)) end))) then do return end end
local F = (function() p.auraFlicks = OR(p.auraFlicks, AN(0)):filter(function(_, e)  return ((b.t - e.t) <= IFX(T(this.inferGround), function() return c.auraFlickMsReplay end, function() return c.auraFlickMs end)) end); return p.auraFlicks end)();
local dir = Math.sign(wrap(nil, (b.yaw - a.yaw)));
local ap0 = this:posAt(p, b.t); local close = this:nearAt(p, b.t):filter(function(_, __p88) local q = __p88[0] local qp = __p88[1] return LE(Math.hypot((qp.x - ap0.x), (qp.y - ap0.y), (qp.z - ap0.z)), c.auraEnemyNear) end);
local onto = ORF(this:flickTarget(p, b.yaw, b.t), function() return this:flickTarget(p, a.yaw, a.t) end);
if (((GE(adiff(nil, a.yaw, b.yaw), c.auraFlickDeg) and GE(close.length, 2)) and T(close:some(function(_, __p89) local q = __p89[0] return (not T(this:sameTeam(p, q))) end))) and T(onto)) then F:push({t = b.t, dir = dir, deg = Math.round(adiff(nil, a.yaw, b.yaw)), onto = onto});
local rev = 0;
do local i = 1; while LT(i, F.length) do do if (F[i].dir ~= F[(i - 1)].dir) then rev = rev + 1; end end  i = i + 1; end end
if (((GE(F.length, c.auraFlicks) and (rev >= (c.auraFlicks - 2))) and GE(NEW(Set, F:map(function(_, e)  return e.onto end)).size, 2)) and (not (T(p.auraAt) and ((b.t - p.auraAt) < 3000)))) then p.auraAt = b.t;
this:add(p, "KillAura", 2, ("head flicked " .. JSSTR(F.length) .. " times in " .. JSSTR(TOFIXED(((b.t - F[0].t) / 1000), 2)) .. "s while hitting (turns of " .. JSSTR(F:map(function(_, e)  return (JSSTR(e.deg) .. JSSTR("°")) end):join(", ")) .. "), back and forth faster than a hand can"), t, c.auraVL);
do return end end end
local ap = this:posAt(p, b.t);
local ta = this:auraTarget(p, a.yaw, a.t, this:posAt(p, a.t)); local tb = this:auraTarget(p, b.yaw, b.t, ap);
if ((((not T(ta)) or (not T(tb))) or (ta == tb)) or (T(this:sameTeam(p, ta)) and T(this:sameTeam(p, tb)))) then do return end end
local L = (function() p.auraSw = OR(p.auraSw, AN(0)):filter(function(_, e)  return LE((b.t - e.t), c.auraWindowMs) end); return p.auraSw end)();
L:push({t = b.t, deg = Math.round(adiff(nil, a.yaw, b.yaw)), names = AN(2, OR(ta.name, "a player"), OR(tb.name, "a player"))});
if (LT(L.length, c.auraSwitches) or (T(p.auraAt) and ((b.t - p.auraAt) < 3000))) then do return end end
p.auraAt = b.t;
local names = ACAT(NEW(Set, L:flatMap(function(_, e)  return e.names end))):slice(0, 3):join(" and ");
this:add(p, "KillAura", 2, ("head snapped straight from one player to another " .. JSSTR(L.length) .. " times in " .. JSSTR(TOFIXED(((b.t - L[0].t) / 1000), 1)) .. "s while hitting (" .. JSSTR(names) .. "; turns of " .. JSSTR(L:map(function(_, e)  return (JSSTR(e.deg) .. JSSTR("°")) end):join(", ")) .. "), landing dead on each one"), t, c.auraVL); end
Engine.checkFastPlace = function(this, p, pl)  local c = this.cfg; local t = pl.t;
local prev = p.places[(p.places.length - 2)];
local near = ANDF(ANDF(ANDF(prev, function() return (Math.abs((prev.x - pl.x)) <= 2) end), function() return (Math.abs((prev.y - pl.y)) <= 2) end), function() return (Math.abs((prev.z - pl.z)) <= 2) end);
if ((T(prev) and T(near)) and ((t - prev.t) <= 75)) then p.tickRun = (OR(p.tickRun, 1) + 1); else p.tickRun = 1;
p.tickRunFrom = t; end
local sec = p.places:filter(function(_, b)  return ((t - b.t) <= 1000) end);
local secOk = function(_)  return (LT(sec:filter(function(_, b)  return (not T(this:posAt(p, b.t).g)) end).length, (sec.length / 2)) and GE(sec:filter(function(_, b)  return b.under end).length, (sec.length / 2))) end;
if (((GE(sec.length, c.fastPlaceSecond) and (not (T(p.fastPlaceAt) and ((t - p.fastPlaceAt) < 3000)))) and (not T(this:stalled(sec[0].t, t)))) and T(secOk(nil))) then p.fastPlaceAt = t;
this:add(p, "Scaffold", 2, ("placed " .. JSSTR(sec.length) .. " blocks in " .. JSSTR(TOFIXED(((t - sec[0].t) / 1000), 1)) .. "s (by hand it's at most about 11 in 1.5 s)"), t, c.keepYVL);
do return end end
if (LT(p.tickRun, c.fastPlaceRun) or (T(p.fastPlaceAt) and ((t - p.fastPlaceAt) < 3000))) then do return end end
if T(this:stalled(p.tickRunFrom, t)) then do return end end
local run = p.places:slice((-p.tickRun));
local ms = (t - run[0].t);
if (ms > (p.tickRun * 60)) then do return end end
p.fastPlaceAt = t;
local inAir = run:filter(function(_, b)  return (not T(this:posAt(p, b.t).g)) end).length;
if (inAir >= (run.length / 2)) then local under = run:filter(function(_, b)  return b.under end);
if (LT(under.length, (run.length / 2)) or (not T(this:knockedOff(p, t)))) then do return end end
if (not T(run:some(function(_, b)  return this:fallingAt(p, b.t, b.feetY) end))) then do return end end
local pos = this:posAt(p, (run[0].t - 100));
if (not T(this:voidBelow(pos.x, pos.y, pos.z, 4, (run[0].t - 600)))) then do return end end
this:proposeClutch(p, t, 2, ("placed " .. JSSTR(run.length) .. " blocks in a row while falling, one every tick (" .. JSSTR(ms) .. " ms) - by hand it's at most about 6"), under);
do return end end
if LT(run:filter(function(_, b)  return b.under end).length, (run.length / 2)) then do return end end
this:add(p, "Scaffold", 2, ("placed " .. JSSTR(run.length) .. " blocks in a row, one every tick (" .. JSSTR(ms) .. " ms) - by hand it's at most about 6"), t, c.keepYVL); end
Engine.eggNear = function(this, b)  for __i91, o in ITER(this.objects:values()) do do if (o.type ~= 62) then goto __c92 end
for __i93, __v94 in ITER(o.path) do local x = __v94[0] local y = __v94[1] local z = __v94[2] do if (((Math.abs(((x - b.x) - 0.5)) < 2.5) and (Math.abs((y - b.y)) < 3.5)) and (Math.abs(((z - b.z) - 0.5)) < 2.5)) then do return true end end end   end end ::__c92::  end
for __i96, e in ITER(this.eggs) do do if (((b.t - e.t) > 4000) or LT(b.t, (e.t - 100))) then goto __c97 end
local px = ((b.x + 0.5) - e.x); local py = ((b.y + 0.5) - e.y); local pz = ((b.z + 0.5) - e.z);
if ((not T(e.v)) or (Math.hypot(e.v[0], e.v[2]) < 0.000001)) then if ((Math.hypot(px, pz) < 3) and (Math.abs(py) < 4)) then do return true end end
goto __c97 end
local len = Math.hypot(e.v[0], e.v[2]);
local ux = (e.v[0] / len); local uz = (e.v[2] / len);
local along = ((px * ux) + (pz * uz)); local side = Math.abs(((px * uz) - (pz * ux)));
if ((((along > (-3)) and (along < 45)) and (side < 2.5)) and (Math.abs(py) < 4)) then do return true end end end ::__c97::  end
do return false end end
Engine.breakAnim = function(this, d, t)  local p = this.players:get(d.id);
if (not T(p)) then do return end end
if ((T(p.invis) and (p.invisKind ~= "dead")) and GE(d.stage, 0)) then p.invisKind = "potion"; end
local k = (JSSTR((JSSTR((JSSTR((JSSTR(d.x) .. JSSTR(","))) .. JSSTR(d.y))) .. JSSTR(","))) .. JSSTR(d.z));
if GE(d.stage, 0) then if (((not T(p.dig)) or (p.dig.k ~= k)) or T(p.dig.ended)) then local last = p.breaks[(p.breaks.length - 1)];
p.dig = {k = k, x = d.x, y = d.y, z = d.z, t0 = t, from = t, max = d.stage, last = d.stage, n = 1, hist = AN(1, AN(2, t, d.stage)), block = this.world:get(d.x, d.y, d.z), afterBreak = (T(last) and (t - last.t) or 1000000000), lastBreak = last};
this:checkAutoTool(p, t); elseif LT(d.stage, p.dig.last) then local g = p.dig;
g.from = t;
g.max = d.stage;
g.last = d.stage;
g.n = 1;
g.hist = AN(1, AN(2, t, d.stage)); else local g = p.dig;
g.max = Math.max(g.max, d.stage);
g.last = d.stage;
g.n = g.n + 1;
if LT(g.hist.length, 40) then g.hist:push(AN(2, t, d.stage)); end end elseif ((T(p.dig) and (p.dig.k == k)) and (not T(p.dig.ended))) then p.dig.ended = t;
if (T(p.dig.goneAt) and (Math.abs((p.dig.goneAt - t)) < 200)) then this:digDone(p, p.dig, t); end end end
Engine.blockGone = function(this, x, y, z, before, t)  local k = (JSSTR((JSSTR((JSSTR((JSSTR(x) .. JSSTR(","))) .. JSSTR(y))) .. JSSTR(","))) .. JSSTR(z));
for __i98, p in ITER(this.players:values()) do do local g = p.dig;
if (((not T(g)) or (g.k ~= k)) or T(g.done)) then goto __c99 end
g.goneAt = t;
g.block = before;
if (T(g.ended) and (Math.abs((g.ended - t)) < 200)) then this:digDone(p, g, t); end end ::__c99::  end end
Engine.digDone = function(this, p, g, t)  g.done = true;
local brk = {t = t, t0 = g.t0, from = g.from, stage = g.max, hist = g.hist, x = g.x, y = g.y, z = g.z, n = g.n, block = g.block, afterBreak = g.afterBreak, lastBreak = g.lastBreak};
p.breaks:push(brk);
if GT(p.breaks.length, 30) then p.breaks:shift(); end
this:checkFastMine(p, brk);
this:checkBreakDelay(p, brk); end
Engine.crouch = function(this, p, t, ms)  p.crouches:push({t = t, ms = ms, edge = p.sneakEdge});
p.sneakEdge = nil;
if GT(p.crouches.length, 40) then p.crouches:shift(); end
this:checkEagle(p, t); end
Engine.checkEagle = function(this, p, t)  local c = this.cfg;
local from = (t - c.eagleWindow);
local bridge = p.places:filter(function(_, b)  return ANDF(ANDF(ANDF(GE(b.t, from), function() return b.under end), function() return (not T(b.air)) end), function() return GE(b.pitch, c.eagleMinPitch) end) end);
if LT(bridge.length, 3) then do return end end
local cr = p.crouches:filter(function(_, x)  return GE(x.t, from) end);
if LT(cr.length, c.eagleMinCrouches) then do return end end
if (T(p.eagleAt) and ((t - p.eagleAt) < 1000)) then do return end end
local edges = p.crouches:filter(function(_, x)  return (GE(x.t, (t - c.eagleEdgeWindow)) and (x.edge ~= nil)) end):slice((-c.eagleEdgeN)):map(function(_, x)  return x.edge end):sort(function(_, a, b)  return (a - b) end);
local spread = (GE(edges.length, c.eagleMinCrouches) and (edges[Math.floor((edges.length * 0.75))] - edges[Math.floor((edges.length * 0.25))]) or nil);
if (spread ~= nil) then local late = (edges:filter(function(_, x)  return (x == 0) end).length / edges.length);
if (GT(spread, c.eagleEdgeSpread) or GE(late, c.eagleLateShare)) then if T(this.debug) then this:debug(p, "EagleHand", 0, ("crouch timing spread " .. JSSTR(TOFIXED(spread, 2)) .. " ticks, " .. JSSTR(Math.round((late * 100))) .. "% late"), t); end
do return end end end
local recent = p.crouches:filter(function(_, x)  return (GE(x.t, (t - c.eagleEdgeWindow)) and LE(x.ms, 400)) end):slice((-c.eagleEdgeN));
if (GE(recent.length, 8) and GE((recent:filter(function(_, x)  return GT(x.ms, c.eagleShortMs) end).length / recent.length), c.eagleHeldShare)) then if T(this.debug) then this:debug(p, "EagleHand", 0, ("held " .. JSSTR(recent:filter(function(_, x)  return GT(x.ms, c.eagleShortMs) end).length) .. " of their last " .. JSSTR(recent.length) .. " crouches for 3+ ticks"), t); end
do return end end
if ((spread == nil) and T(c.eagleNeedEdges)) then do return end end
local one = cr:filter(function(_, x)  return LE(x.ms, c.eagleOneTickMs) end).length;
for __i100, __v101 in ITER(AN(2, AN(3, c.eagleShortMs, 2, 1), AN(3, c.eagleSlowMs, 3, c.eagleSlowAmount))) do local ms = __v101[0] local ticks = __v101[1] local amt = __v101[2] do if ((ticks == 3) and ((spread == nil) or GT(spread, c.eagleSlowSpread))) then goto __c102 end
local short = cr:filter(function(_, x)  return LE(x.ms, ms) end).length;
local share = (short / cr.length);
if (LT(share, c.eagleShortShare) or LT(short, c.eagleMinCrouches)) then goto __c102 end
p.eagleAt = t;
local amount = (((amt == 1) and (share >= 0.99)) and 1.5 or amt);
this:addEagle(p, amount, ("crouched " .. JSSTR(cr.length) .. " times in " .. JSSTR((Math.round(((c.eagleWindow / 1000) * 10)) / 10)) .. "s while bridging, " .. JSSTR(short) .. " of them for 1-" .. JSSTR(ticks) .. " ticks" .. JSSTR((T(one) and (" (" .. JSSTR(one) .. " for exactly one tick)") or ""))), t, c.eagleVL);
do return end end ::__c102::  end end
Engine.checkSkippedShifts = function(this, p, pl)  local c = this.cfg; local t = pl.t;
if (((not T(pl.under)) or T(pl.air)) or LT(pl.pitch, c.eagleMinPitch)) then do return end end
local g = p.places:filter(function(_, b)  return ANDF(ANDF(b.under, function() return (not T(b.air)) end), function() return GE(b.pitch, c.eagleMinPitch) end) end);
local i = (g.length - 1);
while ((i > 0) and LE((g[i].t - g[(i - 1)].t), c.skipGapMs)) do do i = i - 1; end   end
local run = g:slice((i + 2));
if LT(run.length, c.skipMinBlocks) then do return end end
local t0 = run[0].t;
local steps = 0;
do local j = 0; while LT(j, run.length) do do if ((j == 0) or GT((run[j].t - run[(j - 1)].t), c.skipStepMs)) then steps = steps + 1; end end  j = j + 1; end end
if ((p.skipFrom == t0) and LT(run.length, p.skipNext)) then do return end end
if (T(p.sneak) and GT((t - p.sneakStart), c.skipShortMs)) then do return end end
local cr = p.crouches:filter(function(_, x)  return (((x.t - x.ms) >= (t0 - 300)) and ((x.t - x.ms) <= t)) end);
local now = (T(p.sneak) and 1 or 0);
if ((LT(cr.length, c.skipMinCrouches) or ((cr.length + now) > (steps * c.skipMaxShare))) or LT(((steps - cr.length) - now), c.skipMinSkipped)) then do return end end
if T(cr:some(function(_, x)  return GT(x.ms, c.skipShortMs) end)) then do return end end
if T(this:stalled((t0 - 500), t)) then do return end end
p.skipFrom = t0;
p.skipNext = (run.length + c.skipMinBlocks);
local one = cr:filter(function(_, x)  return LE(x.ms, c.eagleOneTickMs) end).length;
this:addEagle(p, c.skipAmount, ("bridged " .. JSSTR(steps) .. " steps (" .. JSSTR(run.length) .. " blocks) but crouched only " .. JSSTR(cr.length) .. " times, every one a tap of 1-2 ticks" .. JSSTR((T(one) and (" (" .. JSSTR(one) .. " for exactly one tick)") or "")) .. " - people shift at every block (holding it 150 ms+) or not at all"), t, c.eagleVL); end
Engine.edgeTicks = function(this, p, t)  if ((not T(p.onGround)) or (not T(p.places:some(function(_, b)  return ANDF(ANDF(GE(b.t, (t - 2500)), function() return b.under end), function() return (not T(b.air)) end) end)))) then do return nil end end
local tr = p.track; local a = tr[(tr.length - 1)];
if ((not T(a)) or ((t - a.t) > 300)) then do return nil end end
local b0 = nil;
do local i = (tr.length - 2); while (i >= 0) do do if ((a.t - tr[i].t) >= 90) then b0 = tr[i];
break end end  i = i - 1; end end
if (((not T(b0)) or ((a.t - b0.t) > 400)) or T(a.tp)) then do return nil end end
local ticks = ((a.t - b0.t) / 50); local vx = ((a.x - b0.x) / ticks); local vz = ((a.z - b0.z) / ticks); local sp = Math.hypot(vx, vz);
if (sp < 0.02) then do return nil end end
local ux = (vx / sp); local uz = (vz / sp); local y = Math.floor((p.y - 0.01)); local w = this.world;
local sup = function(_, x, z)  return ORF(ORF(ORF(w:solidAt(Math.floor((x - 0.3)), y, Math.floor((z - 0.3))), function() return w:solidAt(Math.floor((x - 0.3)), y, Math.floor((z + 0.3))) end), function() return w:solidAt(Math.floor((x + 0.3)), y, Math.floor((z - 0.3))) end), function() return w:solidAt(Math.floor((x + 0.3)), y, Math.floor((z + 0.3))) end) end;
do local s = 0; while (s <= 1) do do if (not T(sup(nil, (p.x + (ux * s)), (p.z + (uz * s))))) then do return (s / sp) end end end  s = (s + 0.01); end end
do return nil end end
Engine.checkBridgeFall = function(this, p, t)  local last = p.places[(p.places.length - 1)];
if ((((((not T(last)) or (not T(last.under))) or T(last.air)) or ((t - last.t) > 2500)) or (p.fellFrom == last.t)) or ((t - OR(p.bridgeFallAt, (-1000000000))) < 3000)) then do return end end
if GT(p.y, (last.feetY - 2.5)) then do return end end
local bridge = p.places:filter(function(_, b)  return ANDF(ANDF(b.under, function() return (not T(b.air)) end), function() return ((last.t - b.t) <= 4000) end) end);
if LT(bridge.length, 3) then do return end end
p.fellFrom = last.t;
if (((T(this:hidden(p)) or T(this:recentlyPushed(p, t, 2000))) or T(this:stalled((last.t - 500), t))) or T(this:laggy(p, (last.t - 500), t))) then do return end end
if (not T(this:voidBelow(p.x, p.y, p.z, 40, (last.t + 1)))) then do return end end
local ranOut = ORF((not T(isBlockItem(nil, p.held))), function() return OR(p.heldHistory, AN(0)):some(function(_, h)  return ANDF(ANDF(ANDF(isBlockItem(nil, h.prev), function() return (not T(isBlockItem(nil, h.id))) end), function() return GE(h.t, (last.t - 300)) end), function() return LE(h.t, t) end) end) end);
if T(ranOut) then do return end end
p.bridgeFallAt = t;
if (T(p.eaglePend) and T(p.eaglePend.length)) then if T(this.debug) then this:debug(p, "EagleFall", 0, ("dropped " .. JSSTR(p.eaglePend.length) .. " Eagle points from the last " .. JSSTR((this.cfg.eagleWaitMs / 1000)) .. " s"), t); end
p.eaglePend = AN(0); end
this:cool(p, "Eagle", this.cfg.eagleFallCool);
if T(this.debug) then this:debug(p, "EagleFall", (-this.cfg.eagleFallCool), "fell off their bridge into the void", t); end end
Engine.checkScaffold = function(this, p, pl)  local c = this.cfg; local t = pl.t;
local recent = p.places:filter(function(_, b)  return ANDF(b.under, function() return ((t - b.t) < 3000) end) end);
local run = AN(0);
do local i = (recent.length - 1); while (i >= 0) do do if (recent[i].y ~= pl.y) then break end
run:unshift(recent[i]); end  i = i - 1; end end
if (((not T(pl.onto)) and GE(run:filter(function(_, b)  return (not T(b.onto)) end).length, c.keepYMinBlocks)) and (not (T(p.keepYAt) and LT((t - p.keepYAt), c.keepYGapMs)))) then local span = ((run[(run.length - 1)].t - run[0].t) / 1000);
local dist = Math.hypot((run[(run.length - 1)].px - run[0].px), (run[(run.length - 1)].pz - run[0].pz));
local speed = ((span > 0.25) and (dist / span) or 0);
local mid = run:filter(function(_, b)  return ANDF(b.air, function() return ((b.feetY - (b.y + 1)) >= 0.5) end) end).length;
local jumpy = this:jumpsBetween(p, run[0].t, t);
if (((speed >= (c.keepYMinSpeed * this:speedMul(p, t))) and GE((mid / run.length), c.keepYMidAirShare)) and (jumpy >= 2)) then p.keepYAt = t;
this:add(p, "Scaffold", 1, ("jumped and placed " .. JSSTR(mid) .. "/" .. JSSTR(run.length) .. " blocks mid-air without gaining height (" .. JSSTR(TOFIXED(speed, 1)) .. " b/s)"), t, c.keepYVL); end end
local back = recent:filter(function(_, b)  return ((t - b.t) < 1500) end);
if (GE(back.length, c.backMinBlocks) and (not (T(p.backAt) and ((t - p.backAt) < 1500)))) then local a = back[0]; local z = back[(back.length - 1)];
local span = ((z.t - a.t) / 1000);
local dx = (z.px - a.px); local dz = (z.pz - a.pz);
local speed = ((span > 0.3) and (Math.hypot(dx, dz) / span) or 0);
if ((speed >= (c.backMinSpeed * this:speedMul(p, t))) and (not T(this:recentlyPushed(p, t, 1500)))) then local moveYaw = yawTo(nil, dx, dz);
local facingBack = back:filter(function(_, b)  return (adiff(nil, b.yaw, moveYaw) > 120) end).length;
if (facingBack >= (back.length * 0.8)) then p.backAt = t;
this:add(p, "Scaffold", 1, ("bridged backwards at " .. JSSTR(TOFIXED(speed, 1)) .. " b/s placing " .. JSSTR(back.length) .. " blocks under themselves (walking backwards is 4.3 b/s)"), t, c.backVL); end end end
local tapping = ORF(ANDF(p.sneak, function() return ((t - p.sneakStart) < 500) end), function() return OR(p.crouches, AN(0)):some(function(_, x)  return (LE((t - x.t), c.rotCrouchMs) and LT(x.ms, 500)) end) end);
local ok = (T(tapping) and true or this:couldAim(p, pl));
if (ok == false) then p.rotFails = (OR(p.rotFails, 0) + 1); elseif (ok == true) then p.rotFails = 0; end
if (GE(p.rotFails, c.rotFailRun) and (not (T(p.rotAt) and ((t - p.rotAt) < 2000)))) then p.rotAt = t;
this:add(p, "Scaffold", 1, ("placed " .. JSSTR(p.rotFails) .. " blocks in a row under themselves while looking where they couldn't have aimed at any block face"), t, c.rotVL);
p.rotFails = 0; end
this:checkRavenPitch(p, pl); end
Engine.checkRavenPitch = function(this, p, pl)  local c = this.cfg; local t = pl.t;
local B = function(_, d)  return Math.round(((d * 256) / 360)) end;
local R = p.raven;
local rots = p.rots:filter(function(_, r)  return ANDF(ANDF(R, function() return GT(r.t, R.last) end), function() return LE(r.t, t) end) end);
local fixed = ANDF((B(nil, pl.pitch) == c.ravenPitchByte), function() return rots:every(function(_, r)  return (B(nil, r.pitch) == c.ravenPitchByte) end) end);
if (not T(fixed)) then p.raven = nil;
do return end end
if ((not T(R)) or ((t - R.last) > 1000)) then R = (function() p.raven = {n = 0, yaws = NEW(Set), last = t}; return p.raven end)(); end
R.n = R.n + 1;
R.last = t;
for __i108, r in ITER(rots) do do R.yaws:add(BAND(B(nil, r.yaw), 255)); end   end
R.yaws:add(BAND(B(nil, pl.yaw), 255));
if ((GE(R.n, c.ravenMinBlocks) and GE(R.yaws.size, c.ravenMinYaws)) and (not (T(p.ravenAt) and ((t - p.ravenAt) < 5000)))) then p.ravenAt = t;
this:add(p, "Scaffold", 2, ("Raven Scaffold: pitch stuck at exactly 85° for " .. JSSTR(R.n) .. " blocks while turning " .. JSSTR(R.yaws.size) .. " yaw steps (hands: 6 at most)"), t, c.ravenVL);
p.raven = nil; end end
Engine.jumpsBetween = function(this, p, a, b)  local n = 0; local prevY = nil; local rising = false;
for __i110, e in ITER(p.track) do do if (LT(e.t, (a - 400)) or GT(e.t, (b + 100))) then goto __c111 end
if (prevY ~= nil) then if (((e.y - prevY) > 0.05) and (not T(rising))) then rising = true;
n = n + 1; end
if ((e.y - prevY) < (-0.02)) then rising = false; end end
prevY = e.y; end ::__c111::  end
do return n end end
Engine.fallHurt = function(this, p, t)  local tr = p.track;
local top = p.y; local prev = p.y; local airAt = nil;
do local k = (tr.length - 1); while ((k >= 0) and ((t - tr[k].t) <= 1500)) do do local y = tr[k].y;
if (y < (prev - 0.05)) then break end
if ((airAt == nil) and (y > (p.y + 0.3))) then airAt = tr[k].t; end
prev = y;
if (y > top) then top = y; end end  k = k - 1; end end
do return ANDF(((((top - p.y) >= 2) and (airAt ~= nil)) and ((t - airAt) <= 250)), function() return this:supportBelow(p.x, p.y, p.z, 2.5) end) end end
Engine.knockedOff = function(this, p, t, ms) if ms == nil then ms = 2500 end do return ORF(((t - p.knockAt) < ms), function() return this:nearExplosion(p, t, (ms + 500)) end) end end
Engine.recentlyPushed = function(this, p, t, ms)  do return ORF((((t - p.hurtAt) < ms) or ((t - p.velAt) < ms)), function() return this:nearExplosion(p, t, (ms + 1500)) end) end end
Engine.couldAim = function(this, p, pl)  local w = this.world;
local support = false;
for __i113, __v114 in ITER(FACES) do local dx = __v114[0] local dy = __v114[1] local dz = __v114[2] do local s = w:get((pl.x + dx), (pl.y + dy), (pl.z + dz));
if (s == (-1)) then do return nil end end
if ((s > 0) and T(solid(nil, s))) then support = true; end end   end
if (not T(support)) then do return nil end end
local rots = p.rots:filter(function(_, r)  return (GE(r.t, (pl.t - 150)) and LE(r.t, (pl.t + 60))) end);
rots:push(this:rotAt(p, (pl.t - 150)));
local poss = AN(2, this:posAt(p, pl.t), this:posAt(p, (pl.t - 100)));
local nxt = p.track:find(function(_, e)  return GT(e.t, pl.t) end);
if (T(nxt) and ((nxt.t - pl.t) < 150)) then poss:push(nxt);
local a = poss[0];
if (T(a) and (not T(nxt.tp))) then for __i116, u in ITER(AN(4, 0.2, 0.4, 0.6, 0.8)) do do poss:push({x = (a.x + ((nxt.x - a.x) * u)), y = (a.y + ((nxt.y - a.y) * u)), z = (a.z + ((nxt.z - a.z) * u))}); end   end end end
local later = function(_, x, y, z)  local t = this.placedAt:get((JSSTR((JSSTR((JSSTR((JSSTR(x) .. JSSTR(","))) .. JSSTR(y))) .. JSSTR(","))) .. JSSTR(z)));
do return ((t ~= nil) and GT(t, pl.t)) end end;
for __i118, pos in ITER(poss) do do for __i120, eye in ITER(AN(2, 1.62, 1.54)) do do local ex = pos.x; local ey = (pos.y + eye); local ez = pos.z;
for __i122, r in ITER(rots) do do for __i124, dyaw in ITER(AN(3, (-1.4), 0, 1.4)) do do for __i126, dp in ITER(AN(3, (-1.4), 0, 1.4)) do do local yaw = ((r.yaw + dyaw) / DEG); local pitch = (Math.max((-90), Math.min(90, (r.pitch + dp))) / DEG);
local vx = ((-Math.sin(yaw)) * Math.cos(pitch)); local vy = (-Math.sin(pitch)); local vz = (Math.cos(yaw) * Math.cos(pitch));
local hit = raycast(nil, w, ex, ey, ez, vx, vy, vz, 5, pl, later);
if (((T(hit) and ((hit.x + hit.nx) == pl.x)) and ((hit.y + hit.ny) == pl.y)) and ((hit.z + hit.nz) == pl.z)) then do return true end end end   end end   end end   end end   end end   end
do return false end end
Engine.checkFastMine = function(this, p, brk)  local c = this.cfg; local t = brk.t;
if LT(brk.n, 2) then do return end end
if GE(brk.stage, 10) then this:cool(p, "FastMine", 1);
do return end end
local h = OR(brk.hist, AN(0)):filter(function(_, e)  return (GE(e[1], 0) and LE(e[1], 9)) end);
if (GE(h.length, 3) and GE(brk.stage, 6)) then local a = h[0]; local z = h[(h.length - 1)];
local span = (z[0] - a[0]);
if ((span >= 90) and GT(z[1], a[1])) then local rate = ((z[1] - a[1]) / span);
local est = (Math.min(10, ((z[1] + 0.5) + (rate * (t - z[0])))) * 10);
if T(this.debug) then this:debug(p, "MineEst", 0, (JSSTR(blockName(nil, brk.block)) .. " " .. JSSTR(TOFIXED(est, 0)) .. "% (last " .. JSSTR(z[1]) .. ", " .. JSSTR(span) .. " ms)"), t); end
if GE(est, c.fastMineDonePct) then this:cool(p, "FastMine", 1);
do return end end
if T(this:stalled(brk.from, brk.t)) then do return end end
p.fastMine = OR(p.fastMine, AN(0));
p.fastMine:push(brk.stage);
local amount = IFX((est < 85), function() return c.fastMineVL end, function() return 2 end);
this:add(p, "FastMine", amount, ("broke " .. JSSTR(blockName(nil, brk.block)) .. " when it was only about " .. JSSTR((Math.round((est / 5)) * 5)) .. "% done (the cracks were growing steadily and stopped at stage " .. JSSTR(z[1]) .. " of 10; a normal break needs 100%)"), t, c.fastMineVL);
do return end end end
if LT(brk.stage, 7) then do return end end
if T(this:stalled(brk.from, brk.t)) then do return end end
local amount = (10 - brk.stage);
local name = blockName(nil, brk.block);
local pct = (brk.stage * 10);
p.fastMine = OR(p.fastMine, AN(0));
p.fastMine:push(brk.stage);
this:add(p, "FastMine", amount, ("broke " .. JSSTR(name) .. " when it was only " .. JSSTR(pct) .. "-" .. JSSTR((pct + 9)) .. "% done (" .. JSSTR(p.fastMine.length) .. " fast break" .. JSSTR((GT(p.fastMine.length, 1) and "s" or "")) .. " this game; a normal break needs 100%)"), t, c.fastMineVL); end
Engine.checkBreakDelay = function(this, p, brk)  local c = this.cfg;
local g = brk.afterBreak; local last = brk.lastBreak;
if ((not T(last)) or (g > 1500)) then do return end end
local near = (((Math.abs((last.x - brk.x)) + Math.abs((last.y - brk.y))) + Math.abs((last.z - brk.z))) <= 3);
if (not T(near)) then do return end end
if (LE(g, c.breakDelayShortMs) and T(this:stalled((last.t - 300), (brk.t0 + 100)))) then do return end end
p.gaps = OR(p.gaps, AN(0));
p.gaps:push(g);
if GT(p.gaps.length, 8) then p.gaps:shift(); end
p.gapT = OR(p.gapT, AN(0));
p.gapT:push(brk.t);
if GT(p.gapT.length, 8) then p.gapT:shift(); end
local q2 = p.gaps:slice((-2)); local qt = p.gapT:slice((-2));
if (((q2.length == 2) and T(q2:every(function(_, x)  return LE(x, c.breakDelayQuickMs) end))) and ((qt[1] - qt[0]) <= 3000)) then this:add(p, "BreakDelay", c.breakDelayVL, ("started the next block " .. JSSTR(q2:join(" ms and ")) .. " ms after each break, twice in a row (the game waits 300 ms)"), brk.t, c.breakDelayVL);
p.gaps = AN(0);
p.gapT = AN(0);
do return end end
local lastN = p.gaps:slice((-Math.max(c.breakDelayMinRun, 5)));
local short = lastN:filter(function(_, x)  return LE(x, c.breakDelayShortMs) end).length;
if ((GE(lastN.length, c.breakDelayMinRun) and GE(short, c.breakDelayMinRun)) and ((short / lastN.length) >= 0.75)) then local avg = Math.round((lastN:filter(function(_, x)  return LE(x, c.breakDelayShortMs) end):reduce(function(_, a, b)  return (a + b) end, 0) / short));
this:add(p, "BreakDelay", ((short == lastN.length) and 1.5 or 1), ("started the next block " .. JSSTR(avg) .. " ms after each break, " .. JSSTR(short) .. " of the last " .. JSSTR(lastN.length) .. " times (the game waits 300 ms)"), brk.t, c.breakDelayVL);
p.gaps = AN(0); end end
Engine.startJumpReset = function(this, p, t, fall)  if T(p.jr) then p.jr = nil;
do return end end
local tr = p.track; local last = tr[(tr.length - 1)];
if (((T(fall) or (not T(last))) or (not T(last.g))) or T(last.tp)) then do return end end
do local k = (tr.length - 1); while ((k >= 0) and LE((t - tr[k].t), this.cfg.jumpResetStandMs)) do do if ((not T(tr[k].g)) or (Math.abs((tr[k].y - last.y)) > 0.01)) then do return end end end  k = k - 1; end end
if ((T(this:nearExplosion(p, t, 1500)) or T(this:climbOrSlow(p.x, p.y, p.z))) or T(this:webNear(p.x, p.y, p.z))) then do return end end
p.jr = {t = t, y0 = last.y, peak = last.y, rose = false}; end
Engine.trackJumpReset = function(this, p, t, abs, oy)  local j = p.jr;
if (T(abs) or ((t - j.t) > 1500)) then p.jr = nil;
do return end end
if GT(p.y, (oy + 0.000001)) then j.rose = true; end
if GT(p.y, j.peak) then j.peak = p.y; end
if (((not T(j.rose)) or ((t - j.t) < 150)) or ((not T(p.onGround)) and GE(p.y, (j.peak - 0.1)))) then do return end end
p.jr = nil;
if T(this:stalled(j.t, t)) then do return end end
local air = p.track:filter(function(_, e)  return (GT(e.t, j.t) and LE(e.t, t)) end);
if (T(air:slice(1):some(function(_, e)  return GT(e.gap, 250) end)) or GE(air:filter(function(_, e)  return LT(e.gap, 20) end).length, 2)) then do return end end
local h = (j.peak - j.y0);
local kind = (((h >= 0.8) and (h <= 1.1)) and "miss" or (((h >= 1.15) and (h <= 1.36)) and "reset" or nil));
if (not T(kind)) then do return end end
local up = air:find(function(_, e)  return GT(e.y, (j.y0 + 0.01)) end);
if ((not T(up)) or T(air:some(function(_, e)  return (LT(e.t, up.t) and LT(e.y, (j.y0 - 0.01))) end))) then do return end end
if ((kind == "reset") and ((up.y - j.y0) < 0.38)) then do return end end
p.jrN = (OR(p.jrN, 0) + 1);
if (kind == "reset") then p.jrR = (OR(p.jrR, 0) + 1); end
if T(this.debug) then this:debug(p, "JumpResetRun", 0, (JSSTR(kind) .. ": " .. JSSTR(OR(p.jrR, 0)) .. " of " .. JSSTR(p.jrN)), t); end
local c = this.cfg; local n = p.jrN; local r = OR(p.jrR, 0);
if (((kind ~= "reset") or LT(n, c.jumpResetMinHits)) or LT((r / n), c.jumpResetShare)) then do return end end
this:add(p, "JumpReset", (T(p.jrFlagged) and 1 or c.jumpResetVL), ("jumped on the exact tick the knockback landed on " .. JSSTR(r) .. " of the " .. JSSTR(n) .. " hits they took on the ground this game (" .. JSSTR(Math.round(((r / n) * 100))) .. "%) - by hand people manage about half"), t, c.jumpResetVL);
p.jrFlagged = true; end
Engine.stasisLife = function(this, p, t, kind)  if ((t - p.lastMove) < 200) then p.hang = nil;
do return end end
if (not T(p.hang)) then local pos = {x = p.x, y = p.y, z = p.z};
if (T(p.onGround) or T(this:hidden(p))) then do return end end
local fy = (p.y - Math.floor(p.y));
if T(AN(6, 0, 0.5, 0.0625, 0.5625, 0.875, 0.125):some(function(_, h)  return (Math.abs((fy - h)) < 0.001) end)) then do return end end
if ((T(this:supportBelow(pos.x, pos.y, pos.z, 0.6)) or T(this:climbOrSlow(pos.x, pos.y, pos.z))) or T(this:webNear(pos.x, pos.y, pos.z))) then do return end end
p.hang = {from = p.lastMove, signs = AN(0), kinds = NEW(Set), y = p.y, void = this:voidBelow(pos.x, pos.y, pos.z, 5)}; end
p.hang.signs:push(t);
p.hang.kinds:add(kind);
if GT(p.hang.signs.length, 200) then p.hang.signs:shift(); end
this:judgeHang(p, p.hang, t, false); end
Engine.judgeHang = function(this, p, h, t, ended)  local ms = (t - h.from);
if (LT(ms, this.cfg.stasisMinMs) or T(this:hidden(p))) then do return end end
if T(this:webNear(p.x, p.y, p.z)) then do return end end
local first = h.signs[0]; local last = h.signs[(h.signs.length - 1)];
local spread = ORF((GE(h.signs.length, 2) and ((last - first) >= 150)), function() return ANDF(ended, function() return ((t - first) >= 300) end) end);
if (not T(spread)) then do return end end
if T(this:stalled(h.from, t)) then do return end end
local amt = ((ms >= 1500) and 2 or 1);
if (OR(h.amt, 0) >= amt) then do return end end
local did = AN(4, AND(h.kinds:has("look"), "turning their head"), AND(h.kinds:has("block"), "placing blocks"), AND(h.kinds:has("pearl"), "throwing a pearl"), AND(h.kinds:has("swing"), "swinging")):filter(Boolean);
local what = (GT(did.length, 1) and (JSSTR((JSSTR(did:slice(0, (-1)):join(", ")) .. JSSTR(" and "))) .. JSSTR(did[(did.length - 1)])) or did[0]);
local add = (amt - OR(h.amt, 0));
h.amt = amt;
this:add(p, "Stasis", add, (JSSTR((T(ended) and "hung still in mid-air for" or "has hung still in mid-air for")) .. " " .. JSSTR(TOFIXED((ms / 1000), 1)) .. "s" .. JSSTR((T(ended) and "" or " so far")) .. " with " .. JSSTR((T(h.void) and "nothing" or "no block")) .. " below, while still " .. JSSTR(what)), t, (this.cfg.stasisVL + (T(h.void) and 0 or 1))); end
Engine.checkHitHang = function(this, p, t, wasGround, ox, oy, oz)  local c = this.cfg; local from = p.lastMove; local ms = (t - from);
if (((LT(ms, c.hitHangMs) or T(wasGround)) or T(this:hidden(p))) or (T(p.spawnAt) and ((t - p.spawnAt) < 3000))) then do return end end
if GT((from - Math.max(p.hurtAt, p.velAt)), c.hitHangHitMs) then do return end end
if ((Math.hypot((p.x - ox), (p.z - oz)) > 2) or (Math.abs((p.y - oy)) > 2)) then do return end end
local fy = (oy - Math.floor(oy));
if T(AN(6, 0, 0.5, 0.0625, 0.5625, 0.875, 0.125):some(function(_, h)  return (Math.abs((fy - h)) < 0.001) end)) then do return end end
if ((T(this:supportBelow(ox, oy, oz, 0.6)) or T(this:climbOrSlow(ox, oy, oz))) or T(this:webNear(ox, oy, oz))) then do return end end
if (T(this:voidBelow(ox, oy, oz, 6)) or T(this:stalled(from, t))) then do return end end
local life = ANDF(ANDF(p.hang, function() return (p.hang.from == from) end), function() return GT(p.hang.signs.length, 0) end);
if ((not T(life)) and LT(ms, c.freezeQuietMs)) then do return end end
p.hang = nil;
p.stasisAt = t;
this:add(p, "Stasis", (c.stasisVL + 1), ("hung still in mid-air for " .. JSSTR(TOFIXED((ms / 1000), 1)) .. "s right after being hit, with no block below, then carried on from the same spot"), t, (c.stasisVL + 1)); end
Engine.checkStasisEnd = function(this, p, t, ox, oy, oz)  local h = p.hang;
p.hang = nil;
if (not T(h)) then do return end end
this:judgeHang(p, h, t, true);
if T(h.amt) then p.stasisAt = t; end end
Engine.trackFall = function(this, p, t, abs, ox, oy, oz, gap)  if (T(this:hidden(p)) or (T(abs) and ((Math.hypot((p.x - ox), (p.z - oz)) > 4.5) or GT(p.y, (oy + 0.5))))) then p.fall = nil;
do return end end
if GT(p.y, (oy + 0.000001)) then p.fall = IFX(T(p.onGround), function() return nil end, function() return {x = p.x, y = p.y, z = p.z, t = t} end);
do return end end
local f = p.fall;
if (T(f) and T(this:checkFreeze(p, f, t, gap, ox, oy, oz))) then p.fall = nil;
do return end end
if (T(p.onGround) or T(this:supportBelow(p.x, p.y, p.z, 0.05))) then p.fall = nil;
do return end end
if ((not T(f)) or GE(p.y, f.y)) then p.fall = {x = p.x, y = p.y, z = p.z, t = t}; end end
Engine.checkFreeze = function(this, p, f, t, gap, ox, oy, oz)  local c = this.cfg;
local E = (t - f.t);
local n = Math.floor((((E - c.freezeSlackMs) / TICK) * c.freezeRate));
if LT(n, c.freezeMinTicks) then do return false end end
local want = FALL[Math.min(n, (FALL.length - 1))];
local fell = (f.y - p.y);
if LT((want - fell), c.freezeMargin) then do return false end end
if (GE(p.y, (oy - 0.000001)) and (Math.hypot((p.x - ox), (p.z - oz)) > 0.01)) then do return true end end
if T(this:stalled(f.t, t)) then do return true end end
if (T(p.spawnAt) and ((t - p.spawnAt) < 2000)) then do return true end end
local frozeAt = ((gap >= 300) and (t - gap) or t);
local path = p.track:filter(function(_, e)  return (GE(e.t, f.t) and LT(e.t, t)) end):map(function(_, e)  return AN(3, e.x, e.y, e.z) end);
path:push(AN(3, ox, oy, oz), AN(3, p.x, p.y, p.z));
for __i129, __v130 in ITER(path) do local x = __v130[0] local y = __v130[1] local z = __v130[2] do if T(this:couldStand(x, y, z, frozeAt, (f.t - 1000))) then do return true end end end   end
if (T(this:climbOrSlow(f.x, f.y, f.z, frozeAt)) or T(this:climbOrSlow(p.x, p.y, p.z, frozeAt))) then do return true end end
local frozen = IFX((gap >= 300), function() return gap end, function() return 0 end);
local wet = false;
local way = ACAT(A(AN(3, f.x, f.y, f.z)), path);
do local k = 1; while (LT(k, way.length) and (not T(wet))) do do local __d133 = way[(k - 1)] local ax = __d133[0] local ay = __d133[1] local az = __d133[2]; local __d134 = way[k] local bx = __d134[0] local by = __d134[1] local bz = __d134[2];
local steps = Math.min(40, Math.ceil((Math.max(Math.abs((by - ay)), Math.hypot((bx - ax), (bz - az))) / 0.5)));
do local s = 1; while ((s <= steps) and (not T(wet))) do do local u = (s / steps);
wet = this:climbOrSlow((ax + ((bx - ax) * u)), (ay + ((by - ay) * u)), (az + ((bz - az) * u)), frozeAt); end  s = s + 1; end end end  k = k + 1; end end
if (T(wet) and LT(frozen, c.freezeWetMs)) then do return true end end
if (p.stasisAt == t) then do return true end end
local voidBelow = this:voidBelow(f.x, f.y, f.z, 6);
local knocked = ((f.t - Math.max(p.hurtAt, p.velAt)) < 2500);
if (((not T(knocked)) and (not T(voidBelow))) and LT(frozen, c.freezeQuietMs)) then if T(this.debug) then this:debug(p, "TimerQuiet", 0, ("froze " .. JSSTR(TOFIXED((frozen / 1000), 1)) .. "s, not hit, not over the void"), t); end
do return true end end
local extra = ((T(knocked) and T(voidBelow)) and ", right after being knocked off, over the void" or (T(knocked) and ", right after being knocked" or (T(voidBelow) and ", over the void" or "")));
local fellBy = (T(wet) and "falling through water, and water never stops you dead" or ("they fell only " .. JSSTR(TOFIXED(Math.max(0, fell), 1)) .. " blocks in " .. JSSTR(TOFIXED((E / 1000), 1)) .. "s, gravity pulls you down at least " .. JSSTR(TOFIXED(want, 0))));
local why = (T(frozen) and ("froze " .. JSSTR((T(wet) and "in water" or "in mid-air")) .. " for " .. JSSTR(TOFIXED((frozen / 1000), 1)) .. "s with no movement or head turns at all" .. JSSTR(extra) .. ", then carried on from the same spot (" .. JSSTR(fellBy) .. ")") or ("fell in slow motion" .. JSSTR(extra) .. " (" .. JSSTR(fellBy) .. "): their game was running slower than normal"));
this:add(p, "Timer", ((1 + (T(voidBelow) and 0.5 or 0)) + (T(knocked) and 0.5 or 0)), why, t, c.freezeVL);
do return true end end
Engine.checkDisplaceSwings = function(this, p)  if ((not T(p.swingQ)) or (not T(p.swingQ.length))) then do return end end
local rs = p.rots; local n = rs.length; local maxL = this.cfg.displaceMaxUpdates;
local keep = AN(0);
for __i136, st in ITER(p.swingQ) do do local k = (-1);
do local i = (n - 1); while (i >= 0) do do if LE(rs[i].t, (st + 30)) then k = i;
break end end  i = i - 1; end end
if ((k < 0) or LT(rs[k].t, (st - 160))) then goto __c137 end
if ((k + 1) >= n) then if ((rs[(n - 1)].t - st) < 600) then keep:push(st); end
goto __c137 end
local found = false; local waiting = false;
do local i = Math.max(1, ((k - maxL) + 1)); while (i <= k) do do if (T(p.displaceSeen) and LE(rs[i].t, p.displaceSeen)) then goto __c140 end
do local j = Math.max((i + 1), k); while (j <= (i + maxL)) do do if (j >= n) then waiting = true;
break end
if T(this:displaceSpike(p, rs[(i - 1)], rs:slice(i, j), rs[j], st)) then p.displaceSeen = rs[(j - 1)].t;
found = true;
goto __b139 end end  j = j + 1; end end end ::__c140:: i = i + 1; end end ::__b139::
if (((not T(found)) and T(waiting)) and ((rs[(n - 1)].t - st) < 600)) then keep:push(st); end end ::__c137::  end
p.swingQ = keep; end
Engine.snapHit = function(this, a, b, run, f, t, out, back, busy, onto)  local c = this.cfg;
if (((run.length ~= 1) or (onto.length ~= 1)) or T(busy)) then do return false end end
if (LT(Math.min(out, back), c.displaceOneAt) or GT(adiff(nil, b.yaw, f.yaw), c.snapBackDeg)) then do return false end end
local __d142 = onto[0] local q = __d142[0] local d = __d142[1];
if ((d > 4.5) or T(this:sameTeam(a, q))) then do return false end end
local r = run[0];
if (not T(OR(q.hurts, AN(0)):some(function(_, h)  return (((not T(h.fall)) and GE(h.t, (Math.min(r.t, t) - 50))) and LE(h.t, (Math.max(r.t, t) + c.snapHurtMs))) end))) then do return false end end
a.displaceHits = (OR(a.displaceHits, 0) + 1);
local deg = Math.round(Math.min(out, back));
this:add(a, "Displace", c.displaceVL, ("snapped their head " .. JSSTR(deg) .. "° onto " .. JSSTR(OR(q.name, "a player")) .. " for one update to hit them, then straight back (knockback goes where the head points); " .. JSSTR(a.displaceHits) .. " hit" .. JSSTR((GT(a.displaceHits, 1) and "s" or "")) .. " like this"), t, c.displaceVL);
do return true end end
Engine.steadySince = function(this, p, from, to)  local prev = from;
for __i143, e in ITER(p.track) do do if LE(e.t, from) then goto __c144 end
if GE(e.t, to) then break end
if (T(e.tp) or ((e.t - prev) > 300)) then do return false end end
prev = e.t; end ::__c144::  end
do return ((to - prev) <= 300) end end
Engine.displaceSpike = function(this, a, b, run, f, t)  local c = this.cfg;
local r = run[0]; local last = run[(run.length - 1)];
local steady = ((r.t - b.t) > 300);
if (((T(steady) and (not T(this:steadySince(a, b.t, r.t)))) or ((f.t - last.t) > 300)) or ((last.t - r.t) > 200)) then do return false end end
if (T(this:stalled((b.t - 1700), f.t)) or T(this.choppy:some(function(_, g)  return (GE(g.to, (b.t - 2000)) and LE(g.from, (f.t + 300))) end))) then do return false end end
local out = 180; local back = 180;
for __i145, x in ITER(run) do do out = Math.min(out, adiff(nil, x.yaw, b.yaw));
back = Math.min(back, adiff(nil, x.yaw, f.yaw)); end   end
if (LT(out, c.displaceAt) or LT(back, c.displaceAt)) then do return false end end
if (T(steady) and (LT(Math.min(out, back), c.displaceOneAt) or GT(adiff(nil, b.yaw, f.yaw), c.snapBackDeg))) then do return false end end
if (GT(run.length, 1) and LT(Math.min(out, back), c.displaceLongAt)) then do return false end end
if GT(adiff(nil, b.yaw, f.yaw), c.displaceAround) then do return false end end
local busy = 0;
local rs = a.rots;
local big = 0;
do local i = 1; while LT(i, rs.length) do do if (((LT(rs[i].t, b.t) and GE(rs[i].t, (b.t - c.displaceBusyMs))) and ((rs[i].t - rs[(i - 1)].t) <= 160)) and (adiff(nil, rs[i].yaw, rs[(i - 1)].yaw) >= 90)) then big = big + 1; end end  i = i + 1; end end
busy = big;
if ((T(this.inferGround) and (big >= 2)) and GE(this:nearAt(a, b.t):filter(function(_, __p148) local q = __p148[0] local qp = __p148[1] return ((q ~= a) and (Math.hypot((qp.x - a.x), (qp.z - a.z)) <= 6)) end).length, 2)) then do return false end end
local ap = this:posAt(a, r.t);
local v = nil; local vd = 1000000000; local other = false;
local onto = AN(0);
local near = AN(0);
for __i149, q in ITER(this.players:values()) do do if ((q ~= a) and (not T(this:hidden(q)))) then near:push(AN(2, q, this:posAt(q, r.t))); end end   end
if (T(this.self) and (Math.abs((r.t - this.self.t)) < 1500)) then local sp = this.self;
for __i151, e in ITER(OR(this.selfTrack, AN(0))) do do if (Math.abs((e.t - r.t)) < Math.abs((sp.t - r.t))) then sp = e; end end   end
near:push(AN(2, {name = "you"}, sp)); end
for __i153, q, qp in ITER2(near) do do local d = Math.hypot((qp.x - ap.x), (qp.y - ap.y), (qp.z - ap.z));
if LT(d, this.cfg.displaceMinDist) then goto __c154 end
local want = yawTo(nil, (qp.x - ap.x), (qp.z - ap.z));
local replay = this.inferGround;
if (((d <= (T(replay) and 6 or 4.5)) and T(run:every(function(_, x)  return (adiff(nil, x.yaw, want) <= IFX(T(replay), function() return c.displaceOtherAim end, function() return c.auraAim end)) end))) and (adiff(nil, b.yaw, want) > 45)) then other = true;
onto:push(AN(2, q, d));
goto __c154 end
if (d > 4.5) then goto __c154 end
if (GT(run.length, 1) and T(run:every(function(_, x)  return (adiff(nil, x.yaw, want) <= 40) end))) then other = true;
goto __c154 end
if (d >= vd) then goto __c154 end
if T(this:sameTeam(a, q)) then goto __c154 end
if (((adiff(nil, b.yaw, want) > 70) or (adiff(nil, f.yaw, want) > 70)) or T(run:some(function(_, x)  return (adiff(nil, x.yaw, want) < 45) end))) then goto __c154 end
v = q;
vd = d; end ::__c154::  end
if (T(other) and T(this:snapHit(a, b, run, f, t, out, back, busy, onto))) then do return true end end
if ((not T(v)) or T(other)) then do return false end end
local deg = Math.round(Math.min(out, back));
local ups = ((run.length == 1) and "one update" or (JSSTR(run.length) .. " updates"));
a.displaceHits = (OR(a.displaceHits, 0) + 1);
local what = ((deg >= 135) and ("turned their head right round (" .. JSSTR(deg) .. "°) for " .. JSSTR(ups) .. " exactly when hitting " .. JSSTR(OR(v.name, "a player")) .. ", then straight back (knockback goes where the head points, so they flew back through them)") or ("turned their head " .. JSSTR(deg) .. "° sideways for " .. JSSTR(ups) .. " exactly when hitting " .. JSSTR(OR(v.name, "a player")) .. ", then straight back (knockback goes where the head points)"));
this:add(a, "Displace", IFX(GE(deg, c.displaceOneAt), function() return c.displaceVL end, function() return 1 end), (JSSTR(what) .. "; " .. JSSTR(a.displaceHits) .. " hit" .. JSSTR((GT(a.displaceHits, 1) and "s" or "")) .. " like this"), t, c.displaceVL);
do return true end end
Engine.onSwing = function(this, p, t)  (function() p.swingQ = OR(p.swingQ, AN(0)); return p.swingQ end)():push(t);
if GT(p.swingQ.length, 20) then p.swingQ:shift(); end
this:bhSwing(p, t); end
Engine.bhSwing = function(this, p, t)  if ((not T(SWORDS:has(p.held))) or T(p.use)) then do return end end
local q = (function() p.bhPend = OR(p.bhPend, AN(0)); return p.bhPend end)();
if (T(q.length) and ((t - q[(q.length - 1)].t) < 20)) then do return end end
this:bhFlush(p, t, true);
q:push({t = t, blockAt = nil}); end
Engine.bhBlock = function(this, p, t)  local q = p.bhPend; local s = ANDF(q, function() return q[(q.length - 1)] end);
if ((T(s) and (s.blockAt == nil)) and LE((t - s.t), this.cfg.blockHitAfterMs)) then s.blockAt = t; end end
Engine.fightAt = function(this, p, t)  local ms = 100;
if ((T(this.self) and T(OR(this.selfHurts, AN(0)):some(function(_, h)  return (Math.abs((h - t)) <= ms) end))) and (Math.hypot((this.self.x - p.x), (this.self.y - p.y), (this.self.z - p.z)) < 6)) then do return true end end
for __i155, q in ITER(this.players:values()) do do if ((q == p) or (not T(OR(q.hurts, AN(0)):some(function(_, h)  return (Math.abs((h.t - t)) <= ms) end)))) then goto __c156 end
local a = this:posAt(p, t); local b = this:posAt(q, t);
if (Math.hypot((a.x - b.x), (a.y - b.y), (a.z - b.z)) < 6) then do return true end end end ::__c156::  end
do return false end end
Engine.bhFlush = function(this, p, t, next)  local c = this.cfg; local q = OR(p.bhPend, AN(0));
while (T(q.length) and (T(next) or GT((t - q[0].t), c.blockHitAfterMs))) do do local s = q:shift();
if (not T(this:fightAt(p, s.t))) then goto __c157 end
local H = (function() p.bhHits = OR(p.bhHits, AN(0)); return p.bhHits end)();
H:push({t = s.t, del = IFX((s.blockAt == nil), function() return nil end, function() return Math.round(((s.blockAt - s.t) / TICK)) end)});
if GT(H.length, c.blockHitHits) then H:shift(); end
this:checkBlockHit(p, t); end ::__c157::  end end
Engine.checkBlockHit = function(this, p, t)  local c = this.cfg; local H = p.bhHits;
if (LT(H.length, c.blockHitHits) or GT((H[(H.length - 1)].t - H[0].t), c.blockHitSpanMs)) then do return end end
local b = H:filter(function(_, x)  return (x.del ~= nil) end);
if LT(b.length, c.blockHitMin) then do return end end
local best = 0; local at = 0;
for __i158, x in ITER(b) do do local n = b:filter(function(_, y)  return ((y.del == x.del) or (y.del == (x.del + 1))) end).length;
if (n > best) then best = n;
at = x.del; end end   end
if (LT((best / b.length), c.blockHitBand) or T(this:stalled(H[0].t, t))) then do return end end
p.bhHits = AN(0);
this:add(p, "BlockHit", c.blockHitVL, ("blocked with their sword right after " .. JSSTR(b.length) .. " of their last " .. JSSTR(H.length) .. " hits in " .. JSSTR(TOFIXED(((H[(H.length - 1)].t - H[0].t) / 1000), 1)) .. "s, " .. JSSTR(best) .. " of them " .. JSSTR(at) .. "-" .. JSSTR((at + 1)) .. " ticks after the hit - people who block-hit by hand skip some"), t, c.blockHitVL); end
Engine.unblock = function(this, p, t, ms)  local c = this.cfg;
local swing = this:recentSwing(p, t, (ms + 40), 40);
local fight = this:hitNearby(p, t, 400);
p.unblocks:push({t = t, ms = ms, swing = (not (not T(swing))), fight = fight});
if GT(p.unblocks.length, 40) then p.unblocks:shift(); end
local win = p.unblocks:filter(function(_, u)  return ANDF(LE((t - u.t), c.abWindow), function() return u.fight end) end);
local quick = win:filter(function(_, u)  return ANDF(LE(u.ms, 75), function() return u.swing end) end);
if (GE(quick.length, c.abMinCycles) and GE((quick.length / win.length), c.abShare)) then if (T(p.abAt) and ((t - p.abAt) < 3000)) then do return end end
p.abAt = t;
local zero = quick:filter(function(_, u)  return (u.ms == 0) end).length;
this:add(p, "AutoBlock", 1, ("unblocked their sword for " .. JSSTR(((zero == quick.length) and "less than a tick" or "exactly one tick")) .. " to hit and blocked again, " .. JSSTR(quick.length) .. " of " .. JSSTR(win.length) .. " times in " .. JSSTR(Math.round((c.abWindow / 1000))) .. "s (by hand it takes 2+ ticks)"), t, c.abVL); end end
Engine.hitNearby = function(this, p, t, ms)  if ((T(this.self) and (Math.abs((this.selfHurtAt - t)) <= ms)) and (Math.hypot((this.self.x - p.x), (this.self.y - p.y), (this.self.z - p.z)) < 6)) then do return true end end
for __i160, q in ITER(this.players:values()) do do if (q == p) then goto __c161 end
if (Math.abs((q.hurtAt - t)) <= ms) then local a = this:posAt(p, t); local b = this:posAt(q, t);
if (Math.hypot((a.x - b.x), (a.y - b.y), (a.z - b.z)) < 6) then do return true end end end end ::__c161::  end
do return false end end
Engine.bedsNear = function(this, x, z, r, y)  do return this.world:bedsNear(x, z, r, y) end end
Engine.checkDefend = function(this, p, pl)  local c = this.cfg; local t = pl.t;
local bed = this:bedsNear(pl.x, pl.z, c.defendRadius, pl.y):find(function(_, b)  return ((GE(pl.y, (b.y - 1)) and LE(pl.y, (b.y + 3))) and LE(Math.min(Math.max(Math.abs((pl.x - b.x)), Math.abs((pl.z - b.z))), Math.max(Math.abs((pl.x - b.hx)), Math.abs((pl.z - b.hz)))), c.defendRadius)) end);
if (not T(bed)) then do return end end
pl.bed = bed;
if (T(p.defendAt) and ((t - p.defendAt) < 8000)) then do return end end
local touch = p.places:filter(function(_, b)  return ANDF(ANDF(b.bed, function() return (b.bed.k == bed.k) end), function() return LE((t - b.t), c.defendOrderMs) end) end):map(function(_, b)  return {i = myauIndex(nil, b, bed), t = b.t} end):filter(function(_, x)  return GE(x.i, 0) end);
local run = 1; local best = 1; local from = IFX(T(touch.length), function() return touch[0].t end, function() return t end); local bestFrom = from;
do local i = 1; while LT(i, touch.length) do do if GT(touch[i].i, touch[(i - 1)].i) then run = run + 1;
if (run > best) then best = run;
bestFrom = from; end else run = 1;
from = touch[i].t; end end  i = i + 1; end end
if ((GE(best, c.defendOrder) and (touch[(touch.length - 1)].i == Math.max(SPREAD(touch:map(function(_, x)  return x.i end))))) and (not T(this:stalled(bestFrom, t)))) then p.defendAt = t;
local secs = ((t - bestFrom) / 1000);
this:add(p, "AutoDefend", ((best >= 7) and 2 or 1.5), ("placed " .. JSSTR(best) .. " blocks around their bed in " .. JSSTR(TOFIXED(secs, 1)) .. "s in the exact order of an auto bed defense (left, right, left, right, ends, then on top)"), t, c.defendVL);
do return end end
local recent = p.places:filter(function(_, b)  return ANDF(ANDF(b.bed, function() return (b.bed.k == bed.k) end), function() return LE((t - b.t), c.defendSwapMs) end) end);
local swaps = 0;
do local i = 1; while LT(i, recent.length) do do if ((SAR(recent[i].state, 4) ~= SAR(recent[(i - 1)].state, 4)) and LE((recent[i].t - recent[(i - 1)].t), c.defendSwapGap)) then swaps = swaps + 1; end end  i = i + 1; end end
if ((GE(swaps, c.defendSwaps) and GE(recent.length, 6)) and (not T(this:stalled(recent[0].t, t)))) then p.defendAt = t;
this:add(p, "AutoDefend", 1.5, ("placed " .. JSSTR(recent.length) .. " blocks around their bed in " .. JSSTR(TOFIXED(((t - recent[0].t) / 1000), 1)) .. "s, switching block type " .. JSSTR(swaps) .. " times with no delay (by hand a switch takes 3+ ticks)"), t, c.defendVL);
do return end end
local around = p.places:filter(function(_, b)  return ANDF(ANDF(b.bed, function() return (b.bed.k == bed.k) end), function() return LE((t - b.t), c.defendMs) end) end);
if (GE(around.length, c.defendBlocks) and (not T(this:stalled(around[0].t, t)))) then local secs = ((t - around[0].t) / 1000);
p.defendAt = t;
this:add(p, "AutoDefend", 1, ("placed " .. JSSTR(around.length) .. " blocks around their bed in " .. JSSTR(TOFIXED(secs, 1)) .. "s (the fastest hands take about 1.3 s for 13)"), t, c.defendVL); end end
Engine.checkClutch = function(this, p, pl)  local c = this.cfg; local t = pl.t;
if (not T(this:knockedOff(p, t))) then do return end end
local before = this:posAt(p, (t - 150));
if (((T(before.g) or GT(pl.y, (Math.floor((pl.feetY + 0.01)) - 1))) or (Math.abs(((pl.x + 0.5) - pl.px)) > 1.8)) or (Math.abs(((pl.z + 0.5) - pl.pz)) > 1.8)) then do return end end
local pos = this:posAt(p, (t - 250));
if (not T(this:voidBelow(pos.x, pos.y, pos.z, 4, (t - 600)))) then do return end end
if T(this:stalled((t - 500), t)) then do return end end
pl.falling = this:fallingAt(p, t, pl.feetY);
if (not T(p.places:some(function(_, b)  return ANDF((((t - b.t) <= 400) and LE(b.t, t)), function() return b.falling end) end))) then do return end end
local snap = 0;
local rs = p.rots:filter(function(_, r)  return (GE(r.t, (t - 450)) and LE(r.t, (t + 60))) end);
do local i = 1; while LT(i, rs.length) do do local d = Math.hypot(wrap(nil, (rs[i].yaw - rs[(i - 1)].yaw)), (rs[i].pitch - rs[(i - 1)].pitch));
if (((rs[i].t - rs[(i - 1)].t) <= 110) and (d > snap)) then snap = d; end end  i = i + 1; end end
local swapIn = OR(p.heldHistory, AN(0)):some(function(_, h)  return ANDF(ANDF(ANDF(isBlockItem(nil, h.id), function() return (not T(isBlockItem(nil, h.prev))) end), function() return ((t - h.t) >= 0) end), function() return ((t - h.t) <= 200) end) end);
local chain = p.places:filter(function(_, b)  return (((t - b.t) <= 400) and LE(b.y, (Math.floor((b.feetY + 0.01)) - 1))) end).length;
local score = 0;
local bits = AN(0);
if (snap >= 100) then score = (score + 1);
bits:push(("turned their head " .. JSSTR(Math.round(snap)) .. "° in one update to look down")); end
if T(swapIn) then score = (score + 0.5);
bits:push("switched to blocks right before"); end
if (chain >= 5) then score = (score + 1);
bits:push(("placed " .. JSSTR(chain) .. " blocks under themselves in 0.4s")); elseif (chain >= 3) then score = (score + 0.5);
bits:push(("placed " .. JSSTR(chain) .. " blocks under themselves in 0.4s")); end
if LT(score, c.clutchMinScore) then do return end end
score = (score + 0.5);
local caught = p.places:filter(function(_, b)  return ANDF(((t - b.t) <= 400), function() return b.under end) end);
this:proposeClutch(p, t, score, ("knocked off and falling, " .. JSSTR(bits:join(", "))), IFX(T(caught.length), function() return caught end, function() return AN(1, pl) end)); end
Engine.checkHitClutch = function(this, p, pl)  local c = this.cfg; local t = pl.t;
if (T(p.hitClutchAt) and ((t - p.hitClutchAt) < 5000)) then do return end end
local air = p.places:filter(function(_, b)  return ANDF(ANDF(LE((t - b.t), c.hitClutchMs), function() return b.under end), function() return b.air end) end);
if LT(air.length, c.hitClutchBlocks) then do return end end
local hits = OR(p.hurts, AN(0)):filter(function(_, h)  return (((not T(h.fall)) and GE(h.t, air[0].t)) and LE(h.t, t)) end).length;
if LT(hits, c.hitClutchHits) then do return end end
local levels = NEW(Set, air:map(function(_, b)  return b.y end)).size;
if (GT(levels, c.hitClutchLevels) or T(this:stalled(air[0].t, t))) then do return end end
p.hitClutchAt = t;
this:add(p, "AutoClutch", c.clutchVL, ("kept putting blocks under their feet in mid-air while being hit: " .. JSSTR(air.length) .. " blocks in " .. JSSTR(TOFIXED(((t - air[0].t) / 1000), 1)) .. "s, hit " .. JSSTR(hits) .. " times meanwhile, all in a flat line - knocked about like that, a hand can't keep a block under itself"), t, c.clutchVL); end
Engine.checkSafewalk = function(this, p, pl)  local c = this.cfg; local t = pl.t;
local R = p.safeRun;
if (not ((T(pl.under) and (not T(pl.air))) and GE(pl.pitch, 45))) then if (T(R) and ((t - R.last) > 100)) then p.safeRun = nil; end
do return end end
if (T(R) and GT((t - R.last), c.safeGapMs)) then R = nil; end
if (not T(R)) then R = (function() p.safeRun = {t0 = t, last = t, n = 0, x0 = pl.x, z0 = pl.z, px0 = pl.px, pz0 = pl.pz, yaw0 = pl.yaw, t3 = 0, ymin = 0, ymax = 0, pmin = pl.pitch, pmax = pl.pitch, bad = 0, aimed = 0, broken = false, done = false}; return p.safeRun end)(); end
local look = function(_, yaw, pitch)  local d = wrap(nil, (yaw - R.yaw0));
R.ymin = Math.min(R.ymin, d);
R.ymax = Math.max(R.ymax, d);
R.pmin = Math.min(R.pmin, pitch);
R.pmax = Math.max(R.pmax, pitch); end;
R.n = R.n + 1;
if (R.n == 3) then R.t3 = t;
R.yaw0 = pl.yaw;
R.ymin = (function() R.ymax = 0; return R.ymax end)();
R.pmin = (function() R.pmax = pl.pitch; return R.pmax end)(); end
if GT(R.n, 3) then for __i165, r in ITER(p.rots) do do if (GT(r.t, R.last) and LE(r.t, (t + 5))) then look(nil, r.yaw, r.pitch); end end   end
look(nil, pl.yaw, pl.pitch); end
if (GE(R.n, 3) and (T(p.sneak) or T(p.crouches:some(function(_, x)  return GE((x.t - x.ms), R.t3) end)))) then R.broken = true; end
if (GT((R.ymax - R.ymin), c.safeHeadDeg) or GT((R.pmax - R.pmin), c.safeHeadDeg)) then R.broken = true; end
R.last = t;
if (T(R.broken) or T(R.done)) then do return end end
local aim = this:couldAim(p, pl);
if (aim == false) then R.bad = R.bad + 1; end
if (aim ~= nil) then R.aimed = R.aimed + 1; end
if (LT(R.n, c.safeMinBlocks) or LT((t - R.t0), c.safeMinMs)) then do return end end
local dx = (pl.px - R.px0); local dz = (pl.pz - R.pz0); local secs = ((t - R.t0) / 1000); local speed = (Math.hypot(dx, dz) / secs);
local bx = Math.abs((pl.x - R.x0)); local bz = Math.abs((pl.z - R.z0)); local diag = (Math.min(bx, bz) / Math.max(1, bx, bz));
local back = adiff(nil, (R.yaw0 + ((R.ymin + R.ymax) / 2)), yawTo(nil, dx, dz));
if (((((((GE(diag, c.safeMaxDiag) and GE(R.n, c.diagMinBlocks)) and GE((t - R.t0), c.diagMinMs)) and (speed >= (c.diagMinSpeed * this:speedMul(p, t)))) and GE(back, c.safeBack)) and LE((R.ymax - R.ymin), c.diagHeadDeg)) and LE((R.pmax - R.pmin), c.diagHeadDeg)) and (not T(this.stalls:some(function(_, s)  return ((((not T(s.tp)) and ((s.to - s.from) >= 600)) and GE(s.to, (R.t0 - 300))) and LE(s.from, t)) end)))) then R.done = true;
this:add(p, "Scaffold", c.safeVL, ("bridged backwards diagonally, " .. JSSTR(R.n) .. " blocks in " .. JSSTR(TOFIXED(secs, 1)) .. "s (" .. JSSTR(TOFIXED(speed, 1)) .. " b/s), without crouching once and with their head dead still"), t, c.keepYVL);
do return end end
local dx = (pl.px - R.px0); local dz = (pl.pz - R.pz0); local secs = ((t - R.t0) / 1000); local speed = (Math.hypot(dx, dz) / secs);
local back = adiff(nil, (R.yaw0 + ((R.ymin + R.ymax) / 2)), yawTo(nil, dx, dz));
local bx = Math.abs((pl.x - R.x0)); local bz = Math.abs((pl.z - R.z0)); local diag = (Math.min(bx, bz) / Math.max(1, bx, bz));
if (((LT(speed, c.safeMinSpeed) or LT(back, c.safeBack)) or GE(diag, c.safeMaxDiag)) or T(this.stalls:some(function(_, s)  return ((((not T(s.tp)) and ((s.to - s.from) >= 600)) and GE(s.to, (R.t0 - 300))) and LE(s.from, t)) end))) then do return end end
R.done = true;
this:add(p, "Scaffold", c.safeVL, ("bridged backwards in a straight line, " .. JSSTR(R.n) .. " blocks in " .. JSSTR(TOFIXED(secs, 1)) .. "s (" .. JSSTR(TOFIXED(speed, 1)) .. " b/s), without crouching once and with their head locked" .. JSSTR((T(R.bad) and (" (" .. JSSTR(R.bad) .. " of " .. JSSTR(R.aimed) .. " blocks placed where they couldn't have aimed)") or "")) .. " - like safewalk: at that pace hands shift at every block, unless bridging diagonally (breezily) or facing forward (godbridge)"), t, c.keepYVL); end
Engine.fallingAt = function(this, p, t, feetY)  local before = this:posAt(p, (t - 150));
local peak = (-1000000000);
for __i167, e in ITER(p.track) do do if (LE(e.t, t) and ((t - e.t) <= 1500)) then peak = Math.max(peak, e.y); end end   end
do return ((feetY < (before.y - 0.1)) and ((peak - feetY) >= 1)) end end
Engine.proposeClutch = function(this, p, t, score, reason, blocks)  local c = p.clutchPend;
local bs = blocks:map(function(_, b)  return {x = b.x, y = b.y, z = b.z} end);
if (T(c) and ((t - c.t0) < 2000)) then if GT(score, c.score) then c.score = score;
c.reason = reason; end
for __i169, b in ITER(bs) do do if (not T(c.blocks:some(function(_, o)  return (((o.x == b.x) and (o.y == b.y)) and (o.z == b.z)) end))) then c.blocks:push(b); end end   end
c.t = t; else p.clutchPend = {t0 = t, t = t, score = score, reason = reason, blocks = bs}; end
this:checkClutchLanded(p, t); end
Engine.checkClutchLanded = function(this, p, t)  local c = p.clutchPend;
if (not T(c)) then do return end end
local low = Math.min(SPREAD(c.blocks:map(function(_, b)  return b.y end)));
if (((t - c.t) > 1500) or LT(p.y, (low - 2))) then p.clutchPend = nil;
do return end end
if (not T(p.onGround)) then do return end end
local on = c.blocks:some(function(_, b)  return (((Math.abs(((b.x + 0.5) - p.x)) <= 1.3) and (Math.abs(((b.z + 0.5) - p.z)) <= 1.3)) and (Math.abs((p.y - (b.y + 1))) <= 0.6)) end);
if (not T(on)) then do return end end
p.clutchPend = nil;
local same = ANDF(p.clutchAt, function() return ((c.t0 - p.clutchAt) < 2000) end);
local had = IFX(T(same), function() return OR(p.clutchScore, 0) end, function() return 0 end);
if LE(c.score, had) then do return end end
if (not T(same)) then p.clutchAt = c.t0;
p.clutches = (OR(p.clutches, 0) + 1); end
p.clutchScore = c.score;
this:add(p, "AutoClutch", (c.score - had), (JSSTR(c.reason) .. ", and landed on them" .. JSSTR((GT(p.clutches, 1) and (" (" .. JSSTR(p.clutches) .. " times this game)") or ""))), t, this.cfg.clutchVL); end
myauIndex = function(this, b, bed)  local fwd = AN(4, AN(2, 0, 1), AN(2, (-1), 0), AN(2, 0, (-1)), AN(2, 1, 0))[bed.dir];
local left = AN(4, AN(2, 1, 0), AN(2, 0, 1), AN(2, (-1), 0), AN(2, 0, (-1)))[bed.dir];
local fx = bed.x; local fz = bed.z; local hx = bed.hx; local hz = bed.hz; local y = bed.y;
local list = AN(8, AN(3, (fx + left[0]), y, (fz + left[1])), AN(3, (fx - left[0]), y, (fz - left[1])), AN(3, (hx + left[0]), y, (hz + left[1])), AN(3, (hx - left[0]), y, (hz - left[1])), AN(3, (fx - fwd[0]), y, (fz - fwd[1])), AN(3, (hx + fwd[0]), y, (hz + fwd[1])), AN(3, fx, (y + 1), fz), AN(3, hx, (y + 1), hz));
do return list:findIndex(function(_, __p171) local x = __p171[0] local yy = __p171[1] local z = __p171[2] return (((x == b.x) and (yy == b.y)) and (z == b.z)) end) end end
FACES = AN(6, AN(3, 0, (-1), 0), AN(3, 0, 1, 0), AN(3, 1, 0, 0), AN(3, (-1), 0, 0), AN(3, 0, 0, 1), AN(3, 0, 0, (-1)))
raycast = function(this, w, ox, oy, oz, vx, vy, vz, maxD, skip, later)  local x = Math.floor(ox); local y = Math.floor(oy); local z = Math.floor(oz);
local sx = ((vx > 0) and 1 or (-1)); local sy = ((vy > 0) and 1 or (-1)); local sz = ((vz > 0) and 1 or (-1));
local tdx = Math.abs((1 / OR(vx, 1e-12))); local tdy = Math.abs((1 / OR(vy, 1e-12))); local tdz = Math.abs((1 / OR(vz, 1e-12)));
local tx = (((vx > 0) and ((x + 1) - ox) or (ox - x)) * tdx); local ty = (((vy > 0) and ((y + 1) - oy) or (oy - y)) * tdy); local tz = (((vz > 0) and ((z + 1) - oz) or (oz - z)) * tdz);
local nx = 0; local ny = 0; local nz = 0; local d = 0;
do local i = 0; while ((i < 20) and (d <= maxD)) do do if ((tx < ty) and (tx < tz)) then x = (x + sx);
d = tx;
tx = (tx + tdx);
nx = (-sx);
ny = 0;
nz = 0; elseif (ty < tz) then y = (y + sy);
d = ty;
ty = (ty + tdy);
nx = 0;
ny = (-sy);
nz = 0; else z = (z + sz);
d = tz;
tz = (tz + tdz);
nx = 0;
ny = 0;
nz = (-sz); end
if (d > maxD) then break end
if (((x == skip.x) and (y == skip.y)) and (z == skip.z)) then goto __c172 end
local s = w:get(x, y, z);
if (((s > 0) and T(solid(nil, s))) and (not T(later(nil, x, y, z)))) then do return {x = x, y = y, z = z, nx = nx, ny = ny, nz = nz} end end end ::__c172:: i = i + 1; end end
do return nil end end
BLOCK_NAMES = {[35] = "wool", [121] = "end stone", [5] = "wood", [159] = "clay", [172] = "clay", [49] = "obsidian", [20] = "glass", [95] = "glass", [26] = "a bed", [65] = "a ladder", [24] = "sandstone"}
blockName = function(this, state)  do return IFX((state > 0), function() return OR(BLOCK_NAMES[SAR(state, 4)], "a block") end, function() return "a block" end) end end
__exports = {Engine = Engine, CFG = CFG};
return __exports