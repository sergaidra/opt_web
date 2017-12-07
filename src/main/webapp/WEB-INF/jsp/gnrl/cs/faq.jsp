<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

	<script type="text/javascript" src="../../../js/acco.js"></script>
	
</head>

<body>
	
<!-- 본문 -->
<section>
 <div id="container">
<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
    <div class="inner2">
		<div class="cont_all">
            <!--FAQ검색-->  <div class="faq_search">
			    <div class="search_text">
			      <div class="tx1 fw_500">FAQ</div>
				  <div class="tx2">무엇을 도와드릴까요? <br>
고객님의 궁금함을 빠르게 해결해 드리겠습니다. </div>
			    </div>
<div class="search_in w_50p">
                 <div class="search_input w_100p"><input type="text">
	      <div class="btn"><i class="material-icons">&#xE8B6;</i></div>
	    </div>
                </div>
      </div> <!--//FAQ검색--> 
			<!--faq 아이콘 탭 -->
      <div class="faq_list_tab">
        <div class="icon_bar">
        <ul> <li class="icon_on">
            <p class="img"><i class="material-icons">&#xE39D;</i></p>
            <p class="text"><a href="#">전체</a></p>
          </li>   <li class="line"></li>
                  <li class="icon">
            <p class="img"><i class="material-icons">&#xE85E;</i></p>
            <p class="text"><a href="#">회원관련</a></p>
          </li>
                  <li class="line"></li>
                  <li class="icon">
            <p class="img"><i class="material-icons">&#xE8B1;</i></p>
            <p class="text"><a href="#">상품관련</a></p>
          </li>
                  <li class="line"></li>
                  <li class="icon">
            <p class="img"><i class="material-icons">&#xE863;</i></p>
            <p class="text"><a href="#">반품/취소/교환</a></p>
          </li>
                  <li class="line"></li>
                  <li class="icon">
            <p class="img"><i class="material-icons">&#xE558;</i></p>
            <p class="text"><a href="#">주문/배송</a></p>
          </li>
                  <li class="line"></li>
                  <li class="icon">
            <p class="img"><i class="material-icons">&#xE870;</i></p>
            <p class="text"><a href="#">결제관련</a></p>
          </li>
                  <li class="line"></li>
                  <li class="icon">
            <p class="img"><i class="material-icons">&#xE8D1;</i></p>
            <p class="text"><a href="#">입점관련</a></p>
          </li>
          <li class="line"></li>
                  <li class="icon">
            <p class="img"><i class="material-icons">&#xE0C6;</i></p>
            <p class="text"><a href="#">기타</a></p>
          </li>
                </ul>
      </div>
      </div>
			<!--//faq 아이콘 탭 -->
             <!--faq 리스트 --> <div class="list_box">
        <div class="tb_03_box">
                  <table width="100%" class="tb_03  pc_view">
            <col width="5%" />
            <col width="10%" />
            <col width="10%" />
            <col width="" />
            <thead>
                      <tr>
                <th>&nbsp;</th>
                <th>번호</th>
                <th>구분</th>
                <th>제목</th>
              </tr>
                    </thead>
          </table>
               </div>
        <div class="faq_container">
                  <h6 class="acc_trigger"><a href="#">
                    <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                    <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                    <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                     <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                     <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                    <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                   <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                      <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                     <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                     <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                     <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
                  <h6 class="acc_trigger"><a href="#">
                     <p class="no pc_view">100</p>
                    <p class="cate">회원관리</p>
                    질문이 있습니다. 질문이 있습니다. 질문이 있습니다. 질문이 있습니다. </a></h6>
                  <div class="acc_container">
            <div class="block"> 답변내용이 나오는곳입니다.답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. 답변내용이 나오는곳입니다. </div>
          </div>
               </div>
      </div> <!--/faq 리스트 --> 
            </div></div>   
<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
  </div>
   
</section>
<!-- //본문 -->

</body>
