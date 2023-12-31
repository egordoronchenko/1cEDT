
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда



#Область ПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ,Режим)
	
	Движения.АктивныеПосещения.Записывать = Истина;
	Движения.Записать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктивныеПосещенияОстатки.ВидАтракциона,
		|	АктивныеПосещенияОстатки.КоличествоПосещенийОстаток
		|ИЗ
		|	РегистрНакопления.АктивныеПосещения.Остатки(, Основание = &Основание) КАК АктивныеПосещенияОстатки";
		
	Запрос.УстановитьПараметр("Основание", Основание);
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОсталосьПосещений = 0;
	ВидАтракционаАбонемента = Неопределено;
	
	Если Выборка.Следующий() Тогда
		ОсталосьПосещений = Выборка.КоличествоПосещенийОстаток;
		ВидАтракционаАбонемента = Выборка.ВидАтракциона;
	КонецЕсли;
	
	Если ОсталосьПосещений < 1 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "В билете не осталось посещений.";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Основание";
		Сообщение.Сообщить();
	КонецЕсли;
	
	ВидАтракционаДокумента = ВидАтракциона(Атракцион);
	Если ЗначениеЗаполнено(ВидАтракционаАбонемента) 
		И ВидАтракционаДокумента <> ВидАтракционаАбонемента Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Билет не подходит для посещения этого Атракциона.";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Основание";
		Сообщение.Сообщить();
	КонецЕсли;
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// регистр АктивныеПосещения
	Движения.АктивныеПосещения.Записывать = Истина;
	Движение = Движения.АктивныеПосещения.Добавить();
	Движение.Период = Дата;
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Основание = Основание;
	Движение.ВидАтракциона = ВидАтракционаАбонемента;
	Движение.КоличествоПосещений = 1;

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


Функция ВидАтракциона(Атракцион)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Атракционы.ВидАтракциона
	|ИЗ
	|	Справочник.Атракционы КАК Атракционы
	|ГДЕ
	|	Атракционы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",Атракцион);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	
	Возврат Выборка.ВидАтракциона;
КонецФункции

#КонецОбласти

#Область Инициализация

#КонецОбласти

#КонецЕсли
