var domain = "";

function go_home() {document.location.href="/";}


function go_main() {	document.location.href="/";}
function go_login() {	document.location.href="/member/login/";}
function go_logout() {	document.location.href="/member/logoutAction/";}
function go_join() {	document.location.href="/member/join";}
function go_mypage() { document.location.href="/purchs/OrderList"; }
function go_cartpage() { document.location.href="/cart/list"; }
function go_myinfo() { document.location.href="/member/info/"; }

// 셀프여행 ///
function go_01_01_01() {
	var frm = $("<form></form>");
	$(frm).attr("action", "/goods/category");
	$(frm).attr("method", "get");
	
	var item = $("<input type='hidden' name='category' value='S'>");
	$(frm).append(item);
	$(document.body).append(frm);
	$(frm).submit();
}

// 핫여행 ///
function go_02_01_01() {
	var frm = $("<form></form>");
	$(frm).attr("action", "/goods/list");
	$(frm).attr("method", "get");
	
	var item = $("<input type='hidden' name='goodskind' value='H'>");
	$(frm).append(item);
	$(document.body).append(frm);
	$(frm).submit();
}

// 추천여행 ///
function go_03_01_01() {
	var frm = $("<form></form>");
	$(frm).attr("action", "/goods/list");
	$(frm).attr("method", "get");
	
	var item = $("<input type='hidden' name='goodskind' value='R'>");
	$(frm).append(item);
	$(document.body).append(frm);
	$(frm).submit();
}

//패키지여행 ///
function go_03_02_01() {
	var frm = $("<form></form>");
	$(frm).attr("action", "/goods/list");
	$(frm).attr("method", "get");
	
	var item = $("<input type='hidden' name='goodskind' value='P'>");
	$(frm).append(item);
	$(document.body).append(frm);
	$(frm).submit();
}


// 여행체크리스트 ///
function go_04_01_01() {	document.location.href="/cs/checklist_old"; }
function go_04_02_01() {	document.location.href="/cs/checklistview"; }
function go_04_03_01() {	document.location.href="/cs/checklist"; }



// 결제 ///
function go_06_01_01() {	document.location.href="/opt_design/jsp/gnrl/cart/OrderList.jsp";} // 결제목록///
function go_06_02_01() {	document.location.href="/opt_design/jsp/gnrl/cart/Cancel.jsp";}
function go_06_03_01() {	document.location.href="/opt_design/jsp/gnrl/cart/Point.jsp";}
function go_06_04_01() {	document.location.href="/opt_design/jsp/gnrl/cart/Wish.jsp";}
function go_06_05_01() {	document.location.href="/opt_design/jsp/gnrl/cart/Wish.jsp";}
function go_06_06_01() {	document.location.href="#";}


// 고객지원 //
function go_07_01_01() {	document.location.href="/cs/review";}
function go_07_02_01() {	document.location.href="/cs/faq";}
function go_07_03_01() {	document.location.href="/cs/qna";}
function go_07_04_01() {	document.location.href="/cs/notice";}
function go_07_05_01() {	document.location.href="/cs/liveview";}
function go_07_06_01() {	document.location.href="/cs/usetext";} 
function go_07_07_01() {	document.location.href="/cs/usetext2";}
function go_07_08_01() {	document.location.href="/cs/usetext3";}


// ABOUT //
function go_08_01_01() {	alert("준비중입니다."); }
function go_08_02_01() {	alert("준비중입니다."); }
function go_08_03_01() {	alert("준비중입니다."); } 

// 여행 상담 //
function go_05_01_01() {	document.location.href="/bbs/list";}
function go_05_02_01() {	document.location.href="/bbs/admin";}

// ADMIN //
function go_09_01_01() {	window.open("/mngr/", "_blank");}
