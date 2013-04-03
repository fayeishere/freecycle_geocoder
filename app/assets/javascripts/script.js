function Mail() {
  this.id = null;
  this.subject = null;
  this.location = null;
}

Mail.prototype.fetch = function() {
  $.ajax({
    url: '/',
    dataType: 'json',
    type: 'GET',
    context: this,
    success: function(data) {
      // code for how to populate the marker bubble
      console.log(data);
    }, // 2xx response
    error: function(){
    } // 4xx-5xx response
  });
};
