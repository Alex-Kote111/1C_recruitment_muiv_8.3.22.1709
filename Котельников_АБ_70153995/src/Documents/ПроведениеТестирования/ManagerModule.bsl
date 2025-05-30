
Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Документы.ПроведениеТестирования.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПроведениеТестирования.Вакансия) КАК Вакансия,
	|	ПроведениеТестирования.ВремяНачала КАК ВремяНачала,
	|	ПроведениеТестирования.ВремяОкончания КАК ВремяОкончания,
	|	ПроведениеТестирования.Дата КАК Дата,
	|	ПроведениеТестирования.Кандидат КАК Кандидат,
	|	ПроведениеТестирования.Номер КАК Номер,
	|	ПроведениеТестирования.Ответственный КАК Ответственный,
	|	ПроведениеТестирования.СписокВопросов.(
	|		НомерСтроки КАК НомерСтроки,
	|		Вопрос КАК Вопрос,
	|		Вопрос.Формулировка КАК ВопросФормулировка
	|	) КАК СписокВопросов,
	|	ПроведениеТестирования.Вакансия.Должность КАК ВакансияДолжность
	|ИЗ
	|	Документ.ПроведениеТестирования КАК ПроведениеТестирования
	|ГДЕ
	|	ПроведениеТестирования.Ссылка В(&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСписокВопросовШапка = Макет.ПолучитьОбласть("СписокВопросовШапка");
	ОбластьСписокВопросов = Макет.ПолучитьОбласть("СписокВопросов");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);
		Шапка.Параметры.Заполнить(Выборка);
		
		ДатаПроведения = Формат(Выборка.Дата, "ДЛФ=DD");
		
		ПоследнийПробел = СтрНайти(Выборка.Вакансия, " ", НаправлениеПоиска.СКонца);
		Вакансия = Сред(Выборка.Вакансия, 0, ПоследнийПробел - 1);
		
		ВремяНачала = Формат(Выборка.ВремяНачала, "ДЛФ=T");
		ВремяОкончания = Формат(Выборка.ВремяОкончания, "ДЛФ=T");
		Шапка.Параметры.Дата = ДатаПроведения;
		Шапка.Параметры.Вакансия = Вакансия;
		Шапка.Параметры.ВремяНачала	= ВремяНачала;
		Шапка.Параметры.ВремяОкончания = ВремяОкончания;
		
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьСписокВопросовШапка);
		ВыборкаСписокВопросов = Выборка.СписокВопросов.Выбрать();
		Пока ВыборкаСписокВопросов.Следующий() Цикл
			ОбластьСписокВопросов.Параметры.Заполнить(ВыборкаСписокВопросов);
			ТабДок.Вывести(ОбластьСписокВопросов, ВыборкаСписокВопросов.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
