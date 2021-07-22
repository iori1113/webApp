<%-- データベース接続用ファイル 変更しないこと --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.*" %>

<% 
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:sqlite:C:/Users/my/web2021/forum/class.db");
	%>
	