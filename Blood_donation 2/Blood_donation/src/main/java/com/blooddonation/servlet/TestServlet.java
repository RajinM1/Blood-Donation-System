package com.blooddonation.servlet;

import com.blooddonation.dao.FeedbackDAO;
import com.blooddonation.util.DatabaseUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Test</title></head><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        try {
            // Test database connection
            Connection conn = DatabaseUtil.getConnection();
            if (conn != null) {
                out.println("<p style='color: green;'>✓ Database connection successful</p>");
                
                // Test if feedback table exists
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SHOW TABLES LIKE 'feedback'");
                if (rs.next()) {
                    out.println("<p style='color: green;'>✓ Feedback table exists</p>");
                    
                    // Test if table has data
                    ResultSet countRs = stmt.executeQuery("SELECT COUNT(*) as count FROM feedback");
                    if (countRs.next()) {
                        int count = countRs.getInt("count");
                        out.println("<p style='color: blue;'>ℹ Feedback table has " + count + " records</p>");
                    }
                } else {
                    out.println("<p style='color: red;'>✗ Feedback table does not exist</p>");
                }
                
                // Test FeedbackDAO
                FeedbackDAO feedbackDAO = new FeedbackDAO();
                try {
                    var feedbacks = feedbackDAO.getAllFeedback();
                    out.println("<p style='color: green;'>✓ FeedbackDAO.getAllFeedback() works - found " + feedbacks.size() + " records</p>");
                } catch (Exception e) {
                    out.println("<p style='color: red;'>✗ FeedbackDAO.getAllFeedback() failed: " + e.getMessage() + "</p>");
                }
                
                conn.close();
            } else {
                out.println("<p style='color: red;'>✗ Database connection failed</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>✗ Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("</body></html>");
    }
}
