<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
<link href="/css/video-js.css" rel="stylesheet" type="text/css" media="screen">
<link href="/css/jquery-ui.css" rel="stylesheet" type="text/css" media="screen"/>
<script src="/js/jquery-1.11.1.js"></script>
<script src="/js/jquery.blockUI.js"></script>
<script src="/js/videojs-ie8.min.js"></script>
<script src="/js/video.js"></script>
<script type="text/javascript">
/*
 * loading indicator show/hide
 */
function showLoading() {
	$.blockUI({
		overlayCSS:{
			backgroundColor:'#ffe',
			opacity: .5
		},
		css:{
			border:'none',
			opacity: .5,
			width:'80px',
			left:'45%'
		},
		message:"<img src='/images/loading_white.gif' width='80px'>"
	});
}

function hideLoading() {
	$.unblockUI();
}
</script>

<script type="text/javascript">
	var player;
	
	$(document).ready(function() {
		player = videojs('videoPlayer', {
			techOrder: ['flash', 'html5'],
			autoplay: false,
			poster: "<c:url value='/cmm/getThumbnail/'/>?file_id=${file_id}&file_no=${file_no}&thumb_no=",
			sources: [{ 
				type: "video/flv",
				src: "http://localhost<c:url value='/cmm/streamView/'/>?file_id=${file_id}&file_no=${file_no}"
			}]
		});
		fnChangeFrame();
		
	});

	function fnChangeSource(src) {
		player.pause();
		player.currentTime(0);
		
		player.src(src);
		
		player.ready(function() {
			this.one('loadeddata', videojs.bind(this, function() {
				this.currentTime(0);
			}));
	
			this.load();
			this.play();
		});
	}

	//동영상 특정위치 재생 - 초단위
	function fnNext(arg) {
		player.pause();
		player.currentTime(arg);

		player.ready(function() {
			this.one('loadeddata', videojs.bind(this, function() {
				this.currentTime(0);
			}));
	
			this.load();
			this.play();
		});
	}

	function fnChangeFrame() {
		document.getElementById("thumbFrame").src = "<c:url value='/cmm/thumbView/'/>?file_id=${file_id}&file_no=${file_no}";
	}

	function fnExtract(){
		var position = player.currentTime();

		var form_data = {
			file_id : "${file_id}",
			file_no : "${file_no}",
			position : position,
			is_ajax : 1
		};

		$.ajax({
			url : "<c:url value='/cmm/thumbExtract/'/>",
			dataType : "json",
			type : "POST",
			async : true,
			data : form_data,
			beforeSend:function(){
				player.pause();
				showLoading();
			},
			success : function(json) {
				if(json.result == "0") {
					fnChangeFrame();
				} else {
					alert("Fail");
				}
			},
			complete:function() {
				hideLoading();
				player.play();
			},
			error : function() {
				alert('error');
			}
		});
	}	

	function fnCopy(){

		var form_data = {
			file_id : "${file_id}",
			file_no : "${file_no}",
			copyPath : $('#copyPath').val(),
			copyOpt : $('#copyOpt').val(),
			is_ajax : 1
		};

		$.ajax({
			url : "<c:url value='/cmm/fileCopy/'/>",
			dataType : "json",
			type : "POST",
			async : true,
			data : form_data,
			beforeSend:function(){
				player.pause();
				showLoading();
			},
			success : function(json) {
				if(json.result == "0") {
					alert("Success");
				} else {
					alert("Fail");
				}
			},
			complete:function() {
				hideLoading();
				player.play();
			},
			error : function() {
				alert('error');
			}
		});
	}		
</script>
</head>
<body>
<div align="center">
	<video id="videoPlayer" class="video-js vjs-default-skin" controls preload="auto" width="640" height="268"></video>
	<br>
	<a href="javascript:fnExtract()">추출</a>
	<br>
	<iframe id="thumbFrame" src="" width="640" height="200" frameborder=0 border=0 scrolling="yes" ></iframe>
	<br>
	<input type="text" id="copyPath" name="copyPath" value="d:\">    
	<select id="copyOpt" name="copyOpt">
	<option value="1" selected>stream</option>
	<option value="2">cmd</option>
	</select> 
	<a href="javascript:fnCopy()">복사</a>
	<br>
</div>
</body>
</html>