<%-- 要求するリクエストパラメータ : lecture_id、name --%>

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

String getTableResult(String lecture_id,String lecture_name, Connection conn) {
    String msg = "";
    String sql = "select * from reviews where lecture_id = " + lecture_id;

    try {
	Statement state = conn.createStatement();
	ResultSet rs = state.executeQuery(sql);
	ResultSetMetaData md = rs.getMetaData();
	int cols = md.getColumnCount();


	while(rs.next()){
		/*レビュー*/
		msg += "<p>" + escapeCell(rs.getString("created_date")) + "に投稿</p>";
		msg += "<p>レビュー評価 : " + escapeCell(rs.getString("grade")) + "/5</p>";
		msg += "<p>レビュー内容:</p><p>" + escapeCell(rs.getString("content")) + "</p>";
		msg += "<hr>";
	}
	
    } catch (SQLException e) {
	msg += "データベースの問い合わせでエラーが発生しました";
    }

    //msg += "<a href=\"addReview.jsp?lecture_id="+lecture_id+"&lecture_name="+lecture_name+"\">”新たにこの授業のレビューを投稿する</a>";
		msg += "<a href = \"\" onclick = \"document.form1.submit(); return false;\">新たにこの授業のレビューを投稿する</a> <br>";
		msg += "<form name = \"form1\" method = \"get\" action = \"addReview.jsp\">";
		msg += "<input type = hidden name = \"lecture_name\" value = \""+ lecture_name + "\">";
		msg += "<input type = hidden name = \"lecture_id\" value = \""+ lecture_id + "\">";
		msg += "</form>";    
    return msg;
}
%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");


String msg = "";
Class.forName("org.sqlite.JDBC");

/*この講義のレビューを参照する*/
String lecture_id = request.getParameter("lecture_id");
String name = request.getParameter("name");

msg += getTableResult(lecture_id,name, conn);
conn.close();

%>
	
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel = "stylesheet" href = "styleUser.css">
<title><%= name %>のレビュー一覧</title>
</head>
<body>
<div class = "header">
	<a href = "userTop.jsp" class = "title">授業掲示板</a>
<%if(session.getAttribute("id") == null){ %>	<a href = "../login.jsp" class = "login">ログイン</a>
<%} %>
</div>

<div class = "content">
	<h1><%= name %>のレビュー一覧</h1>
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