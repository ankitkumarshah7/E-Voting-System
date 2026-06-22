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
import jakarta.servlet.http.HttpSession;

@WebServlet("/AreaSelectionServlet")
public class AreaSelectionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String countryId =
                request.getParameter("country");

        String stateId =
                request.getParameter("state");

        String district =
                request.getParameter("district");

        try(Connection con =
                DBConnection.getConnection()) {

            String country = "";
            String state = "";

            PreparedStatement cps =
                    con.prepareStatement(
                            "SELECT country_name "
                            + "FROM country "
                            + "WHERE country_id=?");

            cps.setInt(1,
                    Integer.parseInt(countryId));

            ResultSet crs =
                    cps.executeQuery();

            if(crs.next()) {

                country =
                        crs.getString(
                                "country_name");
            }

            PreparedStatement sps =
                    con.prepareStatement(
                            "SELECT state_name "
                            + "FROM state "
                            + "WHERE state_id=?");

            sps.setInt(1,
                    Integer.parseInt(stateId));

            ResultSet srs =
                    sps.executeQuery();

            if(srs.next()) {

                state =
                        srs.getString(
                                "state_name");
            }

            HttpSession session =
                    request.getSession();

            session.setAttribute(
                    "country",
                    country);

            session.setAttribute(
                    "state",
                    state);

            session.setAttribute(
                    "district",
                    district);

            response.sendRedirect(
                    "index.jsp");

        } catch(Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    e.getMessage());
        }
    }
}