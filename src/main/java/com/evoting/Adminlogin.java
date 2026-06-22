package com.evoting;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Adminlogin")
public class Adminlogin extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {

            try (Connection con = DBConnection.getConnection()) {
                String query =
                        "SELECT * FROM admin WHERE username=? AND password=?";
                
                PreparedStatement ps =
                        con.prepareStatement(query);
                
                ps.setString(1, username);
                ps.setString(2, password);
                
                ResultSet rs = ps.executeQuery();
                
                if(rs.next()) {
                    
                    HttpSession session =
                            request.getSession();
                    
                    // Admin Information
                    session.setAttribute(
                            "admin_id",
                            rs.getInt("admin_id"));
                    
                    session.setAttribute(
                            "admin",
                            rs.getString("username"));
                    
                    // Area Information
                    session.setAttribute(
                            "country",
                            rs.getString("country"));
                    
                    session.setAttribute(
                            "state",
                            rs.getString("state"));
                    
                    session.setAttribute(
                            "district",
                            rs.getString("district"));
                    
                    response.sendRedirect(
                            "admindashboard.jsp");
                    
                }
                else {
                    
                    out.println(
                            "<script>"
                                    + "alert('Invalid Username or Password');"
                                    + "window.location='Adminlogin.html';"
                                    + "</script>");
                    
                }
                
                rs.close();
                ps.close();
            }

        }
        catch(SQLException e) {

            out.println(
            "<h3 style='color:red'>"
            + e.getMessage()
            + "</h3>");

        }
    }
}