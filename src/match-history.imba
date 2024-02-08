import {getPlayer, getColor, formatRating as fr} from "./utils.imba"
import RelativeTime from '@yaireo/relative-time'

tag match-history
	prop players
	prop matches

	relativeTime = undefined
	playersdc = []

	def recentMatches
		return matches.sort(do(a,b) b.created_at - a.created_at).slice(0, 25)

	def setup
		relativeTime = new RelativeTime();

	css .match bgc: warm7 width:auto
		.item my:.25em p:.25em

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
					<row>
						<p .item [font-size: .5em c: warm5 text-align: center m: 0]> "{relativeTime.from(new Date(m.created_at))}"
					<row [d:flex jc:space-between align-items: center mb:.5em mt: -.5em]>
						<div .item [text-align: right flex-grow: 1 flex-basis: 0]>
							<h3> p1.name
							<div [font-size: .75em]>
								<span> "{fr(p1.rating)}("
								<span .{getColor(m.p1_rating_diff)}> fr(m.p1_rating_diff)
								<span> ")"
						<h3 .item [w: 50px ta: center]> "{m.p1_wins} : {m.p2_wins}"
						<div .item [flex-grow: 1 flex-basis: 0]>	
							<h3> p2.name
							<div [font-size: .75em]>
								<span> "("
								<span .{getColor(m.p2_rating_diff)}> fr(m.p2_rating_diff)
								<span> "){fr(p2.rating)}"

				p1.rating = p1.rating - m.p1_rating_diff
				p2.rating = p2.rating - m.p2_rating_diff
			