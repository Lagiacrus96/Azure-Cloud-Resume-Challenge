async function updateVisitorCount() {
    try {
        const response = await fetch('https://websitefunctionapp-meinemawebsite.azurewebsites.net/api/VisitorTrigger');
        const count = await response.text();
        document.getElementById('visitor-count').innerText = count;
    } catch (error) {
        console.error('Error fetching visitor count:', error);
    }
}

updateVisitorCount();