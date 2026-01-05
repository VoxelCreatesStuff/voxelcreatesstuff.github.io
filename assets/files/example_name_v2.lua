-- Weapon base this weapon derrives from
-- Always derive from weapon_tttbase unless youre 300% sure what youre doing!
-- For ttt2, this file is stored under: Steam/steamapps/workshop/content/4000/1357204556/temp.gma
-- and then: /gamemodes/terrortown/entities/weapons
SWEP.Base				= "weapon_tttbase"


-- Serverside Setup
if SERVER then
	-- Tells the server to load this file
	AddCSLuaFile( "example.lua" )
end


-- Name
if CLIENT then
	SWEP.PrintName = "Automatic Rifle"
end


-- Shooting
SWEP.Primary.Damage                 = 20
SWEP.Primary.NumShots               = 1
SWEP.Primary.Automatic              = true
	-- Recoil is applied per bullet shot, so fast shooting weapons dont need as much recoil
	-- For easy comparison, you can calculate Recoil * (1 / Delay) to get the approximate recoil per second
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
		-- Type is shown under the weapon name. Common types include "Weapon" and "Passive effect item".
		-- You can add your own category here, but try to avoid every single item you make having its own category
		type = "Weapon",
		desc = "Description.\nNew Line."
	};
	-- The icon thats shown in menus. Has to be a unique name!
	-- Otherwise players might see the wrong icon if theyve used a simmilar addon before
	SWEP.Icon = "VGUI/ttt/icon_myserver_ak47"
end
	-- The server making sure the client actually has the icon
	-- Should point to the same vile in SWEP.Icon
if SERVER then
	resource.AddFile("materials/VGUI/ttt/icon_myserver_ak47.vmt")
end


-- TTT shenanigans
	-- Allows the gun to spawn
	-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can spawn at random weapon spawns
SWEP.AutoSpawnable = true
	-- The number key thats sued to select the weapon, -1   (So slot 0 is accessed by pressing the 1 key)
	-- GMod behaviour. Should line up with SWEP.Kind
if CLIENT then
	SWEP.Slot      = 2
end
	-- Players can only carry a limited amount of weapons per type
	-- TTT behaviour. Should line up with SWEP.Slot
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

-- Just copied from weapon_tttbase.lua, but uses self.CustomZoom instead of 40
-- Can be edited at the top by editing SWEP.CustomZoom
-- The 'or 40' is a fallback in case the variable is ever empty / nil
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

-- Just copied from weapon_tttbase.lua, but uses self.CustomSightsCone instead of 0.8
-- Can be edited at the top by editing SWEP.CustomSightsCone
-- The 'or 0.8' is a fallback in case the variable is ever empty / nil
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