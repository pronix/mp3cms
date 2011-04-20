$(function(){


function js_link_to_content(url,el) {
    var dialog = $(el).parents("div.ui-dialog-content");
    var _url = url.split('?')
        _url = [[_url[0],'js'].join('.'),_url[1]].join('?')
        $(dialog).load(_url);
    return false;


  };


function js_link(url,dialog, _height, _width){
     var _url = url.split('?')
     var base_url = _url[0];
     var return_to = 'return_to='+escape(location.href);
     var params_url = [return_to];
     if (!!_url[1]) { params_url.push(_url[1])};
        _url = [[base_url,'js'].join('.'), params_url.join('&') ].join('?')
    _width = _width+'px';
    _height = _height+'px';
    $(dialog).load(_url, function(data) {
        var options = { resizable: false,    modal: true, zIndex: 3000, dialogClass: "apply_overlay",
                        close: function(event, ui) { $(dialog).remove(); },
                        width: _width,
                        height: _height };

        /* if ($(data).find("form").length == 0) {
          options.buttons =  { "Refresh": function() {  js_link(url,dialog);   } };
          };*/

        $(dialog).dialog(options);
      });
    return false;


  };



   $(document).click(function(e){
      var el = $(e.target);
      var hw;
      if ($(el).is("a") && $(el).hasClass("js_link")){
         var dialog = $("<div></div>").insertAfter('.content');

         if ($(el).attr("data_size")) { hw = $(el).attr("data_size").split("x"); };
         var _height = $(window).height()-100;
         var _width  = $(window).width()-100;
         if (hw && !hw[0]=="") {_height = hw[0] };
         if (hw && !hw[1]=="") {_width = hw[1] };

         js_link($(el).attr('href'), dialog, _height, _width);
         return false;

      } else if ($(el).is("a") && $(el).hasClass("js_link_to_content") ) {
         js_link_to_content($(el).attr('href'),el);
         return false;
      } else {
         return true; };
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

