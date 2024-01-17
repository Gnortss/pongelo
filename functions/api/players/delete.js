export async function onRequestPost(context) {
    try {
        let payload = await context.request.json();
        console.log(`[player/delete] payload: ${JSON.stringify(payload)}`)
        if (payload.id === undefined) {
            return new Response("{}");
        }
        const ps = context.env.PONGELO_DB.prepare('DELETE FROM players WHERE id = ?;').bind(payload.id);
        let {success} = await ps.run();
        console.log(`[player/delete] ${success}`)
    } catch (error) {
        console.log(error);
        return new Response("{}");
    }
    return new Response("{}");
}