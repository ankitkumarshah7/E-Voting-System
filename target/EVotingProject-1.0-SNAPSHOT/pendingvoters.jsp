<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String adminDistrict =
(String)session.getAttribute("district");

if(adminDistrict == null){

    response.sendRedirect("Adminlogin.html");
    return;
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Pending Voter Requests</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

    font-family:Arial,sans-serif;

    background:#f5f5f5;

    margin:0;
    padding:0;
}

.container-box{

    width:95%;

    margin:auto;

    margin-top:30px;

    margin-bottom:40px;
}

.top-bar{

    display:flex;

    justify-content:space-between;

    align-items:center;

    margin-bottom:30px;
}

.page-title{

    font-size:40px;

    font-weight:bold;

    color:#333;
}

.back-btn{

    background:#0d6efd;

    color:white;

    border:none;

    padding:10px 20px;

    border-radius:10px;

    text-decoration:none;

    font-weight:bold;
}

.location-box{

    background:white;

    padding:25px;

    border-radius:20px;

    margin-bottom:40px;

    box-shadow:0px 0px 10px gray;
}

.location-title{

    font-size:30px;

    font-weight:bold;

    margin-bottom:20px;

    color:#0d6efd;
}

table{

    width:100%;

    border-collapse:collapse;
}

th,td{

    border:1px solid #ddd;

    padding:12px;

    text-align:center;
}

th{

    background:#343a40;

    color:white;
}

img{

    width:80px;

    height:80px;

    object-fit:cover;

    border-radius:10px;
}

.footer{

    width:100%;

    background:rgba(0,0,0,0.85);

    color:white;

    text-align:center;

    padding:15px;

    font-size:18px;

    font-weight:bold;

    margin-top:40px;
}

.footer span{

    color:#00bfff;

    font-size:20px;
}

</style>

</head>

<body>

<div class="container-box">

<div class="top-bar">

<div class="page-title">

🗳 Pending Voter Requests

</div>

<a href="admindashboard.jsp"
class="back-btn">

⬅ Back Dashboard

</a>

</div>

<%

// APPROVE

String approveId =
request.getParameter("approveId");

if(approveId != null){

try{

Connection con =
DBConnection.getConnection();

PreparedStatement ps =
con.prepareStatement(
"SELECT * FROM voter_requests WHERE voter_id=? AND district=?"
);

ps.setInt(1,
Integer.parseInt(approveId));

ps.setString(2,
adminDistrict);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

    String requestType =
rs.getString("request_type");

// LOCATION CHANGE REQUEST

if("LOCATION_CHANGE".equalsIgnoreCase(requestType)){

    PreparedStatement updatePs =
    con.prepareStatement(

    "UPDATE voter SET " +
    "full_name=?," +
    "gender=?," +
    "age=?," +
    "mobile=?," +
    "email=?," +
    "address=?," +
    "country=?," +
    "state=?," +
    "district=?," +
    "location=? " +
    "WHERE voter_id=?"

    );

    updatePs.setString(1,
    rs.getString("full_name"));

    updatePs.setString(2,
    rs.getString("gender"));

    updatePs.setInt(3,
    rs.getInt("age"));

    updatePs.setString(4,
    rs.getString("mobile"));

    updatePs.setString(5,
    rs.getString("email"));

    updatePs.setString(6,
    rs.getString("address"));

   updatePs.setString(7,
rs.getString("country"));

updatePs.setString(8,
rs.getString("state"));

updatePs.setString(9,
rs.getString("district"));

updatePs.setString(10,
rs.getString("location"));

updatePs.setInt(11,
rs.getInt("voter_id"));

    updatePs.executeUpdate();

}else{

    // NEW REGISTRATION

    PreparedStatement insertPs =
con.prepareStatement(

"INSERT INTO voter(" +
"full_name," +
"password," +
"gender," +
"age," +
"mobile," +
"email," +
"address," +
"country," +
"state," +
"district," +
"location," +
"photo," +
"status," +
"has_voted," +
"login_attempt" +
") VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

);

    insertPs.setString(1,
rs.getString("full_name"));

insertPs.setString(2,
rs.getString("password"));

insertPs.setString(3,
rs.getString("gender"));

insertPs.setInt(4,
rs.getInt("age"));

insertPs.setString(5,
rs.getString("mobile"));

insertPs.setString(6,
rs.getString("email"));

insertPs.setString(7,
rs.getString("address"));

insertPs.setString(8,
rs.getString("country"));

insertPs.setString(9,
rs.getString("state"));

insertPs.setString(10,
rs.getString("district"));

insertPs.setString(11,
rs.getString("location"));

insertPs.setBytes(12,
rs.getBytes("photo"));

insertPs.setString(13,
"inactive");

insertPs.setBoolean(14,
false);

insertPs.setInt(15,
0);

    insertPs.executeUpdate();
}

// DELETE REQUEST AFTER APPROVAL

PreparedStatement deletePs =
con.prepareStatement(
"DELETE FROM voter_requests WHERE voter_id=?"
);

deletePs.setInt(1,
Integer.parseInt(approveId));

deletePs.executeUpdate();
}

response.sendRedirect("pendingvoters.jsp");

}catch(Exception e){

out.println(e);
}
}

// DENY

String denyId =
request.getParameter("denyId");

if(denyId != null){

try{

Connection con =
DBConnection.getConnection();

PreparedStatement ps =
con.prepareStatement(

"DELETE FROM voter_requests " +
"WHERE voter_id=? AND district=?"

);

ps.setInt(1,
Integer.parseInt(denyId));

ps.setString(2,
adminDistrict);

ps.executeUpdate();

response.sendRedirect(
"pendingvoters.jsp");

}catch(Exception e){

out.println(e);
}
}
%>

<%

try{

Connection con =
DBConnection.getConnection();

PreparedStatement locPs =
con.prepareStatement(

"SELECT DISTINCT location " +
"FROM voter_requests " +
"WHERE district=? " +
"AND request_status='Pending' " +
"ORDER BY location"

);

locPs.setString(1,
adminDistrict);

ResultSet locRs =
locPs.executeQuery();

while(locRs.next()){

String location =
locRs.getString("location");

%>

<div class="location-box">

<div class="location-title">

📍 <%=location%>

</div>

<table>

<tr>

<th>ID</th>

<th>Name</th>

<th>Gender</th>

<th>Age</th>

<th>Mobile</th>

<th>Email</th>

<th>District</th>

<th>Location</th>

<th>Photo</th>

<th>Request Type</th>

<th>Approve</th>

<th>Deny</th>

</tr>

<%

PreparedStatement voterPs =
con.prepareStatement(

"SELECT * FROM voter_requests " +
"WHERE district=? " +
"AND location=? " +
"AND request_status='Pending'"

);

voterPs.setString(1,
adminDistrict);

voterPs.setString(2,
location);

ResultSet rs =
voterPs.executeQuery();

while(rs.next()){

%>

<tr>

<td>
<%=rs.getInt("voter_id")%>
</td>

<td>
<%=rs.getString("full_name")%>
</td>

<td>
<%=rs.getString("gender")%>
</td>

<td>
<%=rs.getInt("age")%>
</td>

<td>
<%=rs.getString("mobile")%>
</td>

<td>
<%=rs.getString("email")%>
</td>

<td>
<%=rs.getString("district")%>
</td>

<td>
<%=rs.getString("location")%>
</td>

<td>

<img src=
"ShowImage?voter_id=<%=rs.getInt("voter_id")%>">

</td>
<td>

<%=rs.getString("request_type")%>

</td>
<td>

<a href=
"pendingvoters.jsp?approveId=<%=rs.getInt("voter_id")%>">

<button class="btn btn-success">

Approve

</button>

</a>

</td>

<td>

<a href=
"pendingvoters.jsp?denyId=<%=rs.getInt("voter_id")%>"
onclick=
"return confirm('Reject this voter?')">

<button class="btn btn-danger">

Deny

</button>

</a>

</td>

</tr>

<%
}
%>

</table>

</div>

<%
}

con.close();

}catch(Exception e){

out.println(e);
}
%>

</div>

<div class="footer">

Developed By 🚀

<span>

ANKIT KUMAR SHAH

</span>

</div>

</body>
</html>