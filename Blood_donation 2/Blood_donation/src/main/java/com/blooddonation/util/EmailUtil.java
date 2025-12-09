package com.blooddonation.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {
    
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USER = "blooddonationsystem1@gmail.com";
    private static final String EMAIL_PASSWORD = "kbosjmunqwddgqjt"; // Gmail App Password for blooddonationsystem1@gmail.com
    
    public static boolean sendAlertEmail(String alertTitle, String alertMessage) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USER, EMAIL_PASSWORD);
                }
            });
            
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USER, "Blood Donation System"));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress("blooddonationsystem1@gmail.com"));
            message.setSubject("Blood Donation Alert: " + alertTitle);
            
            String emailBody = "BLOOD DONATION SYSTEM ALERT\n\n" +
                             "Alert Title: " + alertTitle + "\n\n" +
                             "Message: " + alertMessage + "\n\n" +
                             "Please check the system for more details.\n\n" +
                             "From: Blood Donation Management System";
            
            message.setText(emailBody);
            Transport.send(message);
            
            return true;
            
        } catch (Exception e) {
            return false;
        }
    }
    
    public static void sendEmail(String toEmail, String subject, String messageText) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USER, EMAIL_PASSWORD);
                }
            });
            
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USER, "Blood Donation System"));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject);
            message.setText(messageText);
            Transport.send(message);
            
        } catch (Exception e) {
            // Silent fail - no console output
        }
    }
}