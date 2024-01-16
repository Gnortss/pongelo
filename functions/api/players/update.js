export async function onRequestPost(context) {
    try {
        let payload = await context.request.json();
        console.log(`[player/update] payload: ${JSON.stringify(payload)}`)
        if (payload.id === undefined || payload.rating === undefined) {
            return new Response("{}");
        }
        const ps = context.env.PONGELO_DB.prepare('UPDATE players SET rating = ? WHERE id = ?;').bind(payload.rating, payload.id);
        let {success} = await ps.run();
        console.log(`[player/update] ${success}`)
    } catch (error) {
        console.log(error);
        return new Response("{}");
    }
    return new Response("{}");
}