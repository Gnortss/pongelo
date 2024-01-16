import {nanoid} from "nanoid"
import {persistData, loadData} from './persist.imba'

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

	def handleSubmit
		emit("addPlayer", name)
		name = ""	

	<self>
		<form @submit.prevent.throttle(1000)=handleSubmit>
			<input type="text" .dstyle placeholder="Player Name" bind=name>
			<button .dstyle type="submit"> "Add Player"

tag app
	players = []
	matches = []

	def rating Ra, Rb, d, K=32
		def prob(r1, r2)
			(1.0 * 1.0) / (1 + 1.0 * Math.pow(10, (1.0 * (r1 - r2)) / 400))

		let Pb = prob(Ra, Rb)
		let Pa = prob(Rb, Ra)

		if d # P1 wins
			Ra = Ra + K * (1 - Pa)
			Rb = Rb + K * (0 - Pb)
		else
			Ra = Ra + K * (0 - Pa)
			Rb = Rb + K * (1 - Pb)
		
		return [Ra, Rb]

	def addPlayer e
		if e.detail === ""
			return
		players.push({name: e.detail, rating: 1000, id: nanoid()})
		console.log(JSON.stringify(players))
		persist!

	def addMatch e
		if e.detail..p1 === undefined or e.detail..p2 === undefined or e.detail.p1 === e.detail.p2
			return

		p1 = players.find(do(el) el.id === e.detail.p1)
		p2 = players.find(do(el) el.id === e.detail.p2)
		
		oldR1 = p1.rating
		oldR2 = p2.rating

		[newR1, newR2] = rating(oldR1, oldR2, false)

		matches.push({p1: e.detail.p1, p2: e.detail.p2, stats: {p1change: oldR1 - newR1, p2change: oldR2 - newR2, winner: p1.id}})
		# update players
		for p in players
			if p.id == p1.id
				p.rating = newR1
			elif p.id == p2.id
				p.rating = newR2
		imba.commit()
		persist!

	def persist
		persistData({players: players, matches: matches})

	def setup
		let data = loadData()
		players = data.players
		matches = data.matches


	<self>
		if players.length > 1
			<match-form [my:10px] players=players @addMatch=addMatch>
		<leaderboard [my:10px] players=players>
		<player-form [my:10px] @addPlayer=addPlayer>

imba.mount <app>
