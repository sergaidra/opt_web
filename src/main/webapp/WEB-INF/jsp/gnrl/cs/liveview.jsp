<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<link rel="stylesheet" type="text/css" href="/jq/gallery/css/component.css" />
<script src="/jq/gallery/js/modernizr.custom.js"></script>

<style>
</style>

<script type="text/javascript">
function fnLiveView(url, obj) {
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
	$('#divVideoPlayer').find("#videoTitle").text($(obj).find("h3").text());
	$('#divVideoPlayer').find("#videoDesc").text($(obj).find("p").text());
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

function figResize() {
   var max_h=0;
   $("#grid-gallery figcaption").each(function(){ 
		$(this).css({height:''});
  });
   $("#grid-gallery figcaption").each(function(){
 		var h = parseInt($(this).css("height"));
    	if(max_h<h){ max_h = h; }
   });
   
   $("#grid-gallery figcaption").each(function(){ 
 		$(this).css({height:max_h});
   });   
   var ulW = Number($("#grid-gallery ul:eq(0)").css("width").replace(/[^0-9]/g, "")) + 5;
   var liW = Number($("#grid-gallery li:eq(0)").css("width").replace(/[^0-9]/g, ""));
   var cnt = Math.floor(ulW / liW);
   $("#grid-gallery li").each(function(index){
	   if(index % cnt == 0)
 		$(this).css({clear:"both"});
	   else
 		$(this).css({clear:"none"});
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
<!-- 본문 -->
<section>
 <div id="container">
<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
    <div class="inner2">
				<!--게시판 검색-->
      <div class="bbs_search comf">
        <div class="search_text">
          <div class="tx1"><i class="material-icons">&#xE412;</i></div>
          <div class="tx2">원패스투어의 동영상 홍보갤러리입니다. </div>
        </div>
        <!-- <div class="search_in">
          <div class="search_select ">기본 셀렉트 박스 .w_100p는 사이즈
            <select class="w_100p">
              <option>상세분류</option>
              <option>상세분류</option>
            </select>
            
            //기본 셀렉트 박스</div>
          <div class="search_input  search_input_w">
            <input type="text" class="w_100p">
            <div class="btn"><i class="material-icons">&#xE8B6;</i></div>
          </div>
        </div> -->
      </div>
      <!--//게시판 검색-->
			<div id="grid-gallery" class="grid-gallery comf">
				<section class="grid-wrap">
					<ul class="grid">
						<!-- <li class="grid-sizer"></li> --><!-- for Masonry column width -->
						<c:forEach var="item" items="${lstVideo}">
							<li onclick="fnLiveView('${item.VIDEO_URL}', this);" style="margin-bottom:10px;">
							<figure>
								<img src="<c:url value='/file/getImage/'/>?file_code=${item.FILE_CODE}" alt="img01"/>
								<figcaption><h3>${item.GOODS_NM}</h3><p>${item.GOODS_INTRCN_SIMPL}</p></figcaption>
							</figure>
							</li>
						</c:forEach>
					</ul>
				</section><!-- // grid-wrap -->
				<section class="slideshow">
					<ul>
					</ul>
					<nav>
						<span class="icon nav-prev"></span>
						<span class="icon nav-next"></span>
						<span class="icon nav-close"></span>
					</nav>
				
				</section> <!-- // slideshow -->
			</div>
		<script src="/jq/gallery/js/imagesloaded.pkgd.min.js"></script>
		<script src="/jq/gallery/js/masonry.pkgd.min.js"></script>
		<script src="/jq/gallery/js/classie.js"></script>
		<script src="/jq/gallery/js/cbpGridGallery.js"></script>
		<script>
			//new CBPGridGallery( document.getElementById( 'grid-gallery', {slideshow:false} ) );
			  $(document).ready(function(){
				  figResize();
				  $(window).resize(figResize);
			  });			
		</script>	
	<!--여백--><div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div><!--여백-->
		 <!-- <div class="list_more">     
      <div class="more_btn">
       <a href="SelfList2.jsp"> <div class="ok_btn">더보기</div></a>
      </div>
    </div> -->
		
	</div>  
<!--여백--><div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div><!--여백-->
  </div>

<!--팝업 : 동영상 홍보방-->
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

</body>
