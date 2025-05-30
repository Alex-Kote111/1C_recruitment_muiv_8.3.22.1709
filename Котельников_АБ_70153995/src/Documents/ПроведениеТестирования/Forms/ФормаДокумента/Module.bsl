
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
 	Если Объект.Ссылка.Пустая() Тогда	
		ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
		Объект.Ответственный = ТекущийПользователь.Сотрудник;
		Объект.АвторДокумента = ТекущийПользователь;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КандидатПриИзменении(Элемент)
	
	Если Объект.Кандидат.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.Тестирование"));	
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
	
	ОтборКандидатов = Новый Структура("СсылкаНаВакансию, ЭтапПодбора", Объект.Вакансия, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.СобеседованиеСИнициатором"));
	ПараметрыФормы = Новый Структура("Отбор", ОтборКандидатов);

	ОткрытьФорму("Справочник.Кандидаты.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КандидатОчистка(Элемент, СтандартнаяОбработка)
	
	Если Объект.Кандидат.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.СобеседованиеСИнициатором"));	
	ОповеститьОбИзменении(Тип("СправочникСсылка.Кандидаты"));
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура АнкетаВопросовПриИзменении(Элемент)
	
	Если Объект.СписокВопросов.Количество() <> 0 Тогда
		ОтветПользователя = Ждать ВопросАсинх("При изменении анкеты список вопрос будет очищен. Продолжить?", РежимДиалогаВопрос.ДаНет,,, "Список вопросов будет очищен");
		Если ОтветПользователя = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Объект.СписокВопросов.Очистить(); 
	
	ВопросыАнкеты = ПолучитьВопросыАнкеты(Объект.АнкетаВопросов);
	
	Для Каждого Вопрос Из ВопросыАнкеты Цикл
		НоваяСтрока = Объект.СписокВопросов.Добавить();
		НоваяСтрока.Вопрос = Вопрос; 
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РассчитатьРезультат(Команда)
	
	ОчиститьСообщения();

	Результат = 0;
	КоличествоВопросов = Объект.СписокВопросов.Количество();
	
	Если КоличествоВопросов = 0 Тогда
		ОбщегоНазначенияКлиент.ВывестиСообщение("Список вопросов пустой", "Объект.СписокВопросов");
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Объект.СписокВопросов Цикл
		
		Если СтрокаТЧ.ОтветКандидата.Пустая() Тогда
			Индекс = Объект.СписокВопросов.Индекс(СтрокаТЧ); 
			ОбщегоНазначенияКлиент.ВывестиСообщение("Заполните все ответы кандидата для расчета общей оценки", "Объект.СписокВопросов[" + Индекс + "].ОтветКандидата");
			Возврат;
		КонецЕсли;
		
		Если СтрокаТЧ.ОтветКандидата = ПредопределенноеЗначение("Перечисление.ТипыОценкиОтвета.Отлично") Тогда
			Результат = Результат + 5;
		ИначеЕсли СтрокаТЧ.ОтветКандидата = ПредопределенноеЗначение("Перечисление.ТипыОценкиОтвета.Хорошо") Тогда
			Результат = Результат + 4;
		ИначеЕсли СтрокаТЧ.ОтветКандидата = ПредопределенноеЗначение("Перечисление.ТипыОценкиОтвета.Удовлетворительно") Тогда
			Результат = Результат + 3;
		ИначеЕсли СтрокаТЧ.ОтветКандидата = ПредопределенноеЗначение("Перечисление.ТипыОценкиОтвета.Плохо") Тогда
			Результат = Результат + 2;
		ИначеЕсли СтрокаТЧ.ОтветКандидата = ПредопределенноеЗначение("Перечисление.ТипыОценкиОтвета.ОченьПлохо") Тогда
			Результат = Результат + 1;
		КонецЕсли;
	КонецЦикла;
	
	Объект.ОбщаяОценка = Результат / КоличествоВопросов; 
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьВопросыАнкеты(Анкета)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВопросыДляАнкетирования.Ссылка КАК Вопрос
		|ИЗ
		|	Справочник.ВопросыДляАнкетирования КАК ВопросыДляАнкетирования
		|ГДЕ
		|	ВопросыДляАнкетирования.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Анкета);	
	РезультатЗапроса = Запрос.Выполнить();	
	Выборка = РезультатЗапроса.Выбрать();
	
	СписокВопросов = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		СписокВопросов.Добавить(Выборка.Вопрос);
	КонецЦикла;
	
	Возврат СписокВопросов; 
				
КонецФункции

&НаСервереБезКонтекста
Процедура ИзменитьСтатусКандидата(Кандидат, Статус)

	КандидатОбъект = Кандидат.ПолучитьОбъект();
	КандидатОбъект.ЭтапПодбора = Статус;
	КандидатОбъект.Записать();

КонецПроцедуры

#КонецОбласти








