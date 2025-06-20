
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда	
		ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
		СтрокаТЧ = Объект.ОтветственныеЛицаЗаСобеседование.Добавить();
		СтрокаТЧ.Ответственный = ТекущийПользователь.Сотрудник;
		СтрокаТЧ.Должность = ТекущийПользователь.Сотрудник.Должность; 
		Объект.АвторДокумента = ТекущийПользователь;
		
		ЭтоМенеджер = ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.МенеджерПоПодбору);
		ЭтоИнициаторЗаявки = ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.ИнициаторЗаявки);
				
		Если ЭтоМенеджер Тогда
			Объект.ТипСобеседования = Перечисления.ТипыСобеседований.ПервичноеСобеседование;
		ИначеЕсли ЭтоИнициаторЗаявки Тогда
			Объект.ТипСобеседования = Перечисления.ТипыСобеседований.СобеседованиеСИнициатором;
		КонецЕсли;
		
	КонецЕсли;
	
	ПоследнееУведомление = ПолучитьПоследнееУведомлениеКандидата(Объект.Вакансия, Объект.Кандидат);
	
	Если НЕ ПоследнееУведомление.Уведомление.Пустая() Тогда	
		Объект.КандидатУведомлен = Истина;
	Иначе
		Объект.КандидатУведомлен = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОпределитьВидимостьОписанияРезультата();
	ОпределитьДоступностьОтправкиУведомления();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ТипСобеседования = ПредопределенноеЗначение("Перечисление.ТипыСобеседований.ПервичноеСобеседование") Тогда
		ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.ПервичноеСобеседование"));
	ИначеЕсли Объект.ТипСобеседования = ПредопределенноеЗначение("Перечисление.ТипыСобеседований.СобеседованиеСИнициатором") Тогда
		ИзменитьСтатусКандидата(Объект.Кандидат, ПредопределенноеЗначение("Перечисление.ЭтапыПодбора.СобеседованиеСИнициатором"));
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.Кандидаты"));
	
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

&НаКлиенте
Процедура СтатусСобеседованияПриИзменении(Элемент)
	
	ОпределитьДоступностьОтправкиУведомления();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Асинх Процедура ОтправитьУведомлениеКандидату(Команда)
		
	Если Объект.КандидатУведомлен Тогда
		ОтветПользователя = Ждать ВопросАсинх("Кандидат уже был уведомлен. Отправить уведомление повторно?", РежимДиалогаВопрос.ДаНет,,, "Уведомление кандидата");					
		Если ОтветПользователя = КодВозвратаДиалога.Нет Тогда
			Возврат;	
		КонецЕсли; 
	КонецЕсли;
		
	ДанныеДляОтправкиПисьма = ПолучитьДанныеДляОтправкиПисьма(Объект.Кандидат, Объект.Вакансия);	
	Если ДанныеДляОтправкиПисьма.ШаблонПисьма.Пустая() Тогда
		ОбщегоНазначенияКлиент.ВывестиСообщение("Не найден шаблон письма о приглашении на собеседование. Проверьте свои настройки пользователя",, Объект.АвторДокумента);
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ДанныеДляОтправкиПисьма.Почта) ИЛИ ПустаяСтрока(ДанныеДляОтправкиПисьма.Пароль) Тогда
		ОбщегоНазначенияКлиент.ВывестиСообщение("Не заполнены данные почты пользователя. Отправка невозможна",, Объект.АвторДокумента);
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ДанныеДляОтправкиПисьма.ПочтаКандидата) Тогда
		ОбщегоНазначенияКлиент.ВывестиСообщение("У данного кандидата не заполнена почта. Отправка невозможна",, Объект.Кандидат);
		Возврат;
	КонецЕсли;
	
	Профиль = Новый ИнтернетПочтовыйПрофиль;
	Профиль.АдресСервераSMTP = "smtp.mail.ru";
	Профиль.ПользовательSMTP = ДанныеДляОтправкиПисьма.Почта;
	Профиль.ПарольSMTP = ДанныеДляОтправкиПисьма.Пароль;
	Профиль.ИспользоватьSSLSMTP = Истина;
	Профиль.ПортSMTP = 465;     

	Письмо = Новый ИнтернетПочтовоеСообщение;
	
	ТекстПисьма = ПодставитьЗначенияВПисьмо(ДанныеДляОтправкиПисьма);
	
	Текст = Письмо.Тексты.Добавить(ТекстПисьма);
	Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	Письмо.Тема = ДанныеДляОтправкиПисьма.Тема; 
	Письмо.Отправитель = ДанныеДляОтправкиПисьма.Почта;
	Письмо.ИмяОтправителя = ДанныеДляОтправкиПисьма.ИмяОтправителя;
		
	Письмо.Получатели.Добавить(ДанныеДляОтправкиПисьма.ПочтаКандидата);
	Почта = Новый ИнтернетПочта;	
	Попытка
		Почта.Подключиться(Профиль);
	Исключение
		ОбщегоНазначенияКлиент.ВывестиСообщение("Не удалось подключиться к серверу");
		ОбщегоНазначенияКлиент.ВывестиСообщение(ОписаниеОшибки());
	КонецПопытки;
	
	Попытка
		Почта.Послать(Письмо); 
		ОбщегоНазначенияКлиент.ВывестиСообщение("Кандидату """ + ДанныеДляОтправкиПисьма.ФИОКандидата + """ успешно отправлено уведомление о собеседовании");
		Объект.КандидатУведомлен = Истина;
		ЗаписатьУведомлениеКандидатаВРегистр(Объект.Вакансия, Объект.Кандидат, ДанныеДляОтправкиПисьма.ШаблонПисьма);
	Исключение
		ОбщегоНазначенияКлиент.ВывестиСообщение("Не удалось отправить письмо");
		ОбщегоНазначенияКлиент.ВывестиСообщение(ОписаниеОшибки());
	КонецПопытки;
	
	Почта.Отключиться();
	
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

&НаКлиенте
Процедура ОпределитьДоступностьОтправкиУведомления()

	Если Объект.СтатусСобеседования = ПредопределенноеЗначение("Перечисление.СтатусыСобеседований.Запланировано") Тогда
		Элементы.ФормаОтправитьУведомлениеКандидату.Доступность = Истина;
	Иначе
		Элементы.ФормаОтправитьУведомлениеКандидату.Доступность = Ложь;	
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПоследнееУведомлениеКандидата(Вакансия, Кандидат)
	
	ОтборЗаписи = Новый Структура;
	ОтборЗаписи.Вставить("Вакансия", Вакансия);
	ОтборЗаписи.Вставить("ЭтапУведомления", Перечисления.ЭтапыУведомлений.ПриглашениеНаСобеседование);
	ОтборЗаписи.Вставить("Кандидат", Кандидат);
	
	ПоследняяЗапись = РегистрыСведений.УведомленияКандидатов.ПолучитьПоследнее(, ОтборЗаписи);
	
	Возврат ПоследняяЗапись;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеДляОтправкиПисьма(Кандидат, Вакансия)
	
	ШаблонПисьма = Справочники.ШаблоныПисем.ПустаяСсылка();

	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Для Каждого Настройка Из ТекПользователь.НастройкиУведомлений Цикл
		Если Настройка.ЭтапУведомления = Перечисления.ЭтапыУведомлений.ПриглашениеНаСобеседование И НЕ Настройка.ШаблонПисьма.Пустая() Тогда
			ШаблонПисьма = Настройка.ШаблонПисьма;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Сотрудник.Должность КАК СотрудникДолжность,
		|	Пользователи.Сотрудник.Наименование КАК СотрудникНаименование
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Ссылка = &ПользовательСсылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Вакансия.НаименованиеВакансии КАК НаименованиеВакансии
		|ИЗ
		|	Документ.Вакансия КАК Вакансия
		|ГДЕ
		|	Вакансия.Ссылка = &ВакансияСсылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Кандидаты.Наименование КАК Наименование,
		|	Кандидаты.Эмаил КАК Эмаил
		|ИЗ
		|	Справочник.Кандидаты КАК Кандидаты
		|ГДЕ
		|	Кандидаты.Ссылка = &КандидатСсылка";
	
	Запрос.УстановитьПараметр("ПользовательСсылка", ТекПользователь);
	Запрос.УстановитьПараметр("ВакансияСсылка", Вакансия);
	Запрос.УстановитьПараметр("КандидатСсылка", Кандидат);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаПользователь = РезультатЗапроса[0].Выбрать();	
	ВыборкаПользователь.Следующий(); 
	
	ВыборкаВакансия = РезультатЗапроса[1].Выбрать();	
	ВыборкаВакансия.Следующий();
	
	ВыборкаКандидат = РезультатЗапроса[2].Выбрать();	
	ВыборкаКандидат.Следующий();
	
	НаименованиеОрганизации = Константы.НаименованиеОрганизации.Получить();
	АдресОрганизации = Константы.АдресОрганизации.Получить();
	
    ДанныеДляОтправки = Новый Структура;
	ДанныеДляОтправки.Вставить("Почта", ТекПользователь.ПочтаПользователяЭмаил);
	ДанныеДляОтправки.Вставить("Пароль", ТекПользователь.ПарольПриложенияЭмаил);
	ДанныеДляОтправки.Вставить("ИмяСотрудника", ВыборкаПользователь.СотрудникНаименование);
	ДанныеДляОтправки.Вставить("Должность", ВыборкаПользователь.СотрудникДолжность);
	ДанныеДляОтправки.Вставить("НаименованиеОрганизации", НаименованиеОрганизации);
	ДанныеДляОтправки.Вставить("АдресОрганизации", АдресОрганизации);
	ДанныеДляОтправки.Вставить("ШаблонПисьма", ШаблонПисьма);
	ДанныеДляОтправки.Вставить("Тема", ШаблонПисьма.Тема);
	ДанныеДляОтправки.Вставить("ИмяОтправителя", ШаблонПисьма.ИмяОтправителя);
	ДанныеДляОтправки.Вставить("ТекстПисьма", ШаблонПисьма.ТекстПисьма);
	ДанныеДляОтправки.Вставить("НаименованиеВакансии", ВыборкаВакансия.НаименованиеВакансии);
	ДанныеДляОтправки.Вставить("ФИОКандидата", ВыборкаКандидат.Наименование);
	ДанныеДляОтправки.Вставить("ПочтаКандидата", ВыборкаКандидат.Эмаил);
		
	Возврат ДанныеДляОтправки;
	
КонецФункции

&НаКлиенте
Функция ПодставитьЗначенияВПисьмо(ДанныеДляОтправки)
	
	ТекстПисьма = ДанныеДляОтправки.ТекстПисьма;
	
	ТекстПисьма = СтрЗаменить(ТекстПисьма, "[Кандидат]", ДанныеДляОтправки.ФИОКандидата);
	ТекстПисьма = СтрЗаменить(ТекстПисьма, "[Вакансия]", ДанныеДляОтправки.НаименованиеВакансии);
	ТекстПисьма = СтрЗаменить(ТекстПисьма, "[Отправитель]", ДанныеДляОтправки.ИмяСотрудника);
	ТекстПисьма = СтрЗаменить(ТекстПисьма, "[Должность]", ДанныеДляОтправки.Должность);
	ТекстПисьма = СтрЗаменить(ТекстПисьма, "[Организация]", ДанныеДляОтправки.НаименованиеОрганизации);
    ТекстПисьма = СтрЗаменить(ТекстПисьма, "[Адрес]", ДанныеДляОтправки.АдресОрганизации);
	ТекстПисьма = СтрЗаменить(ТекстПисьма, "[ДатаСобеседования]", Формат(Объект.ДатаСобеседования, "ДЛФ=DD"));
	ВремяНачала = СтрРазделить(Формат(Объект.ВремяНачала, "ДЛФ=T"), ":");
    ТекстПисьма = СтрЗаменить(ТекстПисьма, "[ВремяНачала]", ВремяНачала[0] + ":" + ВремяНачала[1]); 
	
	Возврат ТекстПисьма;

КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьУведомлениеКандидатаВРегистр(Вакансия, Кандидат, Уведомление)

	НоваяЗапись = РегистрыСведений.УведомленияКандидатов.СоздатьМенеджерЗаписи();
	НоваяЗапись.Период = ТекущаяДата();
	НоваяЗапись.Вакансия = Вакансия;
	НоваяЗапись.ЭтапУведомления = Перечисления.ЭтапыУведомлений.ПриглашениеНаСобеседование;
	НоваяЗапись.Кандидат = Кандидат;
	НоваяЗапись.Уведомление = Уведомление;
	НоваяЗапись.Записать();

КонецПроцедуры

#КонецОбласти




