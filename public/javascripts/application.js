$(function(){

$(document).ajaxStart(function(){
        $('#ajax_indicator').css({ top: $(document).scrollTop() }).andSelf().show();
    }).ajaxStop(function(){
    $('#ajax_indicator').hide();
});

$(".all-answ, .show-all-tender").click(function(){
    $("tr.tender:visible").hide('slow');
    var order_id = $($(this).parents("tr:first")).attr("data-order_id");
    $("tr.tender_"+order_id).show('slow');
    return false;
});

function js_link_to_content(url,el) {
    var dialog = $(el).parents("div.ui-dialog-content");
    var _url = url.split('?')
        _url = [[_url[0],'js'].join('.'),_url[1]].join('?')
        $(dialog).load(_url);
    return false;


  };


function js_link(el, url, dialog, _height, _width){
     var _url = url.split('?')
     var base_url = _url[0];
     var return_to = 'return_to='+escape(location.href);
     var params_url = [return_to];
     if (!!_url[1]) { params_url.push(_url[1])};
        _url = [[base_url,'js'].join('.'), params_url.join('&') ].join('?')
       width = _width;
       height = _height;
       $(dialog).load(_url, function(data) {
        var options = { resizable: false,    modal: true, zIndex: 3000,
                        close: function(event, ui) { $(dialog).remove(); },
                        width: width,
                        height: height, title: $(el).attr('title') };

        $(dialog).dialog(options);
      });
    return false;


  };

  /* выделение всех треков в корзине */
    $(".select-all-check").click(function(){
      var name_elements = $(this).attr("data-check_name");
      $("input[name='"+name_elements+"']").attr("checked", 'checked')
      return false;
    });
  /* end */

  /* Редактирование трека */
  $("a.js_link_edit_track").click(function(){
     var el = $(this);

     var dialog = $("#share-dialog");
     if (!!!$(dialog).length){ dialog = $("<div id='share-dialog'></div>").insertAfter('.content');  }
         if ($(el).attr("data_size")) { hw = $(el).attr("data_size").split("x"); };
         var _height = $(window).height()-100;
         var _width  = $(window).width()-100;
         if (hw && !hw[0]=="") {_height = hw[0] };
         if (hw && !hw[1]=="") {_width = hw[1] };

         $(dialog).load($(this).attr('href')+'.js', function(data) {
          var options = { resizable: false,    modal: true, zIndex: 3000,
                        close: function(event, ui) { $(dialog).remove(); },
                        width: _width,
                        height: _height, title: $(el).attr('title') };


          options.buttons =  {
                                "Отменить": function() {  $(dialog).dialog("close")   },
                                "Сохранить": function(){ $(dialog).find("form:first").trigger("submit"); }
                             };
        $(dialog).find("div.buttons").hide();

        $(dialog).dialog(options);
        });


    return false;
  });

/* end Редактирование трека */

  $("a.js_link, a.js_link_to_content").live('click', function(e){
      var el = $(this);

      var hw;
      if ($(el).is("a") && $(el).hasClass("js_link")){
        var dialog = $("#share-dialog");
        if (!!!$(dialog).length){ dialog = $("<div id='share-dialog'></div>").insertAfter('.content');  }
         if ($(el).attr("data_size")) { hw = $(el).attr("data_size").split("x"); };
         var _height = $(window).height()-100;
         var _width  = $(window).width()-100;
         if (hw && !hw[0]=="") {_height = hw[0] };
         if (hw && !hw[1]=="") {_width = hw[1] };

         js_link(el, $(el).attr('href'), dialog, _height, _width);

      } else if ($(el).is("a") && $(el).hasClass("js_link_to_content") ) {
         js_link_to_content($(el).attr('href'),el);
      } ;


    return false;
  });


    soundManager.useFlashBlock = false; // skip for now. See the flashblock demo when you want to start getting fancy.
    soundManager.url = '/flash/'; // directory where SM2 .SWFs live
    soundManager.debugMode = false;
    soundManager.consoleOnly = false;

    soundManager.onready(function(oStatus) {
              if (!oStatus.success) {
                   return false;
               }
               $.each($("a.listen-play"), function(i, item){

                 soundManager.createSound({
                                             id: $(item).attr('id'),
                                            url: $(item).attr('href')
                                         });

               });

            });

    $(".listen-play").click(function() {
          if ($(this).attr("data-status") == undefined || $(this).attr("data-status") == 'stop'){
            soundManager.stopAll();
            $(".listen-play").attr("data-status", "stop").removeClass("play")
            $(this).attr("data-status", "play").addClass("play")
            soundManager.play($(this).attr('id'));

          } else {
            soundManager.stopAll();
            $(".listen-play").attr("data-status", "stop").removeClass("play")
          };

           return false;
         });


});

