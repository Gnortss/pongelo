export def rating Ra, Rb, d, K=40
	def prob(r1, r2)
		(1.0 * 1.0) / (1 + 1.0 * Math.pow(10, (1.0 * (r1 - r2)) / 400))

	let Pb = prob(Ra, Rb)
	let Pa = prob(Rb, Ra)

	if d # P1 wins
		Ra = Ra + K * (1 - Pa)
		Rb = Rb + K * (0 - Pb)
	else
		Ra = Ra + K * (0 - Pa)
		Rb = Rb + K * (1 - Pb)
	
	return [Ra, Rb]

export def getPlayer arr, id
	for p in arr
		if p.id === id
			return p
	return null

export def formatRating r
	return Math.round(r + Number.EPSILON)

export def getColor r
	if r > 0 then "green" else "red"
