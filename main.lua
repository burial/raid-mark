local icons = {
  ROGUE = 1,
  DRUID = 2,
  WARLOCK = 3,
  HUNTER = 4,
  MAGE = 6,
  SHAMAN = 6,
  DEATHKNIGHT = 7,
  PRIEST = 8,
  PALADIN = 3,
}

local claimed = {}
local unset = {}

SLASH_MARK1 = "/mark"
function SlashCmdList.MARK()
  for i = 0, GetNumPartyMembers() do
    local unit = i == 0 and "player" or "party" .. i

    do
      local active = GetRaidTargetIndex(unit)
      if active then
        SetRaidTargetIcon(unit, active)
      end
    end

    local _, class = UnitClass(unit)
    local icon = icons[class]

    if icon == nil or claimed[icon] then
      unset[unit] = true
    else
      SetRaidTarget(unit, icon)
      claimed[icon] = true
    end
  end

  for unit in pairs(unset) do
    local icon
    repeat
      icon = math.random(1, 8)
    until not claimed[icon]
    SetRaidTarget(unit, icon)
  end

  if GetNumRaidMembers() == 0 then
    ConvertToRaid()
  end

  wipe(claimed)
  wipe(unset)
end
