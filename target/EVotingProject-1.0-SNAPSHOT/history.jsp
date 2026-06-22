<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>

<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%
if(session.getAttribute("admin_id")==null){

    response.sendRedirect("Adminlogin.html");
    return;
}

String adminDistrict =
(String)session.getAttribute("district");
%>
<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Election History</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

    margin:0;
    padding:0;

    font-family:Arial,sans-serif;

    background:
    linear-gradient(rgba(0,0,0,0.7),
    rgba(0,0,0,0.7)),

    url('https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?q=80&w=1400&auto=format&fit=crop');

    background-size:cover;
    background-position:center;

    min-height:100vh;
}

.navbar{

    background:rgba(0,0,0,0.7);

    padding:15px 40px;
}

.navbar-brand{

    color:white !important;

    font-size:30px;

    font-weight:bold;
}

.container-box{

    width:90%;

    margin:auto;

    padding-top:40px;

    padding-bottom:40px;
}

.title{

    text-align:center;

    color:white;

    font-size:45px;

    font-weight:bold;

    margin-bottom:40px;

    text-shadow:2px 2px 10px black;
}

.reset-box{

    background:white;

    padding:30px;

    border-radius:25px;

    margin-bottom:40px;

    box-shadow:0px 0px 20px rgba(0,0,0,0.3);
}

.reset-header{

    display:flex;

    justify-content:space-between;

    align-items:center;

    margin-bottom:30px;

    border-bottom:2px solid #ddd;

    padding-bottom:15px;
}

.reset-title{

    font-size:28px;

    font-weight:bold;

    color:#198754;
}

.location-title{

    font-size:28px;

    font-weight:bold;

    color:#0d6efd;

    margin-top:25px;

    margin-bottom:20px;
}

.table{

    border-radius:15px;

    overflow:hidden;
}

.back-btn{

    background:#198754;

    color:white;

    border:none;

    padding:10px 25px;

    border-radius:10px;

    font-size:18px;

    font-weight:bold;
}

.delete-btn{

    background:#dc3545;

    color:white;

    border:none;

    padding:10px 20px;

    border-radius:10px;

    font-size:16px;

    font-weight:bold;
}

.delete-btn:hover{

    background:darkred;
}

.no-data{

    text-align:center;

    font-size:25px;

    font-weight:bold;

    color:red;

    background:white;

    padding:40px;

    border-radius:20px;
}
/* FOOTER */

.footer{

    width:100%;

    background:rgba(0,0,0,0.85);

    color:white;

    text-align:center;

    padding:15px;

    font-size:18px;

    font-weight:bold;

    letter-spacing:1px;

    margin-top:40px;

    box-shadow:0px -2px 10px rgba(0,0,0,0.3);
}

.footer span{

    color:#00bfff;

    font-size:20px;

    text-shadow:0px 0px 10px #00bfff;
}
</style>

</head>

<body>

<!-- NAVBAR -->

<nav class="navbar">

<div class="container-fluid">

<span class="navbar-brand">

🗳️ Election History

</span>

<a href="admindashboard.jsp">

<button class="back-btn">

⬅ Back To Dashboard

</button>

</a>

</div>

</nav>

<!-- MAIN -->

<div class="container-box">

<div class="title">

📜 Previous Election Records

</div>

<%

String deleteDate = request.getParameter("deleteDate");

if(deleteDate != null){

try{

    Connection delCon = DBConnection.getConnection();

    String deleteQuery =
    "DELETE FROM election_history " +
    "WHERE election_date=? AND district=?";

    PreparedStatement deletePs =
    delCon.prepareStatement(deleteQuery);

    deletePs.setTimestamp(1,
    Timestamp.valueOf(deleteDate));
    deletePs.setString(2, adminDistrict);

    deletePs.executeUpdate();

    deletePs.close();
    delCon.close();

    response.sendRedirect("history.jsp");
    return;

}catch(Exception e){

    out.println(
    "<div class='no-data'>Error : "
    + e.getMessage()
    + "</div>");
}

}

%>

<%

try{

    Connection con =
    DBConnection.getConnection();
    // GET DISTINCT RESET DATES

String resetQuery =
"SELECT DISTINCT election_date " +
"FROM election_history " +
"WHERE district=? " +
"ORDER BY election_date DESC";

PreparedStatement resetPs =
con.prepareStatement(resetQuery);

resetPs.setString(1, adminDistrict);

    ResultSet resetRs =
    resetPs.executeQuery();

    boolean hasData = false;

    while(resetRs.next()){

        hasData = true;

        Timestamp resetDate =
        resetRs.getTimestamp("election_date");

%>

<!-- ONE RESET BOX -->

<div class="reset-box">

<div class="reset-header">

<div class="reset-title">

🗳️ Election Reset :
<%= resetDate %>

</div>

<a href="history.jsp?deleteDate=<%= java.net.URLEncoder.encode(resetDate.toString(),"UTF-8") %>"
   onclick="return confirm('Delete this full reset history?')">

<button class="delete-btn">

Delete Full Reset

</button>

</a>

</div>

<%

// GET LOCATIONS OF THIS RESET

String locationQuery =
"SELECT DISTINCT country,state,district,location " +
"FROM election_history " +
"WHERE election_date=? " +
"AND district=? " +
"ORDER BY country,state,district,location";

PreparedStatement locationPs =
con.prepareStatement(locationQuery);

locationPs.setTimestamp(1, resetDate);
locationPs.setString(2, adminDistrict);
ResultSet locationRs =
locationPs.executeQuery();

while(locationRs.next()){
    
%>

<div class="location-title">

🌍 <%= locationRs.getString("country") %>

→

🏛 <%= locationRs.getString("state") %>

→

📌 <%= locationRs.getString("district") %>

→

📍 <%= locationRs.getString("location") %>

</div>

<table class="table table-bordered table-hover text-center">

<thead class="table-dark">

<tr>

<th>Candidate ID</th>
<th>Candidate Name</th>
<th>Party Name</th>
<th>Country</th>
<th>State</th>
<th>District</th>
<th>Location</th>
<th>Total Votes</th>

</tr>

</thead>

<tbody>

<%

String historyQuery =
"SELECT * FROM election_history " +
"WHERE election_date=? " +
"AND country=? " +
"AND state=? " +
"AND district=? " +
"AND location=?";

PreparedStatement historyPs =
con.prepareStatement(historyQuery);

historyPs.setTimestamp(1, resetDate);
historyPs.setString(2,
        locationRs.getString("country"));
historyPs.setString(3,
        locationRs.getString("state"));
historyPs.setString(4,
        locationRs.getString("district"));
historyPs.setString(5,
        locationRs.getString("location"));

ResultSet rs =
historyPs.executeQuery();

while(rs.next()){

%>

<tr>

<td><%= rs.getInt("candidate_id") %></td>

<td><%= rs.getString("candidate_name") %></td>

<td><%= rs.getString("party_name") %></td>

<td><%= rs.getString("country") %></td>

<td><%= rs.getString("state") %></td>

<td><%= rs.getString("district") %></td>

<td><%= rs.getString("location") %></td>

<td><%= rs.getInt("total_votes") %></td>

</tr>

<%

}
rs.close();
historyPs.close();
%>

</tbody>

</table>

<%

}

%>
<%
locationRs.close();
locationPs.close();
%>
</div>

<%

}

if(!hasData){

%>

<div class="no-data">

No Election History Available

</div>

<%

}
resetRs.close();
resetPs.close();
con.close();

}catch(Exception e){

%>

<div class="no-data">

Error :
<%= e.getMessage() %>

</div>

<%

}

%>

</div>
<!-- FOOTER -->

<div class="footer">

    Developed By 🚀

    <span>

        ANKIT KUMAR SHAH

    </span>

</div>
</body>

</html>