<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<section>
      <div class="subtop${bp}">
    <div class="inner2">
          <div class="b_title">
        <div class="tx1">${btitle}</div>
        <div class="route_t">HOME > ${btitle} > ${mtitle}</div>
      </div>
          <div class="search_box">
        <div class="btn_icon"><img src="<c:url value='/images/com/search_icon.png' />" width="36" height="36" alt=""/></div>
        <input type="text">
      </div>
          <div class="copy_text">Details package tour is <em>OnePassTour</em></div>
        </div>
  </div>
</section>