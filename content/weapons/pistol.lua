Pistol = {}

function Pistol.new()
	local public = {}
	public = Weapon.new()
	public.magMax = 15
	public.shootTimer = 0.3
	public.mag = public.magMax
	public.resMagsMax = 60
	public.resMags = public.resMagsMax
	public.resMags = 60
	public.dmgMin = 10
	public.dmgMax = 25
	
	
	return public
end