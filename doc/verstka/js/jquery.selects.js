jQuery.noConflict();

jQuery(document).ready(function(){

// при загрузке страницы вызываем скрипт замены селектов
changeSelects();
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

//  подсветка оптиона при наведении (т.к. ие6 пониает hover только на ссылках)
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


// функция обработки клика на элеменах списка для селекта с прокруткой
	jQuery('div.scroller-container > span').click(
	function()
		{
			
		var optionsDivInVisible = jQuery(this).parents("div.optionsDivInvisible");
		var hiddenInput = optionsDivInVisible.parent().find('input').eq(1); //скрытый ипут со значением селекта
		var valueOption = jQuery(this).attr("name"); //значение optiona
		var textOption = jQuery(this).text(); // текст optiona
		var inputInSelect = optionsDivInVisible.parent().find("input").eq(0); // поле, которое содержит текст селекта
		
		inputInSelect.val(textOption); // обновляем текст селекта
		if(hiddenInput) hiddenInput.val(valueOption); // добавляем значение селекта в скрытый input
		optionsDivInVisible.css("display","none"); // скрываем выпадающий список
		}
);
	
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
function changeSelects()
{ 
/* скрипт находит все селекты на странице и заменяет их на спец конструкции */
jQuery("select").each(
function(num)
{
							// num - номер селекта на странице
var selectOrCombobox = 8; 	// если в селекте optionов <= флага selectOrCombobox, тогда селект без прокрутки, больше - добавляется прокрутка
var kolOptions=jQuery(this).children().length; // число option в select

var className=this.className;//  имя класса текущего селекта
var selName=this.name;		 //  name селекта
var selID=this.id;			 // id селекта       	

// определяем тип селекта

if(kolOptions>selectOrCombobox)
{
	
	jQuery(this).css("display","none"); // скрываем select чтобы замена визуально прошла более гладко

	// чтобы верхние селекты нормально перекрывали нижние, автоматически добавляем z-index в порядке убывания
	// для уникальности id элементов селектов используется num - порядковый номер селекта на странице
	jQuery(this).before("<div class='selectArea "+className+"' style='z-index:"+(100-num)+"'>"+
							"<div class='left'></div>"+ // левая часть select
							"<div class='center_a'></div>"+ // правая часть (стрелка) select
							"<div class='optionsDivInvisible' id='optInvis_"+num+"'>"+ // контейнер для option
								"<div class='scrollbar-container' id='scroll_container_"+num+"'>"+ // контейнер для скроллинга   
									"<div class='scrollbar-up'></div>"+ // стрелка вверх для прокрутки
									"<div class='scrollbar-down' id='scrollbar-down'></div>"+ // стрелка вниз
									"<div class='scrollbar-track' id='scrollbar-track'><b class='scrollbar-handle' id='scrollbar-handle'></b></div>"+ // трэк скроллинга
									"<div class='container2' id='container'>"+ 
										"<div class='scroller-1' id='scroller_"+num+"'>"+
										"<div class='scroller-container' id='"+selID+"_fake'></div>"+
										"</div>"+
									"</div>"+
								"</div>"+
							"</div>"+
							"<input id='v"+selID+"' />"+ // видимый текст select
							"<input type='hidden' name='"+selName+"' id='"+selID+"' />"+ // значение select
						"</div>");

// заполняем <option>

var containerFofSel=jQuery("#scroller_"+num+" > div");
var selArr=jQuery(this).children(); // массив всех option селекта
var sel_i; // текущий номер option
for(var i=0;i<kolOptions;i++) // преобразовываем все option в span
{							  // name spana - значение option
							  // текст spana - тект option
	sel_i = selArr.eq(i);
	containerFofSel.append("<span name='"+sel_i.val()+"'>"+sel_i.text()+"</span>");
}

// начальное значение селекта  
jQuery("#"+selID).val(jQuery(this).children("option[@selected=selected]").val());

// начальный текст селекта
jQuery("#v"+selID).val(jQuery(this).children("option[@selected=selected]").eq(0).text());

// инициализация скроллинга
  var id_1='scroll_container_'+num;
  var id_2='scroller_'+num;
  scroller = new jsScroller(document.getElementById(id_2), 0, 143);
  scrollbar = new jsScrollbar(document.getElementById(id_1), scroller, false, false);
  
  	// скрывем новый список option
 	jQuery("#optInvis_"+num).css("display","none").css("visibility","visible");
	 // удаляем обычный селект  
	jQuery(this).remove();
}

// селект без прокрутки  
else 
{
// формируем костяк
jQuery(this).before("<div class='selectArea "+className+"' style='z-index:"+(100-num)+"'>"+
						"<div class='left'></div>"+
						"<div class='center_a'></div>"+
						"<div class='optionsDivInvisible' id='"+selID+"_fake'></div>"+
						"<input type='text' readonly='readonly' name='v"+selName+"' id='v"+selID+"' />"+
						"<input type='hidden' name='"+selName+"' id='"+selID+"' />"+
					"</div>");

//  заполняем <option>

var sel_i; // текущий номер option
var selArr=jQuery(this).children(); // массив всех option селекта
for(var i=0;i<kolOptions;i++)
{
	sel_i = selArr.eq(i);
	// name spana - значение option
	// текст spana - тект option
	jQuery("#"+selID+"_fake").append("<span name='"+sel_i.val()+"'>"+sel_i.text()+"</span>");
}

// начальное значение селекта 
jQuery("#"+selID).val(jQuery(this).children("option[@selected]").eq(0).val());

// начальный текст селекта
jQuery("#v"+selID).val(jQuery(this).children("option[@selected]").eq(0).text());

// скрываем список option
jQuery("#"+selID+"_fake").css("display","none").css("visibility","visible");

//  удаляем обычный селект
jQuery(this).remove();
}

});

// показываем/скрываем список option
jQuery('div.center_a').mousedown(
function()
{
	var optionsDivInvisible = this.parentNode.getElementsByTagName('div').item(2); // контейнер для option
	if(jQuery(optionsDivInvisible).css("display")=="none") jQuery(optionsDivInvisible).slideDown(200); // если контейнер скрыт, показываем 
	else jQuery(optionsDivInvisible).slideUp(200); // иначе скрываем 
	
	// если это select со скроом, обновляем скролл   
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

  	jQuery(this.parentNode.getElementsByTagName('div').item(2)).slideDown(200);
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
  if((x<=posx+left || x>posx+length_obj+min2 || y<posy+2 || y>posy+h+h1) && jQuery(this).children('div.optionsDivInvisible').css("display")=="block")
  {
  jQuery(this).children('div.optionsDivInvisible').slideUp(200);
  }
});

//  отбор option о первым буквам
jQuery('div.selectArea > input').keyup(
function()
{
var id_1=this.parentNode.getElementsByTagName('div').item(3).id;
//id blocka scroll
var id_2=this.parentNode.getElementsByTagName('div').item(8).id;
//cicl proverka na sootvetstvie vvedenim simvolam
var col=jQuery("#"+id_2+" > div > span").length; // к-во всех option
var span=jQuery("#"+id_2+" > div > span"); // массив всех option
var val_input=jQuery(this).val().toUpperCase(); // переводим все символы в один регистр      
  for(i=0;i<col;i++)
  {
    var val_list=span.eq(i).text().toUpperCase();

    var pos=val_list.indexOf(val_input);
	if(pos!=0) span.eq(i).css("display","none"); // если нужной последовательности в слове нет, скрываем option
    else span.eq(i).css("display","block");
  }
  //  обновляем скролл
  scroller  = new jsScroller(document.getElementById(id_2), 0, 143);
  scrollbar = new jsScrollbar(document.getElementById(id_1), scroller, false, false);

});
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

}

