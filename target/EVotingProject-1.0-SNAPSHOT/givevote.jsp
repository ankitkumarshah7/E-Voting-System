<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>

<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%

// SESSION CHECK

if(session.getAttribute("voter_id")==null){

    response.sendRedirect("voterlogin.html");

    return;
}

// GET MESSAGE

String message =
(String)request.getAttribute("message");

%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Vote Page</title>

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
}

.title{

    text-align:center;

    color:white;

    font-size:45px;

    font-weight:bold;

    margin-bottom:20px;
}

.message-box{

    width:50%;

    margin:auto;

    margin-bottom:30px;
}

.card-box{

    background:white;

    border-radius:25px;

    padding:25px;

    text-align:center;

    box-shadow:0px 0px 20px rgba(0,0,0,0.3);

    transition:0.3s;

    margin-bottom:30px;
}

.card-box:hover{

    transform:translateY(-8px);
}

.candidate-img{

    width:120px;

    height:120px;

    border-radius:50%;

    object-fit:cover;

    margin-bottom:15px;

    border:4px solid #0d6efd;
}

.candidate-name{

    font-size:28px;

    font-weight:bold;

    margin-bottom:10px;
}

.party-name{

    font-size:18px;

    margin-bottom:10px;
}

.location-name{

    font-size:16px;

    font-weight:bold;

    color:#0d6efd;

    margin-bottom:20px;
}

.btn-vote{

    width:100%;

    border-radius:10px;

    padding:10px;

    font-weight:bold;

    font-size:18px;
}

.vote-closed{

    background:white;

    padding:20px;

    border-radius:15px;

    text-align:center;

    font-size:24px;

    font-weight:bold;

    color:red;

    margin-bottom:30px;
}

.no-candidate{

    background:white;

    padding:20px;

    border-radius:15px;

    text-align:center;

    font-size:22px;

    font-weight:bold;

    color:#dc3545;

    margin-top:30px;
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

<a href="voterpage.jsp"
class="btn btn-light">

Back

</a>

</div>

</nav>

<!-- MAIN -->

<div class="container-box">

<div class="title">

Vote Your Favorite Candidate

</div>

<!-- MESSAGE -->

<%

if(message != null){

%>

<div class="message-box">

<div class="alert alert-warning text-center">

<%= message %>

</div>

</div>

<%

}

%>

<%

try{

    Connection con =
            DBConnection.getConnection();

    // GET VOTER ID

    int voterId =
            Integer.parseInt(
            session.getAttribute("voter_id").toString()
            );

    // GET VOTER LOCATION

   String voterCountry = "";
String voterState = "";
String voterDistrict = "";
String voterLocation = "";

String voterQuery =
"SELECT country,state,district,location,has_voted "
+ "FROM voter WHERE voter_id=?";

    PreparedStatement voterPs =
            con.prepareStatement(voterQuery);

    voterPs.setInt(1, voterId);

    ResultSet voterRs =
            voterPs.executeQuery();

    int hasVoted = 0;

   if(voterRs.next()){

    voterCountry =
    voterRs.getString("country");

    voterState =
    voterRs.getString("state");

    voterDistrict =
    voterRs.getString("district");

    voterLocation =
    voterRs.getString("location");

    hasVoted =
    voterRs.getInt("has_voted");
}

    // CHECK VOTING STATUS

   String statusQuery =
"SELECT voting_status FROM election_status " +
"WHERE country=? AND state=? AND district=?";

   PreparedStatement ps1 =
con.prepareStatement(statusQuery);

ps1.setString(1, voterCountry);
ps1.setString(2, voterState);
ps1.setString(3, voterDistrict);

    ResultSet rs1 =
            ps1.executeQuery();

    String votingStatus =
            "stopped";

    if(rs1.next()){

        votingStatus =
        rs1.getString("voting_status");
    }

    // IF VOTING STOPPED

    if(!votingStatus.equalsIgnoreCase("started")){

%>

<div class="vote-closed">

Voting Is Currently Closed

</div>

<%

    }

    // IF ALREADY VOTED

    else if(hasVoted == 1){

%>

<div class="vote-closed"
style="color:green;">

You Have Already Submitted Your Vote

</div>

<%

    }

    else {

%>

<div class="row">

<%

    // SHOW ONLY SAME LOCATION CANDIDATES

   String query =
"SELECT * FROM candidate "
+ "WHERE country=? "
+ "AND state=? "
+ "AND district=? "
+ "AND location=?";

    PreparedStatement ps =
con.prepareStatement(query);

ps.setString(1, voterCountry);
ps.setString(2, voterState);
ps.setString(3, voterDistrict);
ps.setString(4, voterLocation);

    ResultSet rs =
            ps.executeQuery();

    boolean found = false;

    while(rs.next()){

        found = true;

%>

<!-- CANDIDATE CARD -->

<div class="col-md-4">

<div class="card-box">

<img src=
"ShowImage?candidate_id=<%= rs.getInt("candidate_id") %>"
class="candidate-img">

<div class="candidate-name">

<%= rs.getString("candidate_name") %>

</div>

<div class="party-name">

Party :
<%= rs.getString("party_name") %>

</div>

<div class="location-name">

🌍 <%= rs.getString("country") %><br>

🏛 <%= rs.getString("state") %><br>

📍 <%= rs.getString("district") %><br>

📌 <%= rs.getString("location") %>

</div>

<form action="GiveVote"
method="post">

<input type="hidden"
name="candidate_id"
value="<%= rs.getInt("candidate_id") %>">

<button type="submit"
class="btn btn-success btn-vote">

Vote Now

</button>

</form>

</div>

</div>

<%

    }

    // NO CANDIDATE FOUND

    if(!found){

%>

<div class="no-candidate">

No Candidate Available For Your Location

</div>

<%

    }

%>

</div>

<%

    }

    con.close();

}catch(Exception e){

%>

<div class="alert alert-danger text-center">

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