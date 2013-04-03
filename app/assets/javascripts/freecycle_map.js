// $(document).ready(function() {
//     initialize();
//     //experimenting with setInterval to get around google's exceeding query alert
//     // setInterval(geoLoop(),3000);
//     //uncomment geoLoop() if abandoning setInterval
//     geoLoop();
//     // codeAddress("Gresham");
//     $("h1").click( function() {
//         alert("Help!");
//     });

//     function popitup(url) {
//         newwindow=window.open(url,'name','height=200,width=150');
//         if (window.focus) {
//             newwindow.focus();
//         }
//         return false;
//     }
// });
// // 1. SET SOME GLOBAL VARS THAT INITIALIZE WILL SET
// // AND CODEADDRESS WILL USE
// var geocoder; //codeAddress needs this, initialize sets this
// var map; //codeAddress needs this, initialize sets this
// var currentPopup; //codeAddress needs this
// var homeCenter; // center of the map- used when closing popups

// function initialize() {
//     //geocoder is a global var, no var prefix here
//     geocoder = new google.maps.Geocoder();
//     var myLatlng = homeCenter = new google.maps.LatLng(45.528, -122.676); // this is Portland
//     var mapOptions = {
//         zoom: 12,
//         center: new google.maps.LatLng(45.528, -122.676),
//         mapTypeId: google.maps.MapTypeId.ROADMAP
//     };
//     //map is a global var, no var prefix here
//     map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
//     var marker = new google.maps.Marker({
//         position: myLatlng,
//         map: map,
//         title:"Freecycle Mapper!"
//     });
// }

// // This function adds the address passed to the map as a marker
// function codeAddress(address, infoWin) {
//     // var address = document.getElementById("address").value;
//     geocoder.geocode( { 'address': address}, function(results, status) {
//         if (status == google.maps.GeocoderStatus.OK) {
//             // map.setCenter(results[0].geometry.location);
//             var marker = new google.maps.Marker({
//                 map: map, // using global "map" var here
//                 position: results[0].geometry.location
//             });
//             var popup = new google.maps.InfoWindow({
//                 content: infoWin,
//                 maxWidth: 300
//             });
//             google.maps.event.addListener(marker, "click", function() {
//                 if (currentPopup != null) {
//                     currentPopup.close();
//                     currentPopup = null;
//                 }
//                 popup.open(map, marker);
//                 map.setCenter(results[0].geometry.location);
//                 currentPopup = popup;
//             });
//             google.maps.event.addListener(popup, "closeclick", function() {
//                 //map.panTo(homeCenter);
//                 currentPopup = null;
//             });

//         }
//         else {
//             alert("Geocode was not successful for the following reason: " + status);
//         }
//     });
// }

// function MakeSubjectList(data) {
//     var post_subject_item;
//     for (var i = 0; i < data.length; i++) {
//         post_subject_item = $('<li>' + data[i].subject + '</li>');
//         $('#subject-list').prepend(post_subject_item);
//     }
// }

// function MakeLocationList(data) {
//     var post_location_item;
//     for (var i = 0; i < data.length; i++) {
//         if ( typeof data[i].location !== null) {
//             post_location_item = $('<li>' + data[i].location + '</li>');
//             $('#location-list').prepend(post_location_item);
//         }
//     }
// }


// function geoLoop() {
//     // iterate over addresses array - one hash at a time
//         // <% $recent_offers_data.each { |myhash| %>
// 	// 			      // call codeAddress and pass the location and subject
// 	// 			      codeAddress("<%=myhash[:location] %>", "<%=myhash[:subject] %>");
// 	// 			      var ready = ("<%=myhash[:subject] %>");
// 	// 			      $("#first").text(ready);
// 	// 			      <% } %>

// // var data = [{"subject":"[freecycleportland] OFFER - Canon Multi-function Color Unit - SW PDX","location":"SW PDX"}]

//     // AJAX
//     $.ajax ({
// 	url: "/",
// 	dataType: "json",
// 	success: function(data) {
// 	    console.log(data);
//         // generate location list via jquery
//         MakeLocationList(data);
//         // generate subject list via jquery
//         MakeSubjectList(data);

// 	    for (var i = 0; i < data.length; i++) {
// 		    if (typeof data[i].location === 'string') {
//                 setInterval(codeAddress(data[i].location, data[i].subject), 500);
//                 console.log(data[i]);
//             }
// 	    }
//     },
// 	type: "GET",
// 	context: this
//     });

//     // for (var mail_data in recent_mail_data) {
//     //
//     // }
// }
// // end geoLoop