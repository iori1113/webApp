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

String getTableResult(Connection conn,String grade,String content,String id, String lecture_id, String lecture_name) {
    String msg = "";
    Calendar cl = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");


    String sql = "INSERT INTO reviews (user_id,grade,content,created_date,lecture_id) VALUES "
    		+ "('"+ id + "'," + grade + ",'" + content + "','" + sdf.format(cl.getTime()) +"',"+lecture_id+")";
    

     

    try{
    	
    Statement sa = conn.createStatement();
	sa.execute(sql);
	Statement state = conn.createStatement();
	msg += "<p>レビューは正常に追加されました。ご協力ありがとうございます。</p>";
	msg += "<a href = \"\" onclick = \"document.form1.submit(); return false;\">レビュー一覧へ戻る</a> <br>";
	msg += "<form name = \"form1\" method = \"post\" action = \"view.jsp\">";
	msg += "<input type = hidden name = \"name\" value = \""+ lecture_name + "\">";
	msg += "<input type = hidden name = \"lecture_id\" value = \""+ lecture_id + "\">";
	msg += "</form>";    
	msg += "<br><a href=\"userTop.jsp\">トップページへ</a>";
    } catch (SQLException e) {
    	msg += e;
	msg += "データベースの問い合わせでエラーが発生しました";
	msg += "<br>もう一度入力してください。";
	msg += "<br><a href=\"addReview.jsp\">元に戻る</a>";
    }
	return msg;
}


%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String grade = request.getParameter("grade");
String content = request.getParameter("content");
String id = session.getAttribute("id").toString();
String lecture_id = request.getParameter("lecture_id");
String lecture_name = request.getParameter("lecture_name");

String msg = "";

Class.forName("org.sqlite.JDBC");


msg += getTableResult(conn,grade,content,id, lecture_id, lecture_name);

conn.close();
%>
<!DOCTYPE html>
<html>
<head>
<title>科目の追加結果</title>
</head>
<body>
<h1>科目の追加結果</h1>
<%= msg %>