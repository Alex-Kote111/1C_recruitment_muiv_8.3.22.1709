
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Объект.Ссылка.Пустая() Тогда	
		ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
		Объект.Ответственный = ТекущийПользователь.Сотрудник;
		Объект.АвторДокумента = ТекущийПользователь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОпределитьВидимостьОписанияРезультата();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ТелефонноеИнтервью"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.Кандидаты"));	
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КандидатПриИзменении(Элемент)
	
	Если Объект.Кандидат.Пустая() Тогда
		Возврат;
	КонецЕсли;
		
	ДанныеКандидата = ПолучитьДанныеКандидата(Объект.Кандидат); 	
	Объект.ТелефонКандидата = ДанныеКандидата.Телефон;
	Объект.ЭмаилКандидата = ДанныеКандидата.Эмаил;
	
	ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ТелефонноеИнтервью"));
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
	
	ОтборКандидатов = Новый Структура("СсылкаНаВакансию, ЭтапПодбора", Объект.Вакансия, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ПросмотрРезюме"));
	ПараметрыФормы = Новый Структура("Отбор", ОтборКандидатов);	
	ОткрытьФорму("Справочник.Кандидаты.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриИзменении(Элемент)
	
	ОпределитьВидимостьОписанияРезультата();
	
КонецПроцедуры

&НаКлиенте
Процедура КандидатОчистка(Элемент, СтандартнаяОбработка)
	
	Если Объект.Кандидат.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ПросмотрРезюме"));
	ОповеститьОбИзменении(Тип("СправочникСсылка.Кандидаты"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОпределитьВидимостьОписанияРезультата()

	Если Объект.Результат = ПредопределенноеЗначение("Перечисление.РезультатыТелефонногоИнтервью.Другое") Тогда
		Элементы.ОписаниеРезультата.Видимость = Истина;
	Иначе
		Элементы.ОписаниеРезультата.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеКандидата(Кандидат)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Кандидаты.Телефон КАК Телефон,
		|	Кандидаты.Эмаил КАК Эмаил
		|ИЗ
		|	Справочник.Кандидаты КАК Кандидаты
		|ГДЕ
		|	Кандидаты.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Кандидат);	
	РезультатЗапроса = Запрос.Выполнить();	
	Выборка = РезультатЗапроса.Выбрать();	
	Выборка.Следующий();
	
	ДанныеКандидата = Новый Структура;
	ДанныеКандидата.Вставить("Телефон", Выборка.Телефон);
	ДанныеКандидата.Вставить("Эмаил", Выборка.Эмаил);
	
	Возврат ДанныеКандидата;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ИзменитьСтатусКандидата(Кандидат, Статус)

	КандидатОбъект = Кандидат.ПолучитьОбъект();
	КандидатОбъект.ЭтапПодбора = Статус;
	КандидатОбъект.Записать();

КонецПроцедуры




#КонецОбласти















