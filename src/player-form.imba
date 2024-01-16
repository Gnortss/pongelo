tag player-form
	name = ""
	rating = 1200

	def handleSubmit
		emit("addPlayer", {name: name, rating: rating})
		name = ""
		rating = 1200	

	css m:1em
	css form d:vflex ja:stretch mx:1em

	<self>
		<h2> "Insert player:"
		<form @submit.prevent.throttle(1000)=handleSubmit>
			css row pb:.5em
				input bg:warm8 c:warm2 py:.5em bd:1px solid transparent mr:1em
				button bg: warm8 c:warm2 bd:1px solid warm5 @hover:warm4 py:.5em
			<row>
				<input type="text" placeholder="Player Name" bind=name>
				<input type="number" placeholder="Rating" min=700 max=1800 bind=rating>
				<button type="submit"> "Add Player"