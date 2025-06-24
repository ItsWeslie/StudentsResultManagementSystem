<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>

<%
    HttpSession Httpsession = request.getSession(false);
    if (Httpsession != null && "student".equals(Httpsession.getAttribute("userRole"))) {
        response.sendRedirect("studentDash.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="CSS/login.css">
</head>
<body>

<form class="form" id="authForm">
    <p class="title" id="formTitle">Student Login</p>
    <p class="message" id="formMessage">Enter your credentials to access the app.</p>

    <label>
        <input class="input" type="email" name="email" id="email" autocomplete="off" required>
        <span>Email</span>
    </label>

    <label>
        <input class="input" type="password" name="dob" id="dob"
               onpaste="return false;" oncopy="return false;" oncut="return false;"
               autocomplete="off" required>
        <span>Password (DOB - eg : YYYY/MM/DD) </span>
    </label>

    <p id="errorMsg" style="color:red;"></p>

    <button type="submit" class="submit" id="submitButton">Login</button>

</form>

<script>
    document.getElementById("authForm").addEventListener("submit", async function (e) {
        e.preventDefault();

        const email = document.getElementById("email").value.trim();
        const dob = document.getElementById("dob").value.trim();
        const errorMsg = document.getElementById("errorMsg");

        if (!email || !dob) {
            errorMsg.textContent = "Please fill in both Email and Password.";
            return;
        }

        const data = new URLSearchParams();
        data.append("email", email);
        data.append("dob", dob);

        try {
            const response = await fetch("login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: data
            });

            const result = await response.json();

            if (result.status === "success") {
                // Use the redirect from server response
                window.location.href = result.redirect;
            } else {
                errorMsg.textContent = result.message || "Invalid credentials.";
            }
        } catch (error) {
            console.error("Login error:", error);
            errorMsg.textContent = "Something went wrong. Please try again.";
        }
    });

</script>
</body>
</html>
