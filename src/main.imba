import {nanoid} from "nanoid"

global css body c:warm2 bg:warm8 ff:Arial inset:0 d:vflex mx:auto
global css .dstyle e:250ms c:white us:none py:3 px:5 rd:4 bg:gray9 mx:5px g:1 bd:1px solid transparent @hover:indigo5


tag match-form
	prop players

	p1 = undefined
	p2 = undefined

	def setup
		if players.length < 2
			return
		p1 = players[0].id
		p2 = players[1].id

	<self>
		<form @submit.prevent.emit("addMatch", {p1: p1, p2: p2})>
			<label> "Player 1"
			<select .dstyle bind=p1> 
				for p in players
					<option value=p.id> p.name
			<label> "Player 2"
			<select .dstyle bind=p2> for p in players
				<option value=p.id> p.name
			<button .dstyle type="submit"> "Add Match"


tag leaderboard
	prop players

	<self>
		for p in players
			<div [d:hflex]>
				<div .dstyle> p.name
				<div .dstyle> p.rating

tag player-form
	prop name = ""
	

	<self>
		<form @submit.prevent.throttle(1000)=emit("addPlayer", name)>
			<input type="text" .dstyle placeholder="Player Name" bind=name>
			<button .dstyle type="submit"> "Add Player"

tag app
	players = [{name: "jure", rating: 1000, id: nanoid()}, {name: "miha", rating: 1000, id: nanoid()}, {name: "matic", rating: 1000, id: nanoid()}]
	matches = []

	def addPlayer e
		if e.detail === ""
			return
		players.push({name: e.detail, rating: 1000, id: nanoid()})
		console.log(JSON.stringify(players))

	def addMatch e
		if e.detail..p1 === undefined or e.detail..p2 === undefined or e.detail.p1 === e.detail.p2
			console.log("ups")
			return
		console.log("added match between {e.detail.p1} and {e.detail.p2}")
		matches.push({p1: e.detail.p1, p2: e.detail.p2})

	<self>
		<match-form [my:10px] players=players @addMatch=addMatch>
		<leaderboard [my:10px] players=players>
		<player-form [my:10px] @addPlayer=addPlayer>

imba.mount <app>
