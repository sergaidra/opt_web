<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-1.11.1.js"></script>
<script src="/js/siione.js"></script>
<script language='javascript'>

	var default_sec = 1200;
	window.onload = function(){
	    fnRestart(default_sec);
	}

	function fnRestart(second){
		//fnTimer_01 호출
		fnTimer_01(second, "divRemainTime","Y");

		//session 연장
		$.ajax({
			url : "<c:url value='/member/aliveJson/'/>",
			dataType : "json",
			type : "POST",
			async : false,
			data : "",
			success : function(json) {
				if(json.RESULT == "-1"){
			        parent.location.reload();
				}
			},
			error : function() {
				//통신오류
			}
		});
	}

	//타이머 종료
	function fnTimer_01_callback(){
        parent.fnTimerStart();
	}


</script>
</head>
<body leftmargin='0' topmargin='0'>

<span id='divRemainTime'></span>&nbsp;<input type='button' value='연장' onclick='javascript:location.reload();'>

</body>
</html>
