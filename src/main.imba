import {nanoid} from "nanoid"
import {persistData, loadData} from './persist.imba'
import {callAPI} from "./api.js"
import "./match-form.imba"
import "./leaderboard.imba"
import "./player-form.imba"

global css body p:0 c:warm2 bg:warm8 ff:Arial inset:0 d:vflex mx:auto my: 0

tag app
	players = []
	matches = []

	onLeaderboard = true

	def rating Ra, Rb, d, K=40
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
		if e.detail.name === undefined or e.detail.rating === undefined or e.detail.name === ""
			return
		let player = {name: e.detail.name, rating: e.detail.rating, id: nanoid()}
		players.push(player)
		callAPI("/api/players/insert", player)
		# persist!

	def addMatch e
		if e.detail..p1 === undefined or e.detail..p2 === undefined or e.detail..winner === undefined or e.detail.p1 === e.detail.p2
			return

		p1 = players.find(do(el) el.id === e.detail.p1)
		p2 = players.find(do(el) el.id === e.detail.p2)
		
		oldR1 = p1.rating
		oldR2 = p2.rating

		[newR1, newR2] = rating(oldR1, oldR2, e.detail.winner === p1.id)

		let match = {id: nanoid(), p1_id: p1.id, p2_id: p2.id, p1_wins: e.detail.winner === p1.id ? 1 : 0, p2_wins: e.detail.winner === p2.id ? 1 : 0, p1_rating_diff: oldR1 - newR1, p2_rating_diff: oldR2 - newR2}
		matches.push(match)
		callAPI("/api/matches/insert", match)
		callAPI("/api/players/update", {id: p1.id, rating: newR1})
		callAPI("/api/players/update", {id: p2.id, rating: newR2})
		# update players
		for p in players
			if p.id == p1.id
				p.rating = newR1
			elif p.id == p2.id
				p.rating = newR2
		imba.commit!
		# persist!

	def deletePlayer e
		if e.detail === undefined
			return
		callAPI("/api/players/delete", {id: e.detail}).then(do()
			players = players.filter(do(el) el.id != e.detail)
			imba.commit!
		)

	def persist
		persistData({players: players, matches: matches})

	def setup
		callAPI("/api/players/get", {}).then do(d) 
			players = d.results
			imba.commit!
		callAPI("/api/matches/get", {}).then do(d) 
			matches = d.results
			imba.commit!

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
				<leaderboard [my:10px] players=players @deletePlayer=deletePlayer visible=onLeaderboard>
			else
				if players.length > 1
					<match-form [my:10px] players=players @addMatch=addMatch>
				<player-form [my:10px] @addPlayer=addPlayer visible=!onLeaderboard>

imba.mount <app>
