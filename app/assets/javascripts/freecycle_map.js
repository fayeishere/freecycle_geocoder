$(document).ready(function() {
    initialize();

    geoLoop();
    // codeAddress("Gresham");
    $("h1").click( function() {
        alert("Help!");
    });

    function popitup(url) {
        newwindow=window.open(url,'name','height=200,width=150');
        if (window.focus) {
            newwindow.focus();
        }
        return false;
    }
});
// 1. SET SOME GLOBAL VARS THAT INITIALIZE WILL SET
// AND CODEADDRESS WILL USE
// var geocoder; //codeAddress needs this, initialize sets this
var map; //codeAddress needs this, initialize sets this
var currentPopup; //codeAddress needs this
var homeCenter; // center of the map- used when closing popups

function initialize() {
    // geocoder = new google.maps.Geocoder();
    var myLatlng = homeCenter = new google.maps.LatLng(45.528, -47.676); // this is Portland
    var mapOptions = {
        zoom: 10,
        center: new google.maps.LatLng(45.528, -122.676),
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        title:"Freecycle Mapper!"
    });
}

// This function adds the lat/longs and subect passed to the map as a marker
function codeAddress(lat, longs, infoWin, link) {
  var newLatLng = new google.maps.LatLng(lat, longs);
    // var address = document.getElementById("address").value;
    // console.log(address);
    // geocoder.geocode( { 'address': address}, function(results, status) {
    //     if (status == google.maps.GeocoderStatus.OK) {
            // map.setCenter(results[0].geometry.location);
            var marker = new google.maps.Marker({
                map: map, // using global "map" var here
                // position: results[0].geometry.location
                position: newLatLng
            });
            var popup = new google.maps.InfoWindow({
                content: infoWin + "" + link,
                maxWidth: 300
            });
            google.maps.event.addListener(marker, "click", function() {
                if (currentPopup != null) {
                    currentPopup.close();
                    currentPopup = null;
                }
                popup.open(map, marker);
                // map.setCenter(results[0].geometry.location);
                currentPopup = popup;
            });
            google.maps.event.addListener(popup, "closeclick", function() {
                //map.panTo(homeCenter);
                currentPopup = null;
            });
        // }
        // else {
        //     alert("Geocode was not successful for the following reason: " + status);
        // }
    // });
}
function MakeSubjectList(spec) {
  var post_subject_item;
  for (var i = 0; i < spec.length; i++) {
    post_subject_item = $('<li>' + spec[i].subject + '</li>');
    $('#subject-list').prepend(post_subject_item);
  }
}

function MakeLocationList(spec) {
    var post_location_item;
    for (var i = 0; i < spec.length; i++) {
        if ( typeof spec[i].location !== null) {
            post_location_item = $('<li>' + spec[i].location + '</li>');
            $('#location-list').prepend(post_location_item);
        }
    }
}

function geoLoop() {

  // AJAX
  $.ajax ({
    url: "/locations",
    dataType: "json",
    type: "GET",
    context: this,
    success: function(data) {
      // generate location list via jquery
      MakeLocationList(data);
      // generate subject list via jquery
      MakeSubjectList(data);

      for (var i = 0; i < data.length; i++) {
        if (typeof data[i].location === 'string') {
          codeAddress(data[i].latitude, data[i].longitude, data[i].subject, data[i].body);
          console.log(data);
        }
      }

    }
  });

}