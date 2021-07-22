<%--
	マイページの要件 
		・ユーザー名、パスワードの確認、変更
		・アカウントの削除(deleted = 1にする)
		・自分の書いたレビューの閲覧、削除(変更ができるかは検討 ; shoppingのRecord.jspまわりを参考にしてください)
		--%>
	
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ include file = "../include.jsp" %>

<%!
String escapeCell(String s) {
    if (s == null || s.equals("")) {
	return "&nbsp;";
    }
    s = s.replace("<", "&lt");
    s = s.replace(">", "&gt");
    s = s.replace("\"", "&quot");
    return s;
}
%>
    
 <% 
 	String msg = "";
 	String name = (String)session.getAttribute("disp");
 	/* ユーザのreview_idが該当するレビューを表示*/

 	
 	%>
 	
 	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel = "stylesheet" href = "styleUser.css">
<title>トップページ</title>
</head>
<body>
<div class = "header">
	<a href = "userTop.jsp" class = "title">授業掲示板</a>
<%if(session.getAttribute("id") == null){ %>	<a href = "../login.jsp" class = "login">ログイン</a>
<%} %>
</div>

<div class = "content">
	<h1><%= name %>さんのマイページ</h1>
	<div class = "account">
		<a href ="">アカウントを削除する</a>
		<a href = "">アカウント名の変更</a>
		<a href = "">パスワードの変更</a>
	</div>
	<%= msg %>
</div>

<div class = "footer">
	 <a href = "userTop.jsp">トップページ</a>
	 <a href = "accountOption.jsp">アカウント管理/レビューの確認</a>
	 <a href = "../login.jsp?o=0">ログアウトする</a>
</div>

</body>
</html>