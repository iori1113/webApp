<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,javax.servlet.RequestDispatcher" %>
<%@ include file = "include.jsp" %>
<%
// HTTPパラメータ
//   u=ユーザ名 : ログイン用ユーザ名
//   p=パスワード : ログイン用パスワード
//   o : ログアウト
// セッションパラメータ
//   id : ユーザID
//   disp : 表示名

// リクエスト・レスポンスとも文字コードをUTF-8に
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

// DB接続
Class.forName("org.sqlite.JDBC");

// 変数定義
//   DB関連

Statement state = null;
PreparedStatement pstate = null;
ResultSet rs = null;

//   HTTPパラメータ
String name = request.getParameter("u");
String password = request.getParameter("p");
String logout = request.getParameter("o");
String search = request.getParameter("a");
String wagon = request.getParameter("b");
String purchase = request.getParameter("c");

//   その他
int isAdmin = 0;
String contents = ""; /* サイトコンテンツ */
String sql = "";
String msg = "";
boolean authenticated = false; // すでに認証されているか，ログイン成功ならtrue
String displayname = "";
int user_id = -1;

if (name == null) {
	name = "";
}
if (password == null) {
	password = "";
}

if (!name.isEmpty() && !password.isEmpty()) {
	// ユーザ名・パスワードによるログイン処理
	msg += "[DEBUG] name = " + name + ", password = " + password + "<hr>";


	// 問い合わせ

		// プリペアドステートメントを使用(SQLインジェクションは成功しない)
		sql = "select user_id, name from users where name=? and pass=?";
		pstate = conn.prepareStatement(sql);
		pstate.setString(1, name);
		pstate.setString(2, password);
		rs = pstate.executeQuery();
		msg += "[DEBUG] " + sql + " (using PreparedStatement)<hr>";
	

	// 該当するレコードがあればログイン成功
	if (rs.next()) {
		authenticated = true;
		user_id = rs.getInt("user_id");
		displayname = rs.getString("name");
		session.setAttribute("id", user_id); // sessionは暗黙オブジェクト
		session.setAttribute("disp", displayname);
		if(user_id == 0){
			/*管理者ページに飛ぶ*/
			//RequestDispatcher dispatcher = request.getRequestDispatcher("./admin/adminTop.jsp");
			//dispatcher.forward(request, response);
			response.sendRedirect("./admin/adminTop.jsp");
		}else{
			/* ユーザページに移動 */
			//RequestDispatcher dispatcher = request.getRequestDispatcher("./user/userTop.jsp");
			//dispatcher.forward(request, response);			
			response.sendRedirect("./user/userTop.jsp");
		}
	} else {
		msg += "ユーザ名またはパスワードが間違っています。<hr>";
	}

	// DB接続終了
	/*
	if (state != null) {
		state.close();
		state = null;
	}
	*/
	if (pstate != null) {
		pstate.close();
		pstate = null;
	}
	if (conn != null) {
		conn.close();
		conn = null;
	}
} else if (session.getAttribute("id") != null) {
	// ログイン済みのとき
	authenticated = true;
	user_id = (int)session.getAttribute("id");
	displayname = (String)session.getAttribute("disp");
}


// ログアウト処理
if (authenticated == true && logout != null) {
	authenticated = false;
	user_id = -1;
	displayname = "";
	session.removeAttribute("id");
	session.removeAttribute("disp");
	// session.invalidate();
	msg = "ログアウトしました。<hr>";
}
%>
<!DOCTYPE html>
<html>
	<head>
		<link rel = "stylesheet" href = "style.css">
		<title>ログインページ</title>
	</head>
	<body>
		<h1>ログインページ</h1>
		<%= msg %>
		<form action="<%= request.getRequestURI() %>" method="post">
			ユーザ名：<input type="text" name="u" size="20" value="<%= name %>"><br>
			パスワード：<input type="text" name="p" size="20" value="<%= password %>"><br>
			<input type="submit" value = "ログイン">
		</form>
		<a href = "user/userTop.jsp">ログインせずに使う(閲覧のみ可能です)</a>
		<a href = "user/createAccount.jsp">新規アカウント作成はこちら</a>
		<a href = "">削除したアカウントを復帰する(未実装)</a>
	</body>
</html>
