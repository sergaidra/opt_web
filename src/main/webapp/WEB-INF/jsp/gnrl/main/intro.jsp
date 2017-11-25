<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<head>
<link rel="stylesheet" href="/jq/swiper/dist/css/swiper.css">

<script type="text/javascript">
$(function(){
	$("#txtKeyword").keydown(function (key) {		 
        if(key.keyCode == 13){
        	$("#imgSearch").trigger("click");
        } 
    });
	$("#imgSearch").click(function () {
		if($.trim($("#txtKeyword").val()) == "") {
			alert("검색어를 입력하세요.");
			$("#txtKeyword").focus();
			return false;
		}
		
		var frm = $("#frmSearch");
		frm.attr("action", "<c:url value='/goods/list'/>");
		frm.attr("method", "post");
		frm.find("input[name='keyword']").val($.trim($("#txtKeyword").val()));
		frm.submit();
	});
});

function fnDetail(goods_code, category) {
	var form = $("form[id=frmList]");
	form.find("input:hidden[id=hidGoodsCode]").val(goods_code);
	form.find("input:hidden[id=category]").val(category);
	form.attr({"method":"post","action":"<c:url value='/goods/detail'/>"});
	form.submit();		
}
</script>

</head>


<body>

<form id="frmSearch" name="frmSearch">
	<input type="hidden" id="keyword" name="keyword">
</form>

<form id="frmList" name="frmList" action="<c:url value='/goods/detail'/>">
	<input type="hidden" id="hidGoodsCode" name="hidGoodsCode">
	<input type="hidden" id="category" name="category">
</form>

<article id="main">
  <div class="main_v">
    <div class="tx1"><em>세부패키지 여행</em>, 고민하지말고 떠나세요</div>
    <div class="tx2">Details package tour is <em>OnePassTour</em></div>
    <div class="msearch_box">
      <div class="icon"><img src="/images/com/search_icon.png" id="imgSearch" alt=""/></div>
      <input type="text" placeholder="가고 싶은 투어, 여행지, 액티비티 검색어를 입력하세요" id="txtKeyword">
    </div>
  </div>

  <div id="visual">
    <div class="swiper-container">
      <ul class="swiper-wrapper">
      	<c:forEach var="list" items="${lstMainImage}">
	        <li class="swiper-slide"><img src="<c:url value='/file/getMainImage/'/>?image_sn=${list.IMAGE_SN}" alt=""> </li>
      	</c:forEach>
      </ul>
    </div>
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
  </div>
  
  <!-- 모바일 노출 -->
  <div id="visual_mobile">
    <div class="swiper-container">
      <ul class="swiper-wrapper">
      	<c:forEach var="list" items="${lstMainImage}">
	        <li class="swiper-slide"><img src="<c:url value='/file/getMainImage/'/>?image_sn=${list.IMAGE_SN}" alt=""> </li>
      	</c:forEach>
      </ul>
      <div class="swiper-pagination"></div>
    </div>
  </div>
  <!-- // 모바일 노출 --> 
    <div class="main_icon">
    <div class="inner2">
      <ul>
        <li>
          <div class="left_icon" onclick="go_01_01_01();"><img src="<c:url value='/images/main/main_a_01.png'/>" alt=""/></div>
          <div class="right_txt"><em>내가 고르는 나만의 여행</em><br>
            직접 상품을 골라 직접 
            <div class="pc_view"></div>
          만드는 셀프여행</div>
        </li>
        <li>
          <div class="left_icon" onclick="go_02_01_01();"><img src="<c:url value='/images/main/main_a_02.png'/>" alt=""/></div>
          <div class="right_txt"><em>이번달의 핫한 여행상품</em><br>
            여러분들이 가장 많이 
            <div class="pc_view"></div>
            찾은 인기 상품들</div>
        </li>
        <li>
          <div class="left_icon" onclick="go_03_01_01();"><img src="<c:url value='/images/main/main_a_03.png'/>" alt=""/></div>
          <div class="right_txt"><em>전문가의 추천 여행</em><br>
            원패스투어 전문가가 추천하는
            <div class="pc_view"></div>
            이번달 추천 여행</div>
        </li>
      </ul>
    </div>
  </div>
  <script src="/js/swiper.min.js" charset="utf-8"></script> 
  <script>
	
	   var swiper = new Swiper('#visual .swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev'
    });
	  	var swiperMobile = new Swiper( '#visual_mobile .swiper-container', {
				pagination: '.swiper-pagination',
				paginationClickable: false,
				autoplay: 3500,
				autoplayDisableOnInteraction: false
			} );
		</script> 
</article>

<!-- 본문 -->
<section>
  <div class="main_abox">
    <div class="inner2">
      <div class="title_box">
        <div class="tx1"><img src="<c:url value='/images/main/main_title01.png'/>"  alt=""/></div>
        <div class="tx2">지금뜨는 따끈따끈한 핫딜 여행정보입니다. 놓치지 마세요 </div>
      </div>
      <div class="cont_box">
      	<c:forEach var="list" items="${hotdeal}" varStatus="status" begin="0" end="2">
      		<div class="in0${status.index + 1}">
      		<c:if test="${list.GOODS_CODE == null}">
		        <img src="/images/main/main_b0${status.index + 1}.jpg"  alt=""/>
      		</c:if>
      		<c:if test="${list.GOODS_CODE != null}">
      			<img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}"  alt="" onclick="fnDetail('${list.GOODS_CODE}', 'H');"/>
      		</c:if>
      		</div>
      	</c:forEach>
      </div>
      <div class="cont_box">
      	<c:forEach var="list" items="${hotdeal}" varStatus="status" begin="3" end="5">
      		<div class="in0${status.index + 1}">
      		<c:if test="${list.GOODS_CODE == null}">
		        <img src="/images/main/main_b0${status.index + 1}.jpg"  alt=""/>
      		</c:if>
      		<c:if test="${list.GOODS_CODE != null}">
      			<img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}"  alt="" onclick="fnDetail('${list.GOODS_CODE}', 'H');"/>
      		</c:if>
      		</div>
      	</c:forEach>
      </div>
    </div>
  </div>
  <!--셀프여행-->
  <div class="main_cbox">
    <div class="inner2">
      <div class="title_box">
        <div class="tx1"><img src="/images/main/main_title02.png"  alt=""/></div>
        <div class="tx2">원패스투어에서 가장많은 선택을 받은 여행지입니다. 여행선정에 많은 도움이 되시길 바랍니다.</div>
      </div>
      <div class="cont_box"> <!-- Swiper --> 
        <!-- Swiper -->
        <div id="pro_sw" class="pc_view">
          <div class="swiper-container">
            <div class="swiper-wrapper">
            	<c:forEach var="list" items="${self}" varStatus="status">
	              <div class="swiper-slide"> 
	              <!---->
	              <div class="sw_out">
	                  <div class="sw_box">
	                    <div class="img">
							<img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}"  alt="" onclick="fnDetail('${list.GOODS_CODE}', 'S');"/>
	                      <div class="um">
	                        <div class="tx1">HIT</div>
	                        <div class="tx2">${status.index + 1 }</div>
	                      </div>
	                    </div>
	                    <div class="txt_box">
	                      <div class="title">${list.GOODS_NM }</div>
	                      <div class="price">
	                        <div class="tr_tx1"><!-- ￦ 900,000 --></div>
	                        <div class="tr_tx2">￦ 1,000,000</div>
	                      </div>
	                    </div>
	                  </div>
	                </div>
	                <!---->
	              </div>
            	</c:forEach>
            </div>
          
        
          </div>     <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>
        </div>
        
		  
		          <!-- Swiper -->
        <div id="pro_sw_m" class="mobile_view">
          <div class="swiper-container">
            <div class="swiper-wrapper">
            	<c:forEach var="list" items="${self}" varStatus="status">            
              <div class="swiper-slide"> <!----><div class="sw_out">
                  <div class="sw_box">
                    <div class="img">
                    	<img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}"  alt="" onclick="fnDetail('${list.GOODS_CODE}', 'S');"/>
                      <div class="um">
                        <div class="tx1">HIT</div>
                        <div class="tx2">${status.index + 1 }</div>
                      </div>
                    </div>
                    <div class="txt_box">
                      <div class="title">${list.GOODS_NM }</div>
                      <div class="price">
                        <div class="tr_tx1"><!-- ￦ 900,000 --></div>
                        <div class="tr_tx2">￦ 1,000,000</div>
                      </div>
                    </div>
                  </div>
                </div><!----></div>
                </c:forEach>
        
          </div>     <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>
        </div>
		  
        <!-- Swiper JS --> 
        <script src="/jq/swiper/dist/js/swiper.min.js"></script> 
        
        <!-- Initialize Swiper --> 
        <script>
    var swiper = new Swiper('#pro_sw .swiper-container', {
        pagination: '.swiper-pagination',
        slidesPerView: 3,
        paginationClickable: true,  nextButton: '.swiper-button-next',
            prevButton: '.swiper-button-prev',
        spaceBetween:0
    });
			 var swiper = new Swiper('#pro_sw_m .swiper-container', {
        pagination: '.swiper-pagination',
        slidesPerView: 2,
        paginationClickable: true,  nextButton: '.swiper-button-next',
            prevButton: '.swiper-button-prev',
        spaceBetween:0
    });
    </script> 
      </div>
    </div>
  </div>
  </div>
  <!--//셀프여행--> 
  <!--추천여행-->
  <div class="main_dbox">
    <div class="inner2">
      <div class="title_box">
        <div class="tx1"><img src="/images/main/main_title03.png"  alt=""/></div>
        <div class="tx2">지금뜨는 따끈따끈한 핫딜 여행정보입니다. 놓치지 마세요 </div>
      </div>
      <div class="cont_box">
        <div class="in01 fl">
          <div class="title">${reco[0].GOODS_NM}</div>
          <div class="text">${reco[0].GOODS_INTRCN_SIMPL}</div>
          <div class="more" onclick="fnDetail('${reco[0].GOODS_CODE}', 'R');">자세히보기 + </div>
        </div>
        <div class="in02 fr">
          <div class="icon"></div>
          	<c:if test="${reco[0].GOODS_CODE != null}">
          		<img src="<c:url value='/file/getImage/'/>?file_code=${reco[0].FILE_CODE}&file_sn=${reco[0].FILE_SN}"  alt=""/>
          	</c:if> 
          	<c:if test="${reco[0].GOODS_CODE == null}">
          		<img src="/images/main/main_d_01.jpg" alt=""/>
          	</c:if> 
          </div>
      </div>
      <div class="cont_box">
        <div class="in01 fl">
          <div class="title">${reco[1].GOODS_NM}</div>
          <div class="text">${reco[1].GOODS_INTRCN_SIMPL}</div>
          <div class="more" onclick="fnDetail('${reco[1].GOODS_CODE}', 'R');">자세히보기 + </div>
        </div>
        <div class="in02 fr">
          <div class="icon"></div>
          	<c:if test="${reco[1].GOODS_CODE != null}">
          		<img src="<c:url value='/file/getImage/'/>?file_code=${reco[1].FILE_CODE}&file_sn=${reco[1].FILE_SN}"  alt=""/>
          	</c:if> 
          	<c:if test="${reco[1].GOODS_CODE == null}">
          		<img src="/images/main/main_d_02.jpg" alt=""/>
          	</c:if> 
        </div>
      </div>
      <div class="cont_box">
        <div class="in03 fl">
          <div class="icon"></div>
          	<c:if test="${reco[2].GOODS_CODE != null}">
          		<img src="<c:url value='/file/getImage/'/>?file_code=${reco[2].FILE_CODE}&file_sn=${reco[2].FILE_SN}"  alt=""/>
          	</c:if> 
          	<c:if test="${reco[2].GOODS_CODE == null}">
          		<img src="/images/main/main_d_03.jpg" alt=""/>
          	</c:if> 
        </div>
        <div class="in04 fr">
          <div class="title">옵션투어</div>
          <div class="text">기획특가! 샹그릴라 호핑투어+<br>
            마사지+아얄라나이트투어 3박4일 </div>
          <div class="more">자세히보기 + </div>
        </div>
      </div>
      <div class="cont_box">
        <div class="in03 fl">
          <div class="icon"></div>
          	<c:if test="${reco[3].GOODS_CODE != null}">
          		<img src="<c:url value='/file/getImage/'/>?file_code=${reco[3].FILE_CODE}&file_sn=${reco[3].FILE_SN}"  alt=""/>
          	</c:if> 
          	<c:if test="${reco[3].GOODS_CODE == null}">
          		<img src="/images/main/main_d_04.jpg" alt=""/>
          	</c:if> 
        </div>
        <div class="in04 fr">
          <div class="title">옵션투어</div>
          <div class="text">기획특가! 샹그릴라 호핑투어+<br>
            마사지+아얄라나이트투어 3박4일 </div>
          <div class="more">자세히보기 + </div>
        </div>
      </div>
    </div>
  </div>
  <!--//추천여행--> 
  <!--홍보방-->
  <div class="main_ebox">
    <div class="inner2">
      <div class="title_box">
        <div class="t_inbox">
          <div class="tx1">라이브뷰 <em>홍보방</em></div>
          <div class="tx2">라이브 뷰 홍보방에 대한 간단한 소개가 들어가는 공간입니다.</div>
        </div>
        <div class="more">+</div>
      </div>
      <div class="cont_box">
        <ul>
        	<c:forEach var="list" items="${video}">
	          <li>
	            <div class="img"><img src="/images/main/ex1.jpg"  alt=""/></div>
	            <div class="tx1">라이브뷰 제목이 들어가는공간</div>
	            <div class="tx2">라이브뷰 제목이 들어가는공간</div>
	          </li>
        	</c:forEach>
        </ul>
      </div>
    </div>
  </div>
  <div class="notice_box">
    <div class="inner2">
      <div class="title">공지사항 <em>more</em></div>
      <ul>
        <li><em>2014-01-01</em> 홈페이지가 새로 문을 열었습니다. </li>
        <li><em>2014-01-01</em> 홈페이지가 새로 문을 열었습니다. </li>
        <li><em>2014-01-01</em> 홈페이지가 새로 문을 열었습니다. </li>
      </ul>
    </div>
  </div>
</section>
<!-- //본문 --> 


</body>