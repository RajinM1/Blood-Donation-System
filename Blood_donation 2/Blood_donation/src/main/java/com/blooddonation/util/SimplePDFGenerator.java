package com.blooddonation.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Simple PDF Generator using basic HTML to PDF conversion
 * This is a fallback implementation that creates simple PDF reports
 */
public class SimplePDFGenerator {
    
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");
    private static final SimpleDateFormat DATETIME_FORMAT = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    
    /**
     * Generate a simple HTML report that can be converted to PDF
     */
    public static String generateHTMLReport(List<Map<String, Object>> data, String title, String[] headers) {
        StringBuilder html = new StringBuilder();
        
        html.append("<!DOCTYPE html>");
        html.append("<html><head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<title>").append(title).append("</title>");
        html.append("<style>");
        html.append("body { font-family: Arial, sans-serif; margin: 20px; }");
        html.append("h1 { color: #e74c3c; text-align: center; }");
        html.append("h2 { color: #2c3e50; border-bottom: 2px solid #e74c3c; }");
        html.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        html.append("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        html.append("th { background-color: #e74c3c; color: white; }");
        html.append("tr:nth-child(even) { background-color: #f2f2f2; }");
        html.append(".report-date { text-align: center; color: #7f8c8d; margin: 10px 0; }");
        html.append("</style>");
        html.append("</head><body>");
        
        html.append("<h1>").append(title).append("</h1>");
        html.append("<div class='report-date'>Generated on: ").append(DATETIME_FORMAT.format(new Date())).append("</div>");
        
        if (data != null && !data.isEmpty()) {
            html.append("<table>");
            html.append("<thead><tr>");
            for (String header : headers) {
                html.append("<th>").append(header).append("</th>");
            }
            html.append("</tr></thead>");
            html.append("<tbody>");
            
            for (Map<String, Object> row : data) {
                html.append("<tr>");
                for (String header : headers) {
                    Object value = row.get(header.toLowerCase().replace(" ", ""));
                    html.append("<td>").append(value != null ? value.toString() : "").append("</td>");
                }
                html.append("</tr>");
            }
            
            html.append("</tbody></table>");
        } else {
            html.append("<p>No data available for this report.</p>");
        }
        
        html.append("</body></html>");
        
        return html.toString();
    }
    
    /**
     * Generate blood stock HTML report
     */
    public static String generateBloodStockHTML(List<Map<String, Object>> stockData) {
        String[] headers = {"Blood Group", "Quantity", "Expiry Date", "Status"};
        return generateHTMLReport(stockData, "Blood Stock Report", headers);
    }
    
    /**
     * Generate donor HTML report
     */
    public static String generateDonorHTML(List<Map<String, Object>> donorData) {
        String[] headers = {"Name", "Blood Group", "Age", "Gender", "Last Donation"};
        return generateHTMLReport(donorData, "Donor Report", headers);
    }
    
    /**
     * Generate blood request HTML report
     */
    public static String generateBloodRequestHTML(List<Map<String, Object>> requestData) {
        String[] headers = {"Hospital", "Blood Group", "Quantity", "Urgency", "Status", "Request Date"};
        return generateHTMLReport(requestData, "Blood Request Report", headers);
    }
    
    /**
     * Generate system overview HTML report
     */
    public static String generateSystemHTML(Map<String, Object> reportData) {
        StringBuilder html = new StringBuilder();
        
        html.append("<!DOCTYPE html>");
        html.append("<html><head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<title>Blood Donation System Report</title>");
        html.append("<style>");
        html.append("body { font-family: Arial, sans-serif; margin: 20px; }");
        html.append("h1 { color: #e74c3c; text-align: center; }");
        html.append("h2 { color: #2c3e50; border-bottom: 2px solid #e74c3c; }");
        html.append(".summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0; }");
        html.append(".summary-item { background: #f8f9fa; padding: 15px; border-radius: 5px; text-align: center; }");
        html.append(".summary-item h3 { color: #e74c3c; margin: 0 0 10px 0; }");
        html.append(".summary-item .number { font-size: 24px; font-weight: bold; color: #2c3e50; }");
        html.append(".report-date { text-align: center; color: #7f8c8d; margin: 10px 0; }");
        html.append("</style>");
        html.append("</head><body>");
        
        html.append("<h1>Blood Donation System Report</h1>");
        html.append("<div class='report-date'>Generated on: ").append(DATETIME_FORMAT.format(new Date())).append("</div>");
        
        html.append("<div class='summary'>");
        html.append("<div class='summary-item'>");
        html.append("<h3>Total Blood Units</h3>");
        html.append("<div class='number'>").append(reportData.getOrDefault("totalBloodUnits", "0")).append("</div>");
        html.append("</div>");
        
        html.append("<div class='summary-item'>");
        html.append("<h3>Total Donors</h3>");
        html.append("<div class='number'>").append(reportData.getOrDefault("totalDonors", "0")).append("</div>");
        html.append("</div>");
        
        html.append("<div class='summary-item'>");
        html.append("<h3>Total Requests</h3>");
        html.append("<div class='number'>").append(reportData.getOrDefault("totalRequests", "0")).append("</div>");
        html.append("</div>");
        
        html.append("<div class='summary-item'>");
        html.append("<h3>Active Appointments</h3>");
        html.append("<div class='number'>").append(reportData.getOrDefault("activeAppointments", "0")).append("</div>");
        html.append("</div>");
        html.append("</div>");
        
        html.append("</body></html>");
        
        return html.toString();
    }
}

