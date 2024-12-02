document.addEventListener('DOMContentLoaded', function() {
    var today = new Date();
    var hour = today.getHours();
    var greeting;

    if (hour > 18) {
        greeting = "Good Evening!";
    } else if (hour > 12) {
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

    // Update time immediately and set interval to update every second
    updateTime();
    setInterval(updateTime, 1000);

    // Fetch weather data
    function fetchWeather() {
        // Use navigator.geolocation to get user's location
        navigator.geolocation.getCurrentPosition(function(position) {
            //var lat = position.coords.latitude;
            //var lon = position.coords.longitude;
	    var lat = 28.49;
	    var lon = 77.49
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

    fetchWeather();
});

