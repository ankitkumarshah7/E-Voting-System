package com.evoting;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/Addcandidate")
@MultipartConfig
public class Addcandidate extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        PrintWriter out = response.getWriter();

        try {

            HttpSession session = request.getSession();

            String country =
                    (String) session.getAttribute("country");

            String state =
                    (String) session.getAttribute("state");

            String district =
                    (String) session.getAttribute("district");

            String candidateName =
                    request.getParameter("candidate_name");

            String partyName =
                    request.getParameter("party_name");

            String location =
                    request.getParameter("location");

            Part filePart =
                    request.getPart("symbol");

            InputStream inputStream =
                    filePart.getInputStream();

            if (candidateName == null || candidateName.trim().isEmpty()
                    || partyName == null || partyName.trim().isEmpty()
                    || location == null || location.trim().isEmpty()) {

                out.println(
                        "<h2 style='color:red;text-align:center;margin-top:50px;'>All Fields Are Required</h2>");

                return;
            }

            try (Connection con = DBConnection.getConnection()) {
                String query =
                        "INSERT INTO candidate("
                        + "candidate_name,"
                        + "party_name,"
                        + "location,"
                        + "symbol,"
                        + "country,"
                        + "state,"
                        + "district"
                        + ") VALUES(?,?,?,?,?,?,?)";
                
                try (PreparedStatement ps = con.prepareStatement(query)) {
                    ps.setString(1, candidateName);
                    ps.setString(2, partyName);
                    ps.setString(3, location);
                    ps.setBlob(4, inputStream);
                    ps.setString(5, country);
                    ps.setString(6, state);
                    ps.setString(7, district);
                    
                    int x = ps.executeUpdate();
                    
                    if (x > 0) {
                        
                        response.sendRedirect(
                                "candidatelist.jsp");
                        
                    } else {
                        
                        out.println(
                                "<h2 style='color:red;text-align:center;margin-top:50px;'>Candidate Not Added</h2>");
                    }
                }
            }

        } catch (SQLException e) {

            out.println(
                    "<h2 style='color:red;text-align:center;margin-top:50px;'>"
                    + e.getMessage()
                    + "</h2>");
        }
    }
}