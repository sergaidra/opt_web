<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>원패스투어</title>

</head>
<body>

<script>
<c:if test="${author_cl == 'A' or author_cl == 'M' }">
	location.href="/main/intro/";
</c:if>
<c:if test="${author_cl != 'A' and author_cl != 'M' }">
	location.href="/bbs/list";
	</c:if>
</script>

</body>
</html>
