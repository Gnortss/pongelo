tag player-form
	prop name = ""

	def handleSubmit
		emit("addPlayer", name)
		name = ""	

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
				<button type="submit"> "Add Player"