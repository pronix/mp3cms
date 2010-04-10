function drop_all_select_div() {
  jQuery('#label_search-mp3').removeClass("selected");
  jQuery('#span_mp3').html('<a href="#">Поиск mp3</a>')
  jQuery('#label_search-in-news').removeClass("selected");
  jQuery('#span_news_item').html('<a href="#">Новости</a>')
  jQuery('#label_search-playlist').removeClass("selected");
  jQuery('#span_playlist').html('<a href="#">Плейлисты</a>')
}

function add_checkboxes_for_track() {
  jQuery('#checkboxes').removeClass("none_checkboxes")
  jQuery('#everywhere').attr("checked", "checked")
}

function remove_checkboxes_for_track() {
  jQuery('#checkboxes').addClass("none_checkboxes")
  jQuery('#author').attr("checked", false)
  jQuery('#title').attr("checked", false)
  jQuery('#everywhere').attr("checked", false)
}

function select(arg) {

  switch(arg)
  {
    case 'mp3':
      jQuery('#span_mp3').html('Поиск mp3')
      break;
    case 'news_item':
      jQuery('#span_news_item').html('Новости')
      break;
    case 'playlist':
      jQuery('#span_playlist').html('Плейлисты')
      break;
  }
}
// Управление вкладками и алфавитом
$(document).ready(function(){

  jQuery('#label_search-mp3').click(function() {
    jQuery('#search-mp3').attr('checked', 'checked');
    drop_all_select_div();
    jQuery('#label_search-mp3').addClass("selected");
    add_checkboxes_for_track();
    select('mp3')
  });


  jQuery('#label_search-in-news').click(function() {
    jQuery('#search-in-news').attr('checked', 'checked');
    drop_all_select_div();
    jQuery('#label_search-in-news').addClass("selected");
    remove_checkboxes_for_track();
    select('news_item')
  });

  jQuery('#label_search-playlist').click(function() {
    jQuery('#search-playlist').attr('checked', 'checked');
    drop_all_select_div();
    jQuery('#label_search-playlist').addClass("selected")
    remove_checkboxes_for_track();
    select('playlist')
  });

  jQuery('#en').click(function() {
    jQuery('#ru').removeClass('selected')
    jQuery('#en').addClass('selected')
  });

  jQuery('#en').click(function() {
    jQuery('#ru').removeClass('selected')
    jQuery('#en').addClass('selected')

    jQuery('#en').html('En')
    jQuery('#ru').html('<a href="#">Ру</a>')
    jQuery('.caracters-nav').html('<li><a href="/searches?model=track&char=a">a</a></li><li><a href="/searches?model=track&char=b">b</a></li><li><a href="/searches?model=track&char=c">c</a></li><li><a href="/searches?model=track&char=d">d</a></li><li><a href="/searches?model=track&char=e">e</a></li><li><a href="/searches?model=track&char=f">f</a></li><li><a href="/searches?model=track&char=g">g</a></li><li><a href="/searches?model=track&char=h">h</a></li><li><a href="/searches?model=track&char=i">i</a></li><li><a href="/searches?model=track&char=j">j</a></li><li><a href="/searches?model=track&char=k">k</a></li><li><a href="/searches?model=track&char=l">l</a></li><li><a href="/searches?model=track&char=n">n</a></li><li><a href="/searches?model=track&char=o">o</a></li><li><a href="/searches?model=track&char=p">p</a></li><li><a href="/searches?model=track&char=q">q</a></li><li><a href="/searches?model=track&char=r">r</a></li><li><a href="/searches?model=track&char=s">s</a></li><li><a href="/searches?model=track&char=t">t</a></li><li><a href="/searches?model=track&char=u">u</a></li><li><a href="/searches?model=track&char=v">v</a></li><li><a href="/searches?model=track&char=w">w</a></li><li><a href="/searches?model=track&char=x">x</a></li><li><a href="/searches?model=track&char=y">y</a></li><li><a href="/searches?model=track&char=z">z</a></li><li><a href="/searches?model=track&char=0">0</a></li><li><a href="/searches?model=track&char=1">1</a></li><li><a href="/searches?model=track&char=2">2</a></li><li><a href="/searches?model=track&char=3">3</a></li><li><a href="/searches?model=track&char=4">4</a></li><li><a href="/searches?model=track&char=5">5</a></li><li><a href="/searches?model=track&char=6">6</a></li><li><a href="/searches?model=track&char=7">7</a></li><li><a href="/searches?model=track&char=8">8</a></li><li><a href="/searches?model=track&char=9">9</a></li><li></li>')
  });

  jQuery('#ru').click(function() {
    jQuery('#en').removeClass('selected')
    jQuery('#ru').addClass('selected')

    jQuery('#ru').html('Ру')
    jQuery('#en').html('<a href="#">En</a>')
    jQuery('.caracters-nav').html('<li><a href="/searches?model=track&char=а">а</a></li><li><a href="/searches?model=track&char=б">б</a></li><li><a href="/searches?model=track&char=в">в</a></li><li><a href="/searches?model=track&char=г">г</a></li><li><a href="/searches?model=track&char=д">д</a></li><li><a href="/searches?model=track&char=е">е</a></li><li><a href="/searches?model=track&char=ё">ё</a></li><li><a href="/searches?model=track&char=ж">ж</a></li><li><a href="/searches?model=track&char=и">и</a></li><li><a href="/searches?model=track&char=й">й</a></li><li><a href="/searches?model=track&char=к">к</a></li><li><a href="/searches?model=track&char=л">л</a></li><li><a href="/searches?model=track&char=м">м</a></li><li><a href="/searches?model=track&char=н">н</a></li><li><a href="/searches?model=track&char=о">о</a></li><li><a href="/searches?model=track&char=п">п</a></li><li><a href="/searches?model=track&char=р">р</a></li><li><a href="/searches?model=track&char=с">с</a></li><li><a href="/searches?model=track&char=т">т</a></li><li><a href="/searches?model=track&char=у">у</a></li><li><a href="/searches?model=track&char=ф">ф</a></li><li><a href="/searches?model=track&char=х">х</a></li><li><a href="/searches?model=track&char=ц">ц</a></li><li><a href="/searches?model=track&char=ч">ч</a></li><li><a href="/searches?model=track&char=ш">ш</a></li><li><a href="/searches?model=track&char=щ">щ</a></li><li><a href="/searches?model=track&char=ы">ы</a></li><li><a href="/searches?model=track&char=э">э</a></li><li><a href="/searches?model=track&char=ю">ю</a></li><li><a href="/searches?model=track&char=я">я</a></li><li><a href="/searches?model=track&char=0">0</a></li><li><a href="/searches?model=track&char=1">1</a></li><li><a href="/searches?model=track&char=2">2</a></li><li><a href="/searches?model=track&char=3">3</a></li><li><a href="/searches?model=track&char=4">4</a></li><li><a href="/searches?model=track&char=5">5</a></li><li><a href="/searches?model=track&char=6">6</a></li><li><a href="/searches?model=track&char=7">7</a></li><li><a href="/searches?model=track&char=8">8</a></li><li><a href="/searches?model=track&char=9">9</a></li><li></li>')
  });

});

// Управление чекбоксами

function drop_title_and_author(){
  jQuery('#author').attr("checked", false)
  jQuery('#title').attr("checked", false)
}

$(document).ready(function(){

  jQuery('#everywhere').click(function(){
    drop_title_and_author()
  });

  jQuery('#author').click(function(){
    $('#everywhere').attr("checked", false)
  });

  jQuery('#title').click(function(){
    $('#everywhere').attr("checked", false)
  });
});

