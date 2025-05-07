<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Portal</title>
    <link rel="stylesheet" href="CSS/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<header class="header">
    <div class="container">
        <h1 class="logo">Student Portal</h1>
        <nav class="nav">
            <a href="#">Home</a>
            <a href="#features">Features</a>
            <a href="#about">About</a>
            <a href="#contact">Contact</a>
        </nav>
    </div>
</header>

<section class="hero">
    <div class="container">
        <h2>Welcome to the Student Portal</h2>
        <p>Effortlessly manage your academic records, access your results, and stay updated with all the latest.</p>
        <div class="hero-buttons">
            <a href="login.jsp" class="btn primary">Login</a>
            <a href="#features" class="btn secondary">Learn More</a>
        </div>
    </div>
</section>

<section id="features" class="features">
    <div class="container">
        <h2 class="section-title">Features</h2>
        <div class="feature-cards">
            <div class="feature-card">
                <i class="fas fa-user-graduate"></i>
                <h3>View Results</h3>
                <p>Access your academic results in one click with detailed performance insights.</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-file-alt"></i>
                <h3>Manage Profile</h3>
                <p>Update your personal details and stay organized throughout your academic journey.</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-bell"></i>
                <h3>Get Notifications</h3>
                <p>Stay informed about exam schedules, new results, and important announcements.</p>
            </div>
        </div>
    </div>
</section>

<section id="about-us" class="container">
    <h2 class="section-title">About Us</h2>
    <p class="section-description">
        Welcome to the Student Portal! Our platform is designed to streamline academic management and enhance the student experience. We provide easy access to academic records, results, and notifications, ensuring that students stay informed and organized throughout their academic journey.
    </p>
</section>

<section id="contact" class="contact">
    <div class="container">
        <h2 class="section-title">Contact Us</h2>
        <form class="contact-form">
            <label for="name">Name</label>
            <input type="text" id="name" placeholder="Enter your name" required>

            <label for="email">Email</label>
            <input type="email" id="email" placeholder="Enter your email" required>

            <label for="message">Message</label>
            <textarea id="message" placeholder="Your message..." rows="5" required></textarea>

            <button type="submit" class="btn primary">Send Message</button>
        </form>
    </div>
</section>

<footer class="footer">
    <div class="container">
        <p>&copy; 2025 Student Portal. All rights reserved.</p>
    </div>
</footer>

<script>

</script>

</body>
</html>
