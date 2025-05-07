<%--
  Created by IntelliJ IDEA.
  User: 91763
  Date: 28-04-2025
  Time: 20:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="CSS/login.css">
</head>
<body>

<!-- Form posts directly to Servlet URL -->
<form class="form" id="signupForm" action="${pageContext.request.contextPath}/signup" method="post">
    <p class="title">Register</p>
    <p class="message">Signup now and get full access to our app.</p>

    <!-- Name Field -->
    <div class="flex">
        <label>
            <input class="input" type="text" name="name" placeholder="" required>
            <span>Name</span>
        </label>
    </div>

    <!-- Email Field -->
    <label>
        <input class="input" type="email" name="email" placeholder="" required>
        <span>Email</span>
    </label>

    <!-- Password Field -->
    <label>
        <input class="input" type="password" name="password" placeholder="" required>
        <span>Password</span>
    </label>

    <!-- Confirm Password Field -->
    <label>
        <input class="input" type="password" name="confirmPassword" placeholder="" required>
        <span>Confirm Password</span>
    </label>

    <!-- Role Selection -->
    <label>
        <select class="input" name="role" required>
            <option value="" disabled selected></option>
            <option value="admin">Admin</option>
            <option value="student">Student</option>
        </select>
        <span>Role</span>
    </label>

    <!-- Submit Button -->
    <button type="submit" class="submit">Register</button>

    <p class="signin">
        <span id="toggleText">Already having an account?</span>
        <a href="login.jsp" id="toggleLink">Login</a>
    </p>
</form>

<script>
    const signupForm = document.getElementById("signupForm");

    signupForm.addEventListener("submit", function (e) {
        const password = signupForm.querySelector('input[name="password"]').value.trim();
        const confirmPassword = signupForm.querySelector('input[name="confirmPassword"]').value.trim();

        if (password !== confirmPassword) {
            e.preventDefault(); // stop the form from submitting
            alert("Passwords do not match!");
        }
    });
</script>

</body>
</html>
