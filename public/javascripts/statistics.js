$(function () {
  // Theme map
  OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
  OpenLayers.ImgPath = 'http://js.mapbox.com/theme/dark/';

  // Create map
  var map = new mxn.Mapstraction('map', 'openlayers');
  map.getMap().removeLayer(map.layers.osmmapnik);
  map.getMap().removeLayer(map.layers.osm);
  map.getMap().addLayer(new OpenLayers.Layer.CloudMade('CloudMade', {
    attribution: '<a href="http://cloudmade.com/">CloudMade</a><br /><a href="http://creativecommons.org/licenses/by-sa/2.0/">CCBYSA</a> <a href="http://openstreetmap.org/">OSM</a>',
    key: '802f8920aed1443583f059aedbf2cef6',
    styleId: '5870'
  }));
  map.setCenterAndZoom(new mxn.LatLonPoint(45.5583927, -73.6425433), 11);

  var context = {
    radius: function (feature) {
      var infractions = 0;
      if (feature.cluster) {
        for (var i = 0, l = feature.cluster.length; i < l; i++) {
          infractions += feature.cluster[i].attributes.infractions;
        }
        feature.attributes.infractions = infractions;
      }
      else {
        infractions = feature.attributes.infractions;
      }
      if (!feature.attributes.popup) {
        var text = (feature.cluster ? feature.cluster.length + ' établissements' : 1 + ' établissement') + ' avec ' + infractions + ' infractions'; // TODO translate
        feature.attributes.popup = new OpenLayers.Popup(null, feature.geometry.getBounds().getCenterLonLat(), new OpenLayers.Size(100, 100), text);
        feature.attributes.popup.autoSize = true;
      }
      return Math.max(parseInt(infractions / 2), 2);
    },
    width: function (feature) {
      return feature.cluster ? 2 : 1;
    }
  };

  var clusters = new OpenLayers.Layer.Vector('Clusters', {
        strategies: [ new OpenLayers.Strategy.Cluster({ threshold: 2 }) ],
        styleMap: new OpenLayers.StyleMap({
          'default': new OpenLayers.Style({
            pointRadius: '${radius}',
            fillColor: '#b8e4f5',
            fillOpacity: 0.8,
            strokeColor: '#2d7bb2',
            strokeWidth: '${width}',
            strokeOpacity: 0.8
          }, { context: context }),
          'select': new OpenLayers.Style({
            pointRadius: '${radius}',
            fillColor: '#5b9bb5',
            fillOpacity: 0.8,
            strokeColor: '#004373',
            strokeWidth: '${width}',
            strokeOpacity: 0.8
          }, { context: context })
        })
      });

  var select = new OpenLayers.Control.SelectFeature(clusters, {
    hover: true,
    highlightOnly: true,
    eventListeners: {
      featurehighlighted: function (event) {
        if (!event.feature.attributes.shown) {
          map.getMap().addPopup(event.feature.attributes.popup);
          event.feature.attributes.popup.show();
          event.feature.attributes.shown = true;
        }
      },
      featureunhighlighted: function (event) {
        if (event.feature.attributes.shown) {
          event.feature.attributes.popup.hide();
          map.getMap().removePopup(event.feature.attributes.popup);
          event.feature.attributes.shown = false;
        }
      }
    }
  });

  map.getMap().addControl(select);
  select.activate();
  map.getMap().addLayer(clusters);

  clusters.addFeatures($.map(establishments, function (value, index) {
    var lng = value.lng * 20037508.34 / 180,
        lat = Math.log(Math.tan((90 + value.lat) * Math.PI / 360)) / (Math.PI / 180) * 20037508.34 / 180,
        feature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(lng, lat));
    feature.attributes.infractions = value.infractions;
    return feature;
  })); // Must add features after adding layer.
});