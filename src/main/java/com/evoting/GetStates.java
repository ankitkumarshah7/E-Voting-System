package com.evoting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GetStates")
public class GetStates extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String countryId =
                request.getParameter("country_id");

        try(Connection con =
                DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement(
                            "SELECT * FROM state "
                            + "WHERE country_id=? "
                            + "ORDER BY state_name");

            ps.setInt(1,
                    Integer.parseInt(countryId));

            ResultSet rs =
                    ps.executeQuery();

            StringBuilder sb =
                    new StringBuilder();

            sb.append(
                    "<option value=''>Select State</option>");

            while(rs.next()) {

                sb.append(
                        "<option value='")
                        .append(rs.getInt("state_id"))
                        .append("'>")
                        .append(rs.getString("state_name"))
                        .append("</option>");
            }

            response.getWriter().print(
                    sb.toString());

        } catch(Exception e) {

            e.printStackTrace();

            response.getWriter().print(
                    "<option>Error Loading States</option>");
        }
    }
}