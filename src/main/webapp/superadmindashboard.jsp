<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<title>Super Admin Dashboard</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

    margin:0;
    padding:0;

    font-family:Arial,sans-serif;

    background:
    linear-gradient(
    rgba(0,0,0,0.70),
    rgba(0,0,0,0.70)
    ),

    url('https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?q=80&w=1600&auto=format&fit=crop');

    background-size:cover;
    background-position:center;

    min-height:100vh;
}

.header{

    background:rgba(0,0,0,0.5);

    padding:20px 40px;
}

.title{

    color:white;

    font-size:40px;

    font-weight:bold;

    text-align:center;
}

.logout-btn{

    float:right;
}

.container-box{

    width:90%;

    margin:auto;

    padding-top:40px;
}

.card-box{

    background:white;

    border-radius:25px;

    padding:30px;

    text-align:center;

    box-shadow:0px 0px 20px rgba(0,0,0,0.3);

    transition:0.3s;

    margin-bottom:30px;

    height:220px;
}

.card-box:hover{

    transform:translateY(-10px);

    box-shadow:0px 10px 30px rgba(0,0,0,0.4);
}

.icon{

    font-size:55px;

    margin-bottom:15px;
}

.card-title{

    font-size:24px;

    font-weight:bold;

    margin-bottom:20px;
}

.card-btn{

    width:100%;

    border-radius:10px;

    font-weight:bold;
}

.footer{

    text-align:center;

    color:white;

    font-size:18px;

    font-weight:bold;

    margin-top:30px;

    padding-bottom:20px;
}

</style>

</head>

<body>

<div class="header">

<a href="Logout">

<button class="btn btn-danger logout-btn">

🚪 Logout

</button>

</a>

<div class="title">

🌍 Super Admin Dashboard

</div>

</div>

<div class="container-box">

<div class="row">

<div class="col-md-4">

<div class="card-box">

<div class="icon">🌎</div>

<div class="card-title">

Add Country

</div>

<a href="addcountry.jsp">

<button class="btn btn-primary card-btn">

Open

</button>

</a>

</div>

</div>

<div class="col-md-4">

<div class="card-box">

<div class="icon">🏛️</div>

<div class="card-title">

Add State

</div>

<a href="addstate.jsp">

<button class="btn btn-success card-btn">

Open

</button>

</a>

</div>

</div>

<div class="col-md-4">

<div class="card-box">

<div class="icon">📍</div>

<div class="card-title">

Add District

</div>

<a href="adddistrict.jsp">

<button class="btn btn-warning card-btn">

Open

</button>

</a>

</div>

</div>

</div>

<div class="row">

<div class="col-md-4">

<div class="card-box">

<div class="icon">👨‍💼</div>

<div class="card-title">

Create District Admin

</div>

<a href="createadmin.jsp">

<button class="btn btn-dark card-btn">

Open

</button>

</a>

</div>

</div>

<div class="col-md-4">

<div class="card-box">

<div class="icon">👀</div>

<div class="card-title">

View District Admins

</div>

<a href="viewadmin.jsp">

<button class="btn btn-secondary card-btn">

Open

</button>

</a>

</div>

</div>

<div class="col-md-4">

<div class="card-box">

<div class="icon">🗺️</div>

<div class="card-title">

View All Areas

</div>

<a href="viewareas.jsp">

<button class="btn btn-info card-btn">

Open

</button>

</a>

</div>

</div>

</div>

<div class="footer">

Developed By 🚀 ANKIT KUMAR SHAH

</div>

</div>

</body>
</html>