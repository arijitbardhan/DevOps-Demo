document.addEventListener('DOMContentLoaded', function() {
    var today = new Date();
    var hour = today.getHours();
    var greeting;

    if (hour >= 18) {
        greeting = "Good Evening!";
    } else if (hour >= 12) {
        greeting = "Good Afternoon!";
    } else {
        greeting = "Good Morning!";
    }

    document.getElementById('greeting').textContent = greeting;

    // Function to update time every second
    function updateTime() {
        var now = new Date();
        var timeString = now.toLocaleTimeString();
        var timeZoneString = Intl.DateTimeFormat().resolvedOptions().timeZone;

        document.getElementById('time').textContent = timeString;
        document.getElementById('timezone').textContent = timeZoneString;
    }

    // Fetch weather data
    function fetchWeather() {
        // Use navigator.geolocation to get user's location
        navigator.geolocation.getCurrentPosition(function(position) {
            var lat = position.coords.latitude;
            var lon = position.coords.longitude;
            var apiKey = 'b94bc5901312bf5ad4dbeed09ce9cb8b';
            var weatherUrl = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}&units=metric`;

            fetch(weatherUrl)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('location').textContent = `Location: ${data.name}`;
                    document.getElementById('temperature').textContent = `Temperature: ${data.main.temp} °C`;
                })
                .catch(error => console.error('Error fetching weather data:', error));
        });
    }

    navigator.geolocation.getCurrentPosition(function(position) {
        const latitude = position.coords.latitude;
        const longitude = position.coords.longitude;
    
        fetchNearestPlaces(latitude, longitude);
    });

    function fetchNearestPlaces(lat, lon) {
        // Example using Google Places API (you need to replace 'YOUR_API_KEY' with your actual Google API key)
        var YOUR_API_KEY = 'AIzaSyB685j0ggI7R-1pRn7UdOLc9JpRJjMuvBw';
        const placesUrl = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat},${lon}&radius=10000&type=airport&key=${YOUR_API_KEY}`;
    
        fetch(placesUrl)
            .then(response => response.json())
            .then(data => {
                const airportName = data.results[0]?.name ?? 'Not found';
                document.getElementById('airport-name').textContent = airportName;
            });
    
        // Repeat for railway station with type=transit_station
        const stationUrl = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat},${lon}&radius=10000&type=train_station&key=${YOUR_API_KEY}`;
    
        fetch(stationUrl)
            .then(response => response.json())
            .then(data => {
                const stationName = data.results[0]?.name ?? 'Not found';
                document.getElementById('station-name').textContent = stationName;
            });
    }

    // Update time immediately and set interval to update every second
    updateTime();
    setInterval(updateTime, 1000);
    // Get current temperature
    fetchWeather();

});

