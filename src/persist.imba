const localStorageKey = 'pongelo-data'

export def persistData data
	localStorage.setItem localStorageKey, JSON.stringify(data)

export def loadData
	const dataString = localStorage.getItem localStorageKey
	if dataString
		try
			JSON.parse(dataString)
		catch
			return {players: [], matches: []}
	else
		return {players: [], matches: []}