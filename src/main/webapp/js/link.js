var domain = "";

function go_home() {document.location.href="/";}


function go_main() {	document.location.href="/";}
function go_login() {	document.location.href="/member/login/";}
function go_logout() {	document.location.href="/member/logoutAction/";}
function go_join() {	document.location.href="#";}
function go_mypage() { document.location.href="/purchs/OrderList"; }

// 셀프여행 ///
function go_01_01_01() {
	var frm = $("<form></form>");
	$(frm).attr("action", "/goods/category");
	$(frm).attr("method", "post");
	
	var item = $("<input type='hidden' name='category' value='S'>");
	$(frm).append(item);
	$(document.body).append(frm);
	$(frm).submit();
}

// 핫여행 ///
function go_02_01_01() {
	var frm = $("<form></form>");
	$(frm).attr("action", "/goods/category");
	$(frm).attr("method", "post");
	
	var item = $("<input type='hidden' name='category' value='H'>");
	$(frm).append(item);
	$(document.body).append(frm);
	$(frm).submit();
}

// 추천여행 ///
function go_03_01_01() {
	var frm = $("<form></form>");
	$(frm).attr("action", "/goods/category");
	$(frm).attr("method", "post");
	
	var item = $("<input type='hidden' name='category' value='R'>");
	$(frm).append(item);
	$(document.body).append(frm);
	$(frm).submit();
}


// 여행체크리스트 ///
function go_04_01_01() {	document.location.href="/opt_design/jsp/gnrl/goods/CheckList.jsp";}



// 결제 ///
function go_06_01_01() {	document.location.href="/opt_design/jsp/gnrl/cart/OrderList.jsp";} // 결제목록///
function go_06_02_01() {	document.location.href="/opt_design/jsp/gnrl/cart/Cancel.jsp";}
function go_06_03_01() {	document.location.href="/opt_design/jsp/gnrl/cart/Point.jsp";}
function go_06_04_01() {	document.location.href="/opt_design/jsp/gnrl/cart/Wish.jsp";}
function go_06_05_01() {	document.location.href="/opt_design/jsp/gnrl/cart/Wish.jsp";}
function go_06_06_01() {	document.location.href="#";}


// 고객지원 //
function go_07_01_01() {	document.location.href="/opt_design/jsp/gnrl/cs/Review.jsp";}
function go_07_02_01() {	document.location.href="/opt_design/jsp/gnrl/cs/FAQ.jsp";}
function go_07_03_01() {	document.location.href="/opt_design/jsp/gnrl/cs/UseText.jsp";} 
function go_07_04_01() {	document.location.href="/opt_design/jsp/gnrl/cs/UseText2.jsp";}
function go_07_05_01() {	document.location.href="/opt_design/jsp/gnrl/cs/Privacy.jsp";}
function go_07_06_01() {	document.location.href="/opt_design/jsp/gnrl/cs/QnA.jsp";}

// ABOUT //
function go_08_01_01() {	document.location.href="/opt_design/jsp/gnrl/about/Company.jsp";}
function go_08_02_01() {	document.location.href="/opt_design/jsp/gnrl/about/Service.jsp";}
function go_08_03_01() {	document.location.href="/opt_design/jsp/gnrl/about/Use.jsp";} 

// 여행 예약 //
function go_09_01_01() {	document.location.href="/bbs/list";}
