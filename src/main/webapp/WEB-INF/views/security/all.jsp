<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
 <h1>/security/all page</h1>
 
 <!-- 인증된 사용자의 경우에만 안의 html 코드가 출력됨 -->
  <sec:authorize access="isAuthenticated()">
	<a href="/customLogout">Logout</a>
  </sec:authorize>	
  <!-- 인증안된 사용자의 경우에만 안의 html 코드가 출력됨 -->
  <sec:authorize access="isAnonymous()">
    <a href="/customLogin">Login</a>
  </sec:authorize>
</body>
</html>