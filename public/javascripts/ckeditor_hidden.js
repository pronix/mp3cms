$(document).ready(function(){
  $('#editor_disable').click(function() {
      if (CKEDITOR.instances.news_item_text == undefined) {
        CKEDITOR.replace("news_item_text")
       } else {
      CKEDITOR.instances.news_item_text.destroy();
      };
  })
});

