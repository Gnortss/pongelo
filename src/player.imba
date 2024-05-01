import RelativeTime from '@yaireo/relative-time'

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

	def hasWon m, pid
		return m.p1_wins > m.p2_wins ? m.p1_id == pid : m.p2_id == pid

	def basicStats p
		let ret = {}
		const player_matches = playerMatches(p.id)
		let wins = 0
		let rating_calc = p.rating
		let highest_rating = rating_calc
		let lowest_rating = rating_calc
		for m in player_matches.sort(do(a,b) b.created_at - a.created_at) # most recent to oldest
			if hasWon(m, p.id)
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

	def mostFrequentOpponentStats pid
		let opp_map = new Map()
		let player_matches = playerMatches(pid)
		for m in player_matches
			if m.p1_id != pid
				opp_map.set(m.p1_id, opp_map.has(m.p1_id) ? opp_map.get(m.p1_id) + 1 : 1)
			elif m.p2_id != pid
				opp_map.set(m.p2_id, opp_map.has(m.p2_id) ? opp_map.get(m.p2_id) + 1 : 1)
		let most_freq_opp_id = undefined
		for [k, v] of opp_map
			if getPlayer(k) == undefined
				continue
			if most_freq_opp_id == undefined
				most_freq_opp_id = k
			elif opp_map.get(most_freq_opp_id) < v
				most_freq_opp_id = k
		let most_freq_opp = getPlayer(most_freq_opp_id)
		let common_matches = player_matches.filter(do(m) (m.p1_id == pid and m.p2_id == most_freq_opp_id) or (m.p2_id == pid and m.p1_id == most_freq_opp_id))
		let ret = {
			"NAME": most_freq_opp.name,
			}
		let wins = 0
		let last_timestamp = 0
		for m in common_matches
			if hasWon(m, pid)
				wins += 1
			if m.created_at > last_timestamp
				last_timestamp = m.created_at
		ret["WIN%"] = Math.round((((wins/common_matches.length) * 100) + Number.EPSILON) * 100) / 100
		ret["#GAMES"] = common_matches.length
		ret["LAST GAME"] = "{relativeTime.from(new Date(last_timestamp))}"
		return ret

	def setup
		relativeTime = new RelativeTime();

	<self>
		let player = getPlayer(route.params.id)
		# let freq_opp_stats = mostFrequentOpponentStats(player.id)
		if player != undefined
			# route.params.idx
			<h2 [mx:8px]> player.name
			# -- basic stats --
			<h3 [mx:8px mt:1em mb:0 color:warm4]> "Player stats"
			<div [w:inherit mx:8px d:flex justify-content:space-between align-items: flex-end]>
				for own k, v of basicStats(player)
					<div [pr:.5em pr@last:0]>
						<h2 [mt: .5em mb: 0.1em]> v
						<p [mb: 1em mt: 0.1em font-size: 0.75em color: warm4]> k
			# -- most frequest opponent --
			<h3 [mx:8px mt:1em mb:0 color:warm4]> "Most frequent opponent"
			<div [w:inherit mx:8px d:flex justify-content:space-between align-items: flex-end]>
				for own k, v of mostFrequentOpponentStats(player.id)
					<div [pr:.5em pr@last:0]>
						<h2 [mt: .5em mb: 0.1em]> v
						<p [mb: 1em mt: 0.1em font-size: 0.75em color: warm4]> k
			# -- match history --
			<match-history players=players matches=playerMatches(player.id)>
