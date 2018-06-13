<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<head>
	<meta property="og:type" content="website">
	<meta property="og:title" content="원패스투어">
	<meta property="og:description" content="내가 만드는 세부 여행, 고민하지 말고 떠나세요">
	<!-- <meta property="og:image" content="http://www.mysite.com/myimage.jpg"> -->
	<meta property="og:url" content="http://onepasstour.com">

<link rel="stylesheet" href="/jq/swiper/dist/css/swiper.css">

<script type="text/javascript">

$(function(){
	$("#txtKeyword").keydown(function (key) {		 
        if(key.keyCode == 13){
        	$("#imgSearch").trigger("click");
        } 
    });
	
	$("#txtKeyword2").keydown(function (key) {		 
        if(key.keyCode == 13){
        	$("#txtKeyword").val($("#txtKeyword2").val());
        	$("#imgSearch").trigger("click");
        } 
    });
	
	$("#txtKeyword").change(function () {
		$("#txtKeyword2").val($("#txtKeyword").val());
	});

	$("#txtKeyword2").change(function () {
		$("#txtKeyword").val($("#txtKeyword2").val());
	});

	$("#imgSearch").click(function () {
		if($.trim($("#txtKeyword").val()) == "") {
			alertPopup("<spring:message code='info.input.keyword'/>"
					, function() {
						$.featherlight.close();
						$("#txtKeyword").focus();
					}, null);
			return;
		}
		
		var frm = $("#frmSearch");
		frm.attr("action", "<c:url value='/goods/list'/>");
		frm.attr("method", "get");
		frm.find("input[name='keyword']").val(encodeURI($.trim($("#txtKeyword").val())));
		frm.find("input[name='category']").val("");
		frm.submit();
	});
});

function fnDetail(goods_code, category) {
	if(!goods_code) return;
	var form = $("form[id=frmList]");
	form.find("input:hidden[id=hidGoodsCode]").val(goods_code);
	form.find("input:hidden[id=category]").val(category);
	form.attr({"method":"get","action":"<c:url value='/goods/detail'/>"});
	form.submit();		
}

function fnHotDeal(kwrd) {
	var frm = $("#frmSearch");
	frm.attr("action", "<c:url value='/goods/list'/>");
	frm.attr("method", "get");
	frm.find("input[name='keyword']").val(encodeURI(kwrd));
	frm.find("input[name='category']").val("H");
	frm.submit();
}

function fnLiveView(url, title, desc) {
	var width = 0;
	if($(window).width() > 1294)
		width = 854;
	else if($(window).width() > 1000)
		width = 640;
	else
		width = $(window).width() - 100;

	$("#video").attr("width", width);

	$("head").find("style").each(function() {
		if($(this).attr("class") == "vjs-styles-dimensions") {
			$(this).remove();
		}
	});
	$('#divVideoPlayer').find("#videoTitle").text(title);
	$('#divVideoPlayer').find("#videoDesc").text(desc);
	$('#divVideoPlayer').find("#videoTitle").css("width", width);
	$('#divVideoPlayer').find("#videoDesc").css("width", width);
	if(width < 640)
		$("#video").css("margin-left", "50px");
	else
		$("#video").css("margin-left", "");
	
	$.featherlight($('#divVideoPlayer'), {});
	var videoEl = $(".featherlight video").get(0);
	player = videojs(videoEl, { "techOrder": ["youtube"], "sources": [{ "type": "video/youtube", "src": url}] });
	//player.src({type: "video/youtube", src: "https://youtu.be/3lQnRVN2Uok"});
	player.ready(function() {
		player.play();
		});
}
</script>

<link href="/jq/video/video-js.css" rel="stylesheet">
    
<!-- If you'd like to support IE8 -->
<script src="/jq/video/videojs-ie8.min.js"></script>

<script src="/jq/video/video.js"></script>
<script src="/jq/video/videojs-youtube-master/Youtube.min.js"></script>

</head>


<body>

<form id="frmSearch" name="frmSearch">
	<input type="hidden" id="keyword" name="keyword">
	<input type="hidden" id="category" name="category">
</form>

<form id="frmList" name="frmList" action="<c:url value='/goods/detail'/>">
	<input type="hidden" id="hidGoodsCode" name="hidGoodsCode">
	<input type="hidden" id="category" name="category">
</form>

<article id="main">
  <div class="main_f">
  <div class="main_v">
    <div class="tx1"><spring:message code='intro.main.title'/></div>
    <div class="tx2">Self-made package tour - <em><img src="/images/com/logo.png"  alt=""/></em></div>
    <div class="msearch_box">
      <div class="icon"><img src="/images/com/search_icon.png" id="imgSearch" alt="" style="cursor:pointer;"/></div>
      <input type="text" placeholder="<spring:message code='intro.main.placeholder1'/>" id="txtKeyword" class="pc_view">
      <input type="text" placeholder="<spring:message code='intro.main.placeholder2'/>" class="mobile_view" id="txtKeyword2">
    </div>
  </div>

  <div id="visual">
    <div class="swiper-container">
      <ul class="swiper-wrapper">
      	<c:forEach var="list" items="${lstMainImage}">
	        <li class="swiper-slide"><div class="swiper-slidebg1" style="background:url(<c:url value='/file/getMainImage/'/>?image_sn=${list.IMAGE_SN}); background-position:left top; background-size: cover;"></div></li>
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
	        <li class="swiper-slide"><div class="swiper-slidebg1" style="background:url(<c:url value='/file/getMainImage/'/>?image_sn=${list.IMAGE_SN}); background-position:left top; background-size: cover;"></div></li>
      	</c:forEach>
      </ul>
    </div>
  </div>
  </div>
  <!-- // 모바일 노출 --> 
    <div class="main_icon">
    <div class="inner2">
      <ul>
        <li>
          <div class="left_icon" onclick="go_01_01_01();" style="cursor:pointer;"><img src="<c:url value='/images/main/main_a_01.png'/>" alt=""/></div>
          <div class="right_txt" onclick="go_01_01_01();" style="cursor:pointer;"><spring:message code='intro.main.msg1'/></div>
        </li>
        <li>
          <div class="left_icon" onclick="go_02_01_01();" style="cursor:pointer;"><img src="<c:url value='/images/main/main_a_02.png'/>" alt=""/></div>
          <div class="right_txt" onclick="go_02_01_01();" style="cursor:pointer;"><spring:message code='intro.main.msg2'/></div>
        </li>
        <li>
          <div class="left_icon" onclick="go_03_01_01();" style="cursor:pointer;"><img src="<c:url value='/images/main/main_a_03.png'/>" alt=""/></div>
          <div class="right_txt" onclick="go_03_01_01();" style="cursor:pointer;"><spring:message code='intro.main.msg3'/></div>
        </li>
      </ul>
    </div>
  </div>
  <script src="/js/swiper.min.js" charset="utf-8"></script> 
  <script>
	
	   var swiper = new Swiper('#visual .swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
		autoplay: 3500,
		speed: 2000,
		loop: true,
		effect: 'fade', // 'slide' or 'fade' or 'cube' or 'coverflow' or 'flip'
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev',
		autoplayDisableOnInteraction: false
    });
	  	var swiperMobile = new Swiper( '#visual_mobile .swiper-container', {
				pagination: '.swiper-pagination',
				paginationClickable: true,
				autoplay: 3500,
				speed: 2000,
				loop: true,
				effect: 'fade', // 'slide' or 'fade' or 'cube' or 'coverflow' or 'flip'
				nextButton: '.swiper-button-next',
		        prevButton: '.swiper-button-prev',
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
        <div class="tx2"><spring:message code='intro.hotdeal.msg'/></div>
      </div>
      <div class="cont_box">
      	<c:forEach var="list" items="${hotdeal}" varStatus="status" begin="0" end="2">
      		<div class="in0${status.index + 1}">
      			<c:if test="${status.index == 0}">
    			<a href="javascript:fnHotDeal('${list.KWRD}', 'H');"><div class="imgover"></div><img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE_L}"  alt="" /></a>
      			</c:if>
      			<c:if test="${status.index != 0}">
    			<a href="javascript:fnHotDeal('${list.KWRD}', 'H');"><div class="imgover"></div><img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE_S}"  alt="" /></a>
      			</c:if>
      		</div>
      	</c:forEach>
      </div>
      <div class="cont_box">
      	<c:forEach var="list" items="${hotdeal}" varStatus="status" begin="3" end="5">
      		<div class="in0${status.index + 1}">
      			<c:if test="${status.index == 5}">
      			<a href="javascript:fnHotDeal('${list.KWRD}', 'H');"><div class="imgover"></div><img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE_L}"  alt="" /></a>
      			</c:if>
      			<c:if test="${status.index != 5}">
      			<a href="javascript:fnHotDeal('${list.KWRD}', 'H');"><div class="imgover"></div><img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE_S}"  alt="" /></a>
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
        <div class="tx2"><spring:message code='intro.self.msg'/></div>
      </div>
      <div class="cont_box"> <!-- Swiper --> 
        <!-- Swiper -->
        <!-- pc -->
        <div id="pro_sw">
          <div class="swiper-container">
            <div class="swiper-wrapper">
            	<c:forEach var="list" items="${self}" varStatus="status">
	              <div class="swiper-slide"> 
	              <!---->
	              <div class="sw_out">
	                  <a href="javascript:fnDetail('${list.GOODS_CODE}', 'S');">
	                  <div class="sw_box">
	                    <div class="img">
							<!-- <img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}"  alt="" onclick="fnDetail('${list.GOODS_CODE}', 'S');"/> -->
		                      <div class="um">
		                        <div class="tx1">HIT</div>
		                        <div class="tx2">${status.index + 1 }</div>
		                      </div>
	                    	<div class="imgbg" style="background: url(<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN});">
		                    </div>
		                </div>
		                <div class="txt_box">
		                  <div class="title">
		                  	<c:if test="${pageContext.response.locale.language == 'en'}">
								<div class="tx1">${list.GOODS_NM_SUB_ENG}</div>
              					<div class="tx2">${list.GOODS_NM_ENG }</div>	                  	
		                  	</c:if>
		                  	<c:if test="${pageContext.response.locale.language != 'en'}">
								<div class="tx1">${list.GOODS_NM_SUB}</div>
              					<div class="tx2">${list.GOODS_NM }</div>	                  	
		                  	</c:if>
		                  </div>
		                  <div class="price">
		                  	<c:if test="${list.REPRSNT_PRICE != null and list.REPRSNT_PRICE != ''}">
		                    	<div class="tr_tx2">${list.REPRSNT_PRICE}</div>
		                  	</c:if>
		                  	<c:if test="${list.REPRSNT_PRICE == null or list.REPRSNT_PRICE == ''}">
			                  	<c:if test="${list.HOTDEAL_AT == 'Y'}">
			                    	<div class="tr_tx1">￦ <fmt:formatNumber value="${list.ORIGIN_AMOUNT}" pattern="#,###" /></div>
			                    	<div class="tr_tx2">￦ <fmt:formatNumber value="${list.ORIGIN_AMOUNT * list.DSCNT_RATE}" pattern="#,###" /></div>
			                  	</c:if>
			                  	<c:if test="${list.HOTDEAL_AT != 'Y'}">
			                    	<div class="tr_tx2">￦ <fmt:formatNumber value="${list.ORIGIN_AMOUNT}" pattern="#,###" /></div>
			                  	</c:if>
		                  	</c:if>
	                      </div>
	                    </div>
	                    </div>
	                  </a>
	                </div>
	                <!---->
	              </div>
            	</c:forEach>
            </div>
          
        
          </div>     
          <div class="swiper-button-prev"></div>
          <div class="swiper-button-next"></div>
        </div>
        
        <!-- 테블렛 -->
        <div id="pro_sw_m">
          <div class="swiper-container">
            <div class="swiper-wrapper">
            	<c:forEach var="list" items="${self}" varStatus="status">
	              <div class="swiper-slide"> 
	              <!---->
	              <div class="sw_out">
	                  <a href="javascript:fnDetail('${list.GOODS_CODE}', 'S');">
	                  <div class="sw_box">
	                    <div class="img">
	                    	<div class="imgbg" style="background: url(<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN});">
							<!-- <img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}"  alt="" onclick="fnDetail('${list.GOODS_CODE}', 'S');"/> -->
		                      <div class="um">
		                        <div class="tx1">HIT</div>
		                        <div class="tx2">${status.index + 1 }</div>
		                      </div>
		                    </div>
		                </div>
		                <div class="txt_box">
		                  <div class="title">
		                  	<c:if test="${pageContext.response.locale.language == 'en'}">
								<div class="tx1">${list.GOODS_NM_SUB_ENG}</div>
              					<div class="tx2">${list.GOODS_NM_ENG }</div>	                  	
		                  	</c:if>
		                  	<c:if test="${pageContext.response.locale.language != 'en'}">
								<div class="tx1">${list.GOODS_NM_SUB}</div>
              					<div class="tx2">${list.GOODS_NM }</div>	                  	
		                  	</c:if>
		                  </div>
		                  <div class="price">
		                  	<c:if test="${list.REPRSNT_PRICE != null and list.REPRSNT_PRICE != ''}">
		                    	<div class="tr_tx2">${list.REPRSNT_PRICE}</div>
		                  	</c:if>
		                  	<c:if test="${list.REPRSNT_PRICE == null or list.REPRSNT_PRICE == ''}">
			                  	<c:if test="${list.HOTDEAL_AT == 'Y'}">
			                    	<div class="tr_tx1">￦ <fmt:formatNumber value="${list.ORIGIN_AMOUNT}" pattern="#,###" /></div>
			                    	<div class="tr_tx2">￦ <fmt:formatNumber value="${list.ORIGIN_AMOUNT * list.DSCNT_RATE}" pattern="#,###" /></div>
			                  	</c:if>
			                  	<c:if test="${list.HOTDEAL_AT != 'Y'}">
			                    	<div class="tr_tx2">￦ <fmt:formatNumber value="${list.ORIGIN_AMOUNT}" pattern="#,###" /></div>
			                  	</c:if>
			                 </c:if>
	                      </div>
	                    </div>
	                    </div>
	                  </a>
	                </div>
	                <!---->
	              </div>
            	</c:forEach>
            </div>
          
        
          </div>     
          <div class="swiper-button-prev"></div>
          <div class="swiper-button-next"></div>
        </div>

        <!-- 모바일 -->
        <div id="pro_sw_s">
          <div class="swiper-container">
            <div class="swiper-wrapper">
            	<c:forEach var="list" items="${self}" varStatus="status">
	              <div class="swiper-slide"> 
	              <!---->
	              <div class="sw_out">
	                  <a href="javascript:fnDetail('${list.GOODS_CODE}', 'S');">
	                  <div class="sw_box">
	                    <div class="img">
	                    	<div class="imgbg" style="background: url(<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN});">
							<!-- <img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}"  alt="" onclick="fnDetail('${list.GOODS_CODE}', 'S');"/> -->
		                      <div class="um">
		                        <div class="tx1">HIT</div>
		                        <div class="tx2">${status.index + 1 }</div>
		                      </div>
		                    </div>
		                </div>
		                <div class="txt_box">
		                  <div class="title">
		                  	<c:if test="${pageContext.response.locale.language == 'en'}">
								<div class="tx1">${list.GOODS_NM_SUB_ENG}</div>
              					<div class="tx2">${list.GOODS_NM_ENG }</div>	                  	
		                  	</c:if>
		                  	<c:if test="${pageContext.response.locale.language != 'en'}">
								<div class="tx1">${list.GOODS_NM_SUB}</div>
              					<div class="tx2">${list.GOODS_NM }</div>	                  	
		                  	</c:if>
		                  </div>
		                  <div class="price">
		                  	<c:if test="${list.REPRSNT_PRICE != null and list.REPRSNT_PRICE != ''}">
		                    	<div class="tr_tx2">${list.REPRSNT_PRICE}</div>
		                  	</c:if>
		                  	<c:if test="${list.REPRSNT_PRICE == null or list.REPRSNT_PRICE == ''}">
			                  	<c:if test="${list.HOTDEAL_AT == 'Y'}">
			                    	<div class="tr_tx1">￦ <fmt:formatNumber value="${list.ORIGIN_AMOUNT}" pattern="#,###" /></div>
			                    	<div class="tr_tx2">￦ <fmt:formatNumber value="${list.ORIGIN_AMOUNT * list.DSCNT_RATE}" pattern="#,###" /></div>
			                  	</c:if>
			                  	<c:if test="${list.HOTDEAL_AT != 'Y'}">
			                    	<div class="tr_tx2">￦ <fmt:formatNumber value="${list.ORIGIN_AMOUNT}" pattern="#,###" /></div>
			                  	</c:if>
			                 </c:if>
	                      </div>
	                    </div>
	                    </div>
	                  </a>
	                </div>
	                <!---->
	              </div>
            	</c:forEach>
            </div>
          
        
          </div>     
          <div class="swiper-button-prev"></div>
          <div class="swiper-button-next"></div>
        </div>

		  
        <!-- Swiper JS --> 
        <script src="/jq/swiper/dist/js/swiper.min.js"></script> 
        
        <!-- Initialize Swiper --> 
        <script>
    var swiper = new Swiper('#pro_sw .swiper-container', {
        pagination: '.swiper-pagination',
        slidesPerView: 4,
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
			 var swiper = new Swiper('#pro_sw_s .swiper-container', {
        pagination: '.swiper-pagination',
        slidesPerView: 1,
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
        <div class="tx2"><spring:message code='intro.recom.msg'/> </div>
      </div>
      <a href="javascript:fnDetail('${reco[0].GOODS_CODE}', 'R');">
      <div class="cont_box">
        <div class="in01 fl">
			<c:if test="${pageContext.response.locale.language == 'en'}">
	          <div class="title">${reco[0].GOODS_NM_ENG}</div>
	          <div class="text">${reco[0].GOODS_INTRCN_SIMPL_ENG}</div>
			</c:if>        
			<c:if test="${pageContext.response.locale.language != 'en'}">
	          <div class="title">${reco[0].GOODS_NM}</div>
	          <div class="text">${reco[0].GOODS_INTRCN_SIMPL}</div>
			</c:if>        
          <div class="more" ><spring:message code='intro.recom.more'/></div>
        </div>
        <c:set var="url1" value="/images/main/main_d_01.jpg"/>
       	<c:if test="${reco[0].GOODS_CODE != null}">
       		<c:set var="url1" value="/file/getImage/?file_code=${reco[0].FILE_CODE}&file_sn=${reco[0].FILE_SN}"/>
        </c:if>
        <div class="in02 fr">
          <div class="icon"></div>
		  <div class="imgbox" style="background: url(<c:out value="${url1}"/>); "></div>          
        </div>
      </div>
      </a>
      <div class="cont_box">
        <div class="in01 fl">
			<c:if test="${pageContext.response.locale.language == 'en'}">
	          <div class="title">${reco[1].GOODS_NM_ENG}</div>
	          <div class="text">${reco[1].GOODS_INTRCN_SIMPL_ENG}</div>
			</c:if>        
			<c:if test="${pageContext.response.locale.language != 'en'}">
	          <div class="title">${reco[1].GOODS_NM}</div>
	          <div class="text">${reco[1].GOODS_INTRCN_SIMPL}</div>
			</c:if>        
          <a href="javascript:fnDetail('${reco[1].GOODS_CODE}', 'R');"><div class="more" ><spring:message code='intro.recom.more'/></div></a>
        </div>
        <c:set var="url2" value="/images/main/main_d_02.jpg"/>
       	<c:if test="${reco[1].GOODS_CODE != null}">
       		<c:set var="url2" value="/file/getImage/?file_code=${reco[1].FILE_CODE}&file_sn=${reco[1].FILE_SN}"/>
        </c:if>
        <div class="in02 fr">
          <div class="icon"></div>
		  <div class="imgbox" style="background: url(<c:out value="${url2}"/>); "></div>          
        </div>
      </div>
      <div class="cont_box">
        <c:set var="url3" value="/images/main/main_d_03.jpg"/>
       	<c:if test="${reco[2].GOODS_CODE != null}">
       		<c:set var="url3" value="/file/getImage/?file_code=${reco[2].FILE_CODE}&file_sn=${reco[2].FILE_SN}"/>
        </c:if>
        <div class="in03 fl">
          <div class="icon"></div>
		  <div class="imgbox" style="background: url(<c:out value="${url3}"/>); "></div>          
        </div>
        <div class="in04 fr">
			<c:if test="${pageContext.response.locale.language == 'en'}">
	          <div class="title">${reco[2].GOODS_NM_ENG}</div>
	          <div class="text">${reco[2].GOODS_INTRCN_SIMPL_ENG}</div>
			</c:if>        
			<c:if test="${pageContext.response.locale.language != 'en'}">
	          <div class="title">${reco[2].GOODS_NM}</div>
	          <div class="text">${reco[2].GOODS_INTRCN_SIMPL}</div>
			</c:if>        
          <a href="javascript:fnDetail('${reco[2].GOODS_CODE}', 'R');"><div class="more"><spring:message code='intro.recom.more'/></div></a>
        </div>
      </div>
      <div class="cont_box">
        <c:set var="url4" value="/images/main/main_d_04.jpg"/>
       	<c:if test="${reco[3].GOODS_CODE != null}">
       		<c:set var="url4" value="/file/getImage/?file_code=${reco[3].FILE_CODE}&file_sn=${reco[3].FILE_SN}"/>
        </c:if>
        <div class="in03 fl" >
          <div class="icon"></div>
		  <div class="imgbox" style="background: url(<c:out value="${url4}"/>); "></div>          
        </div>
        <div class="in04 fr">
			<c:if test="${pageContext.response.locale.language == 'en'}">
	          <div class="title">${reco[3].GOODS_NM_ENG}</div>
	          <div class="text">${reco[3].GOODS_INTRCN_SIMPL_ENG}</div>
			</c:if>        
			<c:if test="${pageContext.response.locale.language != 'en'}">
	          <div class="title">${reco[3].GOODS_NM}</div>
	          <div class="text">${reco[3].GOODS_INTRCN_SIMPL}</div>
			</c:if>        
          <a href="javascript:fnDetail('${reco[3].GOODS_CODE}', 'R');"><div class="more"><spring:message code='intro.recom.more'/></div></a>
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
          <div class="tx1"><spring:message code='intro.liveview.msg1'/></div>
          <div class="tx2"><spring:message code='intro.liveview.msg2'/></div>
        </div>
        <a href="javascript:go_07_05_01();"><div class="more">+</div></a>
      </div>
      <div class="cont_box">
	     <div class="div_pc">
			<div class="swiper-container2">
				<div class="swiper-wrapper">
		        	<c:forEach var="item" items="${video}">
						<div class="swiper-slide">
							<c:if test="${pageContext.response.locale.language == 'en'}">
								<c:set var="GOODS_NM" value="${item.GOODS_NM_ENG}"/>
								<c:set var="GOODS_INTRCN_SIMPL" value="${item.GOODS_INTRCN_SIMPL_ENG}"/>
							</c:if>
							<c:if test="${pageContext.response.locale.language != 'en'}">
								<c:set var="GOODS_NM" value="${item.GOODS_NM}"/>
								<c:set var="GOODS_INTRCN_SIMPL" value="${item.GOODS_INTRCN_SIMPL}"/>
							</c:if>
							<a href="javascript:fnLiveView('${item.VIDEO_URL}', '${GOODS_NM}', '${GOODS_INTRCN_SIMPL}');">
								<div class="main_ebox_img" >
									<div class="imgbox" style="background: url(<c:url value='/file/getImage/'/>?file_code=${item.FILE_CODE}&file_sn=${item.FILE_SN})"></div>
								</div>
								<div class="main_ebox_tx1">${GOODS_NM}</div>
								<div class="main_ebox_tx2">${GOODS_INTRCN_SIMPL}</div>
							</a>
						</div>
					</c:forEach>					
				</div>
				<div class="swiper-button-prev2"></div>
				<div class="swiper-button-next2"></div>				
			</div> 
	     </div>
	     <div class="div_tb">
			<div class="swiper-container2">
				<div class="swiper-wrapper">
		        	<c:forEach var="item" items="${video}">
						<div class="swiper-slide">
							<c:if test="${pageContext.response.locale.language == 'en'}">
								<c:set var="GOODS_NM" value="${item.GOODS_NM_ENG}"/>
								<c:set var="GOODS_INTRCN_SIMPL" value="${item.GOODS_INTRCN_SIMPL_ENG}"/>
							</c:if>
							<c:if test="${pageContext.response.locale.language != 'en'}">
								<c:set var="GOODS_NM" value="${item.GOODS_NM}"/>
								<c:set var="GOODS_INTRCN_SIMPL" value="${item.GOODS_INTRCN_SIMPL}"/>
							</c:if>
							<a href="javascript:fnLiveView('${item.VIDEO_URL}', '${GOODS_NM}', '${GOODS_INTRCN_SIMPL}');">
								<div class="main_ebox_img" >
									<div class="imgbox" style="background: url(<c:url value='/file/getImage/'/>?file_code=${item.FILE_CODE}&file_sn=${item.FILE_SN})"></div>
								</div>
								<div class="main_ebox_tx1">${GOODS_NM}</div>
								<div class="main_ebox_tx2">${GOODS_INTRCN_SIMPL}</div>
							</a>
						</div>
					</c:forEach>					
				</div>
				<div class="swiper-button-prev2"></div>
				<div class="swiper-button-next2"></div>				
			</div> 
	     </div>
	     <div class="div_mo">
			<div class="swiper-container2">
				<div class="swiper-wrapper">
		        	<c:forEach var="item" items="${video}">
						<div class="swiper-slide">
							<c:if test="${pageContext.response.locale.language == 'en'}">
								<c:set var="GOODS_NM" value="${item.GOODS_NM_ENG}"/>
								<c:set var="GOODS_INTRCN_SIMPL" value="${item.GOODS_INTRCN_SIMPL_ENG}"/>
							</c:if>
							<c:if test="${pageContext.response.locale.language != 'en'}">
								<c:set var="GOODS_NM" value="${item.GOODS_NM}"/>
								<c:set var="GOODS_INTRCN_SIMPL" value="${item.GOODS_INTRCN_SIMPL}"/>
							</c:if>
							<a href="javascript:fnLiveView('${item.VIDEO_URL}', '${GOODS_NM}', '${GOODS_INTRCN_SIMPL}');">
								<div class="main_ebox_img" >
									<div class="imgbox" style="background: url(<c:url value='/file/getImage/'/>?file_code=${item.FILE_CODE}&file_sn=${item.FILE_SN})"></div>
								</div>
								<div class="main_ebox_tx1">${GOODS_NM}</div>
								<div class="main_ebox_tx2">${GOODS_INTRCN_SIMPL}</div>
							</a>
						</div>
					</c:forEach>					
				</div>
				<div class="swiper-button-prev2"></div>
				<div class="swiper-button-next2"></div>				
			</div> 
	     </div>

    <!-- Swiper JS -->
    <script src="/jq/swiper/dist/js/swiper.min.js"></script>

    <!-- Initialize Swiper -->
    <script>
    var swiper = new Swiper('.div_pc .swiper-container2', {
        pagination: '.swiper-pagination',
        slidesPerView: 5,
        paginationClickable: true,  nextButton: '.swiper-button-next2',
         prevButton: '.swiper-button-prev2',
        spaceBetween:0,
		autoplay: 2500,
        autoplayDisableOnInteraction: false
    });
		var swiper = new Swiper('.div_tb .swiper-container2', {
        pagination: '.swiper-pagination',
        slidesPerView:3,
        paginationClickable: true,  nextButton: '.swiper-button-next2',
            prevButton: '.swiper-button-prev2',
        spaceBetween:0,
		autoplay: 2500,
        autoplayDisableOnInteraction: false
    });
		var swiper = new Swiper('.div_mo .swiper-container2', {
        pagination: '.swiper-pagination',
        slidesPerView: 2,
        paginationClickable: true,  nextButton: '.swiper-button-next2',
         prevButton: '.swiper-button-prev2',
        spaceBetween:0,
		autoplay: 2500,
        autoplayDisableOnInteraction: false
    });
    </script>
	     
	     
      </div>
    </div>
  </div>
  <div class="notice_box">
    <div class="inner2">
      <div class="title"><spring:message code='intro.notice'/> <em><a href="javascript:go_07_04_01();" style="color:white;">more</a></em></div>
      <ul>
      	<c:forEach var="item" items="${lstNotice}">
	        <li style="cursor:pointer;" onclick="document.location.href='/cs/viewNotice?bbs_sn=${item.BBS_SN}';"><em>${item.WRITNG_DT}</em> ${item.SUBJECT} </li>
      	</c:forEach>
      </ul>
    </div>
  </div>
<%--   
	<div class="banner_box">
		<div class="inbox">     
			<!-- pc-->
			<div class="div_pc">
				<div class="swiper-container3">
					<div class="swiper-wrapper">
						<c:forEach var="item" items="${lstBanner}">
							<div class="swiper-slide"><div class="banner_in"> <div class="in" onclick="window.open('${item.LINK_URL}');" style="background:url(/file/getBannerImage/?banner_sn=${item.BANNER_SN}); background-repeat:no-repeat; background-position:center center; cursor:pointer;"></div></div></div>							
						</c:forEach>
					</div>
					<!-- Add Pagination -->
					<!-- <div class="swiper-pagination3"></div>-->
					<!-- Add Arrows -->
					<div class="swiper-button-prev3"></div>
					<div class="swiper-button-next3"></div>
				</div>
			</div>		  
			<!-- 테블렛-->
			<div class="div_tb">
				<div class="swiper-container3">
					<div class="swiper-wrapper">
						<c:forEach var="item" items="${lstBanner}">
							<div class="swiper-slide"><div class="banner_in"> <div class="in" onclick="window.open('${item.LINK_URL}');" style="background:url(/file/getBannerImage/?banner_sn=${item.BANNER_SN}); background-repeat:no-repeat; background-position:center center; cursor:pointer;"></div></div></div>							
						</c:forEach>
					</div>
					<!-- Add Pagination -->
					<!-- <div class="swiper-pagination3"></div>-->
					<!-- Add Arrows -->
					<div class="swiper-button-prev3"></div>
					<div class="swiper-button-next3"></div>
				</div>
			</div>		  
		  	<!-- 모바일-->
			<div class="div_mo">
				<div class="swiper-container3">
					<div class="swiper-wrapper">
						<c:forEach var="item" items="${lstBanner}">
							<div class="swiper-slide"><div class="banner_in"> <div class="in" onclick="window.open('${item.LINK_URL}');" style="background:url(/file/getBannerImage/?banner_sn=${item.BANNER_SN}); background-repeat:no-repeat; background-position:center center; cursor:pointer;"></div></div></div>							
						</c:forEach>
					</div>
					<!-- Add Pagination -->
					<!-- <div class="swiper-pagination3"></div>-->
					<!-- Add Arrows -->
					<div class="swiper-button-prev3"></div>
					<div class="swiper-button-next3"></div>
				</div>
			</div>

    <!-- Swiper JS -->
    <script src="/jq/swiper/dist/js/swiper.min.js"></script>

    <!-- Initialize Swiper -->
    <script>
    var swiper = new Swiper('.div_pc .swiper-container3', {
        pagination: '.swiper-pagination',
        slidesPerView: 5,
        paginationClickable: true,  nextButton: '.swiper-button-next3',
            prevButton: '.swiper-button-prev3',
        spaceBetween:0,
		autoplay: 2500,
        autoplayDisableOnInteraction: false
    });
		var swiper = new Swiper('.div_tb .swiper-container3', {
        pagination: '.swiper-pagination',
        slidesPerView: 3,
        paginationClickable: true,  nextButton: '.swiper-button-next3',
            prevButton: '.swiper-button-prev3',
        spaceBetween:0,
		autoplay: 2500,
        autoplayDisableOnInteraction: false
    });
		var swiper = new Swiper('.div_mo .swiper-container3', {
        pagination: '.swiper-pagination',
        slidesPerView: 2,
        paginationClickable: true,  nextButton: '.swiper-button-next3',
            prevButton: '.swiper-button-prev3',
        spaceBetween:0,
		autoplay: 2500,
        autoplayDisableOnInteraction: false
    });
    </script>
		</div>
	</div>
  --%> 
  
  
<!--팝업 : 라이브뷰 홍보방-->
<div class="lightbox" id="divVideoPlayer">
  <div class="popup_com2" style="/*margin-top:30px;*/ width:100%;">
  	<div id="videoTitle" style="font-size:26px; font-family:'Noto Sans Korean', 'Noto Sans KR'; font-weight:500;"></div>
  	<div id="videoDesc" style="font-size:14px; color:#999; line-height:20px;"></div>
  	<video id="video" class="video-js vjs-default-skin" controls preload="auto" ></video>
  </div>
</div>
<!--팝업-->
  
</section>
<!-- //본문 --> 

<!-- 메인 이벤트 팝업 POPUP  -->
<div id="" class="popup_st" style=""> 
<c:forEach var="item" items="${popupNotice}">
	<c:set var="popup_width" value="${item.POPUP_WIDTH}" />
	<c:set var="popup_height" value="${item.POPUP_HEIGHT}" />
	<style>
		@media only all and (min-width:769px) {
			.popup_width_${item.BBS_SN} { <c:if test="${popup_width != null}">width:${popup_width}px !important; top:90px;</c:if><c:if test="${popup_width == null}">width:400px !important; top:90px;</c:if>	}
			.popup_height_${item.BBS_SN} { <c:if test="${popup_height != null}">height:${popup_height}px !important;</c:if> }
		}
	</style>
	<div id="divpop_${item.BBS_SN}" class="popup_width_${item.BBS_SN}" style="float:left;"> 
	 <!-- 제목을 넣을경우-->
	 <!-- <div class="popup_head">${item.SUBJECT}</div> --> 
		 <div class="popup_body"> 
		   <div class="popupcont1 popup_height_${item.BBS_SN}" style="padding:0px;">
		 	<!--<div class="tx1">${item.SUBJECT}</div>-->
		 	<div class="tx3">${item.CONTENTS}</div>
		   </div>		
		</div>
		 <div class="popup_bottom"><form name="notice_form">
	    <a href="javascript:closeWin(this, '${item.BBS_SN}');"><i class="material-icons">&#xE14C;</i></a>
		<div class="tx"><spring:message code='intro.notice.close'/></div>
	<div class="tx">
	      <input type="checkbox" name="chkbox" value="checkbox" style="cursor:pointer;">
	    </div>
			</form></div>
		
	
	</div>  
</c:forEach>
</div>

<script language="Javascript">
cookiedata = document.cookie;
<c:forEach var="item" items="${popupNotice}">
if ( cookiedata.indexOf("maindiv_${item.BBS_SN}=done") < 0 ){
	$("#divpop_${item.BBS_SN}").css("visibility", "visible");
}
</c:forEach>

function setCookie( name, value, expiredays ) { 
	var todayDate = new Date(); 
		todayDate.setDate( todayDate.getDate() + expiredays ); 
		document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
	} 

function closeWin(obj, bbs_sn) {
	if($("#divpop_" + bbs_sn).find("[name='chkbox']").is(":checked")) {
		setCookie( "maindiv" + "_" + bbs_sn, "done" , 1 ); 
	} 
	$("#divpop_" + bbs_sn).css("visibility", "hidden");
}

</script>

</body>