<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Search and Sort</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

    <style>
        body {
            background-color: #f0f8ff; /* ace blue */
            color: #3d5cb8;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Force background color on all <th> inside the thead */
        table.dataTable thead th {
            background-color: #3d5cb8 !important;
            color: white !important;
        }

        #spinner {
            display: none;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Student Management</h2>

    <!-- Search Form -->
    <form id="searchForm" class="row g-3">
        <div class="col-md-4">
            <label for="rollno" class="form-label">Roll No</label>
            <input type="text" class="form-control" id="rollno" name="rollno">
        </div>
        <div class="col-md-4">
            <label for="studclass" class="form-label">Class</label>
            <input type="text" class="form-control" id="studclass" name="studclass">
        </div>
        <div class="col-md-4 d-flex align-items-end">
            <button type="submit" class="btn btn-primary me-2">Search</button>
        </div>
    </form>

    <!-- Spinner -->
    <div id="spinner" class="text-center my-4">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>

    <!-- Search Table -->
    <div class="table-responsive mb-5">
        <h4>Search Result</h4>
        <table id="searchResultsTable" class="table table-striped table-bordered">
            <thead class="custom-header">
            <tr>
                <th>ID</th><th>Roll No</th><th>Name</th><th>Class</th>
                <th>Date of Birth</th><th>Gender</th><th>Email</th><th>Phone</th><th>Actions</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <!-- Sort Table -->
    <div class="d-flex justify-content-end mb-2">
        <select id="sortOption" class="form-select w-auto">
            <option value="name_asc">Sort by Name A-Z</option>
            <option value="name_desc">Sort by Name Z-A</option>
            <option value="class">Sort by Class</option>
        </select>
    </div>
    <div class="table-responsive">
        <h4>Sorted Students</h4>
        <table id="studentsTable" class="table table-striped table-bordered">
            <thead class="custom-header">
            <tr>
                <th>ID</th><th>Roll No</th><th>Name</th><th>Class</th>
                <th>Date of Birth</th><th>Gender</th><th>Email</th><th>Phone</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>

<!-- Update Modal -->
<div class="modal fade" id="updateModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Update Student</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="updateForm">
                    <input type="hidden" id="updateId">
                    <div class="mb-3"><label class="form-label">Roll No</label><input type="number" class="form-control" id="updateRollno" required></div>
                    <div class="mb-3"><label class="form-label">Name</label><input type="text" class="form-control" id="updateName" required></div>
                    <div class="mb-3"><label class="form-label">Class</label><input type="text" class="form-control" id="updateClass" required></div>
                    <div class="mb-3"><label class="form-label">DOB</label><input type="date" class="form-control" id="updateDob" required></div>
                    <div class="mb-3">
                        <label class="form-label">Gender</label>
                        <select class="form-select" id="updateGender" required>
                            <option value="">Select</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                        </select>
                    </div>
                    <div class="mb-3"><label class="form-label">Email</label><input type="email" class="form-control" id="updateEmail" required></div>
                    <div class="mb-3"><label class="form-label">Phone</label><input type="text" class="form-control" id="updatePhone" required></div>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
    let searchTable, sortTable;
    let lastSearchParams = null; // Track the latest search params

    function showSpinner() { $('#spinner').show(); }
    function hideSpinner() { $('#spinner').hide(); }

    function fetchSearchResults(params) {
        lastSearchParams = params; // Remember last search for refresh after update
        showSpinner();
        $.ajax({
            url: 'search',
            method: 'GET',
            data: params,
            dataType: 'json',
            success: function (data) {
                searchTable.clear();
                if (data && data.length > 0) {
                    data.forEach(student => {
                        searchTable.row.add({
                            ...student,
                            actions: `
                         <div class="d-flex">
              <button class="btn btn-sm btn-warning me-3 updateBtn"
              data-id="${student.id}"
              data-rollno="${student.rollno}"
              data-name="${student.name}"
              data-studclass="${student.studclass}"
              data-dob="${student.dob}"
              data-gender="${student.gender}"
              data-email="${student.email}"
              data-phone="${student.phone}">
              Update
            </button>
            <button class="btn btn-sm btn-danger deleteBtn"
            data-id="${student.id}">
            Delete
            </button>
            </div>
            `});
                    });
                    searchTable.draw();
                } else {
                    showToast('No students found.', 'warning');
                }
            },
            error: () => showToast('Failed to fetch search results.', 'error'),
            complete: hideSpinner
        });
    }

    function fetchSortedData(sortType) {
        showSpinner();

        $.ajax({
            url: 'sort',
            method: 'GET',
            data: { sort: sortType },
            dataType: 'json',
            success: function (data) {
                console.log("Received sorted data:", data); // for debugging

                // ✅ Clear old data from DataTable
                sortTable.clear();

                // ✅ Add new data to DataTable
                sortTable.rows.add(data);

                // ✅ Redraw the table to reflect changes
                sortTable.draw();
            },
            error: function () {
                showToast('Failed to fetch sorted data.', 'error');
            },
            complete: hideSpinner
        });
    }

    $(document).ready(function () {
        searchTable = $('#searchResultsTable').DataTable({
            data: [],
            columns: [
                { data: 'id' }, { data: 'rollno' }, { data: 'name' }, { data: 'studclass' },
                { data: 'dob' }, { data: 'gender' }, { data: 'email' }, { data: 'phone' },
                { data: 'actions', orderable: false, searchable: false }
            ],
            paging: true,
            searching: true,
            ordering: true,
            info: true
        });

        sortTable = $('#studentsTable').DataTable({
            data: [],
            columns: [
                { data: 'id' }, { data: 'rollno' }, { data: 'name' }, { data: 'studclass' },
                { data: 'dob' }, { data: 'gender' }, { data: 'email' }, { data: 'phone' }
            ],
            paging: true,
            searching: true,
            ordering: false,
            info: true
        });

        // Remember search params for refresh after update
        $('#searchForm').on('submit', function (e) {
            e.preventDefault();
            lastSearchParams = $(this).serialize();
            fetchSearchResults(lastSearchParams);
        });

        $('#sortOption').on('change', function () {
            fetchSortedData($(this).val());
        });

        // Attach handler to delete buttons in the DataTable
        $('#searchResultsTable').on('click', '.deleteBtn', function () {
            const row = $(this).closest('tr');
            // Use DataTables API to get row data (if needed)
            const rowData = searchTable.row(row).data();
            const id = rowData.id;

            if (!confirm("Are you sure you want to delete this student?")) return;

            // Prepare data
            const data = { "student-id": id };

            // Send AJAX request with fetch
            showSpinner();
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
                        // Remove row using DataTables API for proper redraw
                        searchTable.row(row).remove().draw();
                        // Optionally refresh sorted table
                        fetchSortedData($('#sortOption').val());
                    } else {
                        showToast(data.message || "Deletion failed", "error");
                    }
                })
                .catch(err => {
                    showToast("Error deleting student", "error");
                    console.error("Error:", err);
                })
                .finally(hideSpinner);
        });

        // Open modal and fill update form
        $('#searchResultsTable').on('click', '.updateBtn', function () {
            const rowData = searchTable.row($(this).closest('tr')).data();

            $('#updateId').val(rowData.id);
            $('#updateRollno').val(rowData.rollno);
            $('#updateName').val(rowData.name);
            $('#updateClass').val(rowData.studclass);
            $('#updateDob').val(rowData.dob);
            $('#updateGender').val(rowData.gender);
            $('#updateEmail').val(rowData.email);
            $('#updatePhone').val(rowData.phone);

            const modal = new bootstrap.Modal(document.getElementById('updateModal'));
            modal.show();
        });

        // --- FIXED UPDATE HANDLER ---
        $('#updateForm').on('submit', function (e) {
            e.preventDefault();

            const updatedData = {
                id: parseInt($('#updateId').val()),
                rollno: parseInt($('#updateRollno').val()),
                name: $('#updateName').val(),
                studclass: $('#updateClass').val(),
                dob: $('#updateDob').val(),
                gender: $('#updateGender').val(),
                email: $('#updateEmail').val(),
                phone: $('#updatePhone').val()
            };

            showSpinner();

            $.ajax({
                url: 'update',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(updatedData),
                success: function (res) {
                    console.log('Update response:', res);
                    let message = res.message || 'Update completed.';
                    if (res.status === 'success') {
                        showToast(message, 'success');
                        // Close modal
                        const modalEl = document.getElementById('updateModal');
                        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                        modal.hide();
                        // Refresh table
                        if (lastSearchParams) {
                            fetchSearchResults(lastSearchParams);
                        } else {
                            fetchSortedData($('#sortOption').val());
                        }
                    } else {
                        showToast(message, 'error');
                    }
                },
                error: function (xhr, status, error) {
                    console.log('AJAX error:', error);
                    showToast('AJAX request failed.', 'error');
                },
                complete: hideSpinner
            });
        });

        // Reset form on modal close
        const modalEl = document.getElementById('updateModal');
        modalEl.addEventListener('hidden.bs.modal', () => {
            $('#updateForm')[0].reset();
        });

        // Initial sorted data fetch
        fetchSortedData($('#sortOption').val());
    });

    function showToast(message, type = 'success') {
        let container = document.querySelector('.my-toast-container');

        if (!container) {
            container = document.createElement('div');
            container.className = 'my-toast-container';
            container.style.position = 'fixed';
            container.style.top = '20px';
            container.style.right = '20px';
            container.style.zIndex = '9999';
            document.body.appendChild(container);
        }

        const toast = document.createElement('div');
        toast.className = `my-toast my-toast-${type}`; // changed class names
        toast.textContent = message;

        toast.style.padding = '10px 15px';
        toast.style.marginBottom = '10px';
        toast.style.borderRadius = '5px';
        toast.style.boxShadow = '0 0 10px rgba(0,0,0,0.1)';
        toast.style.color = '#fff';
        toast.style.fontWeight = 'bold';
        toast.style.fontSize = '1.1em';
        toast.style.display = 'block';

        if (type === 'success') toast.style.backgroundColor = '#28a745';
        else if (type === 'error') toast.style.backgroundColor = '#dc3545';
        else { toast.style.backgroundColor = '#ffc107'; toast.style.color = '#000'; }

        container.appendChild(toast);

        setTimeout(() => {
            toast.remove();
            if (container.children.length === 0) container.remove();
        }, 5000);
    }



</script>
</body>
</html>

