Weapon = {}

function Weapon.new()
	local private = {}
	local public = {}
	public.magMax = 0
	public.shootTimer = 999
	public.mag = public.magMax
	public.resMags =0
	public.reloadTmr = 0
	public.reloadTmrmax = 1
	public.reloading = 0
	public.dmgMin = 10
	public.dmgMax = 25
	public.spray = 5
	
	function public.reload(dt)
		public.reloadTmr = public.reloadTmr + dt
		if public.reloadTmr > public.reloadTmrmax then
			local valrel = (public.magMax-public.mag)
			public.resMags = public.resMags - valrel
			if public.resMags < 0 then
				valrel = valrel+public.resMags
				public.resMags = 0
			end
			public.mag = public.mag+valrel
			public.reloading = 0
			public.reloadTmr = 0
		end
	end
	
	return public
end