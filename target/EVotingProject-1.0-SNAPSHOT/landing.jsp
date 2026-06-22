<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<title>Global E-Voting System</title>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<style>

body{
    margin:0;
    padding:0;
    display:flex;
    justify-content:center;
    align-items:center;
    min-height:100vh;

    font-family:Arial,sans-serif;

    background:
    linear-gradient(
    rgba(0,0,0,0.60),
    rgba(0,0,0,0.60)
    ),
    url('https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?q=80&w=1600&auto=format&fit=crop');

    background-size:cover;
    background-position:center;
    background-repeat:no-repeat;
}

.box{

    width:650px;

    background:white;

    padding:35px;

    border-radius:20px;

    box-shadow:0px 0px 25px rgba(0,0,0,0.3);
}

h1{

    text-align:center;

    margin-bottom:25px;

    font-weight:bold;

    color:#0d6efd;
}

.btn-enter{

    background:#198754;

    color:white;

    font-weight:bold;
}

.btn-enter:hover{

    background:#157347;
}

.btn-super{

    background:#dc3545;

    color:white;

    font-weight:bold;
}

.btn-super:hover{

    background:#bb2d3b;
}

.footer{

    text-align:center;

    margin-top:20px;

    font-weight:bold;
}

label{

    font-weight:bold;
}

</style>

<script>

function loadStates(){

    var countryId =
    document.getElementById("country").value;

    fetch("GetStates?country_id=" + countryId)

    .then(response => response.text())

    .then(data => {

        document.getElementById("state").innerHTML =
        data;

        document.getElementById("district").innerHTML =
        "<option value=''>Select District</option>";
    });
}

function loadDistricts(){

    var stateId =
    document.getElementById("state").value;

    fetch("GetDistricts?state_id=" + stateId)

    .then(response => response.text())

    .then(data => {

        document.getElementById("district").innerHTML =
        data;
    });
}

</script>

</head>

<body>

<div class="box">

<h1>

🌍 Global E-Voting System

</h1>

<form action="AreaSelectionServlet" method="post">

<label>

Select Country

</label>

<select
        class="form-control"
        id="country"
        name="country"
        onchange="loadStates()"
        required>

<option value="">

Select Country

</option>

<%

Connection con =
        DBConnection.getConnection();

Statement st =
        con.createStatement();

ResultSet countryRs =
        st.executeQuery(
        "SELECT * FROM country ORDER BY country_name");

while(countryRs.next()){

%>

<option value="<%=countryRs.getInt("country_id")%>">

<%=countryRs.getString("country_name")%>

</option>

<%
}
%>

</select>

<br>

<label>

Select State

</label>

<select
        class="form-control"
        id="state"
        name="state"
        onchange="loadDistricts()"
        required>

<option value="">

Select State

</option>

</select>

<br>

<label>

Select District

</label>

<select
        class="form-control"
        id="district"
        name="district"
        required>

<option value="">

Select District

</option>

</select>

<br>

<button
        type="submit"
        class="btn btn-enter w-100">

🗳 Enter Election Portal

</button>

</form>

<hr>

<a href="superadminlogin.html">

<button
        class="btn btn-super w-100">

🔐 Super Admin Login

</button>

</a>

<div class="footer">

Developed By 🚀

<span style="color:#0d6efd">

ANKIT KUMAR SHAH

</span>

</div>

</div>

</body>
</html>