<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%!

String makelink(String msg){
	msg += "<form action=\"addClassResult.jsp\" method=\"post\">";
	msg += "<p>科目名";
	msg += "<input name=\"name\" type=\"text\"></p>";
	msg += "<p>第一メジャー";
	msg += "<input name=\"major1\" type=\"text\"></p>";
	msg += "<p>第二メジャー";
	msg += "<input name=\"major2\" type=\"text\"></p>";
	msg += "<p>開講セメスタ";
	msg += "<input name=\"semester\" type=\"text\"></p>";
	msg += "<p>実施クウォーター";
	msg += "<input name=\"quarter\" type=\"text\"></p>";
	msg += "<p>講師名";
	msg += "<input name=\"teacher\" type=\"text\"></p>";
	
	msg += "<input type=\"submit\" value=\"作成\"></p>";
	msg += "</form>";
	return msg;
}


%>
<%
String msg = "";
//msg += "<h1> 科目の追加 </h1>";
msg += makelink(msg);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel = "stylesheet" href = "styleUser.css">
<title>科目の追加</title>
</head>
<body>
<div class = "header">
	<a href = "userTop.jsp" class = "title">授業掲示板</a>
<%if(session.getAttribute("id") == null){ %>	<a href = "../login.jsp" class = "login">ログイン</a>
<%} %>
</div>

<div class = "content">
	<%= msg %>
</div>

<div class = "footer">
	 <a href = "userTop.jsp">トップページ</a>
	 <a href = "accountOption.jsp">アカウント管理/レビューの確認</a>
	 <a href = "../login.jsp?o=0">ログアウトする</a>
</div>

</body>
</html>