<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 탑메뉴-->
<ul id="demo-list" >
  <li ><a href="javascript:go_01_01_01();" ><spring:message code='topmenu.self'/></a></li>
<!-- 해당활성화 메뉴   <li  class="active"> -->
  <li><a href="javascript:go_02_01_01();"><spring:message code='topmenu.hotdeal'/></a></li>
  <li><a href="javascript:go_03_01_01();"><spring:message code='topmenu.recom'/></a></li>
  <li><a href="javascript:go_08_03_01();"><spring:message code='topmenu.usemethod'/></a></li>
  <li><a href="javascript:go_04_01_01();"><spring:message code='topmenu.checklist'/></a></li>
  <li  class="sub-menu"><a href="javascript:void(0);"><spring:message code='topmenu.customer'/><i class="arrow fa fa-angle-down pull-right"></i></a>
    <ul class="submenu">
		<li><a href="javascript:go_07_01_01();"><spring:message code='topmenu.review'/></a> </li>
      <li><a href="javascript:go_07_02_01();"><spring:message code='topmenu.faq'/></a> </li>
	  <li><a href="javascript:go_07_03_01();"><spring:message code='topmenu.opinion'/></a> </li>
	  <li><a href="javascript:go_07_04_01();"><spring:message code='topmenu.notice'/></a> </li>
	  <li><a href="javascript:go_07_05_01();"><spring:message code='topmenu.liveview'/></a> </li>
      <li><a href="javascript:go_07_06_01();"><spring:message code='topmenu.usetext1'/></a> </li>
      <li><a href="javascript:go_07_07_01();"><spring:message code='topmenu.usetext2'/></a> </li>
      <li><a href="javascript:go_07_08_01();"><spring:message code='topmenu.usetext3'/></a> </li>
    </ul>
  </li>
	<li><a href="javascript:go_05_01_01();"><spring:message code='topmenu.consult'/></a></li>
</ul>

<!---//탑메뉴--> 