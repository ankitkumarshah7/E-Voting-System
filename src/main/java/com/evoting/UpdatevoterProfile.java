package com.evoting;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.SQLException;

@WebServlet("/UpdatevoterProfile")
@MultipartConfig
public class UpdatevoterProfile extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        int voter_id =
                Integer.parseInt(
                        session.getAttribute("voter_id").toString());

        String full_name =
                request.getParameter("full_name");

        String gender =
                request.getParameter("gender");

        int age =
                Integer.parseInt(
                        request.getParameter("age"));

        String mobile =
                request.getParameter("mobile");

        String email =
                request.getParameter("email");

        String address =
                request.getParameter("address");

        String newLocation =
                request.getParameter("location");

        String oldLocation =
                request.getParameter("old_location");

        String district =
                request.getParameter("district");

        Part filePart =
                request.getPart("photo");

        try {

            Connection con =
                    DBConnection.getConnection();

           // ==================================
// LOCATION CHANGED
// ==================================

if (!newLocation.equalsIgnoreCase(oldLocation)) {

    // CHECK IF ALREADY PENDING

    String checkQuery =
    "SELECT voter_id FROM voter_requests "
    + "WHERE voter_id=? "
    + "AND request_status='Pending' "
    + "AND request_type='LOCATION_CHANGE'";

    PreparedStatement checkPs =
    con.prepareStatement(checkQuery);

    checkPs.setInt(1, voter_id);

    java.sql.ResultSet checkRs =
    checkPs.executeQuery();

    if(checkRs.next()){

        response.getWriter().println(

        "<script>"
        + "alert('Your previous location change request is still pending for admin approval');"
        + "window.location='voterpage.jsp';"
        + "</script>"

        );

        return;
    }

    // INSERT NEW LOCATION CHANGE REQUEST

    String requestQuery =
    "INSERT INTO voter_requests("
    + "voter_id,"
    + "full_name,"
    + "gender,"
    + "age,"
    + "mobile,"
    + "email,"
    + "address,"
    + "district,"
    + "location,"
    + "request_status,"
    + "request_type"
    + ") VALUES(?,?,?,?,?,?,?,?,?,'Pending','LOCATION_CHANGE')";

    PreparedStatement reqPs =
    con.prepareStatement(requestQuery);

    reqPs.setInt(1, voter_id);
    reqPs.setString(2, full_name);
    reqPs.setString(3, gender);
    reqPs.setInt(4, age);
    reqPs.setString(5, mobile);
    reqPs.setString(6, email);
    reqPs.setString(7, address);
    reqPs.setString(8, district);
    reqPs.setString(9, newLocation);

    reqPs.executeUpdate();

    session.setAttribute("full_name", full_name);
    session.setAttribute("email", email);

    response.getWriter().println(

    "<script>"
    + "alert('Location change request sent to admin for approval');"
    + "window.location='voterpage.jsp';"
    + "</script>"

    );

    return;
}

            // ==================================
            // NORMAL PROFILE UPDATE
            // ==================================

            PreparedStatement ps;

            if (filePart != null
                    && filePart.getSize() > 0) {

                InputStream inputStream =
                        filePart.getInputStream();

                String query =
                        "UPDATE voter SET "
                        + "full_name=?,"
                        + "gender=?,"
                        + "age=?,"
                        + "mobile=?,"
                        + "email=?,"
                        + "address=?,"
                        + "photo=? "
                        + "WHERE voter_id=?";

                ps = con.prepareStatement(query);

                ps.setString(1, full_name);
                ps.setString(2, gender);
                ps.setInt(3, age);
                ps.setString(4, mobile);
                ps.setString(5, email);
                ps.setString(6, address);
                ps.setBlob(7, inputStream);
                ps.setInt(8, voter_id);

            } else {

                String query =
                        "UPDATE voter SET "
                        + "full_name=?,"
                        + "gender=?,"
                        + "age=?,"
                        + "mobile=?,"
                        + "email=?,"
                        + "address=? "
                        + "WHERE voter_id=?";

                ps = con.prepareStatement(query);

                ps.setString(1, full_name);
                ps.setString(2, gender);
                ps.setInt(3, age);
                ps.setString(4, mobile);
                ps.setString(5, email);
                ps.setString(6, address);
                ps.setInt(7, voter_id);
            }

            int i = ps.executeUpdate();

            if (i > 0) {

                session.setAttribute(
                        "full_name",
                        full_name);

                session.setAttribute(
                        "email",
                        email);

                response.sendRedirect(
                        "voterpage.jsp");

            } else {

                response.getWriter().println(
                        "Profile Not Updated");
            }

        } catch (IOException | SQLException e) {

            response.getWriter().println(e);
        }
    }
}