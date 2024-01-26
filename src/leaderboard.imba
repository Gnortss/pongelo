tag leaderboard
	prop players
	prop matches

	def activePlayers
		ret = new Set()
		date_now = Date.now!
		for m in matches
			if date_now - m.created_at < 1209600000 # 2 weeks in ms
				ret.add(m.p1_id)
				ret.add(m.p2_id)
		return ret

	<self>
		css table mx: auto
			th w:150px border-bottom: 1px solid
			td ta:center
			h2 text-align:center

		active = activePlayers!
		if active.size > 0
			<table>
				<tr>
					<th> "Player"
					<th> "Rating"
				for p in players.filter(do(p) active.has(p.id)).sort(do(a,b) b.rating - a.rating)
					<tr @click.ctrl.shift.emit("deletePlayer", p.id)>
						<td> p.name
						<td> Math.round(p.rating)
		else
			<h2> "No active players in last 2 weeks"