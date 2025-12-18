-- Weapon base this weapon derrives from
-- Always derive from weapon_tttbase unless youre 300% sure what youre doing!
SWEP.Base				= "weapon_tttbase"


-- Serverside Setup
if SERVER then
	--Has to be the same name as this lua file
	AddCSLuaFile( "example.lua" )
end


-- Name
if CLIENT then
	SWEP.PrintName = "Automatic Rifle"
end


-- Shooting
SWEP.Primary.Damage                 = 20
SWEP.Primary.Automatic              = true
SWEP.Primary.Recoil                 = 0.200
SWEP.Primary.Cone                   = 0.050
SWEP.Primary.Delay                  = 0.250
	-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
	-- Base TTT ammo types include:   Pistols/Rifles   Heavy Pistols   Machine Guns   Snipers      Shotguns
	--                 item_...        ammo_pistol     ammo_revolver    ammo_smg1     ammo_357   box_buckshot  ..._ttt
SWEP.AmmoEnt                        = "item_ammo_smg1_ttt"
SWEP.Primary.Ammo                   = "smg1"
SWEP.Primary.ClipSize               = 20
SWEP.Primary.ClipMax                = 100
	--Amount of ammo the gun spawns with. Can be higher than ClipSIze
SWEP.Primary.DefaultClip            = 20
SWEP.DeploySpeed = 0.2
	-- If IsSilent is true, victims will not scream upon death
SWEP.IsSilent = false
	-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = false
	-- Zoom while aiming. Only works if NoSights = flase
	-- Base FOV  Almost no zoom  Vanilla Zoom  Vanilla Sniper zoom  To much zoom
	--    0            60             40               20                1
SWEP.CustomZoom					    = 40
	-- How much smaller the cone gets when aiming. Just multiplies SWEP.Primary.Cone. Only works if NoSights = flase
	-- No change  Vanilla  Perfect acc.
	--   1.0        0.8        0.0
SWEP.CustomSightsCone               = 0.8


-- Model & Sounds
SWEP.HoldType	   = "ar2"
SWEP.ViewModel  = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
	-- Model position while aiming
SWEP.IronSightsPos = Vector( 6.05, -5, 2.4 )
SWEP.IronSightsAng = Vector( 2.2, -0.1, 0 )
SWEP.Primary.Sound = Sound( "Weapon_AK47.Single" )
if CLIENT then
	SWEP.ViewModelFOV  = 72
	-- Makes the weapon left handed
 	SWEP.ViewModelFlip = false
end


-- Description & Icon
	-- Text shown in the shop menu
if CLIENT then
	SWEP.EquipMenuData = {
		-- Type is shown under the weapon name.
		-- Common types include "Weapon", "Grenade" and "Passive effect item"
		type = "Weapon",
		desc = "Description.\nNew Line."
	};
	-- Path to the icon material
	SWEP.Icon = "VGUI/ttt/icon_myserver_ak47"
end
	-- The icon thats shown in menus. Has to be a unique name!
	-- Otherwise players might see the wrong icon if theyve used a simmilar addon before
if SERVER then
	resource.AddFile("materials/VGUI/ttt/icon_myserver_ak47.vmt")
end


-- TTT shenanigans
	-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can spawn at random weapon spawns
SWEP.AutoSpawnable = true
	-- If a map has weapon spawns reserved for only one weapon type, this determines if the weapon can spawn there.
	-- Can be 0-8. The ingame inventory starts at 1, not 0. So SWEP.Slot + 1 gives you its ingame slot.
if CLIENT then
	SWEP.Slot      = 2
end
	-- Kind specifies the category this weapon is in. Players can only carry one of each. 
	-- When using TTT2, players can carry as many things in slot 7 and 8 as they want.
	-- Can be:     WEAPON_...   MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE
	-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind          = WEAPON_HEAVY
SWEP.AllowDrop     = true
-- TTT Roles
	-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE.
	-- If a role is in this table, those players can buy this.
	-- Most modded roles inherit from either traitor or detective
SWEP.CanBuy        = {  }
	-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock  = false
	-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
	-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor  = nil




-- Overrides of base functions and custom code go here

-- Just copied from weapon_tttbase.lua, but uses self.CustomZoom instead of original number
-- The 'or' is a fallback in case the variable is ever empty / nil
function SWEP:SetZoom(state)
    if CLIENT then
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(self.CustomZoom or 40, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

-- Just copied from weapon_tttbase.lua, but uses self.CustomSightsCone instead of original number
-- The 'or' is a fallback in case the variable is ever empty / nil
function SWEP:GetPrimaryConeFactor()
    local owner = self:GetOwner()

    if not IsValid(owner) then
        return 1
    end

    if SPRINT:IsSprinting(owner) and not owner:IsOnGround() then
        return 2.0
    elseif SPRINT:IsSprinting(owner) or not owner:IsOnGround() then
        return 1.6
    elseif self:GetIronsights() then
        return (self.CustomSightsCone or 0.8)
    else
        return 1
    end
end