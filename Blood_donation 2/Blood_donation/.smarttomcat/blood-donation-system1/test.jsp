<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test JSP</title>
</head>
<body>
    <h1>Test JSP Working</h1>
    <p>Context Path: <%= request.getContextPath() %></p>
    <p>Server Info: <%= application.getServerInfo() %></p>
</body>
</html>