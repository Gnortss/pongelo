tag match-form
	prop players

	p1 = undefined
	p2 = undefined
	winner = undefined

	def setup
		if players.length < 2
			return
		p1 = players[0].id
		p2 = players[1].id
		winner = p1

	css m: 1em
	css form d:vflex ja:stretch mx:1em

	<self>
		<h2> "Insert match:"
		<form @submit.prevent.throttle(1000).emit("addMatch", {p1: p1, p2: p2, winner: winner})>
			css row pb: .5em
				label mr:.5em
				select height: 2em bg:warm8 c:warm2 w:auto
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
				<label> "Winner"
				<select bind=winner> for p in players.filter(do(el) el.id === p1 or el.id === p2)
					<option value=p.id> p.name
			<row>
				<button type="submit"> "Add Match"