package com.evoting;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ShowImage")

public class ShowImage extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Connection con =
                    DBConnection.getConnection();

            byte[] imgData = null;

            // CANDIDATE IMAGE

            String candidateId =
                    request.getParameter("candidate_id");

            // VOTER IMAGE

            String voterId =
                    request.getParameter("voter_id");

            if(candidateId != null){

                String query =
                "SELECT symbol FROM candidate WHERE candidate_id=?";

                PreparedStatement ps =
                        con.prepareStatement(query);

                ps.setInt(1,
                Integer.parseInt(candidateId));

                ResultSet rs =
                        ps.executeQuery();

                if(rs.next()){

                    imgData =
                    rs.getBytes("symbol");
                }

            }else if(voterId != null){

                String query =
                "SELECT photo FROM voter WHERE voter_id=?";

                PreparedStatement ps =
                        con.prepareStatement(query);

                ps.setInt(1,
                Integer.parseInt(voterId));

                ResultSet rs =
                        ps.executeQuery();

                if(rs.next()){

                    imgData =
                    rs.getBytes("photo");
                }
            }

            if(imgData != null){

                response.setContentType(
                        "image/jpeg"
                );

                OutputStream os =
                        response.getOutputStream();

                os.write(imgData);

                os.flush();

                os.close();
            }

        }catch(Exception e){

            e.printStackTrace();
        }
    }
}