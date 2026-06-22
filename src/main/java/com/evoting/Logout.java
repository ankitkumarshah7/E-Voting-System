package com.evoting;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Logout")
public class Logout extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // DESTROY SESSION

        HttpSession session =
                request.getSession(false);

        if (session != null) {

            session.invalidate();
        }

        // REMOVE ALL COOKIES

        Cookie[] cookies =
                request.getCookies();

        if (cookies != null) {

            for (Cookie cookie : cookies) {

                cookie.setValue("");
                cookie.setPath("/");
                cookie.setMaxAge(0);

                response.addCookie(cookie);
            }
        }

        // SUCCESS MESSAGE + REDIRECT

        response.setContentType(
                "text/html;charset=UTF-8");

        response.getWriter().println(
                "<script>"
                + "alert('You Logged Out Successfully');"
                + "window.location='index.jsp';"
                + "</script>");
    }
}