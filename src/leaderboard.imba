tag leaderboard
	prop players
	prop matches

	def activePlayers
		ret = new Set()
		date_now = Date.now!
		for m in matches
			if date_now - m.created_at < 1209600000 * 2 # 4 weeks in ms
				ret.add(m.p1_id)
				ret.add(m.p2_id)
		return ret

	def getRecentMatchesForPlayer pid
		ret = []
		for m in matches
			if m.p1_id == pid or m.p2_id == pid
				ret.push(m)
		return ret.sort(do(a,b) b.created_at - a.created_at).slice(0, 5)

	def recentMatchesToString pid
		let l = getRecentMatchesForPlayer(pid)
		let s = ""
		for m in l
			if m.p1_wins == m.p2_wins
				s += "D"
			else
				w_id = m.p1_wins > m.p2_wins ? m.p1_id : m.p2_id
				s += (w_id == pid ? "W" : "L")
		return s

	<self>
		css table mx: auto
			th w:100px border-bottom: 1px solid
			h2 text-align:center
		css div ta:center d:inline-block w:1.2em h:1.2em rd:0.6em mx:.05em c:black
			&.W bgc: green4
			&.L bgc: red4

		active = activePlayers!
		if active.size > 0
			<table>
				<tr>
					<th [ta: left]> "Player"
					<th [ta: right]> "Rating"
					<th [w:150px]>
				for p in players.filter(do(p) active.has(p.id)).sort(do(a,b) b.rating - a.rating)
					<tr @click.ctrl.shift.emit("deletePlayer", p.id)>
						<td [ta: left]> p.name
						<td [ta: right]> Math.round(p.rating)
						<td [ta: left]> for c in recentMatchesToString(p.id)
							<div .{c}> c
		else
			<h2> "No active players in last 4 weeks"