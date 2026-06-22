<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>

<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%

String from = request.getParameter("from");

String backPage = "index.jsp";

if(from != null && from.equals("voter")){

    backPage = "voterpage.jsp";
}

%>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Election Result</title>

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

    url('https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?q=80&w=1400&auto=format&fit=crop');

    background-size:cover;
    background-position:center;

    min-height:100vh;
}

.navbar{

    background:rgba(0,0,0,0.6);

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
}

.result-box{

    background:white;

    border-radius:25px;

    padding:30px;

    box-shadow:0px 0px 20px rgba(0,0,0,0.3);

    margin-bottom:40px;
}

.location-title{

    font-size:35px;

    font-weight:bold;

    text-align:center;

    margin-bottom:25px;

    color:#0d6efd;
}

.winner-box{

    background:#198754;

    color:white;

    padding:20px;

    border-radius:20px;

    text-align:center;

    margin-bottom:30px;
}

.hidden-box{

    background:white;

    padding:40px;

    border-radius:25px;

    text-align:center;

    font-size:28px;

    font-weight:bold;

    color:red;

    box-shadow:0px 0px 20px rgba(0,0,0,0.3);
}

.table{

    margin-top:20px;
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

🗳️ Online E-Voting System

</span>

<a href="<%= backPage %>">

<button class="btn btn-light">

Back

</button>

</a>

</div>

</nav>

<!-- MAIN -->

<div class="container-box">

<div class="title">

Election Result

</div>

<%

try{

    Connection con =
            DBConnection.getConnection();
String country =
(String)session.getAttribute("country");

String state =
(String)session.getAttribute("state");

String district =
(String)session.getAttribute("district");
    // CHECK RESULT STATUS

   String statusQuery =
"SELECT result_status " +
"FROM election_status " +
"WHERE country=? " +
"AND state=? " +
"AND district=?";

    PreparedStatement statusPs =
con.prepareStatement(statusQuery);

statusPs.setString(1, country);
statusPs.setString(2, state);
statusPs.setString(3, district);

    ResultSet statusRs =
            statusPs.executeQuery();

    String resultStatus =
            "hidden";

    if(statusRs.next()){

        resultStatus =
        statusRs.getString("result_status");
    }

    // IF RESULT HIDDEN

    if(resultStatus.equalsIgnoreCase("hidden")){

%>

<div class="hidden-box">

📢 Result Has Not Been Published Yet

</div>

<%

    }else{

        // GET ALL LOCATIONS

        String locationQuery =
"SELECT DISTINCT location FROM result_view WHERE country=? AND state=? AND district=?";

PreparedStatement locationPs =
con.prepareStatement(locationQuery);

locationPs.setString(1, country);
locationPs.setString(2, state);
locationPs.setString(3, district);

ResultSet locationRs =
locationPs.executeQuery();

        while(locationRs.next()){

            String location =
            locationRs.getString("location");

%>

<!-- LOCATION RESULT -->

<div class="result-box">

<div class="location-title">

📍 <%= location %> Election Result

</div>

<%

// GET LOCATION WINNER

String winnerQuery =
"SELECT * FROM result_view WHERE country=? AND state=? AND district=? AND location=? ORDER BY total_votes DESC LIMIT 1";

PreparedStatement winnerPs =
con.prepareStatement(winnerQuery);

winnerPs.setString(1, country);
winnerPs.setString(2, state);
winnerPs.setString(3, district);
winnerPs.setString(4, location);


ResultSet winnerRs =
        winnerPs.executeQuery();

if(winnerRs.next()){

%>

<div class="winner-box">

<h2>

🏆 Winner :
<%= winnerRs.getString("candidate_name") %>

</h2>

<h4>

Party :
<%= winnerRs.getString("party_name") %>

</h4>

<h5>

Total Votes :
<%= winnerRs.getInt("total_votes") %>

</h5>

</div>

<%

}

%>

<!-- RESULT TABLE -->

<table class="table table-bordered table-striped text-center">

<thead class="table-dark">

<tr>

<th>Candidate ID</th>

<th>Candidate Name</th>

<th>Party Name</th>

<th>Total Votes</th>

</tr>

</thead>

<tbody>

<%

String resultQuery =
"SELECT * FROM result_view WHERE country=? AND state=? AND district=? AND location=? ORDER BY total_votes DESC";

PreparedStatement resultPs =
con.prepareStatement(resultQuery);

resultPs.setString(1, country);
resultPs.setString(2, state);
resultPs.setString(3, district);
resultPs.setString(4, location);


ResultSet rs =
        resultPs.executeQuery();

while(rs.next()){

%>

<tr>

<td>

<%= rs.getInt("candidate_id") %>

</td>

<td>

<%= rs.getString("candidate_name") %>

</td>

<td>

<%= rs.getString("party_name") %>

</td>

<td>

<%= rs.getInt("total_votes") %>

</td>

</tr>

<%

}
rs.close();
    resultPs.close();

    winnerRs.close();
    winnerPs.close();
%>

</tbody>

</table>

</div>

<%

        }

    }

    con.close();

}catch(Exception e){

%>

<div class="hidden-box">

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