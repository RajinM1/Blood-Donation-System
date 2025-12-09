package com.blooddonation.util;

import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.kernel.colors.ColorConstants;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class PDFReportGenerator {
    
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");
    private static final SimpleDateFormat DATETIME_FORMAT = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    
    /**
     * Generate PDF report for blood stock
     */
    public static byte[] generateBloodStockReport(List<Map<String, Object>> stockData, String title) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);
        
        // Add title
        Paragraph titlePara = new Paragraph(title)
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(18)
                .setBold()
                .setMarginBottom(20);
        document.add(titlePara);
        
        // Add report date
        Paragraph datePara = new Paragraph("Generated on: " + DATETIME_FORMAT.format(new Date()))
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(10)
                .setMarginBottom(20);
        document.add(datePara);
        
        // Create table
        Table table = new Table(UnitValue.createPercentArray(new float[]{3, 2, 2, 2}))
                .setWidth(UnitValue.createPercentValue(100));
        
        // Add header
        table.addHeaderCell(createHeaderCell("Blood Group"));
        table.addHeaderCell(createHeaderCell("Quantity"));
        table.addHeaderCell(createHeaderCell("Expiry Date"));
        table.addHeaderCell(createHeaderCell("Status"));
        
        // Add data rows
        for (Map<String, Object> stock : stockData) {
            table.addCell(createDataCell(stock.get("bloodGroup").toString()));
            table.addCell(createDataCell(stock.get("quantity").toString() + " units"));
            table.addCell(createDataCell(stock.get("expiryDate").toString()));
            table.addCell(createDataCell(stock.get("status").toString()));
        }
        
        document.add(table);
        document.close();
        
        return baos.toByteArray();
    }
    
    /**
     * Generate PDF report for donors
     */
    public static byte[] generateDonorReport(List<Map<String, Object>> donorData, String title) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);
        
        // Add title
        Paragraph titlePara = new Paragraph(title)
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(18)
                .setBold()
                .setMarginBottom(20);
        document.add(titlePara);
        
        // Add report date
        Paragraph datePara = new Paragraph("Generated on: " + DATETIME_FORMAT.format(new Date()))
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(10)
                .setMarginBottom(20);
        document.add(datePara);
        
        // Create table
        Table table = new Table(UnitValue.createPercentArray(new float[]{3, 2, 2, 2, 2}))
                .setWidth(UnitValue.createPercentValue(100));
        
        // Add header
        table.addHeaderCell(createHeaderCell("Name"));
        table.addHeaderCell(createHeaderCell("Blood Group"));
        table.addHeaderCell(createHeaderCell("Age"));
        table.addHeaderCell(createHeaderCell("Gender"));
        table.addHeaderCell(createHeaderCell("Last Donation"));
        
        // Add data rows
        for (Map<String, Object> donor : donorData) {
            table.addCell(createDataCell(donor.get("name").toString()));
            table.addCell(createDataCell(donor.get("bloodGroup").toString()));
            table.addCell(createDataCell(donor.get("age").toString()));
            table.addCell(createDataCell(donor.get("gender").toString()));
            table.addCell(createDataCell(donor.get("lastDonationDate") != null ? 
                donor.get("lastDonationDate").toString() : "Never"));
        }
        
        document.add(table);
        document.close();
        
        return baos.toByteArray();
    }
    
    /**
     * Generate PDF report for blood requests
     */
    public static byte[] generateBloodRequestReport(List<Map<String, Object>> requestData, String title) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);
        
        // Add title
        Paragraph titlePara = new Paragraph(title)
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(18)
                .setBold()
                .setMarginBottom(20);
        document.add(titlePara);
        
        // Add report date
        Paragraph datePara = new Paragraph("Generated on: " + DATETIME_FORMAT.format(new Date()))
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(10)
                .setMarginBottom(20);
        document.add(datePara);
        
        // Create table
        Table table = new Table(UnitValue.createPercentArray(new float[]{2, 2, 1, 2, 2, 2}))
                .setWidth(UnitValue.createPercentValue(100));
        
        // Add header
        table.addHeaderCell(createHeaderCell("Hospital"));
        table.addHeaderCell(createHeaderCell("Blood Group"));
        table.addHeaderCell(createHeaderCell("Quantity"));
        table.addHeaderCell(createHeaderCell("Urgency"));
        table.addHeaderCell(createHeaderCell("Status"));
        table.addHeaderCell(createHeaderCell("Request Date"));
        
        // Add data rows
        for (Map<String, Object> request : requestData) {
            table.addCell(createDataCell(request.get("hospitalId").toString()));
            table.addCell(createDataCell(request.get("bloodGroup").toString()));
            table.addCell(createDataCell(request.get("quantity").toString() + " units"));
            table.addCell(createDataCell(request.get("urgency").toString()));
            table.addCell(createDataCell(request.get("status").toString()));
            table.addCell(createDataCell(request.get("requestDate").toString()));
        }
        
        document.add(table);
        document.close();
        
        return baos.toByteArray();
    }
    
    /**
     * Generate comprehensive system report
     */
    public static byte[] generateSystemReport(Map<String, Object> reportData, String title) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);
        
        // Add title
        Paragraph titlePara = new Paragraph(title)
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(20)
                .setBold()
                .setMarginBottom(20);
        document.add(titlePara);
        
        // Add report date
        Paragraph datePara = new Paragraph("Generated on: " + DATETIME_FORMAT.format(new Date()))
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(12)
                .setMarginBottom(30);
        document.add(datePara);
        
        // Add summary statistics
        addSummarySection(document, reportData);
        
        // Add detailed sections
        if (reportData.containsKey("bloodStock")) {
            addBloodStockSection(document, (List<Map<String, Object>>) reportData.get("bloodStock"));
        }
        
        if (reportData.containsKey("donors")) {
            addDonorSection(document, (List<Map<String, Object>>) reportData.get("donors"));
        }
        
        if (reportData.containsKey("requests")) {
            addRequestSection(document, (List<Map<String, Object>>) reportData.get("requests"));
        }
        
        document.close();
        
        return baos.toByteArray();
    }
    
    private static void addSummarySection(Document document, Map<String, Object> reportData) {
        Paragraph sectionTitle = new Paragraph("Summary Statistics")
                .setFontSize(16)
                .setBold()
                .setMarginTop(20)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        // Create summary table
        Table summaryTable = new Table(UnitValue.createPercentArray(new float[]{2, 1}))
                .setWidth(UnitValue.createPercentValue(60));
        
        summaryTable.addCell(createDataCell("Total Blood Units:"));
        summaryTable.addCell(createDataCell(reportData.getOrDefault("totalBloodUnits", "0").toString()));
        
        summaryTable.addCell(createDataCell("Total Donors:"));
        summaryTable.addCell(createDataCell(reportData.getOrDefault("totalDonors", "0").toString()));
        
        summaryTable.addCell(createDataCell("Total Requests:"));
        summaryTable.addCell(createDataCell(reportData.getOrDefault("totalRequests", "0").toString()));
        
        summaryTable.addCell(createDataCell("Active Appointments:"));
        summaryTable.addCell(createDataCell(reportData.getOrDefault("activeAppointments", "0").toString()));
        
        document.add(summaryTable);
    }
    
    private static void addBloodStockSection(Document document, List<Map<String, Object>> stockData) {
        Paragraph sectionTitle = new Paragraph("Blood Stock Details")
                .setFontSize(16)
                .setBold()
                .setMarginTop(20)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Table table = new Table(UnitValue.createPercentArray(new float[]{3, 2, 2, 2}))
                .setWidth(UnitValue.createPercentValue(100));
        
        table.addHeaderCell(createHeaderCell("Blood Group"));
        table.addHeaderCell(createHeaderCell("Quantity"));
        table.addHeaderCell(createHeaderCell("Expiry Date"));
        table.addHeaderCell(createHeaderCell("Status"));
        
        for (Map<String, Object> stock : stockData) {
            table.addCell(createDataCell(stock.get("bloodGroup").toString()));
            table.addCell(createDataCell(stock.get("quantity").toString() + " units"));
            table.addCell(createDataCell(stock.get("expiryDate").toString()));
            table.addCell(createDataCell(stock.get("status").toString()));
        }
        
        document.add(table);
    }
    
    private static void addDonorSection(Document document, List<Map<String, Object>> donorData) {
        Paragraph sectionTitle = new Paragraph("Donor Details")
                .setFontSize(16)
                .setBold()
                .setMarginTop(20)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Table table = new Table(UnitValue.createPercentArray(new float[]{3, 2, 1, 2, 2}))
                .setWidth(UnitValue.createPercentValue(100));
        
        table.addHeaderCell(createHeaderCell("Name"));
        table.addHeaderCell(createHeaderCell("Blood Group"));
        table.addHeaderCell(createHeaderCell("Age"));
        table.addHeaderCell(createHeaderCell("Gender"));
        table.addHeaderCell(createHeaderCell("Last Donation"));
        
        for (Map<String, Object> donor : donorData) {
            table.addCell(createDataCell(donor.get("name").toString()));
            table.addCell(createDataCell(donor.get("bloodGroup").toString()));
            table.addCell(createDataCell(donor.get("age").toString()));
            table.addCell(createDataCell(donor.get("gender").toString()));
            table.addCell(createDataCell(donor.get("lastDonationDate") != null ? 
                donor.get("lastDonationDate").toString() : "Never"));
        }
        
        document.add(table);
    }
    
    private static void addRequestSection(Document document, List<Map<String, Object>> requestData) {
        Paragraph sectionTitle = new Paragraph("Blood Request Details")
                .setFontSize(16)
                .setBold()
                .setMarginTop(20)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Table table = new Table(UnitValue.createPercentArray(new float[]{2, 2, 1, 2, 2, 2}))
                .setWidth(UnitValue.createPercentValue(100));
        
        table.addHeaderCell(createHeaderCell("Hospital"));
        table.addHeaderCell(createHeaderCell("Blood Group"));
        table.addHeaderCell(createHeaderCell("Quantity"));
        table.addHeaderCell(createHeaderCell("Urgency"));
        table.addHeaderCell(createHeaderCell("Status"));
        table.addHeaderCell(createHeaderCell("Request Date"));
        
        for (Map<String, Object> request : requestData) {
            table.addCell(createDataCell(request.get("hospitalId").toString()));
            table.addCell(createDataCell(request.get("bloodGroup").toString()));
            table.addCell(createDataCell(request.get("quantity").toString() + " units"));
            table.addCell(createDataCell(request.get("urgency").toString()));
            table.addCell(createDataCell(request.get("status").toString()));
            table.addCell(createDataCell(request.get("requestDate").toString()));
        }
        
        document.add(table);
    }
    
    private static Cell createHeaderCell(String text) {
        return new Cell()
                .add(new Paragraph(text).setBold())
                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                .setTextAlignment(TextAlignment.CENTER)
                .setPadding(8);
    }
    
    private static Cell createDataCell(String text) {
        return new Cell()
                .add(new Paragraph(text))
                .setPadding(8);
    }
}
