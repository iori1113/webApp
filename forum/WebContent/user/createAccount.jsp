<%--
	アカウント登録の要件
		・ user_idは自動入力(になるはず)なので入力不要
		・ユーザ名(半角アルファベットのみ)、重複可
		・書き込み権限は初期値1で統一
		・dateクラスを用いて現在時刻をcreated_dateに自動入力してください
		・パスワード : 入力の制約は未定、今は半角アルファベットのみとしてください
	上記の条件で任意のユーザ名、パスワードを入力して、全角ならもう一度入力、完了すればそのままログインさせてください
	--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,javax.servlet.RequestDispatcher" %>


<%!

String makelink(String msg){
	msg += "<form action=\"createAccountResult.jsp\" method=\"get\">";
	
	msg += "<p>ユーザ名：";
	msg += "<input name=\"name\" type=\"text\"></p>";
	msg += "<p>登録するパスワード：";	
	msg += "<input name=\"pass\" type=\"text\"></p>";

	
	msg += "<input type=\"submit\" value=\"登録\"></p>";
	msg += "</form>";
	return msg;
}


%>
<%
String msg = "";
msg += makelink(msg);

%>
	
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>アカウント作成</title>
</head>
<body>
<h1>アカウント作成ページ</h1>
 <%= msg %>
</body>
</html>