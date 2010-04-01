$(document).ready(function(){
  $("#new_mp3").click(function() {

    $.ajax({
      url: '/tracks/ajax_new_mp3',
      success: function(data)
      {
        $('#ajax_data').html(data);
      }
    });

  })

  $("#top_mp3").click(function() {

    $.ajax({
      url: '/tracks/top_mp3',
      success: function(data)
      {
        $('#ajax_data').html(data);
      }
    });

  })
})

