<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
        <title>banner</title>
        <script type="text/javascript" src="/js/jquery-1.11.1.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
 
                var topHeight = parseInt($("#floatingTop").css("top").substring(0,$("#floatingTop").css("top").indexOf("px")));
 
                $(window).scroll(function () { 
                    offset = topHeight+$(document).scrollTop()+"px";
                    $("#floatingTop").animate({top:offset},{duration:500,queue:false});
                });
 
            }); 
        </script>
        <style>
            #floatingTop{
                position:absolute;
                width:40px;
                top:150px;
                right:500px;
                padding:0;
                margin:0;
                z-index:1000;
            }
        </style>
    </head>
    <body>
        <div id="floatingTop">
            <a href="#top"><img src="https://www.gstatic.com/webp/gallery/1.sm.jpg"></a>
        </div>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
    </body>
</html>