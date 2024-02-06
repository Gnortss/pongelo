import {getColor, formatRating as fr} from "./utils.imba"

tag match-modal
	prop state
	prop data

	css .modal d:block position:fixed z-index:1 pt:100px left:0 top:0 w:100vw h:100vh overflow:auto bgc:rgba(0,0,0,0.4)
		.modal-content bgc:warm7 m:auto width:300px d:vflex
		.match my:.5em bgc: warm7 width:auto
		.item mx:.25em my:.25em p:.25em
		row d:hflex ja:center py:.25em

	<self>
		<div .modal>
			<div .modal-content>
				<div .match>
					css h3 my: 0
						p my: 0
					css	span
						&.green color: green4
						&.red color: red4
					<row [d:hflex jc: space-between  align-items: center]>
						<div .item [text-align: right flex-grow: 1 flex-basis: 0]>
							<h3> data..p1..name
							if state === "done"
								<div [font-size: .75em]>
									<span> "{fr(data..p1_rating)}("
									<span .{getColor(data..p1_rating_diff)}> fr(data..p1_rating_diff)
									<span> ")"
						<h3 .item [w: 50px ta: center]> "{data..p1_wins} : {data..p2_wins}"
						<div .item [flex-grow: 1 flex-basis: 0]>	
							<h3> data..p2..name
							if state === "done"
								<div [font-size: .75em]>
									<span> "("
									<span .{getColor(data..p2_rating_diff)}> fr(data..p2_rating_diff)
									<span> "){fr(data..p2_rating)}"
				<row>
					css button mx:.25em bg: warm8 c:warm2 bd: 1px solid warm5 @hover: warm4 py:.5em
					if state === "done"
						<button @click.emit("closeModal")> "Close"
					else
						<button @click.throttle(1000).emit("addMatch")> "Confirm"
						<button @click.emit("closeModal")> "Cancel"