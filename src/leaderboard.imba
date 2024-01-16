tag leaderboard
	prop players

	def handleDelete id
		emit("deletePlayer", id)

	<self>
		css table
			th w:150px border-bottom: 1px solid
			td ta:center
		<table [mx:auto]>
			<tr>
				<th> "Player"
				<th> "Rating"
			for p in players.sort(do(a,b) b.rating - a.rating)
				<tr @click.ctrl.shift=handleDelete(p.id)>
					<td> p.name
					<td> Math.floor(p.rating)