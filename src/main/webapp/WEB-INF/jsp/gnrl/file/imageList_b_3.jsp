<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
<meta charset="UTF-8">
<style>
body {
	margin: 0 auto;
	background: #F0F0F0;
}

.gallery {
	overflow: hidden;
}

.gallery_img {
	position: absolute;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 100%
}

/* 갤러리 이미지 */
.gallery img {
	position: absolute;
	visibility: hidden;
	top: 0px;
	left: 0px;
	width: 100%
}

.gallery img.active {
	visibility: visible;
}

.gallery img.active_left {
	visibility: visible;
	left: -100%;
}

.gallery img.active_right {
	visibility: visible;
	left: 100%;
}

/* 이전/다음 사진 보여주기 클릭 영역 */
.gallery .left {
	position: absolute;
	top: 0px;
	left: 0px;
	width: 20%;
	height: 100%;
}

.gallery .right {
	position: absolute;
	top: 0px;
	left: 80%;
	width: 20%;
	height: 100%;
}

/* 이전/다음 사진 보여주기 클릭 영역 hover 시 보여지는 좌/우 화살표 이미지 */
.gallery .left .left_btn {
	position: absolute;
	width: 0;
	height: 0;
	left: 20%;
	top: 50%;
	margin-top: -10px;
	visibility: hidden;
	border-right: 10px solid white;
	border-top: 10px solid transparent;
	border-bottom: 10px solid transparent;
}

.gallery .right .right_btn {
	position: absolute;
	width: 0;
	height: 0;
	right: 20%;
	top: 50%;
	margin-top: -10px;
	visibility: hidden;
	border-left: 10px solid white;
	border-top: 10px solid transparent;
	border-bottom: 10px solid transparent;
}

.gallery .left:hover .left_btn {
	visibility: visible;
}

.gallery .right:hover .right_btn {
	visibility: visible;
}
</style>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script>
	(function($) {
		$.fn.gallery = function(options) {
			options = options || {};
			var $this = $(this);
			var $content = $this.children(".gallery_img");
			var $arrImage = $content.children("img");
			var iGalleryIndex = 0, iGalleryBefore = 0, iGalleryCount = $arrImage.length, iGalleryWidth = parseInt($this
					.css("width"));
			var iDuration = 1000;

			if (options.duration) {
				iDuration = options.duration;
			}

			// 현재 선택된 이미지를 보여준다.
			function ShowImage() {
				$arrImage.each(function(index) {
					if (iGalleryIndex == index) {
						$(this).removeClass("active_right");
						$(this).removeClass("active_left");
						$(this).addClass("active");
					} else {
						$(this).removeClass("active");
					}
				});
			}

			// 이전 버튼 영역 클릭시, 이전 사진을 보여준다.
			$this.children(".left").click(function() {
				iGalleryBefore = iGalleryIndex;
				--iGalleryIndex;
				if (iGalleryIndex < 0)
					iGalleryIndex = iGalleryCount - 1;
				$arrImage.eq(iGalleryIndex).addClass("active_right");
				$content.animate({
					left : -iGalleryWidth
				}, {
					duration : iDuration,
					complete : function() {
						$content.css({
							left : 0
						});
						ShowImage();
					}
				});
			});

			// 다음 버튼 영역 클릭시, 다음 사진을 보여준다.
			$this.children(".right").click(function() {
				iGalleryBefore = iGalleryIndex;
				++iGalleryIndex;
				if (iGalleryIndex >= iGalleryCount)
					iGalleryIndex = 0;
				$arrImage.eq(iGalleryIndex).addClass("active_left");
				$content.animate({
					left : iGalleryWidth
				}, {
					duration : iDuration,
					complete : function() {
						$content.css({
							left : 0
						});
						ShowImage();
					}
				});
			});

			ShowImage();
			return this;
		};
	}(jQuery));
	$(document).ready(function() {
		$(".gallery").gallery();
		//$(".gallery" ).gallery( { duration:5000 } );
	});
</script>
</head>
<body>
<!-- 사진에 적합하게 width, height 를 설정해야 한다. -->
<div class="gallery" style="position: relative; width: 824px; height: 428px;">
	<div class="gallery_img">
		<c:forEach var="list" items="${result}" varStatus="status">
			<img src="<c:url value='/file/getImage/'/>?file_code=${list.FILE_CODE}&file_sn=${list.FILE_SN}" width="100%" height="100%">
		</c:forEach>
	</div>

	<!-- 이전 사진 보여주기 클릭 영역 -->
	<div class="left">
		<div class="left_btn"></div>
	</div>
	​
	<!-- 다음 사진 보여주기 클릭 영역 -->
	<div class="right">
		<div class="right_btn"></div>
	</div>
</div>
</body>
</html>
​
