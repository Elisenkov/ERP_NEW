////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
// Используется для перехода "С помощью одной кнопки"
// из УТ 10.3 (Базовая) на УТ 11.

Процедура ВыгрузитьДанныеВоВнешнийФайл() Экспорт
	
	МакетВнешнейОбработки = ПолучитьМакет("ПравилаОбменаУТ");
	мУниверсальнаяВыгрузкаДанных = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	
	ИмяВременногоФайлаПравилОбмена = ПолучитьИмяВременногоФайла("xml");
	
	МакетПравилОбмена = МакетВнешнейОбработки;
	МакетПравилОбмена.Записать(ИмяВременногоФайлаПравилОбмена);
	
	мУниверсальнаяВыгрузкаДанных.ИмяФайлаПравилОбмена = ИмяВременногоФайлаПравилОбмена;
	мУниверсальнаяВыгрузкаДанных.ЗагрузитьПравилаОбмена();
	
	ТаблицаПравилВыгрузки = мУниверсальнаяВыгрузкаДанных.ТаблицаПравилВыгрузки.Скопировать();
	
	Попытка
		УдалитьФайлы(ИмяВременногоФайлаПравилОбмена);// Удаляем временный файл правил
	Исключение
	КонецПопытки;
	
	ДатаОстатков = ТекущаяДатаСеанса();
	СворачиватьХарактеристики = Ложь;
	
	Если ЗначениеЗаполнено(ИмяФайлаДанных) Тогда
		ИмяВременногоФайла = ИмяФайлаДанных;
	Иначе
		Идентификатор = Новый УникальныйИдентификатор;
		ИмяВременногоФайла = КаталогВременныхФайлов() + "УТУТ_ОД" + Идентификатор + ".xml";
	КонецЕсли;
	
	// Установка параметров выгрузки
	мУниверсальнаяВыгрузкаДанных.ИмяФайлаОбмена = ИмяВременногоФайла;
	мУниверсальнаяВыгрузкаДанных.РежимОбмена    = "Выгрузка";
	
	мУниверсальнаяВыгрузкаДанных.ТаблицаПравилВыгрузки = ТаблицаПравилВыгрузки.Скопировать();
	мУниверсальнаяВыгрузкаДанных.НепосредственноеЧтениеВИБПриемнике            = Ложь;
	мУниверсальнаяВыгрузкаДанных.ФлагРежимОтладки                              = Ложь;
	мУниверсальнаяВыгрузкаДанных.ВыполнитьОбменДаннымиВОптимизированномФормате = Истина;
	мУниверсальнаяВыгрузкаДанных.ЭтоИнтерактивныйРежим                         = Ложь;
	
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("ДатаОстатков", ДатаОстатков);
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("СворачиватьХарактеристики", СворачиватьХарактеристики);
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("ЭтоПереходНаБазовуюВерсию", Истина);
	
	// Выгружаем данные
	мУниверсальнаяВыгрузкаДанных.ВыполнитьВыгрузку();
	
	Если НЕ ЗначениеЗаполнено(ИмяФайлаДанных) Тогда
		Идентификатор = Новый УникальныйИдентификатор;
		ИмяФайлаДанных = КаталогВременныхФайлов() + Идентификатор + ".zip";
		
		Архиватор = Новый ЗаписьZipФайла(ИмяФайлаДанных, , "Файл обмена данными");
			
		Архиватор.Добавить(ИмяВременногоФайла);
		
		Архиватор.Записать();
		
		Попытка
			УдалитьФайлы(ИмяВременногоФайла);
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьИнформационнуюБазу() Экспорт

	ПутьКПлатформе = КаталогПрограммы();
	СоздатьКаталог(КаталогИБ);
	
	СтрокаКоманды = """%ПутьКПлатформе%1cv8"" CREATEINFOBASE File=""%КаталогИБ%""; /AddInlist ""%ИмяБазыВСписке%"" /UseTemplate ""%ПутьКФайлуШаблона%""";
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%ПутьКПлатформе%", ПутьКПлатформе);
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%КаталогИБ%", КаталогИБ);
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%ИмяБазыВСписке%", ИмяБазыВСписке);
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%ПутьКФайлуШаблона%", ПутьКФайлуШаблона);
	
	ЗапуститьПриложение(СтрокаКоманды, ПутьКПлатформе, Истина);
	
КонецПроцедуры

Процедура ЗапуститьБазу() Экспорт
	
	ПутьКПлатформе = КаталогПрограммы();
	
	СтрокаКоманды = """%ПутьКПлатформе%1cv8"" ENTERPRISE /F ""%КаталогИБ%"" /C ""Trade103Data=""""%ПутьКФайлуВыгрузки%"""";""";
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%ПутьКПлатформе%", ПутьКПлатформе);
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%КаталогИБ%", КаталогИБ);
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%ПутьКФайлуВыгрузки%", ИмяФайлаДанных);
	
	ЗапуститьПриложение(СтрокаКоманды, ПутьКПлатформе);

КонецПроцедуры
