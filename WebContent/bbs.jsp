<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.lang.Math" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name = "viewport" content="width=device-width", initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP로 만든 게시판 웹사이트</title>
<style type="text/css">
	a, a:hover {
		color : #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	int pageNumber = 1;
	if (request.getParameter("pageNumber") != null) {
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
	 int boardID = 0;
		if (request.getParameter("boardID") != null){
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
			data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
			aria-expanded="false">
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			</button>
			<a 
			class="navbar-brand" href="main.jsp">
				<p style="font-weight: bold">JSP 게시판 웹 사이트</p>
			</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<% if (boardID == 1){ %>
					<li class="active"><a href="bbs.jsp?boardID=1&pageNumber=1">이미지 게시판</a></li>
					<li><a href="bbs.jsp?boardID=2&pageNumber=1">자유 게시판</a></li>
				<%} else if(boardID == 2){ %>
					<li><a href="bbs.jsp?boardID=1&pageNumber=1">이미지 게시판</a></li>
					<li class="active"><a href="bbs.jsp?boardID=2&pageNumber=1">자유 게시판</a></li>
				<% } %>
			</ul>
			<%
			 if(userID == null) { //회원이 아닌 사람의 경우 회원가입을 할수있도록 설정
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class ="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			
			<%
			 } else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class ="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>  
			 <%
			 }
			%>
		</div>
		</nav>
		
		<div class="container">
		<div class="row">
			<form method="post" name="search" action="searchbbs.jsp">
				<table class="pull-right">
					<tr>
						<td><select class="form-control" name="searchField">
								<option value="0">선택</option>
								<option value="bbsTitle">제목</option>
								<option value="userID">작성자</option>
						</select></td>
						<td><input type="text" class="form-control"
							placeholder="검색어 입력" name="searchText" maxlength="100"></td>
						<td><button type="submit" class="btn btn-success">검색</button></td>
					</tr>

				</table>
			</form>
		</div>
	</div>
	<div class="container">
		<%
		if(boardID == 1){
		%>
			<h1>이미지 게시판<br></h1>
			<p>이미지 게시판입니다. 이미지를 위주로 올려놓고 사용하는 게시판입니다.<br><br></p>
		<% }
		else if(boardID == 2){
		%>
			<h1>자유게시판<br></h1>
			<p>자유롭게 글을 쓸수있는 공간입니다. 서로 매너를 지켜주세요<br><br></p>
		<% }%>
		<div class ="container">
			<div class="row">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
					<th style="background-color: #eeeee; text-align: center;">번호</th>
					<th style="background-color: #eeeee; text-align: center;">제목</th>
					<th style="background-color: #eeeee; text-align: center;">작성자</th>
					<th style="background-color: #eeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
				<%
					BbsDAO bbsDAO = new BbsDAO();
					ArrayList<Bbs> list = bbsDAO.getList(boardID,pageNumber);
					for (int i = 0; i < list.size(); i++) {
				%>
					<tr>
						<td><%= list.get(i).getBbsID() %></td>
						<td><a href="view.jsp?boardID=<%=boardID%>&bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></a></td>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13) + "시" + list.get(i).getBbsDate().substring(14,16) + "분" %></td>
					</tr>	
					<%
						}
					%>
				</tbody>
				</table>
				<%
					if(pageNumber != 1) {
				%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber -1 %>" class="btn btn-success btn-arrow-left">이전</a>
				<%
					} if(bbsDAO.nextPage(pageNumber + 1)) {
				%>	
				<a href="bbs.jsp?pageNumber=<%=pageNumber +1 %>" class="btn btn-success btn-arrow-left">다음</a>
				<%
					}
				%>	
				
				<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
				</div>
		</div>
	</div>	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>