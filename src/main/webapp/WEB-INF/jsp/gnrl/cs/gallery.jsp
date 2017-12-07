<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<link rel="stylesheet" type="text/css" href="/jq/gallery/css/component.css" />
<script src="/jq/gallery/js/modernizr.custom.js"></script>


</head>

<body>
<!-- 본문 -->
<section>
 <div id="container">
<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
    <div class="inner2">
		   <div class="com_stitle">라이브뷰 홍보</div>
		<div id="grid-gallery" class="grid-gallery">
				<section class="grid-wrap">
					<ul class="grid">
						<li class="grid-sizer"></li><!-- for Masonry column width -->
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/1.jpg" alt="img01"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/2.jpg" alt="img02"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/3.jpg" alt="img03"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/4.jpg" alt="img04"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
					<li>
							<figure>
								<img src="/jq/gallery/img/thumb/1.jpg" alt="img01"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/2.jpg" alt="img02"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/3.jpg" alt="img03"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/4.jpg" alt="img04"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/1.jpg" alt="img01"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/2.jpg" alt="img02"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
						<li>
							<figure>
								<img src="/jq/gallery/img/thumb/3.jpg" alt="img03"/>
								<figcaption><h3>이미지 제목이 나오는곳</h3><p>이미지 상세설명이 나오는곳</p></figcaption>
							</figure>
						</li>
					
					
					</ul>
				</section><!-- // grid-wrap -->
				<section class="slideshow">
					<ul>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/thumb/1.jpg" alt="img01"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
								<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/thumb/2.jpg" alt="img01"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
							<img src="/jq/gallery/img/thumb/3.jpg" alt="img01"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/thumb/4.jpg" alt="img01"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
							<img src="/jq/gallery/img/thumb/1.jpg" alt="img01"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
								<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/thumb/2.jpg" alt="img01"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/large/1.png" alt="img01"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/large/2.png" alt="img02"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/large/3.png" alt="img03"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/large/4.png" alt="img04"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/large/5.png" alt="img05"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>이미지 제목이 나옵니다.</h3>
									<p>이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳 이미지 상세설명이 나오는곳</p>
								</figcaption>
								<img src="/jq/gallery/img/large/1.png" alt="img01"/>
							</figure>
						</li>
						<li>
							<figure>
								<figcaption>
									<h3>Letterpress asymmetrical</h3>
									<p>Pickled hoodie Pinterest 90's proident church-key chambray. Salvia incididunt slow-carb ugh skateboard velit, flannel authentic hoodie lomo fixie photo booth farm-to-table. Minim meggings Bushwick, semiotics Vice put a bird.</p>
								</figcaption>
								<img src="/jq/gallery/img/large/1.png" alt="img01"/>
							</figure>
						</li>
						
					</ul>
					<nav>
						<span class="icon nav-prev"></span>
						<span class="icon nav-next"></span>
						<span class="icon nav-close"></span>
					</nav>
				
				</section><!-- // slideshow -->
			</div>
		<script src="/jq/gallery/js/imagesloaded.pkgd.min.js"></script>
		<script src="/jq/gallery/js/masonry.pkgd.min.js"></script>
		<script src="/jq/gallery/js/classie.js"></script>
		<script src="/jq/gallery/js/cbpGridGallery.js"></script>
		<script>
			new CBPGridGallery( document.getElementById( 'grid-gallery' ) );
		</script>	
	<!--여백--><div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div><!--여백-->
		 <div class="list_more">     
      <div class="more_btn">
       <a href="SelfList2.jsp"> <div class="ok_btn">더보기</div></a>
      </div>
    </div>
		
	</div>  
<!--여백--><div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div><!--여백-->
  </div>
   
</section>
<!-- //본문 -->

</body>
