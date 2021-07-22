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

String getTableResult(String name,String pass, Connection conn) {
    String msg = "";
    Calendar cl = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	
    int id = 999;//ユーザidの設定
    
    String sql = "INSERT INTO users (user_id, name, right, created_date, pass) VALUES ("+ id +" ,'" + name + "', 1 ,'"+ sdf.format(cl.getTime()) +"','"+ pass + "')";
    
    //String sql2 = "select * from users" ;
     
    try{   	
    Statement sa = conn.createStatement();
	sa.executeUpdate(sql);
	

	
	msg += "<h2>アカウントは正常に追加されました。</h2>";
	
	msg += "<p>約3秒後にトップページに移動します。</p>";
	msg += "<META http-equiv=\"Refresh\" content=\"3;URL=userTop.jsp\">";
	
    } catch (SQLException e) {
	msg += "無効なユーザ名またはパスワードです。";
	msg += "<br>もう一度入力してください。";
	msg += " <a href = \"createAccount.jsp\">アカウント登録ページへ</a>";
    }
	return msg;
}


%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String name = request.getParameter("name");
String pass = request.getParameter("pass");

String msg = "";

Class.forName("org.sqlite.JDBC");



msg += getTableResult(name, pass ,conn);

conn.close();
%>
<!DOCTYPE html>
<html>
<head>
<title>アカウント登録結果</title>
</head>
<body>
<h1>アカウント登録</h1>
<%= msg %>

</body>
</html>