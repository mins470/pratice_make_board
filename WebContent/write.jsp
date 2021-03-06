<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name = "viewport" content="width=device-width", initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP로 만든 게시판 웹사이트</title>
</head>
<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	int boardID = 2;
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
			class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
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
		<div class ="container">
			<div class="row">
			<form method="post" method="post" encType = "multipart/form-data" action="writeAction.jsp?boardID=<%=boardID%>&keyValue=multipart">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="5" style="background-color: #eeeee; text-align: center;">게시판 글쓰기 양식</th>
						</tr>
					</thead>
						<tbody>
						<tr>
							<td colspan="5" ><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50"></td>
						</tr>
						<%-- <% if(boardID==1) %> --%>
						<tr>	
							<td colspan="5"><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"></textarea></td>
						</tr>	
						<tr>
							<td colspan="5"><input type="file" name="fileName"></td>
						</tr>
						</tbody>
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
			</form>
				
				</div>
		</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>