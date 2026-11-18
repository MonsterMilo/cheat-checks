-- JS semantics for code compiled by js2lua.js: 0-based arrays with .length,
-- insertion-ordered Map / Set, JS truthiness, JS number formatting, Math.
-- Every function value takes `this` as its first argument.

local floor, huge, type, select, tostring, mtype = math.floor, math.huge, type, select, tostring, math.type

-- Numbers ------------------------------------------------------------------

local function toint(x)
    if mtype(x) == "integer" then return x end
    if x ~= x or x == huge or x == -huge then return 0 end
    local i = x >= 0 and floor(x) or -floor(-x)
    return math.tointeger(i) or 0
end
local function i32(x)
    x = toint(x) & 0xFFFFFFFF
    if x >= 0x80000000 then x = x - 0x100000000 end
    return x
end
function SAR(a, b) return i32(a) // (1 << (toint(b) & 31)) end
function SHL(a, b) return i32(i32(a) << (toint(b) & 31)) end
function SHR(a, b) return (toint(a) & 0xFFFFFFFF) >> (toint(b) & 31) end
function BAND(a, b) return i32(i32(a) & i32(b)) end
function BOR(a, b) return i32(i32(a) | i32(b)) end
function BXOR(a, b) return i32(i32(a) ~ i32(b)) end
function MOD(a, b) return math.fmod(a, b) end
function POW(a, b) return a ^ b end
function HYPOT(...)
    local s = 0
    for i = 1, select("#", ...) do local v = select(i, ...); s = s + v * v end
    return math.sqrt(s)
end
function TONUM(x)
    if type(x) == "number" then return x end
    if x == nil then return 0 / 0 end
    if x == true then return 1 elseif x == false then return 0 end
    return tonumber(x) or 0 / 0
end

-- JS String(number): integers without ".0", shortest round-trip otherwise.
local function numstr(n)
    if n ~= n then return "NaN" end
    if n == huge then return "Infinity" elseif n == -huge then return "-Infinity" end
    if mtype(n) == "integer" then return tostring(n) end
    if n == floor(n) and n > -1e21 and n < 1e21 then return string.format("%d", n) end
    for p = 1, 17 do
        local s = string.format("%." .. p .. "g", n)
        if tonumber(s) == n then
            -- JS writes 1e-7 style only below 1e-6
            if s:find("e") then
                local m, e = s:match("^(-?[%d%.]+)e([-+]%d+)$")
                e = tonumber(e)
                if e >= -6 and e < 21 then s = string.format("%." .. math.max(0, p - 1 - e) .. "f", n) end
            end
            return s
        end
    end
    return tostring(n)
end
function JSSTR(v)
    local t = type(v)
    if t == "string" then return v end
    if t == "number" then return numstr(v) end
    if v == nil then return "undefined" end
    if t == "boolean" then return v and "true" or "false" end
    if t == "table" and v.__isArray then
        local parts = {}
        for i = 0, v.length - 1 do local e = v[i]; parts[#parts + 1] = e == nil and "" or JSSTR(e) end
        return table.concat(parts, ",")
    end
    return "[object Object]"
end
function TOFIXED(n, d)
    d = d or 0
    if n ~= n then return "NaN" end
    -- JS rounds half away from zero on the decimal string; close enough for messages
    local s = string.format("%." .. d .. "f", n)
    if s:match("^%-0%.?0*$") then s = s:sub(2) end
    return s
end

-- Truthiness / logic ---------------------------------------------------------

function T(x) return x ~= nil and x ~= false and x ~= 0 and x ~= "" and x == x end
function OR(a, b) if T(a) then return a end return b end
function AND(a, b) if T(a) then return b end return a end
function ORF(a, f) if T(a) then return a end return f() end
function ANDF(a, f) if T(a) then return f() end return a end
function NULLISH(a, b) if a == nil then return b end return a end
function NULLISHF(a, f) if a == nil then return f() end return a end
function IFX(c, a, b) if c then return a() end return b() end
function TYPEOF(v)
    local t = type(v)
    if v == nil then return "undefined" end
    if t == "table" then return "object" end
    return t -- number, string, boolean, function
end

-- Classes ----------------------------------------------------------------------

function CLASS(name, super)
    local c = { __name = name }
    c.__index = c
    if super then setmetatable(c, { __index = super }); c.__super = super end
    return c
end
function NEW(cls, ...)
    local o = setmetatable({}, cls)
    local ctor = cls.constructor
    if ctor then ctor(o, ...) end
    return o
end
function INSTANCEOF(o, cls)
    if type(o) ~= "table" then return false end
    local m = getmetatable(o)
    while m do if m == cls then return true end; m = m.__super end
    return false
end
function METHOD(o, name, ...) return o[name](o, ...) end

-- Arrays -----------------------------------------------------------------------

local Arr = CLASS("Array")
Arr.__isArray = true
local function newArr() return setmetatable({ length = 0 }, Arr) end
function A(...)
    local a = newArr()
    local n = select("#", ...)
    for i = 1, n do a[i - 1] = (select(i, ...)) end
    a.length = n
    return a
end
function AN(n, ...)
    local a = newArr()
    for i = 1, n do a[i - 1] = (select(i, ...)) end
    a.length = n
    return a
end
local function isArr(x) return type(x) == "table" and x.__isArray == true end

local Map, Set -- forward
-- Array of a spreadable thing: array, Set (values), Map (entries).
local function toArr(x)
    if isArr(x) then return x end
    if type(x) == "table" and x.__iterValues then return x:__iterValues() end
    error("not iterable")
end
function ACAT(...)
    local out = newArr()
    local n = 0
    for i = 1, select("#", ...) do
        local a = toArr((select(i, ...)))
        for j = 0, a.length - 1 do out[n] = a[j]; n = n + 1 end
    end
    out.length = n
    return out
end
function SPREAD(x)
    local a = toArr(x)
    return table.unpack(a, 0, a.length - 1)
end

function Arr:push(...)
    local n = self.length
    for i = 1, select("#", ...) do self[n] = (select(i, ...)); n = n + 1 end
    self.length = n
    return n
end
function Arr:pop()
    local n = self.length
    if n == 0 then return nil end
    local v = self[n - 1]
    self[n - 1] = nil
    self.length = n - 1
    return v
end
function Arr:shift()
    local n = self.length
    if n == 0 then return nil end
    local v = self[0]
    table.move(self, 1, n - 1, 0)
    self[n - 1] = nil
    self.length = n - 1
    return v
end
function Arr:unshift(...)
    local k, n = select("#", ...), self.length
    if n > 0 then table.move(self, 0, n - 1, k) end
    for i = 1, k do self[i - 1] = (select(i, ...)) end
    self.length = n + k
    return n + k
end
function Arr:filter(f)
    local out, m = newArr(), 0
    for i = 0, self.length - 1 do local v = self[i]; if T(f(nil, v, i, self)) then out[m] = v; m = m + 1 end end
    out.length = m
    return out
end
function Arr:map(f)
    local out = newArr()
    for i = 0, self.length - 1 do out[i] = f(nil, self[i], i, self) end
    out.length = self.length
    return out
end
function Arr:flatMap(f)
    local out, m = newArr(), 0
    for i = 0, self.length - 1 do
        local r = f(nil, self[i], i, self)
        if isArr(r) then for j = 0, r.length - 1 do out[m] = r[j]; m = m + 1 end
        else out[m] = r; m = m + 1 end
    end
    out.length = m
    return out
end
function Arr:forEach(f) for i = 0, self.length - 1 do f(nil, self[i], i, self) end end
function Arr:some(f) for i = 0, self.length - 1 do if T(f(nil, self[i], i, self)) then return true end end return false end
function Arr:every(f) for i = 0, self.length - 1 do if not T(f(nil, self[i], i, self)) then return false end end return true end
function Arr:find(f) for i = 0, self.length - 1 do local v = self[i]; if T(f(nil, v, i, self)) then return v end end return nil end
function Arr:findIndex(f) for i = 0, self.length - 1 do if T(f(nil, self[i], i, self)) then return i end end return -1 end
function Arr:findLast(f) for i = self.length - 1, 0, -1 do local v = self[i]; if T(f(nil, v, i, self)) then return v end end return nil end
function Arr:indexOf(x) for i = 0, self.length - 1 do if self[i] == x then return i end end return -1 end
function Arr:includes(x) for i = 0, self.length - 1 do if self[i] == x then return true end end return false end
function Arr:reduce(f, init)
    local acc, i = init, 0
    if init == nil then acc = self[0]; i = 1 end
    for j = i, self.length - 1 do acc = f(nil, acc, self[j], j, self) end
    return acc
end
function Arr:slice(s, e)
    local n = self.length
    s = s == nil and 0 or toint(s); e = e == nil and n or toint(e)
    if s < 0 then s = math.max(0, n + s) end
    if e < 0 then e = math.max(0, n + e) end
    if e > n then e = n end
    local out, m = newArr(), 0
    for i = s, e - 1 do out[m] = self[i]; m = m + 1 end
    out.length = m
    return out
end
function Arr:splice(s, count, ...)
    local n = self.length
    s = toint(s); if s < 0 then s = math.max(0, n + s) end
    if s > n then s = n end
    count = count == nil and (n - s) or math.max(0, math.min(toint(count), n - s))
    local removed = newArr()
    for i = 0, count - 1 do removed[i] = self[s + i] end
    removed.length = count
    local ins = select("#", ...)
    local tail = {}
    for i = s + count, n - 1 do tail[#tail + 1] = self[i] end
    for i = s, n - 1 do self[i] = nil end
    local k = s
    for i = 1, ins do self[k] = (select(i, ...)); k = k + 1 end
    for i = 1, #tail do self[k] = tail[i]; k = k + 1 end
    self.length = k
    return removed
end
function Arr:concat(...)
    return ACAT(self, ...)
end
function Arr:join(sep)
    sep = sep == nil and "," or sep
    local parts = {}
    for i = 0, self.length - 1 do local v = self[i]; parts[#parts + 1] = v == nil and "" or JSSTR(v) end
    return table.concat(parts, sep)
end
function Arr:reverse()
    local n = self.length
    for i = 0, (n // 2) - 1 do self[i], self[n - 1 - i] = self[n - 1 - i], self[i] end
    return self
end
function Arr:fill(v, s, e)
    s = s or 0; e = e or self.length
    for i = s, e - 1 do self[i] = v end
    return self
end
function Arr:sort(cmp)
    local n = self.length
    local t = table.move(self, 0, n - 1, 1, {})
    if cmp then
        -- stable merge sort (JS sort is stable; table.sort is not)
        local function merge(lo, mid, hi, buf)
            local i, j, k = lo, mid + 1, lo
            while i <= mid and j <= hi do
                if cmp(nil, t[j], t[i]) < 0 then buf[k] = t[j]; j = j + 1 else buf[k] = t[i]; i = i + 1 end
                k = k + 1
            end
            while i <= mid do buf[k] = t[i]; i = i + 1; k = k + 1 end
            while j <= hi do buf[k] = t[j]; j = j + 1; k = k + 1 end
            for x = lo, hi do t[x] = buf[x] end
        end
        local function ms(lo, hi, buf)
            if lo >= hi then return end
            local mid = (lo + hi) // 2
            ms(lo, mid, buf); ms(mid + 1, hi, buf); merge(lo, mid, hi, buf)
        end
        ms(1, n, {})
    else
        table.sort(t, function(a, b) return JSSTR(a) < JSSTR(b) end)
    end
    table.move(t, 1, n, 0, self)
    return self
end
function Arr:keys() local out = newArr(); for i = 0, self.length - 1 do out[i] = i end; out.length = self.length; return out end
function Arr:values() return self:slice() end
function Arr:__iterValues() return self end

-- Iteration helpers for `for..of`.
function ITER(x)
    if isArr(x) then
        local i = -1
        return function() i = i + 1; if i < x.length then return i, x[i] end end
    end
    return ITER(toArr(x))
end
-- for (const [a, b] of x): a Map gives key, value; an array of pairs gives e[0], e[1].
function ITER2(x)
    if type(x) == "table" and x.__isMap then
        local keys, vals, i, n = x._k, x._v, 0, nil
        return function()
            while true do
                i = i + 1
                local k = keys[i]
                if k == nil then
                    if i > #keys then return nil end
                elseif k ~= Map.TOMB and x._has[k] then
                    return i, k, vals[k]
                end
            end
        end
    end
    local a, i = toArr(x), -1
    return function()
        i = i + 1
        if i < a.length then local e = a[i]; return i, e[0], e[1] end
    end
end

-- Map / Set --------------------------------------------------------------------

Map = CLASS("Map")
Map.__isMap = true
Map.TOMB = setmetatable({}, { __tostring = function() return "TOMB" end })
local NILKEY = {}
local function mk(k) if k == nil then return NILKEY end; if k ~= k then error("NaN map key") end; return k end
function Map:constructor(entries)
    self._k, self._v, self._has, self._pos = {}, {}, {}, {}
    self.size, self._dead = 0, 0
    if entries then
        local a = toArr(entries)
        for i = 0, a.length - 1 do local e = a[i]; self:set(e[0], e[1]) end
    end
end
function Map:_compact()
    local nk, np = {}, {}
    for i = 1, #self._k do
        local k = self._k[i]
        if k ~= Map.TOMB and self._has[k] then nk[#nk + 1] = k; np[k] = #nk end
    end
    self._k, self._pos, self._dead = nk, np, 0
end
function Map:set(k, v)
    k = mk(k)
    if not self._has[k] then
        self._has[k] = true
        self._k[#self._k + 1] = k
        self._pos[k] = #self._k
        self.size = self.size + 1
    end
    self._v[k] = v
    return self
end
function Map:get(k) return self._v[mk(k)] end
function Map:has(k) return self._has[mk(k)] == true end
function Map:delete(k)
    k = mk(k)
    if not self._has[k] then return false end
    self._has[k] = nil
    self._v[k] = nil
    local p = self._pos[k]
    self._k[p] = Map.TOMB
    self._pos[k] = nil
    self.size = self.size - 1
    self._dead = self._dead + 1
    if self._dead > 32 and self._dead > self.size then self:_compact() end
    return true
end
function Map:clear()
    self._k, self._v, self._has, self._pos = {}, {}, {}, {}
    self.size, self._dead = 0, 0
end
local function ukey(k) if k == NILKEY then return nil end return k end
function Map:keys()
    local out, n = newArr(), 0
    for i = 1, #self._k do local k = self._k[i]; if k ~= Map.TOMB and self._has[k] then out[n] = ukey(k); n = n + 1 end end
    out.length = n
    return out
end
function Map:values()
    local out, n = newArr(), 0
    for i = 1, #self._k do local k = self._k[i]; if k ~= Map.TOMB and self._has[k] then out[n] = self._v[k]; n = n + 1 end end
    out.length = n
    return out
end
function Map:entries()
    local out, n = newArr(), 0
    for i = 1, #self._k do local k = self._k[i]; if k ~= Map.TOMB and self._has[k] then out[n] = A(ukey(k), self._v[k]); n = n + 1 end end
    out.length = n
    return out
end
Map.__iterValues = Map.entries
function Map:forEach(f) for i, k, v in ITER2(self) do f(nil, v, ukey(k), self) end end

Set = CLASS("Set")
function Set:constructor(items)
    self._m = NEW(Map)
    self.size = 0
    if items then
        local a = toArr(items)
        for i = 0, a.length - 1 do self:add(a[i]) end
    end
end
function Set:add(v) self._m:set(v, true); self.size = self._m.size; return self end
function Set:has(v) return self._m:has(v) end
function Set:delete(v) local r = self._m:delete(v); self.size = self._m.size; return r end
function Set:clear() self._m:clear(); self.size = 0 end
function Set:values() return self._m:keys() end
Set.keys = Set.values
Set.__iterValues = Set.values
function Set:forEach(f) local a = self:values(); for i = 0, a.length - 1 do f(nil, a[i], a[i], self) end end

_G.Map, _G.Set = Map, Set

-- Strings: JS .length and a few methods ---------------------------------------

do
    local smt = getmetatable("")
    local S = {}
    function S.includes(s, x) return s:find(x, 1, true) ~= nil end
    function S.startsWith(s, x) return s:sub(1, #x) == x end
    function S.endsWith(s, x) return x == "" or s:sub(-#x) == x end
    function S.toLowerCase(s) return s:lower() end
    function S.toUpperCase(s) return s:upper() end
    function S.trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
    function S.slice(s, a, b)
        local n = #s; a = a or 0; b = b or n
        if a < 0 then a = math.max(0, n + a) end
        if b < 0 then b = math.max(0, n + b) end
        return s:sub(a + 1, b)
    end
    function S.indexOf(s, x) local i = s:find(x, 1, true); return i and i - 1 or -1 end
    local idx = smt.__index
    smt.__index = function(s, k)
        if k == "length" then return #s end
        local f = S[k]
        if f then return f end
        if type(k) == "number" then return s:sub(k + 1, k + 1) end
        return idx[k]
    end
end

-- Globals: Math, Object, Number ------------------------------------------------

Math = {
    PI = math.pi, E = math.exp(1),
    floor = function(x) local r = floor(x); return math.tointeger(r) or r end,
    ceil = function(x) local r = math.ceil(x); return math.tointeger(r) or r end,
    abs = math.abs, sqrt = math.sqrt, sin = math.sin, cos = math.cos, tan = math.tan,
    atan2 = function(y, x) return math.atan(y, x) end, atan = function(x) return math.atan(x) end,
    asin = math.asin, acos = math.acos, exp = math.exp, log = math.log,
    pow = function(a, b) return a ^ b end,
    hypot = HYPOT,
    round = function(x) local r = floor(x + 0.5); return math.tointeger(r) or r end,
    trunc = function(x) local r = x >= 0 and floor(x) or -floor(-x); return math.tointeger(r) or r end,
    sign = function(x) if x > 0 then return 1 elseif x < 0 then return -1 end return x end,
    max = function(...)
        local n = select("#", ...)
        if n == 0 then return -huge end
        local m = -huge
        for i = 1, n do local v = select(i, ...); if v ~= v then return v end; if v > m then m = v end end
        return m
    end,
    min = function(...)
        local n = select("#", ...)
        if n == 0 then return huge end
        local m = huge
        for i = 1, n do local v = select(i, ...); if v ~= v then return v end; if v < m then m = v end end
        return m
    end,
    random = math.random,
}
Object = {
    assign = function(target, ...)
        for i = 1, select("#", ...) do
            local s = select(i, ...)
            if s then for k, v in pairs(s) do target[k] = v end end
        end
        return target
    end,
    keys = function(o) local out = newArr(); for k in pairs(o) do out:push(JSSTR(k)) end; return out end,
    values = function(o) local out = newArr(); for _, v in pairs(o) do out:push(v) end; return out end,
}
Number = { isNaN = function(x) return type(x) == "number" and x ~= x end, isFinite = function(x) return type(x) == "number" and x == x and x ~= huge and x ~= -huge end }
Array = { isArray = isArr, from = function(x) return ACAT(x) end }
function isNaN(x) x = TONUM(x); return x ~= x end
function isFinite(x) x = TONUM(x); return x == x and x ~= huge and x ~= -huge end
-- Boolean / String / Number as functions (called with `this` first, like every function value).
Boolean = function(_, x) return T(x) end
String = setmetatable({}, { __call = function(_, _this, x) return JSSTR(x) end })
setmetatable(Number, { __call = function(_, _this, x) return TONUM(x) end })
-- Relational compare where a side may be undefined (JS: false).
function LT(a, b) if a == nil or b == nil then return false end return a < b end
function GT(a, b) if a == nil or b == nil then return false end return a > b end
function LE(a, b) if a == nil or b == nil then return false end return a <= b end
function GE(a, b) if a == nil or b == nil then return false end return a >= b end
