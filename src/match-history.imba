import {getPlayer, getColor, formatRating as fr} from "./utils.imba"

tag match-history
	prop players
	prop matches

	playersdc = []

	def recentMatches
		return matches.sort(do(a,b) b.created_at - a.created_at).slice(0, 10)

	css .match d:hflex ja:center my:.5em bgc: warm7 width:auto
		.item mx:.25em my:.25em p:.25em

	<self>
		<h2 [text-align: center mt:2em]> "History"
		<div>
			playersdc = JSON.parse(JSON.stringify(players))
			for m in recentMatches!
				p1 = getPlayer(playersdc, m.p1_id)
				p2 = getPlayer(playersdc, m.p2_id)

				if p1 === null or p2 === null
					continue

				<div .match @click.ctrl.shift=emit('revertMatch', m.id)>
					css h3 my: 0
						p my: 0
					css span
						&.green color: green4
						&.red color: red4
					<div .item [text-align: right]>
						<h3> p1.name
						<div [font-size: .75em]>
							<span> "{fr(p1.rating)}("
							<span .{getColor(m.p1_rating_diff)}> fr(m.p1_rating_diff)
							<span> ")"
					<h3 .item> "{m.p1_wins} : {m.p2_wins}"
					<div .item>	
						<h3> p2.name
						<div [font-size: .75em]>
							<span> "("
							<span .{getColor(m.p2_rating_diff)}> fr(m.p2_rating_diff)
							<span> "){fr(p2.rating)}"

				p1.rating = p1.rating - m.p1_rating_diff
				p2.rating = p2.rating - m.p2_rating_diff
			