tag player
	prop players
	prop matches

	def getPlayer pid
		for p in players
			if p.id == pid
				return p
		return undefined

	def playerMatches pid
		let ret = []
		for m in matches
			if m.p1_id == pid or m.p2_id == pid
				ret.push(m)
		return ret

	def basicStats p
		let has_won = do(m, pid) 
			return m.p1_wins > m.p2_wins ? m.p1_id == pid : m.p2_id == pid
		let ret = {}
		const player_matches = playerMatches(p.id)
		let wins = 0
		let rating_calc = p.rating
		let highest_rating = rating_calc
		let lowest_rating = rating_calc
		for m in player_matches.sort(do(a,b) b.created_at - a.created_at) # most recent to oldest
			if has_won(m, p.id)
				wins += 1
			rating_calc -= m.p1_id == p.id ? m.p1_rating_diff : m.p2_rating_diff
			if rating_calc > highest_rating
				highest_rating = rating_calc
			elif rating_calc < lowest_rating
				lowest_rating = rating_calc
		ret["WIN%"] = Math.round((((wins/player_matches.length) * 100) + Number.EPSILON) * 100) / 100
		ret["#GAMES"] = player_matches.length
		ret["HIGH"] = Math.round(highest_rating + Number.EPSILON)
		ret["CUR"] = Math.round(p.rating + Number.EPSILON)
		ret["LOW"] = Math.round(lowest_rating + Number.EPSILON)
		return ret


	<self>
		let player = getPlayer(route.params.id)
		if player != undefined
			# route.params.idx
			<h2 [mx:8px]> player.name
			<div [h:100px w:inherit mx:8px d:flex justify-content:space-between]>
				for own k, v of basicStats(player)
					<div [pr:.5em pr@last:0]>
						<h2 [mt: 1em mb: 0.1em]> v
						<p [mb: 1em mt: 0.1em font-size: 0.75em color: warm4]> k
			<match-history players=players matches=playerMatches(player.id)>
