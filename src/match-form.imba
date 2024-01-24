tag match-form
	prop players

	p1 = undefined
	p2 = undefined
	p1_wins = 1
	p2_wins = 0

	modal_open = false
	adding_match = false
	match_added = false
	match_details = {p1_rating: 0, p2_rating: 0, p1_rating_diff: 0, p2_rating_diff: 0}

	def presentModal
		modal_open = true

	def closeModal
		modal_open = false
		modal_open = false
		adding_match = false
		match_added = false
		match_details = {p1_rating: 0, p2_rating: 0, p1_rating_diff: 0, p2_rating_diff: 0}

	def addMatch
		adding_match = true
		emit("addMatch", {p1: p1, p2: p2, p1_wins: p1_wins, p2_wins: p2_wins})

	def matchAdded e
		adding_match = false
		match_details = e.detail
		console.log(match_details)
		match_added = true

	def fr rating
		Math.round(rating)

	def getColor rating
		if rating > 0 then "green" else "red"

	def setup
		if players.length < 2
			return
		p1 = players[0].id
		p2 = players[1].id

	css m: 1em
	css form d:vflex ja:stretch mx:1em
	css .modal-open d:fixed

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
		<div [d:none position:fixed z-index:1 pt:100px left:0 top:0 w:100vw h:100vh overflow:auto bgc:rgba(0,0,0,0.4)] [d:block]=modal_open .modal>
			<div [bgc:warm7 m:auto width:250px d:vflex] .modal-content>
				css .match d:hflex ja:center my:.5em bgc: warm7 width:auto
					.item mx:.25em my:.25em p:.25em
				<div .match>
					css h3 my: 0
					css p my: 0
					css span
						&.green color: green4
						&.red color: red4
					<div .item [text-align: right]>
						<h3> players.filter(do(el) el.id === p1)[0].name
						if match_added
							<div [font-size: .75em]>
								<span> "{fr(match_details.p1_rating)}("
								<span .{getColor(match_details.p1_rating_diff)}> fr(match_details.p1_rating_diff)
								<span> ")"
					<h3 .item> "{p1_wins} : {p2_wins}"
					<div .item>	
						<h3> players.filter(do(el) el.id === p2)[0].name
						if match_added
							<div [font-size: .75em]>
								<span> "("
								<span .{getColor(match_details.p2_rating_diff)}> fr(match_details.p2_rating_diff)
								<span> "){fr(match_details.p2_rating)}"
				<row [d:hflex ja:center py:.25em]>
					css button mx:.25em bg: warm8 c:warm2 bd: 1px solid warm5 @hover: warm4 py:.5em
					unless adding_match or match_added
						<button @click.throttle(1000)=addMatch!> "Confirm"
						<button @click=closeModal!> "Cancel"
					elif match_added
						<button @click=closeModal!> "Close"
