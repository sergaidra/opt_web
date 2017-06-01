<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<link href="/css/video-js.css" rel="stylesheet" type="text/css" media="screen">
<link href="/css/jquery-ui.css" rel="stylesheet" type="text/css" media="screen"/>
<script src="/js/jquery-1.11.1.js"></script>
<script src="/js/videojs-ie8.min.js"></script>
<script src="/js/video.js"></script>
<script src="/js/Youtube.min.js"></script>
<script type="text/javascript">
	var player;
	
	$(document).ready(function() {
		player = videojs('videoPlayer', {
			techOrder: ['youtube'],
			autoplay: false,
			sources: [{ 
				type: "video/youtube",
				src: "https://www.youtube.com/watch?v=3tJahCHjVhI"
			}]
		});
	});

	function fnChangeSource() {
		player.pause();
		player.currentTime(0);
		
		player.src(yaddr.value);
		
		player.ready(function() {
			this.one('loadeddata', videojs.bind(this, function() {
				this.currentTime(0);
			}));
	
			this.load();
			this.play();
		});
	}
	
</script>
</head>
<body>
<div align="center">
	<input type="text" id="yaddr" name="yaddr" size="80" value="https://www.youtube.com/watch?v=3tJahCHjVhI"> <a href="javascript:fnChangeSource()">재생</a>
<br><br>
	<video id="videoPlayer" class="video-js vjs-default-skin" controls preload="auto" width="640" height="268"></video>
</div>
</body>
</html>