<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<form id="frmMenuCategory" name="frmMenuCategory" action="<c:url value='/goods/list'/>">
</form>

<script>
function goSelfCategory(cl_code) {
	var form = $("form[id=frmMenuCategory]");
	$(form).empty();
	$(form).append("<input type=\"hidden\" name=\"hidUpperClCodeNavi\" value=\"" + cl_code + "\" >");
	$(form).append("<input type=\"hidden\" name=\"category\" value=\"S\" >");
	form.attr({"method":"get","action":"<c:url value='/goods/list'/>"});
	form.submit();		
}
</script>

<!-- 탑메뉴-->
<ul id="demo-list" >
  <li class="sub-menu" >
  	<a href="javascript:go_01_01_01();" ><spring:message code='topmenu.self'/><i class="arrow fa fa-angle-down pull-right"></i></a>
    <ul class="submenu">
	  <li><a href="javascript:goSelfCategory('00411');">숙박</a></li>
	  <li><a href="javascript:goSelfCategory('00412');">맞춤투어</a></li>
	  <li><a href="javascript:goSelfCategory('00413');">데이투어</a></li>
	  <li><a href="javascript:goSelfCategory('00414');">골프투어</a></li>
	  <li><a href="javascript:goSelfCategory('00429');">해양스포츠</a></li>
	  <li><a href="javascript:goSelfCategory('00571');">액티비티</a></li>
	  <li><a href="javascript:goSelfCategory('00415');">마사지</a></li>
	  <li><a href="javascript:goSelfCategory('00416');">차량렌트</a></li>
	  <li><a href="javascript:goSelfCategory('00591');">패키지투어</a></li>
	  <li><a href="javascript:goSelfCategory('00417');">로컬쇼핑(준비중)</a></li>
    </ul>
  </li>
<!-- 해당활성화 메뉴   <li  class="active"> -->
  <li><a href="javascript:go_03_01_01();"><spring:message code='topmenu.recom'/></a></li>
  <li><a href="javascript:go_03_02_01();"><spring:message code='topmenu.package'/></a></li>
  <li><a href="javascript:go_02_01_01();"><spring:message code='topmenu.hotdeal'/></a></li>
  <li><a href="javascript:go_04_03_01();"><spring:message code='topmenu.checklist'/></a></li>
  <li  class="sub-menu"><a href="javascript:void(0);"><spring:message code='topmenu.customer'/><i class="arrow fa fa-angle-down pull-right"></i></a>
    <ul class="submenu">
	  <li><a href="javascript:go_07_03_01();"><spring:message code='topmenu.opinion'/></a> </li>
      <li><a href="javascript:go_07_02_01();"><spring:message code='topmenu.faq'/></a> </li>
		<li><a href="javascript:go_07_01_01();"><spring:message code='topmenu.review'/></a> </li>
	  <li><a href="javascript:go_07_05_01();"><spring:message code='topmenu.liveview'/></a> </li>
	  <li><a href="javascript:go_07_04_01();"><spring:message code='topmenu.notice'/></a> </li>
	  <li><a href="javascript:go_05_01_01();"><spring:message code='topmenu.bbs1'/></a> </li>
	  <c:if test="${author_cl == 'A' or author_cl == 'M' }">
	  	<li><a href="javascript:go_05_02_01();"><spring:message code='topmenu.bbs2'/></a> </li>
	  </c:if>
	  
	  
      <!-- <li><a href="javascript:go_07_06_01();"><spring:message code='topmenu.usetext1'/></a> </li>
      <li><a href="javascript:go_07_07_01();"><spring:message code='topmenu.usetext2'/></a> </li>
      <li><a href="javascript:go_07_08_01();"><spring:message code='topmenu.usetext3'/></a> </li> -->
    </ul>
  </li>
	<!-- <li><a href="javascript:go_05_01_01();"><spring:message code='topmenu.consult'/></a></li> -->
</ul>

<!---//탑메뉴--> 