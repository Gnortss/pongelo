import {getPlayer, formatRating as fr} from "./utils.imba"

tag match-form
	prop players

	p1 = undefined
	p2 = undefined
	p1_wins = 1
	p2_wins = 0

	state = ""
	match_details = undefined

	def presentModal
		match_details = {
			p1: getPlayer(players, p1), p2: getPlayer(players, p2),
			p1_wins: p1_wins, 			p2_wins: p2_wins,
			p1_rating: 0,				p2_rating: 0,
			p1_rating_diff: 0,			p2_rating_diff: 0
		}
		state = "open"

	def closeModal
		state = ""
		match_details = undefined

	def addMatch
		state = "adding"
		emit("addMatch", {p1: p1, p2: p2, p1_wins: p1_wins, p2_wins: p2_wins})

	def matchAdded e
		match_data = e.detail
		match_details = {
			p1: match_details..p1,						p2: match_details..p2,
			p1_wins: p1_wins, 							p2_wins: p2_wins,
			p1_rating: match_data..p1_rating,			p2_rating: match_data..p2_rating,
			p1_rating_diff: match_data..p1_rating_diff,	p2_rating_diff: match_data..p2_rating_diff
		}
		state = "done"

	def setup
		if players.length < 2
			return
		p1 = players[0].id
		p2 = players[1].id

	css m: 1em
	css form d:vflex ja:stretch mx:1em

	<self>
		<global @matchAdded=matchAdded>
		<h2> "Insert match:"
		<form @submit.prevent.throttle(1000)=presentModal!>
			css row pb: .5em
				label mr:.5em
				select height: 2em bg:warm8 c:warm2 w:auto
				input bg:warm8 c:warm2 w:2em ta:center
				button bg: warm8 c:warm2 bd: 1px solid warm5 @hover: warm4 py:.5em
			<row>
				<label> "Player 1"
				<select bind=p1> 
					for p in players
						<option value=p.id> p.name
			<row>
				<label> "Player 2"
				<select bind=p2> for p in players
					<option value=p.id> p.name
			<row>
				<label> "{players.filter(do(el) el.id === p1)[0].name} wins:"
				<input type=number bind=p1_wins min=0>
			<row>
				<label> "{players.filter(do(el) el.id === p2)[0].name} wins:"
				<input type=number bind=p2_wins min=0>
			<row>
				<button type="submit"> "Add Match Results"
		if state !== ""
			<match-modal state=state data=match_details @addMatch=addMatch! @closeModal=closeModal!>
