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

@WebServlet("/UpdateCandidate")
@MultipartConfig

public class UpdateCandidate extends HttpServlet {

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    try {

        HttpSession session =
                request.getSession();

        String district =
                (String) session.getAttribute("district");

        int candidate_id =
                Integer.parseInt(
                request.getParameter("candidate_id"));

        String candidate_name =
                request.getParameter("candidate_name");

        String party_name =
                request.getParameter("party_name");

        String location =
                request.getParameter("location");

        Part filePart =
                request.getPart("symbol");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps;
            
            if(filePart != null &&
                    filePart.getSize() > 0){
                
                InputStream inputStream =
                        filePart.getInputStream();
                
                String query =
                        
                        "UPDATE candidate SET " +
                        "candidate_name=?, " +
                        "party_name=?, " +
                        "location=?, " +
                        "symbol=? " +
                        "WHERE candidate_id=? " +
                        "AND district=?";
                
                ps =
                        con.prepareStatement(query);
                
                ps.setString(1,
                        candidate_name);
                
                ps.setString(2,
                        party_name);
                
                ps.setString(3,
                        location);
                
                ps.setBlob(4,
                        inputStream);
                
                ps.setInt(5,
                        candidate_id);
                
                ps.setString(6,
                        district);
                
            }else{
                
                String query =
                        
                        "UPDATE candidate SET " +
                        "candidate_name=?, " +
                        "party_name=?, " +
                        "location=? " +
                        "WHERE candidate_id=? " +
                        "AND district=?";
                
                ps =
                        con.prepareStatement(query);
                
                ps.setString(1,
                        candidate_name);
                
                ps.setString(2,
                        party_name);
                
                ps.setString(3,
                        location);
                
                ps.setInt(4,
                        candidate_id);
                
                ps.setString(5,
                        district);
            }
            
            int rows =
                    ps.executeUpdate();
            
            if(rows > 0){
                
                response.sendRedirect(
                        "candidatelist.jsp");
                
            }else{
                
                response.getWriter().println(
                        
                        "<h2 style='color:red;text-align:center;'>"
                                +
                                "Candidate not found in your district."
                                +
                                "</h2>"
                        
                );
            }
        }

    }catch(ServletException | IOException | NumberFormatException | SQLException e){


        response.getWriter().println(

        "<h3 style='color:red;'>"
        +
        e.getMessage()
        +
        "</h3>"

        );
    }
}


}
