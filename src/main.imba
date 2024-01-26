import {nanoid} from "nanoid"
import {callAPI} from "./api.js"
import {rating} from "./utils.imba"
import "./match-form.imba"
import "./leaderboard.imba"
import "./player-form.imba"
import "./match-history.imba"
import "./match-modal.imba"

global css body p:0 c:warm2 bg:warm8 ff:Arial inset:0 d:vflex mx:auto my: 0

tag app
	players = []
	matches = []

	onLeaderboard = true

	def addPlayer e
		if e.detail.name === undefined or e.detail.rating === undefined or e.detail.name === ""
			return
		let player = {name: e.detail.name, rating: e.detail.rating, id: nanoid()}
		players.push(player)
		callAPI("/api/players/insert", player)

	def addMatch e
		if e.detail..p1 === undefined or e.detail..p2 === undefined or e.detail..p1_wins === undefined or e.detail..p2_wins === undefined or e.detail.p1 === e.detail.p2 or e.detail.p1_wins === e.detail.p2_wins
			return

		callAPI("/api/players/get", {}).then( do(d) 
			players = d.results

			p1 = players.find(do(el) el.id === e.detail.p1)
			p2 = players.find(do(el) el.id === e.detail.p2)

			oldR1 = p1.rating
			oldR2 = p2.rating

			p1_wins = e.detail.p1_wins
			p2_wins = e.detail.p2_wins

			[newR1, newR2] = rating(oldR1, oldR2, p1_wins > p2_wins)

			let match = {
				id: nanoid()
				p1_id: p1.id
				p2_id: p2.id
				p1_wins: p1_wins
				p2_wins: p2_wins
				p1_rating_diff: newR1 - oldR1
				p2_rating_diff: newR2 - oldR2
				created_at: Date.now!
			}

			matches.push(match)
			callAPI("/api/matches/insert", match).then(do()
				emit("matchAdded", {p1_rating: newR1, p2_rating: newR2, p1_rating_diff: newR1 - oldR1, p2_rating_diff: newR2 - oldR2})
			)
			
			callAPI("/api/players/update", {id: p1.id, rating: newR1})
			callAPI("/api/players/update", {id: p2.id, rating: newR2})
			# update players
			for p in players
				if p.id == p1.id
					p.rating = newR1
				elif p.id == p2.id
					p.rating = newR2
			imba.commit!
		)

	def deletePlayer e
		if e.detail === undefined
			return
		callAPI("/api/players/delete", {id: e.detail}).then(do()
			players = players.filter(do(el) el.id != e.detail)
			imba.commit!
		)

	def revertMatch e
		def getPlayer id
			for p in players
				if p.id === id
					return p
			return null

		match_to_delete = undefined
		for m in matches
			if m.id === e.detail
				match_to_delete = m
		if match_to_delete === undefined
			return
		p1 = getPlayer match_to_delete.p1_id
		p2 = getPlayer match_to_delete.p2_id
		if p1 != undefined
			callAPI("/api/players/update", {id: p1.id, rating: p1.rating - match_to_delete.p1_rating_diff})
		if p2 != undefined
			callAPI("/api/players/update", {id: p2.id, rating: p2.rating - match_to_delete.p2_rating_diff})
		callAPI("/api/matches/delete", {id: e.detail}).then(do() 
			refresh!
		)

	def refresh
		callAPI("/api/players/get", {}).then do(d) 
			players = d.results
			imba.commit!
		callAPI("/api/matches/get", {}).then do(d) 
			matches = d.results
			imba.commit!

	def setup
		refresh!

	css .nav-button w: 50% h: 3em c:warm2 bgc:warm8 @hover:warm7 bd: 0px
	css .wrapper
		width: min(100vw, 600px)
		mx: auto
	css .selected bgc:warm7

	<self>
		<div .wrapper>
			<div route='/antikun'>
				<player-form [my:10px] @addPlayer=addPlayer>
			<div route='/*'>
				<nav>
					<button route-to='/leaderboard' .nav-button .selected=onLeaderboard @click=(do() onLeaderboard=true)> "Leaderboard"
					<button route-to='/settings' .nav-button .selected=!onLeaderboard @click=(do() onLeaderboard=false)> "Settings"
				<div route='/settings'>
					if players.length > 1
						<match-form [my:10px] players=players @addMatch=addMatch>
				<div route='/*'>
					if players.length > 0
						<leaderboard [my:10px] matches=matches players=players @deletePlayer=deletePlayer>
					if matches.length > 0
						<match-history matches=matches players=players @revertMatch=revertMatch>

imba.mount <app>
