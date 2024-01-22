export async function onRequestPost(context) {
    try {
        let payload = await context.request.json();
        console.log(`[matches/insert] payload: ${JSON.stringify(payload)}`)
        if (payload.id === undefined || payload.p1_id === undefined || payload.p2_id === undefined || payload.p1_wins === undefined || payload.p2_wins === undefined || payload.p1_rating_diff === undefined || payload.p2_rating_diff === undefined || payload.created_at === undefined) {
            return new Response("{}");
        }
        const ps = context.env.PONGELO_DB.prepare(`INSERT INTO matches (id, p1_id, p2_id, p1_wins, p2_wins, p1_rating_diff, p2_rating_diff, created_at) VALUES ("${payload.id}", "${payload.p1_id}","${payload.p2_id}", ${payload.p1_wins}, ${payload.p2_wins}, ${payload.p1_rating_diff}, ${payload.p2_rating_diff}, ${payload.created_at});`);
        // ps.bind(payload.id, payload.p1_id, payload.p2_id, payload.p1_wins, payload.p2_wins, payload.p1_rating_diff, payload.p2_rating_diff);
        let {success} = await ps.run();
        console.log(`[matches/insert] ${success}`)
        return new Response("{}");
    } catch (error) {
        console.log(error);
        return new Response("{}");
    }
}