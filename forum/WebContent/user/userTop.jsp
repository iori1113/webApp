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
 
//リクエスト・レスポンスとも文字コードをUTF-8に
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

 	String msg = "";
 	String name = "";
 	/*ゲスト入場*/
 	if(session.getAttribute("id") == null){
 		name = "ゲスト";
 	}else{
 		name = (String)session.getAttribute("disp");
 	}
 	
 	/*最新5件のレビューを取得 */
 	String sql = "select * from reviews ";
 	int last_id = 0; /*最新のレビューidを保存*/
 	
    try {
	Statement state = conn.createStatement();
	ResultSet rs = state.executeQuery(sql);
	
	while(rs.next()){
		last_id = rs.getInt("review_id");
	}
	
	int i = last_id; /* ループ用 非常に重い処理なので回数を増やさないこと*/
	int j = 0;
	String sql2;
	while((i != 100001) && (last_id - i < 5)){
		/*レビューidに該当するレビューをもってくる*/
		sql2 = "select * from reviews where review_id = "+ i;
		try{
			
			Statement state2 = conn.createStatement();
			ResultSet rs2 = state.executeQuery(sql2);

			msg += "<p>" + escapeCell(rs2.getString("created_date")) + "に投稿</p>";
			msg += "<p>レビュー評価 : " + escapeCell(rs2.getString("grade")) + "/5</p>";
			msg += "<p>レビュー内容:</p><p>" + escapeCell(rs2.getString("content")) + "</p>";

			
			/* lecture_idに該当するlecture_nameを持ってくる*/
			String sql3 = "select * from lectures where lecture_id = "+ escapeCell(rs2.getString("lecture_id"));
			try{
				Statement state3 = conn.createStatement();
				ResultSet rs3 = state.executeQuery(sql3);
				msg += "(講義名 :"; 
				msg += "<a href = \"\" onclick = \"document.form"+ j +".submit(); return false;\">"+ escapeCell(rs2.getString("lecture_name")) +")</a> ";
				msg += "<form name = \"form"+ j +"\" method = \"get\" action = \"view.jsp\">";
				msg += "<input type = hidden name = \"name\" value = \""+ escapeCell(rs2.getString("lecture_name")) + "\">";
				msg += "<input type = hidden name = \"lecture_id\" value = \""+ escapeCell(rs2.getString("lecture_id")) + "\">";
				msg += "</form>";    

			}catch (SQLException e) {
				msg += "データベースの問い合わせでエラーが発生しました";
		    }
			
			msg += "<hr>";
			
		}catch (SQLException e) {
			msg += "データベースの問い合わせでエラーが発生しました";
	    }
		i--;
		j++;
	}
	
    } catch (SQLException e) {
	msg += "データベースの問い合わせでエラーが発生しました";
    }
 	
 	conn.close();
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
	<h1><%= name %>さんのトップページ</h1>
	<h2>授業を探す</h2>
			<form action="outputResult.jsp" method="post">
			授業名：<input type="text" name="className" size="20"> <br>
			<hr>
			詳細な検索  <br>
			メジャー : <input type = "checkbox" name = "major" value = "none" checked >指定しない
			<input type = "checkbox" name = "major" value = "MT">MT
			<input type = "checkbox" name = "major" value = "EE">EE
			<input type = "checkbox" name = "major" value = "ME">ME
			<input type = "checkbox" name = "major" value = "CH">CH
			<input type = "checkbox" name = "major" value = "II">II
			<input type = "checkbox" name = "major" value = "NI">NI
			<input type = "checkbox" name = "major" value = "ES">ES
			<input type = "checkbox" name = "major" value = "ED">ED
			<input type = "checkbox" name = "major" value = "MD">SI <br>
			
			セメスター : 
				<select name="semester">
					<option value="0" selected="selected">指定しない</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">その他</option>
				</select> <br>
				
			クォーター: 
				<select name="quarter">
					<option value="0" selected="selected">指定しない</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="12">前期</option>
					<option value="34">後期</option>
					<option value="1234">通年</option>
					<option value="5">その他</option>
				</select> <br>	
				
			講師名：<input type="text" name="teacherName" size="20"> <br>
							
			<hr>				
							
			<input type="submit" value = "検索する">
		</form>
		
		<%--レビュー一覧 --%>
		<hr>
		<h2>新着レビュー</h2>
		<%= msg %>
	<!-- ローカル環境でのurl指定 サーバで運用するなら要変更 -->
		<%if(session.getAttribute("id") != null){ %>	<a href = "./addClass.jsp">授業の追加をする</a>
	<%}else{ %>
		ログインをすれば授業を追加できます
		<a href = "../login.jsp">ログインページへ</a>	
	<%} %>		
	
</div>

<div class = "footer">
	 <a href = "./userTop.jsp">トップページ</a>
	<%if(session.getAttribute("id") != null){ %>	<a href = "./accountOption.jsp">アカウント管理/レビューの確認</a>
	<a href = "../login.jsp?o=0">ログアウトする</a>
	<%} %>	 
	 
</div>

</body>
</html>