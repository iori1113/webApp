<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ include file = "../include.jsp" %>

<%!

String makelink(String msg, String lecture_id, String lecture_name){
	msg += "<form action=\"addReviewResult.jsp\" method=\"get\">";
	
	msg += "<p>評価点(1∼5点で入力)";
	msg += "<input name=\"grade\" type=\"text\"></p>";
	msg += "<div class = \"stars\">";
	msg += "<input id=\"review01\" type=\"radio\" name=\"review\"><label for=\"review01\">★</label>" ;
	msg += "<input id=\"review02\" type=\"radio\" name=\"review\"><label for=\"review02\">★</label>" ;
	msg += "<input id=\"review03\" type=\"radio\" name=\"review\"><label for=\"review03\">★</label>" ;
	msg += "<input id=\"review04\" type=\"radio\" name=\"review\"><label for=\"review04\">★</label>" ;
	msg += "<input id=\"review05\" type=\"radio\" name=\"review\"><label for=\"review05\">★</label>" ;
	msg += "</div>";			
	msg += "<p>レビュー内容";
	msg += "<input name=\"content\" type=\"text\"></p>";
	
	/*hidden属性でlecture_idを通す*/
	msg += "<input type = \"hidden\" name = \"lecture_id\" value = \""+ lecture_id+"\">";
	msg += "<input type = \"hidden\" name = \"lecture_name\" value = \""+ lecture_name+"\">";
	msg += "<input type=\"submit\" value=\"投稿\"></p>";
	msg += "</form>";
	
	msg += "<p>レビューの内容、評価点は後から変更できないため、気をつけてください(レビューの削除はできます)。</p>";
	return msg;
}


%>

<%
String msg = "";
String lecture_id = request.getParameter("lecture_id");
String lecture_name = request.getParameter("lecture_name");


msg += makelink(msg, lecture_id, lecture_name);

conn.close();
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
	<a href = "userTop.jsp" class = "title">授業掲示板</a>
<%if(session.getAttribute("id") == null){ %>	<a href = "../login.jsp" class = "login">ログイン</a>
<%} %>
</div>

<div class = "content">
		
	<%= msg %>
	
</div>

<div class = "footer">
	 <a href = "userTop.jsp">トップページ</a>
	<%if(session.getAttribute("id") != null){ %>	<a href = "./accountOption.jsp">アカウント管理/レビューの確認</a>
	<a href = "../login.jsp?o=0">ログアウトする</a>
	<%} %>	 
</div>

</body>
</html>
