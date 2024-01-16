export async function onRequestPost(context) {
    const ps = context.env.PONGELO_DB.prepare('SELECT * from players');
    const data = await ps.all();

    return Response.json(data);
}