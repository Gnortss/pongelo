export async function onRequestPost(context) {
    try {
        let payload = await context.request.json();
        console.log(`[player/insert] payload: ${JSON.stringify(payload)}`)
        if (payload.id === undefined || payload.name === undefined || payload.rating === undefined) {
            return new Response("{}");
        }
        const ps = context.env.PONGELO_DB.prepare('INSERT INTO players (id, name, rating) VALUES (?, ?, ?);').bind(payload.id, payload.name, payload.rating);
        const {success} = await ps.run();
        console.log(`[player/insert] ${success}`)
        return new Response("{}");
    } catch (error) {
        console.log(error);
        return new Response("{}");
    }
}