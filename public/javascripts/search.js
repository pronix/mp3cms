function drop_all_select_div() {
  $('#label_search-mp3').removeClass("selected");
  $('#label_search-in-news').removeClass("selected");
  $('#label_search-playlist').removeClass("selected");
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


$(document).ready(function(){

  $('#search-mp3').click(function() {
    $('#search-mp3').attr('checked', 'checked');
    drop_all_select_div();
    $('#label_search-mp3').addClass("selected");
    add_checkboxes_for_track();
  });

  $('#search-in-news').click(function() {
    $('#search-in-news').attr('checked', 'checked');
    drop_all_select_div();
    $('#label_search-in-news').addClass("selected");
    remove_checkboxes_for_track();
  });

  $('#search-playlist').click(function() {
    $('#search-playlist').attr('checked', 'checked');
    drop_all_select_div();
    $('#label_search-playlist').addClass("selected")
    remove_checkboxes_for_track();
  });

  $('#en').click(function() {
    $('#ru').removeClass('selected')
    $('#en').addClass('selected')
  });

  $('#en').click(function() {
    $('#ru').removeClass('selected')
    $('#en').addClass('selected')

    $('#en').html('En')
    $('#ru').html('<a href="#">Ру</a>')
    $('.caracters-nav').html('<li><a href="#">a</a></li><li><a href="#">b</a></li><li><a href="#">c</a></li><li><a href="#">d</a></li><li><a href="#">e</a></li><li><a href="#">f</a></li><li><a href="#">g</a></li><li><a href="#">h</a></li><li><a href="#">i</a></li><li><a href="#">j</a></li><li><a href="#">k</a></li><li><a href="#">l</a></li><li><a href="#">n</a></li><li><a href="#">o</a></li><li><a href="#">p</a></li><li><a href="#">q</a></li><li><a href="#">r</a></li><li><a href="#">s</a></li><li><a href="#">t</a></li><li><a href="#">u</a></li><li><a href="#">v</a></li><li><a href="#">w</a></li><li><a href="#">x</a></li><li><a href="#">y</a></li><li><a href="#">z</a></li><li><a href="#">0</a></li><li><a href="#">1</a></li><li><a href="#">2</a></li><li><a href="#">3</a></li><li><a href="#">4</a></li><li><a href="#">5</a></li><li><a href="#">6</a></li><li><a href="#">7</a></li><li><a href="#">8</a></li><li><a href="#">9</a></li><li></li>')
  });

  $('#ru').click(function() {
    $('#en').removeClass('selected')
    $('#ru').addClass('selected')

    $('#ru').html('Ру')
    $('#en').html('<a href="#">En</a>')
    $('.caracters-nav').html('<li><a href="#">а</a></li><li><a href="#">б</a></li><li><a href="#">в</a></li><li><a href="#">г</a></li><li><a href="#">д</a></li><li><a href="#">е</a></li><li><a href="#">ё</a></li><li><a href="#">ж</a></li><li><a href="#">и</a></li><li><a href="#">й</a></li><li><a href="#">к</a></li><li><a href="#">л</a></li><li><a href="#">м</a></li><li><a href="#">н</a></li><li><a href="#">о</a></li><li><a href="#">п</a></li><li><a href="#">р</a></li><li><a href="#">с</a></li><li><a href="#">т</a></li><li><a href="#">у</a></li><li><a href="#">ф</a></li><li><a href="#">х</a></li><li><a href="#">ц</a></li><li><a href="#">ч</a></li><li><a href="#">ш</a></li><li><a href="#">щ</a></li><li><a href="#">ы</a></li><li><a href="#">э</a></li><li><a href="#">ю</a></li><li><a href="#">я</a></li><li><a href="#">0</a></li><li><a href="#">1</a></li><li><a href="#">2</a></li><li><a href="#">3</a></li><li><a href="#">4</a></li><li><a href="#">5</a></li><li><a href="#">6</a></li><li><a href="#">7</a></li><li><a href="#">8</a></li><li><a href="#">9</a></li><li></li>')
  });

});

