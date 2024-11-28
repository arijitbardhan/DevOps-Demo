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
});

