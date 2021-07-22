<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ include file = "../include.jsp" %>
<%
	String msg = "ここに処理結果を記述してください";
	%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel = "stylesheet" href = "styleUser.css">
<title>ここにタイトルを入力</title>
</head>
<body>
<div class = "header">
	<p>授業掲示板</p>
	<%if(session.getAttribute("id") == null){ %>	<a href = "../login.jsp">ログイン</a>
	<%} %>
</div>

<div class = "content">
		
	<%= msg %>
		<a href = "adminTop.jsp">管理者トップページに戻る</a>
</div>

<div class = "footer">
	 <a href = "userTop.jsp">トップページ</a>
	<%if(session.getAttribute("id") != null){ %>	<a href = "./accountOption.jsp">アカウント管理/レビューの確認</a>
	<a href = "../login.jsp?o=0">ログアウトする</a>
	<%} %>	 
</div>

</body>
</html>

