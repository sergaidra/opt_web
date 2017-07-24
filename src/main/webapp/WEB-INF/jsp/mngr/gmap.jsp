<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Simple Map</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
    <meta name="viewport" content="initial-scale=1.0">
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
    </style>
  </head>
  <body>
    <div id="map"></div>
    <script>
      var map;
      function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
          center: {lat: ${la}, lng: ${lo}},
          zoom: 8
        });
      }
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA88oWHhxjR6HD5RqCg2lvXAkp0fj_Vatc&callback=initMap"
    async defer></script>
  </body>
</html>