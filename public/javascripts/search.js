function drop_all_select_div() {
  $('#label_search-mp3').removeClass("selected");
  $('#span_mp3').html('<a href="#">Поиск mp3</a>')
  $('#label_search-in-news').removeClass("selected");
  $('#span_news_item').html('<a href="#">Новости</a>')
  $('#label_search-playlist').removeClass("selected");
  $('#span_playlist').html('<a href="#">Плейлисты</a>')
}

function add_checkboxes_for_track() {
  $('#checkboxes').removeClass("none_checkboxes")
  $('#everywhere').attr("checked", "checked")
}

function remove_checkboxes_for_track() {
  $('#checkboxes').addClass("none_checkboxes")
  $('#author').attr("checked", false)
  $('#title').attr("checked", false)
  $('#everywhere').attr("checked", false)
}

function select(arg) {

  switch(arg)
  {
    case 'mp3':
      $('#span_mp3').html('Поиск mp3')
      break;
    case 'news_item':
      $('#span_news_item').html('Новости')
      break;
    case 'playlist':
      $('#span_playlist').html('Плейлисты')
      break;
  }
}
// Управление вкладками и алфавитом
$(document).ready(function(){

  $('#label_search-mp3').click(function() {
    $('#search-mp3').attr('checked', 'checked');
    drop_all_select_div();
    $('#label_search-mp3').addClass("selected");
    add_checkboxes_for_track();
    select('mp3')
  });


  $('#label_search-in-news').click(function() {
    $('#search-in-news').attr('checked', 'checked');
    drop_all_select_div();
    $('#label_search-in-news').addClass("selected");
    remove_checkboxes_for_track();
    select('news_item')
  });

  $('#label_search-playlist').click(function() {
    $('#search-playlist').attr('checked', 'checked');
    drop_all_select_div();
    $('#label_search-playlist').addClass("selected")
    remove_checkboxes_for_track();
    select('playlist')
  });

  $('#en').click(function() {
    $('#ru').removeClass('selected')
    $('#en').addClass('selected')
  });

  $('#en').click(function() {
    $('#ru').removeClass('selected')
    $('#en').addClass('selected')
    $("li.caracters-en").show();
    $("li.caracters-ru").hide();
    $('#en').html('En')
    $('#ru').html('<a href="#">Ру</a>')

  });

  $('#ru').click(function() {
    $('#en').removeClass('selected')
    $('#ru').addClass('selected')
    $("li.caracters-en").hide();
    $("li.caracters-ru").show();

    $('#ru').html('Ру')
    $('#en').html('<a href="#">En</a>')
  });

});

// Управление чекбоксами

function drop_title_and_author(){
  $('#author').attr("checked", false)
  $('#title').attr("checked", false)
}

$(document).ready(function(){

  $('#everywhere').click(function(){
    drop_title_and_author()
  });

  $('#author').click(function(){
    $('#everywhere').attr("checked", false)
  });

  $('#title').click(function(){
    $('#everywhere').attr("checked", false)
  });
});

