async function updateVisitorCount() {
    try {
        const response = await fetch('https://myfunctionapp.azurewebsites.net/api/VisitorTrigger');
        const count = await response.text();
        document.getElementById('visitor-count').innerText = count;
    } catch (error) {
        console.error('Error fetching visitor count:', error);
    }
}

updateVisitorCount();