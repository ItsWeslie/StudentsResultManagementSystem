<%@ page import="java.util.List" %>
<%@ page import="com.studentsresultmanagement.studentsresultmanagement.Student" %>
<%@ page import="com.studentsresultmanagement.studentsresultmanagement.Results" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    HttpSession Httpsession = request.getSession(false);
    if (session == null || !"staff".equals(Httpsession.getAttribute("userRole"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<meta charset="UTF-8">
<title>Student Results Management Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="CSS/AdminDashCSS.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>
<body>
<div class="sidebar">
    <h2>Admin Dashboard</h2>

    <h2>Welcome, Admin: <%= session.getAttribute("userName") %></h2>
    <ul>
        <li class="nav-item active" data-target="dashboard">Overall View</li>
        <li class="nav-item" data-target="student-form">Add Student</li>
        <li class="nav-item" data-target="results-form">Add Results</li>
        <li class="nav-item" data-target="records">View Student Details</li>
        <li class="nav-item" data-target="results">View Result</li>
        <li class="nav-item logout-btn"><a href="logout">Logout</a></li>
    </ul>
</div>

<div class="content">
    <!-- Student Form -->
    <div class="section" id="student-form">
        <h2>Add Student</h2>
        <form id="add-student" enctype="multipart/form-data">
            <input name="student-name" type="text" placeholder="Name" required>
            <input name="student-rollno" type="number" placeholder="Roll-no" required>
            <input name="student-class" type="text" placeholder="Class" required>
            <input name="student-dob" type="date" placeholder="Date of Birth" required>
            <label for="gender">Gender:</label>
            <select name="student-gender" id="gender" required>
                <option value="" disabled selected>Select gender</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="other">Other</option>
            </select>
            <input name="student-email" type="email" placeholder="Email" required>
            <input name="student-phone" type="text" placeholder="Phone" required>
            <button type="submit">Submit</button>
        </form>
    </div>

    <!-- Results Form -->
    <div class="section" id="results-form">
        <h2>Add Student Result</h2>
        <form id="add-result" enctype="multipart/form-data">
            <input name="student-rollno" type="number" placeholder="Rollno" required>
            <input name="student-tamil-mark" type="number" placeholder="Tamil mark" required>
            <input name="student-english-mark" type="number" placeholder="English mark" required>
            <input name="student-maths-mark" type="number" placeholder="Maths mark" required>
            <input name="student-science-mark" type="number" placeholder="Science mark" required>
            <input name="student-social-mark" type="number" placeholder="Social Science mark" required>
            <button type="submit">Submit</button>
        </form>
    </div>

    <!-- Records Table -->

    <div class="section" id="records">
        <div id="student-spinner" style="display: none; text-align: center; padding: 10px;">
            <div class="mini-spinner"></div>
        </div>
        <div class="records-header">
            <h2>Student Records</h2>
            <div class="btn-group">
            <button onclick="refreshStudents()" class="refresh-btn"><i class="fa-solid fa-rotate-right"></i> Refresh</button>
            <button onclick="window.location.href='search.jsp'" class="search-btn"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
            </div>
        </div>

        <table>

            <thead>
            <tr>
                <th>ID</th>
                <th>Student Rollno</th>
                <th>Name</th>
                <th>DOB</th>
                <th>Gender</th>
                <th>Class</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>

            <%
                List<Student> studentList = (List<Student>) request.getAttribute("student");

                if (studentList != null && !studentList.isEmpty()) {
                    for (Student s : studentList) {
            %>
            <tr data-id="<%= s.getId() %>">
                <td><%= s.getId() %></td>
                <td><span class="static"><%= s.getRollno() %></span><input class="edit-input" name="rollno" value="<%= s.getRollno() %>" hidden></td>
                <td><span class="static"><%= s.getName() %></span><input class="edit-input" name="name" value="<%= s.getName() %>" hidden></td>
                <td><span class="static"><%= s.getDob() %></span><input class="edit-input" name="dob" type="date" value="<%= s.getDob() %>" hidden></td>
                <td><span class="static"><%= s.getGender() %></span><input class="edit-input" name="gender" type="text" value="<%= s.getGender() %>" hidden></td>
                <td><span class="static"><%= s.getStudclass() %></span><input class="edit-input" name="studclass" value="<%= s.getStudclass() %>" hidden></td>
                <td><span class="static"><%= s.getEmail() %></span><input class="edit-input" name="email" value="<%= s.getEmail() %>" hidden></td>
                <td><span class="static"><%= s.getPhone() %></span><input class="edit-input" name="phone" value="<%= s.getPhone() %>" hidden></td>

                <td>
                    <button type="button" class="btn-small update-btn" onclick="enableEdit(this)" title="Edit"><i class="fas fa-pen"></i> Update</button>
                    <button type="button" class="btn-small save-btn" hidden onclick="submitUpdate(this)"><i class="fas fa-check"></i> Save</button>
                    <button type="button" class="btn-small cancel-btn" hidden onclick="cancelEdit(this)"><i class="fas fa-times"></i> Cancel</button>
                    <button type="button" class="btn-small delete-btn" onclick="deleteStudent(this)" title="Delete"><i class="fas fa-trash"></i> Delete</button>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr><td colspan="6">No student records found.</td></tr>
            <%
                }
            %>

            </tbody>
        </table>
    </div>

    <div class="section" id="results">
        <div id="results-spinner" style="display: none; text-align: center; padding: 10px;">
            <div class="mini-spinner"></div>
        </div>

        <div class="records-header">
            <h2>Student Records</h2>
            <div class="btn-group">
            <button onclick="refreshResults()" class="refresh-btn"><i class="fa-solid fa-rotate-right"></i> Refresh</button>
            <button onclick="window.location.href='search.jsp'" class="search-btn"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
            </div>
        </div>
        <span id="results-loading" style="display:none;">
        <span class="loading-spinner"></span>
        </span>
        <table>

            <thead>
            <tr>
                <th>Result ID</th>
                <th>Student Rollno</th>
                <th>Name</th>
                <th>Class</th>
                <th>Tamil</th>
                <th>English</th>
                <th>Maths</th>
                <th>Science</th>
                <th>Social</th>
                <th>Total Marks</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Results> resultsList = (List<Results>) request.getAttribute("results");

                if (resultsList != null && !resultsList.isEmpty()) {
                    for (Results r : resultsList) {
            %>
            <tr data-id="<%= r.getResult_id() %>">
                <td><%= r.getResult_id() %></td>
                <td><span class="static"><%= r.getRollno() %></span><input class="edit-input" name="rollno" value="<%= r.getRollno() %>" hidden></td>
                <td><span class="static"><%= r.getName() %></span><input class="edit-input" name="name" value="<%= r.getName() %>" hidden></td>
                <td><span class="static"><%= r.getStudclass() %></span><input class="edit-input" name="studclass" value="<%= r.getStudclass() %>" hidden></td>
                <td><span class="static"><%= r.getTamil() %></span><input class="edit-input" name="tamil" value="<%= r.getTamil() %>" hidden></td>
                <td><span class="static"><%= r.getEnglish() %></span><input class="edit-input" name="english"  value="<%= r.getEnglish() %>" hidden></td>
                <td><span class="static"><%= r.getMaths() %></span><input class="edit-input" name="maths" value="<%= r.getMaths() %>" hidden></td>
                <td><span class="static"><%= r.getScience() %></span><input class="edit-input" name="science" value="<%= r.getScience() %>" hidden></td>
                <td><span class="static"><%= r.getSocial_science() %></span><input class="edit-input" name="social_science" value="<%= r.getSocial_science() %>" hidden></td>
                <td><span class="static"><%= r.getTotal_marks() %></span><input class="edit-input" name="total_marks" value="<%= r.getTotal_marks() %>" hidden></td>
                <td><span class="static"><%= r.getStatus() %></span><input class="edit-input" name="status" value="<%= r.getStatus() %>" hidden></td>
                <td>
                    <button type="button" class="btn-small update-btn" onclick="enableEdit(this)" title="Edit"><i class="fas fa-pen"></i> Update</button>
                    <button type="button" class="btn-small save-btn" hidden onclick="submitUpdateResult(this)"><i class="fas fa-check"></i> Save</button>
                    <button type="button" class="btn-small cancel-btn" hidden onclick="cancelEdit(this)"><i class="fas fa-times"></i> Cancel</button>
                    <button type="button" class="btn-small delete-btn" onclick="deleteResult(this)" title="Delete"><i class="fas fa-trash"></i> Delete</button>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr><td colspan="6">No results records found.</td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <!-- Dashboard Section -->
    <div class="section active" id="dashboard">
        <h2>Dashboard</h2>

        <div class="stats-container">
            <div class="stat-card total">
                <strong>Total Students</strong>
                <p id="total-students">0</p>
            </div>
            <div class="stat-card passed">
                <strong>Passed</strong>
                <p id="passed-students">0</p>
            </div>
            <div class="stat-card failed">
                <strong>Failed</strong>
                <p id="failed-students">0</p>
            </div>
        </div>

        <h3>Subject Statistics</h3>
        <table id="statsTable">
            <thead>
            <tr>
                <th>S.No</th>
                <th>Subject Name</th>
                <th>Average Marks</th>
                <th>Highest Mark</th>
                <th>Lowest Mark</th>
            </tr>
            </thead>
            <tbody>

            </tbody>
        </table>
        <p id="error" class="error"></p>

        <h3 style="margin-top: 40px;">Performance Overview</h3>
        <canvas id="studentStatusChart" width="600" height="250" style="margin-bottom: 40px;"></canvas>

        <h3>Top Scoring Subjects</h3>
        <canvas id="subjectPerformanceChart" width="600" height="250"></canvas>

    </div>
</div>

<script>
    // Sidebar Navigation
    const navItems = document.querySelectorAll('.nav-item');
    const sections = document.querySelectorAll('.section');

    function activateSection(sectionId) {
        navItems.forEach(nav => {
            nav.classList.toggle('active', nav.getAttribute('data-target') === sectionId);
        });
        sections.forEach(sec => {
            sec.classList.toggle('active', sec.id === sectionId);
        });
    }

    document.addEventListener('DOMContentLoaded', () => {
        const savedSection = localStorage.getItem('activeSection');
        const defaultSection = 'dashboard';  // your overall view section

        if (savedSection && document.getElementById(savedSection)) {
            activateSection(savedSection);
        } else {
            activateSection(defaultSection);
        }
    });

    navItems.forEach(item => {
        item.addEventListener('click', () => {
            const target = item.getAttribute('data-target');
            activateSection(target);
            localStorage.setItem('activeSection', target);
        });
    });


    //total no of students, no of passed, no of failed details
    function animateNumber(id, target) {
        const el = document.getElementById(id);
        let count = 0;
        const step = Math.ceil(target / 50);

        const interval = setInterval(() => {
            count += step;
            if (count >= target) {
                el.textContent = target;
                clearInterval(interval);
            } else {
                el.textContent = count;
            }
        }, 20);
    }

    function updateStats() {
        fetch('overallstats')
            .then(response => response.json())
            .then(data => {
                animateNumber("total-students", data.total);
                animateNumber("passed-students", data.passed);
                animateNumber("failed-students", data.failed);
            })
            .catch(err => console.error("Failed to fetch student stats:", err));
    }

    document.addEventListener("DOMContentLoaded", () => {
        updateStats();                  // Initial load
        setInterval(updateStats, 5000); // Repeat every 5 seconds
    });


    // Chart.js Graph
    // === Chart 1: Student Status Summary ===
    const ctxStatus = document.getElementById('studentStatusChart').getContext('2d');
    let studentStatusChart; // Declare chart globally

    function fetchAndUpdateChart() {
        fetch('overallstats')
            .then(response => response.json())
            .then(data => {
                const chartData = [data.total, data.passed, data.failed];

                if (!studentStatusChart) {
                    // Initialize chart if it doesn't exist yet
                    studentStatusChart = new Chart(ctxStatus, {
                        type: 'bar',
                        data: {
                            labels: ['Total Students', 'Passed', 'Failed'],
                            datasets: [{
                                label: 'Count',
                                data: chartData,
                                backgroundColor: ['#d8bade', '#98fb98', '#ff6347'],
                                borderColor: ['#d8bade', '#98fb98', '#ff6347'],
                                borderWidth: 1
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                title: {
                                    display: true,
                                    text: 'Student Performance Overview'
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            }
                        }
                    });
                } else {
                    // Update chart data if already initialized
                    studentStatusChart.data.datasets[0].data = chartData;
                    studentStatusChart.update();
                }
            })
            .catch(err => console.error("Failed to fetch student stats:", err));
    }

    document.addEventListener("DOMContentLoaded", () => {
        fetchAndUpdateChart();               // Initial load
        setInterval(fetchAndUpdateChart, 5000); // Update every 5 seconds
    });

    // === Chart 2: Subject Scores ===
    const ctxSubjects = document.getElementById('subjectPerformanceChart').getContext('2d');

    let subjectChart; // Declare globally

    function fetchAndRenderSubjectChart() {
        fetch('overallstats')
            .then(response => response.json())
            .then(data => {
                const averages = data.averages;

                const avgData = [
                    averages.tamil,
                    averages.english,
                    averages.maths,
                    averages.science,
                    averages.social_science
                ];

                if (!subjectChart) {
                    // Initial render
                    subjectChart = new Chart(ctxSubjects, {
                        type: 'bar',
                        data: {
                            labels: ['Tamil', 'English', 'Maths', 'Science', 'Social Science'],
                            datasets: [{
                                label: 'Average Marks',
                                data: avgData,
                                backgroundColor: [
                                    '#ff6384', '#36a2eb', '#ffcd56', '#4bc0c0', '#9966ff'
                                ],
                                borderColor: [
                                    '#ff6384', '#36a2eb', '#ffcd56', '#4bc0c0', '#9966ff'
                                ],
                                borderWidth: 1
                            }]
                        },
                        options: {
                            indexAxis: 'y',
                            responsive: true,
                            plugins: {
                                title: {
                                    display: true,
                                    text: 'Average Marks by Subject'
                                }
                            },
                            scales: {
                                x: {
                                    beginAtZero: true,
                                    max: 100
                                }
                            }
                        }
                    });
                } else {
                    // Update existing chart
                    subjectChart.data.datasets[0].data = avgData;
                    subjectChart.update();
                }
            })
            .catch(err => console.error("Failed to fetch subject averages:", err));
    }

    // Call once when the page loads
    document.addEventListener("DOMContentLoaded", () => {
        fetchAndRenderSubjectChart();

        // Optional: Refresh every 10 seconds
        setInterval(fetchAndRenderSubjectChart, 10000);
    });


    document.addEventListener('DOMContentLoaded', () => {
        fetch('subjectstats')
            .then(response => {
                if (!response.ok) throw new Error('Network response was not OK');
                return response.json();
            })
            .then(data => {
                console.log('Data received:', data);

                const subjects = ['Tamil', 'English', 'Maths', 'Science', 'Social_Science'];
                const displayNames = {
                    Tamil: 'Tamil',
                    English: 'English',
                    Maths: 'Maths',
                    Science: 'Science',
                    Social_Science: 'Social Science'
                };

                const tbody = document.querySelector('#statsTable tbody');
                tbody.innerHTML = '';

                subjects.forEach((subject, index) => {
                    // Defensive check for data existence

                    const subjectStats = data[subject] || {};
                    const max = subjectStats.max ?? '-';
                    const min = subjectStats.min ?? '-';
                    const avg = subjectStats.average ?? '-';

                    const tr = document.createElement('tr');

                    // Create and append all cells individually to avoid HTML syntax errors
                    const tdIndex = document.createElement('td');
                    tdIndex.textContent = index + 1;

                    const tdSubject = document.createElement('td');
                    tdSubject.textContent = displayNames[subject];

                    const tdAvg = document.createElement('td');
                    tdAvg.textContent = avg;

                    const tdMax = document.createElement('td');
                    tdMax.textContent = max;

                    const tdMin = document.createElement('td');
                    tdMin.textContent = min;

                    tr.appendChild(tdIndex);
                    tr.appendChild(tdSubject);
                    tr.appendChild(tdAvg);
                    tr.appendChild(tdMax);
                    tr.appendChild(tdMin);

                    tbody.appendChild(tr);
                });
            })
            .catch(err => {
                document.getElementById('error').textContent = 'Failed to load data: ' + err.message;
            });
    });


    //ajax operation for sending data to backend from forms
    document.getElementById("add-student").addEventListener("submit", function (e) {
        e.preventDefault(); // Prevent full page reload

        const formData = new FormData(this);

        fetch("manage", {
            method: "POST",
            body: formData
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                return response.json();  // Parse the response as JSON
            })
            .then(data => {
                // Check if response contains success or failure
                if (data.status === "success") {
                    showToast(data.message, "success");
                    this.reset();  // Reset form fields after success
                } else {
                    showToast(data.message, "failure");
                }
            })
            .catch(error => {
                showToast("Failed to add student.", "failure");
                console.error("Error:", error); // Log error for debugging
            });
    });

    function enableEdit(button) {
        const row = button.closest('tr');

        // Ensure the row is correctly selected
        if (!row) {
            console.error("Failed to find the row for editing");
            return;
        }

        // Hide static elements and show input fields
        const staticElements = row.querySelectorAll('.static');
        const inputElements = row.querySelectorAll('.edit-input');
        staticElements.forEach(el => el.style.display = 'none');
        inputElements.forEach(el => el.style.display = 'inline-block');

        // Toggle button visibility
        const updateButton = row.querySelector('.update-btn');
        const saveButton = row.querySelector('.save-btn');
        const cancelButton = row.querySelector('.cancel-btn');
        const deleteButton = row.querySelector('.delete-btn'); // Select the delete button

        if (updateButton) updateButton.style.display = 'none'; // Hide "Update" button
        if (saveButton) saveButton.style.display = 'inline-block'; // Show "Save" button
        if (cancelButton) cancelButton.style.display = 'inline-block'; // Show "Cancel" button
        if (deleteButton) deleteButton.style.display = 'none'; // Hide "Delete" button

        console.log("Edit mode enabled for row:", row.dataset.id); // Debugging
    }

    function cancelEdit(button) {
        const row = button.closest('tr');

        const staticElements = row.querySelectorAll('.static');
        const inputElements = row.querySelectorAll('.edit-input');
        staticElements.forEach(el => el.style.display = 'inline-block');
        inputElements.forEach(el => el.style.display = 'none');

        // Toggle button visibility
        const updateButton = row.querySelector('.update-btn');
        const saveButton = row.querySelector('.save-btn');
        const cancelButton = row.querySelector('.cancel-btn');
        const deleteButton = row.querySelector('.delete-btn'); // Select the delete button

        if (updateButton) updateButton.style.display = 'inline-block'; // Show "Update" button
        if (saveButton) saveButton.style.display = 'none'; // Hide "Save" button
        if (cancelButton) cancelButton.style.display = 'none'; // Hide "Cancel" button
        if (deleteButton) deleteButton.style.display = 'inline-block'; // Show "Delete" button


    }

    function submitUpdate(button) {
        const row = button.closest('tr');
        const id = row.dataset.id;
        const name = row.querySelector('input[name="name"]').value;
        const rollno = row.querySelector('input[name="rollno"]').value;
        const studclass = row.querySelector('input[name="studclass"]').value;
        const email = row.querySelector('input[name="email"]').value;
        const phone = row.querySelector('input[name="phone"]').value;
        const dob = row.querySelector('input[name="dob"]').value;
        const gender = row.querySelector('input[name="gender"]').value;

        fetch("update", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ id, name,rollno,studclass,dob,gender,email, phone })
        })
            .then(res => res.json())
            .then(data => {
                if (data.status === "success") {
                    showToast("Student updated", "success");

                    row.querySelectorAll('.static')[0].textContent = name;
                    row.querySelectorAll('.static')[1].textContent = rollno;
                    row.querySelectorAll('.static')[2].textContent = studclass;
                    row.querySelectorAll('.static')[3].textContent = dob;
                    row.querySelectorAll('.static')[4].textContent = gender;
                    row.querySelectorAll('.static')[5].textContent = email;
                    row.querySelectorAll('.static')[6].textContent = phone;

                    cancelEdit(button);
                } else {
                    showToast(data.message || "Update failed", "failure");
                }
            })
            .catch(err => {
                showToast("Error updating student", "failure");
                console.error(err);
            });
    }

    function deleteStudent(button) {
        const row = button.closest('tr');
        const id = row.dataset.id;

        if (!confirm("Are you sure you want to delete this student?")) return;

        // Prepare the data to send to the server
        const data = { "student-id": id };

        // Send AJAX request to delete student
        fetch("delete", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams(data)
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === "success") {
                    showToast("Student deleted successfully", "success");
                    row.remove();  // Remove the row from the table
                } else {
                    showToast(data.message || "Deletion failed", "failure");
                }
            })
            .catch(err => {
                showToast("Error deleting student", "failure");
                console.error("Error:", err);
            });
    }


    //result management ajax codes
    document.getElementById("add-result").addEventListener("submit", function (e) {
        e.preventDefault(); // Prevent full page reload

        const formData = new FormData(this);

        fetch("result", {
            method: "POST",
            body: formData
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                return response.json();  // Parse the response as JSON
            })
            .then(data => {
                // Check if response contains success or failure
                if (data.status === "success") {
                    showToast(data.message, "success");
                    this.reset();  // Reset form fields after success
                } else {
                    showToast(data.message, "failure");
                }
            })
            .catch(error => {
                showToast("Failed to add result.", "failure");
                console.error("Error:", error); // Log error for debugging
            });
    });

    function submitUpdateResult(button) {
        const row = button.closest('tr');
        const id = row.dataset.id;

        const data = {
            id: id,
            rollno: row.querySelector('input[name="rollno"]').value,
            name: row.querySelector('input[name="name"]').value,
            studclass: row.querySelector('input[name="studclass"]').value,
            tamil: row.querySelector('input[name="tamil"]').value,
            english: row.querySelector('input[name="english"]').value,
            maths: row.querySelector('input[name="maths"]').value,
            science: row.querySelector('input[name="science"]').value,
            social_science: row.querySelector('input[name="social_science"]').value,
            total_marks: row.querySelector('input[name="total_marks"]').value,
            status: row.querySelector('input[name="status"]').value
        };

        fetch("updateResult", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        })
            .then(res => res.json())
            .then(data => {
                if (data.status === "success") {
                    showToast("Result updated successfully", "success");

                    // Update visible static values
                    const statics = row.querySelectorAll('.static');
                    statics[0].textContent = data.rollno;
                    statics[1].textContent = data.name;
                    statics[2].textContent = data.studclass;
                    statics[3].textContent = data.tamil;
                    statics[4].textContent = data.english;
                    statics[5].textContent = data.maths;
                    statics[6].textContent = data.science;
                    statics[7].textContent = data.social_science;
                    statics[8].textContent = data.total_marks;
                    statics[9].textContent = data.status;

                    cancelEdit(button);
                } else {
                    showToast(data.message || "Update failed", "failure");
                }
            })
            .catch(err => {
                console.error("Update error:", err);
                showToast("Error updating result", "failure");
            });
    }

    function deleteResult(button) {
        const row = button.closest('tr');
        const id = row.dataset.id;

        if (!confirm("Are you sure you want to delete this result?")) return;

        fetch("deleteResult", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: JSON.stringify({ "result-id": parseInt(id) })
        })
            .then(res => res.json())
            .then(data => {
                if (data.status === "success") {
                    row.remove();
                    showToast("Result deleted successfully", "success");
                } else {
                    showToast(data.message || "Delete failed", "failure");
                }
            })
            .catch(err => {
                console.error("Delete error:", err);
                showToast("Error deleting result", "failure");
            });
    }

    function refreshStudents() {
        const spinner = document.getElementById('student-spinner');
        spinner.style.display = 'block'; // Show spinner in results section

        setTimeout(() => {
            location.reload();
        }, 400); // Small delay for smoother visual transition
    }
    function refreshResults() {
        const spinner = document.getElementById('results-spinner');
        spinner.style.display = 'block'; // Show spinner in results section

        setTimeout(() => {
            location.reload();
        }, 400); // Small delay for smoother visual transition
    }

    function showToast(message, type) {
        let container = document.querySelector('.toast-container');

        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container';
            document.body.appendChild(container);
        }

        const toast = document.createElement('div');
        toast.classList.add('toast', type);
        toast.textContent = message;

        container.appendChild(toast);

        // Remove the toast after 3 seconds with animation
        setTimeout(() => {
            toast.style.animation = 'slideOut 0.4s ease-in forwards';
            toast.addEventListener('animationend', () => {
                toast.remove();

                if (container.children.length === 0) container.remove();
            });
        }, 3000);
    }

</script>
</body>
</html>

