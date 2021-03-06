$(function() {
  var map = new google.maps.Map(document.getElementById("map_canvas"), {
    zoom: 11,
    center: new google.maps.LatLng(45.519098,-73.644632),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false
  });

  var data = $.map(establishments, function(e) {
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(e.lat, e.lng),
      title: e.name,
      icon: sprintf('http://google-maps-icons.googlecode.com/files/red%02d.png', e.count),
    });

    marker.set('id', e.id);

    var info_window = new google.maps.InfoWindow({
      content: "<div class='info_window'>" +
        "<h1><a href='" + e.url + "'>" + e.name + "</a></h1>" +
        "<ul>" +
        "<li>" + t.total_infractions + ": " + e.amount + " (" + e.count + ")</li>" +
        "<li>" + t.latest_infraction + ": " + e.latest.date + " (" + e.latest.amount + ")</li>" +
        "</ul>" +
        "</div>"
    });

    return $.extend({}, e, { marker: marker, info_window: info_window });
  });

  $.each(data, function(index, item) {
    google.maps.event.addListener(item.marker, 'click', function() {
      $.each(data, function(i, d){ d.info_window.close() });
      item.info_window.open(map, item.marker);
    });

    google.maps.event.addListener(item.marker, 'mouseover', function() {
      $('#establishment_'+item.id).addClass('hover');
    });

    google.maps.event.addListener(item.marker, 'mouseout', function() {
      $('#establishment_'+item.id).removeClass('hover');
    });

    $('#establishment_'+item.id).hover(function() {
      $(this).addClass('hover');
      item.marker.setAnimation(google.maps.Animation.BOUNCE);
    }, function() {
      $(this).removeClass('hover');
      item.marker.setAnimation(null);
    });
  });

  google.maps.event.addListener(map, 'click', function() {
    $.each(data, function(i, d){ d.info_window.close() });
  });

  var clusterer = new MarkerClusterer(map, $.map(data, function(i){ return i.marker }), { maxZoom: 15 });

  google.maps.event.addListener(clusterer, 'mouseover', function(cluster) {
    $.each(cluster.getMarkers(), function(i, marker) {
      $('#establishment_'+marker.get('id')).addClass('hover');
    });
  });
  google.maps.event.addListener(clusterer, 'mouseout', function(cluster) {
    $.each(cluster.getMarkers(), function(i, marker) {
      $('#establishment_'+marker.get('id')).removeClass('hover');
    });
  });
});
