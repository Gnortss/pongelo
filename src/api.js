export async function callAPI(method, payload) {
    try {
        let p = JSON.stringify(payload);
        const response = await fetch(method, {
            method: "POST",
            headers: {
            'Content-Type': 'application/json'
            },
            body: p
        });
        if (!response.ok) {
            alert(await response.json());
            return;
        }
        return response.json();
    } catch(e) {
        console.log("tukaj bi moral klicati API: "+method);
        console.log(e);
        return null;
    }
}