
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда	
		ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
		СтрокаТЧ = Объект.ОтветственныеЛицаЗаСобеседование.Добавить();
		СтрокаТЧ.Ответственный = ТекущийПользователь.Сотрудник;
		СтрокаТЧ.Должность = ТекущийПользователь.Сотрудник.Должность; 
		Объект.АвторДокумента = ТекущийПользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОпределитьВидимостьОписанияРезультата();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РезультатСобеседованияПриИзменении(Элемент)
	
	ОпределитьВидимостьОписанияРезультата();	
	
КонецПроцедуры

&НаКлиенте
Процедура КандидатПриИзменении(Элемент)
	
	Если Объект.Кандидат.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипСобеседования = ПредопределенноеЗначение("Перечисление.ТипыСобеседований.ПервичноеСобеседование") Тогда
		ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ПервичноеСобеседование"));
	ИначеЕсли Объект.ТипСобеседования = ПредопределенноеЗначение("Перечисление.ТипыСобеседований.СобеседованиеСИнициатором") Тогда
		ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.СобеседованиеСИнициатором"));
	КонецЕсли;
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.Кандидаты"));
	
КонецПроцедуры

&НаКлиенте
Процедура КандидатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОчиститьСообщения();
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ Объект.Кандидат.Пустая() Тогда
		ОбщегоНазначенияКлиент.ВывестиСообщение("Вы уже выбрали кандидата. Если выбор был ошибочным, то нажмите на кнопку очистки и добавьте другого кандидата", "Объект.Кандидат");
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипСобеседования = ПредопределенноеЗначение("Перечисление.ТипыСобеседований.ПервичноеСобеседование") Тогда
		ОтборКандидатов = Новый Структура("СсылкаНаВакансию, ЭтапПодбора", Объект.Вакансия, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ТелефонноеИнтервью"));
		ПараметрыФормы = Новый Структура("Отбор", ОтборКандидатов);
	ИначеЕсли Объект.ТипСобеседования = ПредопределенноеЗначение("Перечисление.ТипыСобеседований.СобеседованиеСИнициатором") Тогда
		ОтборКандидатов = Новый Структура("СсылкаНаВакансию, ЭтапПодбора", Объект.Вакансия, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ПервичноеСобеседование"));
		ПараметрыФормы = Новый Структура("Отбор", ОтборКандидатов);
	КонецЕсли;
	ОткрытьФорму("Справочник.Кандидаты.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КандидатОчистка(Элемент, СтандартнаяОбработка)
	
	Если Объект.Кандидат.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипСобеседования = ПредопределенноеЗначение("Перечисление.ТипыСобеседований.ПервичноеСобеседование") Тогда
		ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ТелефонноеИнтервью"));
	ИначеЕсли Объект.ТипСобеседования = ПредопределенноеЗначение("Перечисление.ТипыСобеседований.СобеседованиеСИнициатором") Тогда
		ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ПервичноеСобеседование"));
	КонецЕсли;
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.Кандидаты"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОпределитьВидимостьОписанияРезультата()

	Если Объект.РезультатСобеседования = ПредопределенноеЗначение("Перечисление.РезультатыСобеседования.Другое") Тогда
		Элементы.ОписаниеРезультата.Видимость = Истина;
	Иначе
		Элементы.ОписаниеРезультата.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьСтатусКандидата(Кандидат, Статус)

	КандидатОбъект = Кандидат.ПолучитьОбъект();
	КандидатОбъект.ЭтапПодбора = Статус;
	КандидатОбъект.Записать();

КонецПроцедуры

#КонецОбласти




