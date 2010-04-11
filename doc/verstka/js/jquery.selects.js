jQuery(document).ready(function(){
// при загрузке страницы вызываем скрипт замены селектов
$('div.center_a').mousedown(
function()
{
	//alert($(optionsDivInvisible).css("display")!="none");
	var optionsDivInvisible = this.parentNode.getElementsByTagName('div').item(2); // контейнер для option
	
	 //$(optionsDivInvisible).css("display","block");
	 
	 if( jQuery(optionsDivInvisible).css("display")=="none")  jQuery(optionsDivInvisible).css("display","block"); // если контейнер скрыт, показываем 
	else  jQuery(optionsDivInvisible).css("display","none"); // иначе скрываем 
	// если это select со скроллом, обновляем скролл   
    var inp=this.parentNode.getElementsByTagName('input').item(0);
		if(!jQuery(inp).attr("readonly")) 
		{
		jQuery(inp).focus(); jQuery(inp).select(); // устанавливаем фокус на селект, чтобы можно было отбирать по первым буквам
		// обновляем scroll
		var id_1=this.parentNode.getElementsByTagName('div').item(3).id;
		var id_2=this.parentNode.getElementsByTagName('div').item(8).id;
		scroller  = new jsScroller(document.getElementById(id_2), 0, 143);
		scrollbar = new jsScrollbar(document.getElementById(id_1), scroller, false, false);
		}
});

// дубляж показа/скрытия option при клике на input selectArea (для combobox)
jQuery('div.selectArea > input').mousedown(
function()
{

  if(jQuery(this.parentNode.getElementsByTagName('div').item(2)).css("display")=="none")
  {

  	jQuery(this.parentNode.getElementsByTagName('div').item(2)).css("display","block");
	var id_1=this.parentNode.getElementsByTagName('div').item(3).id;
	var id_2=this.parentNode.getElementsByTagName('div').item(8).id;
	scroller  = new jsScroller(document.getElementById(id_2), 0, 143);
	scrollbar = new jsScrollbar(document.getElementById(id_1), scroller, false, false);
  }
});

// выбор позиции в списке option
optionClickHover();


//  скрываем список option когда убираем курсор с селекта
jQuery('div.selectArea').mouseout(
function(e)
{
var x = 0, y = 0; // объявляем и обнуляем координаты курсора  
    if (!e) e = window.event;
    if (e.pageX || e.pageY){
        x = e.pageX;
        y = e.pageY;
    } else if (e.clientX || e.clientY){
        x = e.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft) - document.documentElement.clientLeft;
        y = e.clientY + (document.documentElement.scrollTop || document.body.scrollTop) - document.documentElement.clientTop;
    }
  var obj = this;
  var posx=findPosX(obj);
  var posy=findPosY(obj);
  var length_obj = obj.offsetWidth-2;
  var left=this.getElementsByTagName('div')[0].offsetWidth;
  var h = this.getElementsByTagName('div')[1].offsetHeight;
  var minus;
  if(jQuery.browser.msie) {minus=0;min2=1;left-=1;}
  else {minus=2;min2=1;left-=3;}
  var h1 = this.getElementsByTagName('div')[2].offsetHeight-minus;
  // если курсор левее, или выше, или правее, или вне списка оптионов - скрываем список
  if((x<=posx+left || x>posx+length_obj+min2 || y<posy+2 || y>posy+h+h1) && jQuery(this).children('div.optionsDivInvisible').css("display")=="block"  )
  { 
		jQuery(this).children('div.optionsDivInvisible').css("display","none");
  }

});


});

function optionClickHover()
{
	// выбор позиции в списке option
jQuery('div.optionsDivInvisible > span').mousedown(
function()
{
	jQuery(this.parentNode.parentNode.getElementsByTagName('input').item(1)).attr("value",jQuery(this).attr("name")); //  значение (value) option заносим в input
	jQuery(this.parentNode.parentNode.getElementsByTagName('input').item(0)).attr("value",jQuery(this).text()); // текст для отображения в селекте
	jQuery(this.parentNode).css("display","none"); //  скрываем выпадающий список
});

//  подсветка option'a при наведении (т.к. ие6 пониает hover только на ссылках)
jQuery('div.optionsDivInvisible > span').mouseover(
function()
{
  this.className="over";
});

jQuery('div.optionsDivInvisible > span').mouseout(
function()
{
  this.className="";
});

// hover option for ie

	jQuery('div.scroller-container > span').mouseover(
	function()
		{
  		this.className="over";
		});

	jQuery('div.scroller-container > span').mouseout(
	function()
		{
  		this.className="";
		});
}

// замена обычных select при вызове функции

function findPosY(obj) {
  var posTop = 0;
  while (obj.offsetParent) {posTop += obj.offsetTop; obj = obj.offsetParent;}
  return posTop;
}
function findPosX(obj) {
  var posLeft = 0;
  while (obj.offsetParent) {posLeft += obj.offsetLeft; obj = obj.offsetParent;}
  return posLeft;
}
