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
	    return s;
	}

%>

<%!
	String output(String  className, List<String> major, int semester, int quarter, String teacherName, Connection conn){
		int count = 0;
		String msg = "";
		String temp; /*一時的lecture_id格納用*/
		
		String sql ="select *  from Lectures where ";

		/*授業名*/
		if(className != null ){
			sql +=  "lecture_name like '%"+ className +"%'";
			
		}
		
		/*メジャー*/
		if(!major.contains("none")){
			for(String s : major){
				sql+= "and (major1 = '"+ s +"' or major2 = '"+ s +"')  ";
			}
		}
		
		/*セメスター*/
		if(semester != 0){
			sql += "and semester = '"+ semester +"'  ";
		}
		
		/* クォーター*/
		if(quarter != 0){
			sql += "and quarter = '"+ quarter +"' ";
		}
		
		/*講師名*/
		if(teacherName != ""){
			sql +=  "and teacher like '%"+ teacherName +"%' ;";
		}
		
		msg += sql;
		
		try {
    		Statement state = conn.createStatement();		
   			ResultSet rs = state.executeQuery(sql);
   			ResultSetMetaData md = rs.getMetaData();
   			
   			while(rs.next()){
   				temp = escapeCell(rs.getString("lecture_id"));
   				msg += "<h3>";
   				/*授業ページに飛ぶリンクを貼り付けること*/
   				/*aタグでpost通信を行う*/
   				msg += "<a href = \"\" onclick = \"document.form1.submit(); return false;\">"+ escapeCell(rs.getString("lecture_name")) /*授業名*/ + "</a> <br>";
   				msg += "<form name = \"form1\" method = \"post\" action = \"view.jsp\">";
   				msg += "<input type = hidden name = \"name\" value = \""+ escapeCell(rs.getString("lecture_name")) + "\">";
   				msg += "<input type = hidden name = \"lecture_id\" value = \""+ temp + "\">";
   				msg += "</form>";
    			//msg+= "<a href = \"view.jsp?lecture_id="+ temp +"&name="+ escapeCell(rs.getString("lecture_name"))+"\">"+ escapeCell(rs.getString("lecture_name")) /*授業名*/ + "</a> <br>";
    			msg += "</h3>";
    			msg += "<div style=\"padding: 10px; margin-bottom: 10px; border: 1px dashed #333333; border-radius: 5px;\">";
    			msg += "<p>対応メジャー : ";
    			/* メジャー表示*/
    			if(escapeCell(rs.getString("major1")) == ""){
    				msg+= "不明</p>";
    			}else{
    				msg += escapeCell(rs.getString("major1"))+" "+ escapeCell(rs.getString("major2")) +"</p>";
    			}
    			
    			/*セメスター表示*/
    			msg += "<p>開講セメスター: ";
    			if(escapeCell(rs.getString("semester")) == ""){
    				msg+= "不明</p>";
    			}else{
    				msg += (escapeCell(rs.getString("semester")) == "9"  ? "その他" : escapeCell(rs.getString("semester")) ) + "</p>";
    			}
    			
    			/*クォーター表示*/
    			msg += "<p>実施クォーター: ";
    			if(escapeCell(rs.getString("quarter")) == ""){
    				msg+= "不明</p>";
    			}else{
    				String quart_char = escapeCell(rs.getString("quarter"));
    				switch (quart_char) {
    					case "12" :
    						msg += "前期";  break;
    					case "34" :
    						msg += "後期"; break;
    					case "1234" : 
    						msg += "通年";  break;
    					case "5" :
    						msg += "その他"; break;
    					default : 
    						msg += quart_char; 
    				}
    				msg += "</p>";
    			}
    			
    			/*講師表示*/
    			msg += "<p>担当講師: " + (escapeCell(rs.getString("teacher")) == "" ? "不明" :  escapeCell(rs.getString("teacher"))) + "</p>";
    			

    			count++;
    			
    			/*投稿されているレビュー数を数える*/
				String sql2 = "select *  from reviews where lecture_id = " + temp;
				try {
		    		Statement state2 = conn.createStatement();		
		   			ResultSet rs2 = state.executeQuery(sql2);
		   			/* レビューカウント用 */
		   			int count_reviews = 0;
		   			while(rs2.next()){
		   				count_reviews++;
		   			}
		   			msg += "この講義について"+ count_reviews+"件のレビューが投稿されています。";
				}catch (SQLException e) {
					msg += "データベースの問い合わせでエラーが発生しました";
			    }
    			
    			msg += "</div>";
    			msg += "<hr> <br> ";			
    			
   			}
   			if(count == 0){
   				msg += "検索結果に該当する授業はありません。";
   			}else{
   				msg += count + "件の授業が該当しました。";
   			}
	    } catch (SQLException e) {
		msg += "データベースの問い合わせでエラーが発生しました";
	    }
		return msg;
	}
	%>    
	
 <% 
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	
 	String msg = "";
 	String name = "";
 	
 	
 	String className = (String)request.getParameter("className");
 	String[] major = request.getParameterValues("major");
 	List<String> majorList = Arrays.asList(major);
 	int semester = Integer.parseInt(request.getParameter("semester"));
 	int quarter = Integer.parseInt(request.getParameter("quarter"));
 	String teacherName = (String)request.getParameter("teacherName");
 	
 	/*ゲスト入場*/
 	if(session.getAttribute("id") == null){
 		name = "ゲスト";
 	}else{
 		name = (String)session.getAttribute("disp");
 	}
 	
	if(className != null){
		
		Class.forName("org.sqlite.JDBC");
		msg += output(className, majorList, semester, quarter, teacherName ,conn);
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
	<h1>検索結果</h1>
	<h2>検索条件:</h2>
	
	未実装
		<%= msg %>

	
</div>

<div class = "footer">
	 <a href = "userTop.jsp">トップページ</a>
	<%if(session.getAttribute("id") != null){ %>	<a href = "accountOption.jsp">アカウント管理/レビューの確認</a>
	<%} %>	 
	 <a href = "../login.jsp?o=0">ログアウトする</a>
</div>

</body>
</html>