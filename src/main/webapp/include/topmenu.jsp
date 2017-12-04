<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!------------------------- 탑메뉴-->
<ul id="demo-list" >
  <li ><a href="javascript:go_01_01_01();" >셀프여행</a></li>
<!-- 해당활성화 메뉴   <li  class="active"> -->
  <li><a href="javascript:go_02_01_01();">핫딜여행</a></li>
  <li><a href="javascript:go_03_01_01();">추천여행</a></li>
  <li><a href="javascript:go_08_03_01();">이용방법</a></li>
  <li><a href="javascript:go_04_01_01();">여행체크리스트</a></li>
  <li><a href="javascript:go_07_01_01();">고객지원 </a>
    <ul class="submenu">
		<li><a href="javascript:go_07_01_01();">여행후기</a> </li>
      <li><a href="javascript:go_07_02_01();">FAQ</a> </li>
      <li><a href="javascript:go_07_03_01();">이용약관</a> </li>
      <li><a href="javascript:go_07_04_01();">여행자약관</a> </li>
      <li><a href="javascript:go_07_05_01();">개인정보 및 취급방침</a> </li>
      <li><a href="javascript:go_07_06_01();">Q&A</a> </li>
    </ul>
  </li>
  <li><a href="javascript:go_09_01_01();" style="color:red !important;">여행상담</a></li>
</ul>

<!---//탑메뉴--> 