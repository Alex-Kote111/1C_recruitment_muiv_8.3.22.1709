
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОпределениеВидимостиОписанияЗакрытия();
КонецПроцедуры

&НаКлиенте
Процедура ПричинаЗакрытияПриИзменении(Элемент)	
	ОпределениеВидимостиОписанияЗакрытия();		
КонецПроцедуры

&НаКлиенте
Процедура ОпределениеВидимостиОписанияЗакрытия()

	Если Объект.ПричинаЗакрытия = ПредопределенноеЗначение("Перечисление.ПричиныЗакрытияВакансий.ДругаяПричина") Тогда
		Элементы.ОписаниеПричины.Видимость = Истина;
	Иначе
		Элементы.ОписаниеПричины.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Асинх Процедура ЗакрытьВакансиюНаСайтеУниверситета(Команда)
	
	ОчиститьСообщения();
	
	НомерВакансии = СтрРазделить(Объект.Вакансия, " ")[1];
	
	HTTPСоединение = Новый HTTPСоединение("localhost", 3000);
	HTTPЗапрос = Новый HTTPЗапрос("/includes/delete_vacancy.php?vacancy_number=" + НомерВакансии);
	HTTPЗапрос.Заголовки.Вставить("Application", "1C_recruitment");
		
	Попытка
		HTTPОтвет = Ждать HTTPСоединение.ПолучитьАсинх(HTTPЗапрос);
		Если HTTPОтвет.КодСостояния <> 200 Тогда
			ОбщегоНазначенияКлиент.ВывестиСообщение("Не удалось закрыть вакансию на сайте университета. Код ответа - " + HTTPОтвет.КодСостояния);
		Иначе
			ОбщегоНазначенияКлиент.ВывестиСообщение("Вакансия на сайте университета успешно закрыта.");
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиент.ВывестиСообщение(ОписаниеОшибки());
	КонецПопытки;
	
	
КонецПроцедуры
