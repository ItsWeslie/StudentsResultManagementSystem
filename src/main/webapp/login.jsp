<%--
  Created by IntelliJ IDEA.
  User: 91763
  Date: 28-04-2025
  Time: 17:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="CSS/login.css">
</head>
<body>

<form class="form" id="authForm" action="${pageContext.request.contextPath}/login" method="post">
    <p class="title" id="formTitle">Login</p>
    <p class="message" id="formMessage">Enter your credentials to access the app.</p>

    <label>
        <input class="input" type="email" name="email" id="email" placeholder="" required>
        <span>Email</span>
    </label>

    <label>
        <input class="input" type="password" name="password" id="password" placeholder="" required>
        <span>Password</span>
    </label>

    <button type="submit" class="submit" id="submitButton">Login</button>

    <p class="signin">
        <span id="toggleText">Don't have an account?</span>
        <a href="signup.jsp" id="toggleLink">Sign Up</a>
    </p>
</form>

<script>
    const authForm = document.getElementById("authForm");

    authForm.addEventListener("submit", function (e) {
        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();

        // Basic client-side validation
        if (!email || !password) {
            e.preventDefault();
            alert("Please fill in both Email and Password.");
            return;
        }
    });
</script>

</body>
</html>
