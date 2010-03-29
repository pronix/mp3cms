$(document).ready(function(){
  $('#editor_disable').click(function() {
    if (CKEDITOR.instances.news_item_text_editor == undefined) {
    CKEDITOR.replace("news_item_text_editor")
    }
    else {
      CKEDITOR.instances.news_item_text_editor.destroy();
    }
  })
});

