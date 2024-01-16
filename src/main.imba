import {nanoid} from "nanoid"
import {persistData, loadData} from './persist.imba'
import "./match-form.imba"
import "./leaderboard.imba"
import "./player-form.imba"

global css body p:0 c:warm2 bg:warm8 ff:Arial inset:0 d:vflex mx:auto my: 0

tag app
	players = []
	matches = []

	onLeaderboard = true

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
		persist!

	def addMatch e
		if e.detail..p1 === undefined or e.detail..p2 === undefined or e.detail..winner === undefined or e.detail.p1 === e.detail.p2
			return

		p1 = players.find(do(el) el.id === e.detail.p1)
		p2 = players.find(do(el) el.id === e.detail.p2)
		
		oldR1 = p1.rating
		oldR2 = p2.rating

		[newR1, newR2] = rating(oldR1, oldR2, e.detail.winner === p1.id)

		matches.push({p1: e.detail.p1, p2: e.detail.p2, stats: {p1change: oldR1 - newR1, p2change: oldR2 - newR2, winner: winner}})
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

	css .nav-button w: 50% h: 3em c:warm2 bgc:warm8 @hover:warm7 bd: 0px
	css .wrapper
		width: min(100vw, 600px)
		mx: auto
		# bg: warm6
	css .selected bgc:warm7

	<self>
		<div .wrapper>
			<nav>
				<button .nav-button .selected=onLeaderboard @click=(do() onLeaderboard=true)> "Leaderboard"
				<button .nav-button .selected=!onLeaderboard @click=(do() onLeaderboard=false)> "Settings"
			if onLeaderboard
				<leaderboard [my:10px] players=players visible=onLeaderboard>
			else
				if players.length > 1
					<match-form [my:10px] players=players @addMatch=addMatch>
				<player-form [my:10px] @addPlayer=addPlayer visible=!onLeaderboard>

imba.mount <app>
