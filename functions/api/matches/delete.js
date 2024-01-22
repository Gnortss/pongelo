export async function onRequestPost(context) {
    try {
        let payload = await context.request.json();
        console.log(`[matches/delete] payload: ${JSON.stringify(payload)}`)
        if (payload.id === undefined) {
            return new Response("{}");
        }
        const ps = context.env.PONGELO_DB.prepare('DELETE FROM matches WHERE id = ?;').bind(payload.id);
        let {success} = await ps.run();
        console.log(`[matches/delete] ${success}`)
    } catch (error) {
        console.log(error);
        return new Response("{}");
    }
    return new Response("{}");
}