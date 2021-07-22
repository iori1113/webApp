<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.*" %>
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

String getTableResult(String name,String major1,String major2,String semester,String quarter,String teacher, Connection conn) {
    String msg = "";
    Calendar cl = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

    String sql = "INSERT INTO lectures(lecture_name, major1, major2, semester, quarter, teacher, created_date) VALUES ('" + name + "','" + major1 + "','" + major2 + "','" + semester + "','" + quarter + "','" + teacher + "','"+ sdf.format(cl.getTime()) +"')";
    //String sql2 = "select * from lectures WHERE lecture_name ='" + name + "'";
     
    try{   	
    Statement sa = conn.createStatement();
	sa.executeUpdate(sql);
	
	msg += "授業は正常に追加されました。";

	msg += "<br><a href=\"./userTop.jsp\">トップページへ</a>";
    } catch (SQLException e) {
	msg += "データベースの問い合わせでエラーが発生しました";
	msg += "<br>もう一度入力してください。";
	msg += "<br><a href=\"./CreateLecture.jsp\">科目の追加</a>";
    }
	return msg;
}


%>
<% 
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String name = request.getParameter("name");
String major1 = request.getParameter("major1");
String major2 = request.getParameter("major2");
String semester = request.getParameter("semester");
String quarter = request.getParameter("quarter");
String teacher = request.getParameter("teacher");


String msg = "";

Class.forName("org.sqlite.JDBC");


msg += getTableResult(name, major1,major2,semester,quarter,teacher,conn);

conn.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel = "stylesheet" href = "styleUser.css">
<title>科目の追加結果</title>
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
	 <a href = "./userTop.jsp">トップページ</a>
	<%if(session.getAttribute("id") != null){ %>	<a href = "./accountOption.jsp">アカウント管理/レビューの確認</a>
	<a href = "../login.jsp?o=0">ログアウトする</a>
	<%} %>	 
</div>

</body>
</html>