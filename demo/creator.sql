CREATE TYPE Позиция AS enum('Мид', 'Керри', 'Офлейн', 'Частичная Поддержка', 'Полная Поддержка');
CREATE TYPE Статус AS enum('Не начался', 'Идет', 'Прошел');
CREATE TYPE Итог AS enum('0-2', '2-0', '2-1', '1-2', '1-0', '0-1');
CREATE TYPE Тип_компании AS enum('БК', 'Техника', 'Автопром', 'Финансы', 'Питание', 'Одежда');

CREATE TABLE Адрес(
ID_Адреса SERIAL PRIMARY KEY,
Страна VARCHAR(32),
Город VARCHAR(32),
Улица VARCHAR(64),
Дом VARCHAR(32),
Индекс INTEGER
);

CREATE TABLE Мафия  (
ID_Мафии SERIAL PRIMARY KEY,
Название VARCHAR(32),
Штаб_квартира INTEGER REFERENCES Адрес(ID_Адреса) ON UPDATE CASCADE ON DELETE CASCADE,
Нацианальность VARCHAR(100) NOT NULL,
Бюджет INTEGER NOT NULL
);

CREATE TABLE Члены_Мафии  (
ID_Члена SERIAL PRIMARY KEY,
Login VARCHAR(32),
Password VARCHAR (32),
Balance DECIMAL ,
ID_Мафии INTEGER REFERENCES Мафия(ID_Мафии) ON UPDATE CASCADE ON DELETE CASCADE,
Имя VARCHAR(32),
Фамилия VARCHAR(32),
Отчество VARCHAR(32),
Должность VARCHAR(32),
Кличка VARCHAR(32),
Дата_Вступления DATE
);

CREATE TABLE Команды  (
ID_Команды SERIAL PRIMARY KEY,
ID_Мафии INTEGER REFERENCES Мафия(ID_Мафии) ON UPDATE CASCADE ON DELETE CASCADE,
Название VARCHAR(32),
Тег VARCHAR(4),
Logo VARCHAR (2048),
Бюджет INTEGER NOT NULL,
Дата_Основания DATE
);

CREATE TABLE БК  (
ID_БК SERIAL PRIMARY KEY,
ID_Мафии INTEGER REFERENCES Мафия(ID_Мафии) ON UPDATE CASCADE ON DELETE CASCADE,
Название VARCHAR(32),
Сайт VARCHAR(64),
Штаб_квартира INTEGER REFERENCES Адрес(ID_Адреса) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Должности  (
ID_Должности SERIAL PRIMARY KEY,
Название VARCHAR(64),
Описание TEXT
);

CREATE TABLE Контракты  (
ID_Контракта SERIAL PRIMARY KEY,
Дата_Подписания DATE,
Дата_Окончания DATE,
ID_Команды INTEGER REFERENCES Команды(ID_Команды) ON UPDATE CASCADE ON DELETE CASCADE,
Зарплата_в_долларах INTEGER ,
Условия TEXT ,
ID_Должности INTEGER REFERENCES Должности(ID_Должности) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Игроки  (
ID_Игрока SERIAL PRIMARY KEY,
Имя VARCHAR (32),
Фамилия VARCHAR(32),
Отчество VARCHAR(32),
Никнейм VARCHAR(32),
ММР INTEGER ,
Лучший_Герой VARCHAR(32),
Позиция Позиция,
ID_Контракта INTEGER REFERENCES Контракты(ID_Контракта) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Сотрудники  (
ID_Сотрудника SERIAL PRIMARY KEY,
Имя VARCHAR (32),
Фамилия VARCHAR(32),
Отчество VARCHAR(32),
Дата_рождения DATE,
ID_Контракта INTEGER REFERENCES Контракты(ID_Контракта) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Инфраструктура  (
ID_Инфраструктуры SERIAL PRIMARY KEY,
Наименование VARCHAR (64),
Год_постройки DATE ,
Площадь_м_кв DECIMAL ,
ID_Адреса INTEGER REFERENCES Адрес(ID_Адреса) ON UPDATE CASCADE ON DELETE CASCADE,
ID_Команды INTEGER REFERENCES Команды(ID_Команды) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Инвентарь  (
ID_Инвентаря SERIAL PRIMARY KEY,
Наименование VARCHAR (64),
Стоимость INTEGER ,
ID_Завхоза INTEGER REFERENCES Сотрудники(ID_Сотрудника) ON UPDATE CASCADE ON DELETE CASCADE,
ID_Инфраструктуры INTEGER REFERENCES Инфраструктура(ID_Инфраструктуры) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Турниры  (
ID_Турнира SERIAL PRIMARY KEY,
Название VARCHAR (64),
Место_проведения VARCHAR (64),
Дата_начала DATE ,
Дата_оконания DATE ,
Колво_команд INTEGER ,
Призовой_фонд_дол INTEGER,
Победитель INTEGER REFERENCES Команды(ID_Команды) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Матчи  (
ID_Матча SERIAL PRIMARY KEY,
ID_Турнира INTEGER REFERENCES Турниры(ID_Турнира) ON UPDATE CASCADE ON DELETE CASCADE,
ID_Команды1 INTEGER REFERENCES Команды(ID_Команды) ON UPDATE CASCADE ON DELETE CASCADE,
ID_Команды2 INTEGER REFERENCES Команды(ID_Команды) ON UPDATE CASCADE ON DELETE CASCADE,
Наименование VARCHAR (64),
Длительность INTERVAL ,
Статус Статус,
Итог Итог
);

CREATE TABLE Спонсоры  (
ID_Спонсора SERIAL PRIMARY KEY,
Название VARCHAR (64),
Тип_компании Тип_компании
);

CREATE TABLE Спонсоры_Команды  (
ID_Спонсора INTEGER REFERENCES Спонсоры(ID_Спонсора) ON UPDATE CASCADE ON DELETE CASCADE,
ID_Команды INTEGER REFERENCES Команды(ID_Команды) ON UPDATE CASCADE ON DELETE CASCADE,
Условия TEXT
);

CREATE TABLE БК_Матчи  (
ID_БК INTEGER REFERENCES БК(ID_БК) ON UPDATE CASCADE ON DELETE CASCADE,
ID_Команды INTEGER REFERENCES Матчи(ID_Матча) ON UPDATE CASCADE ON DELETE CASCADE,
Коэф_на_победу_1 DECIMAL,
Коэф_на_победу_2 DECIMAL,
Договорной_матч BOOLEAN,
Договорной_исход Итог
);

CREATE TABLE Турниры_Команды  (
ID_Турнира INTEGER REFERENCES Турниры(ID_Турнира) ON UPDATE CASCADE ON DELETE CASCADE,
ID_Команды INTEGER REFERENCES Команды(ID_Команды) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Пользователи_Ставки  (
ID_БК INTEGER REFERENCES БК(ID_БК) ON UPDATE CASCADE ON DELETE CASCADE,
ID_Матча INTEGER REFERENCES Матчи(ID_Матча) ON UPDATE CASCADE ON DELETE CASCADE,
ID_Пользователя INTEGER REFERENCES Члены_Мафии(ID_Члена) ON UPDATE CASCADE ON DELETE CASCADE,
Ставка INTEGER ,
П1 BOOLEAN
);
--Добавление
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Россия', 'Москва','пр-кт Пушкина', '14к2', 955032);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Россия', 'Москва','пр-кт Пушкина', '14к3', 955032);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Россия', 'Москва','пр-кт Пушкина', '14к4', 955032);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Украина', 'Киев','Грибоедова', '11к4', 254575);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Украина', 'Киев','Грибоедова', '11к3', 254345);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Германия', 'Берлин','Schlustrasse', '123', 224575);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Франция', 'Париж','Bonemoux', '12', 25453215);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Китай', 'Nin Cha Gin','Nin Cha 32', '11к4', 253175);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Эстония', 'Таллин','Manturalli', '45', 2154155);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('США', 'Чикаго','3-Avenue', '114', 2545731);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Испания', 'Мадрид','Garsias', '13', 2551355);
insert into Адрес(Страна, Город, Улица, Дом, Индекс) values('Дания', 'Копенгаген','Dangerlowsberg', '75', 214575);

insert into Мафия(Название, Штаб_квартира, Нацианальность, Бюджет) values('Якудза', 1,'Японцы', 100000);
insert into Мафия(Название, Штаб_квартира, Нацианальность, Бюджет) values('Коза Ностра', 2,'Итальянцы', 1000000);

insert into Члены_Мафии(ID_Мафии, Имя, Фамилия, Отчество, Должность, Кличка, Login, Password, Balance) values(1, 'Михаил','Зубенко','Петрович', 'Дон', 'Мафиозник', 'don', 'don123', 666);
insert into Члены_Мафии(ID_Мафии, Имя, Фамилия, Отчество, Должность) values(1, 'Андрей','Шаля','Юрьевич', 'Капо');
insert into Члены_Мафии(ID_Мафии, Имя, Фамилия, Отчество, Должность) values(2, 'Паобло','Эскобар', 'Дон');
insert into Члены_Мафии(ID_Мафии, Имя, Фамилия, Должность) values(2, 'Борис','Бритва', 'Солдат');
insert into Члены_Мафии(ID_Мафии, Имя, Фамилия, Должность) values(1, 'Чон','Чачкуг', 'Солдат');
insert into Члены_Мафии(ID_Мафии, Имя, Фамилия, Должность) values(1, 'Ким','Ирсен', 'Капо');
insert into Члены_Мафии(ID_Мафии, Имя, Фамилия, Должность) values(2, 'Аль','Пачино', 'Солдат');
insert into Члены_Мафии(ID_Мафии, Имя, Фамилия, Должность) values(2, 'Сонни','Карлеоне', 'Солдат');

insert into Команды(ID_Мафии, Название, Тег, Бюджет, Дата_Основания) values(1, 'Natus Vinsere','NAVI', 10000000, '11.11.2003');
insert into Команды(ID_Мафии, Название, Тег, Бюджет, Дата_Основания) values(1, 'Secret','SEC', 15000000, '01.03.2012');
insert into Команды(ID_Мафии, Название, Тег, Бюджет) values(2, 'Virtus Pro','VP', 5000000);
insert into Команды(ID_Мафии, Название, Тег, Бюджет) values(2, 'PSG.LGD','LGD', 50000000);
insert into Команды(ID_Мафии, Название, Тег, Бюджет) values(2, 'Royal','RNG', 500000);
insert into Команды(ID_Мафии, Название, Тег, Бюджет) values(1, 'OG','OG', 50000000);
insert into Команды(ID_Мафии, Название, Тег, Бюджет) values(1, 'Evil Geniuses','EG', 5000000);

insert into БК(ID_Мафии, Название, Сайт, Штаб_квартира) values(1, 'JeckichBets','www.jbets.com', 1);
insert into БК(ID_Мафии, Название, Сайт, Штаб_квартира) values(2, 'MyBets','www.mybets.com', 2);

insert into Должности(Название) values('Тренер');
insert into Должности(Название) values('Менеджер');
insert into Должности(Название) values('Завхоз');

insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах) values('11.11.2020', '11.11.2023', 1, 2000);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах) values('10.11.2020', '10.11.2023', 2, 3000);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах) values('09.11.2020', '12.11.2023', 3, 5000);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах) values('09.11.2020', '12.11.2023', 4, 1000);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах) values('02.11.2020', '03.11.2023', 5, 12000);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах) values('01.11.2020', '06.11.2023', 6, 500);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах) values('01.11.2020', '06.11.2023', 7, 500);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах, ID_Должности) values('01.11.2020', '06.11.2023', 1, 5000,1);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах, ID_Должности) values('01.11.2020', '06.11.2023', 1, 100, 3);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах, ID_Должности) values('01.11.2020', '06.11.2023', 2, 1000, 1);
insert into Контракты(Дата_Подписания, Дата_Окончания, ID_Команды, Зарплата_в_долларах, ID_Должности) values('01.11.2020', '06.11.2023', 5, 800, 2);

insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Alik', 'Vorobey', 'V-Tune', 10000, 'Slark', 'Керри',  1);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Bogdan', 'Vasilenko', 'Iceberg', 9000, 'Zeus', 'Мид',  1);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Viktor', 'Nigiri', 'GeneRaL', 10000, 'Batrider', 'Офлейн',  1);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Vladimir', 'Nikogosyan', 'RodjER', 9000, 'Earthshaker', 'Частичная Поддержка',  1);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Andrey', 'Bondarenko', 'ALWAYSWANNAFLY', 5000, 'Disruptor', 'Полная Поддержка',  1);

insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Lasse', 'Urpalainen', 'MATUMBAMAN', 11000, 'Lone Druid', 'Керри',  2);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Michael', 'Janovski', 'Nisha', 9000, 'Storm Spirit', 'Мид',  2);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Ludwig', 'Wahlberg', 'zai', 11000, 'Dark Seer', 'Офлейн',  2);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Yazied', 'Jaradat', 'YapzOr', 10000, 'Rubik', 'Частичная Поддержка',  2);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Clement', 'Ivanov', 'Puppey', 10000, 'Chen', 'Полная Поддержка',  2);

insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Egor', 'Grigorenko', 'Nightfall', 10000, 'Phantom Lancer', 'Керри',  3);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Danil', 'Skutin', 'gpk', 9000, 'Lina', 'Мид',  3);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Dmitry', 'Dorokhin', 'DM', 10000, 'Tidehunter', 'Офлейн',  3);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Vitalie', 'Melnic', 'Save-', 9000, 'Windrunner', 'Частичная Поддержка',  3);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Illias', 'Ganeev', 'Kingslayer', 5000, 'Disruptor', 'Полная Поддержка',  3);

insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Wang', 'Chunyu', 'Ame', 5000, 'Phantom Lancer', 'Керри',  4);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Cheng', 'Xiang', 'NothingToSay', 12000, 'Magnus', 'Мид',  4);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Zhang', 'Ruida', 'Faith_bian', 11000, 'Puck', 'Офлейн',  4);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Zhao', 'Zixing', 'XinQ', 9000, 'Techies', 'Частичная Поддержка',  4);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Cheng', 'Yiping', 'y', 8000, 'Oracle', 'Полная Поддержка',  4);

insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Lu', 'Chengjun', 'Eurus', 10000, 'Medusa', 'Керри',  5);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Yao', 'Linsen', 'Somnus', 11000, 'Ember Spirit', 'Мид',  5);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Lu', 'Haiyang', 'Yang', 11000, 'Mars', 'Офлейн',  5);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Ru', 'Yaoli', 'fy', 12000, 'Rubik', 'Частичная Поддержка',  5);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Yao', 'Zhihao', 'RedPanda', 10000, 'Slardar', 'Полная Поддержка',  5);

insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Yao', 'Zheng', 'midone', 10000, 'Riki', 'Керри',  6);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Topias', 'Taavitsainen', 'Topson', 9000, 'Invoker', 'Мид',  6);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Sebastien', 'Debs', 'Seb', 10000, 'Axe', 'Офлейн',  6);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Martin', 'Sazdov', 'Saksa', 9000, 'Clockwerk', 'Частичная Поддержка',  6);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Johan', 'Sundstein', 'N0tail', 5000, 'Bane', 'Полная Поддержка',  6);

insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Alik', 'Vorobey', 'Arteezy', 10000, 'Slark', 'Керри',  22);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Bogdan', 'Vasilenko', 'Abed', 9000, 'Zeus', 'Мид',  22);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Viktor', 'Nigiri', 'iceiceice', 10000, 'Batrider', 'Офлейн',  22);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Vladimir', 'Nikogosyan', 'Cr1t', 9000, 'Earthshaker', 'Частичная Поддержка',  22);
insert into Игроки(Имя, Фамилия, Никнейм, ММР, Лучший_Герой, Позиция, ID_Контракта) values('Andrey', 'Bondarenko', 'Fly', 5000, 'Disruptor', 'Полная Поддержка',  22);

insert into Сотрудники(Имя, Фамилия, Отчество, Дата_рождения, ID_Контракта) values('Andrey', 'Chipenko', 'Nikolaevich', '02.03.1992', 18);
insert into Сотрудники(Имя, Фамилия,  Дата_рождения, ID_Контракта) values('Niko', 'Brane', '01.03.1982', 19);
insert into Сотрудники(Имя, Фамилия,  Дата_рождения, ID_Контракта) values('Wan', 'Yaling',  '12.06.1999', 20);
insert into Сотрудники(Имя, Фамилия, Отчество, Дата_рождения, ID_Контракта) values('Alexei', 'Berezin', 'Ivanovich', '02.03.1995', 21);
insert into Сотрудники(Имя, Фамилия, Отчество, Дата_рождения, ID_Контракта) values('Chang', 'Chon', 'Chun', '02.03.1995', 22);

insert into Инфраструктура(Наименование, ID_Адреса, ID_Команды) values('Тренировочная база', 4,1);
insert into Инфраструктура(Наименование, ID_Адреса, ID_Команды) values('Тренировочная база', 7,2);
insert into Инфраструктура(Наименование, ID_Адреса, ID_Команды) values('Тренировочная база', 6,3);
insert into Инфраструктура(Наименование, ID_Адреса, ID_Команды) values('Тренировочная база', 8,4);
insert into Инфраструктура(Наименование, ID_Адреса, ID_Команды) values('Тренировочная база', 7,5);
insert into Инфраструктура(Наименование, ID_Адреса, ID_Команды) values('Тренировочная база', 9,6);

insert into Инвентарь(Наименование, Стоимость, ID_Завхоза, ID_Инфраструктуры) values('Мыши Logitech g901', 500, 2,6);
insert into Инвентарь(Наименование, Стоимость, ID_Завхоза, ID_Инфраструктуры) values('Мониторы ASUS 3465', 15000, 2,6);

insert into Турниры(Название, Место_проведения, Дата_начала, Дата_оконания, Колво_команд, Призовой_фонд_дол) values('Dreamhack Wiinter', 'London', '15.04.2021', '21.04.2021', 4, 1000000);
insert into Турниры(Название, Место_проведения, Дата_начала, Дата_оконания, Колво_команд, Призовой_фонд_дол) values('ESL One Wiinter', 'Bejin', '05.03.2021', '14.03.2021', 4, 2000000);

insert into Матчи(ID_Турнира, ID_Команды1, ID_Команды2, Наименование, Статус) values(1, 1, 2, 'Semifinal',  'Не начался');
insert into Матчи(ID_Турнира, ID_Команды1, ID_Команды2, Наименование,  Статус) values(1, 3, 4, 'Semifinal',  'Не начался');
insert into Матчи(ID_Турнира, ID_Команды1, ID_Команды2, Наименование,  Статус) values(2, 5, 1, 'Semifinal', 'Не начался');
insert into Матчи(ID_Турнира, ID_Команды1, ID_Команды2, Наименование, Статус) values(2, 6, 4, 'Semifinal',  'Не начался');

insert into Спонсоры(Название, Тип_компании) values('Сбербанк',  'Финансы');
insert into Спонсоры(Название, Тип_компании) values('Intel',  'Техника');
insert into Спонсоры(Название, Тип_компании) values('ASUS',  'Техника');
insert into Спонсоры(Название, Тип_компании) values('AMD',  'Техника');
insert into Спонсоры(Название, Тип_компании) values('HyperX',  'Техника');
insert into Спонсоры(Название, Тип_компании) values('Audi',  'Автопром');

insert into Спонсоры_Команды(ID_Спонсора, ID_Команды) values(1,1);
insert into Спонсоры_Команды(ID_Спонсора, ID_Команды) values(2,2);
insert into Спонсоры_Команды(ID_Спонсора, ID_Команды) values(3,3);
insert into Спонсоры_Команды(ID_Спонсора, ID_Команды) values(4,4);
insert into Спонсоры_Команды(ID_Спонсора, ID_Команды) values(5,5);
insert into Спонсоры_Команды(ID_Спонсора, ID_Команды) values(6,6);

insert into Турниры_Команды(ID_Турнира, ID_Команды) values(1,1);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values(1,2);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values(1,3);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values(1,4);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values(2,1);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values(2,4);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values(2,5);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values(2,6);

insert into БК_Матчи(ID_БК, ID_Команды, Коэф_на_победу_1, Коэф_на_победу_2, Договорной_матч, Договорной_исход) values(1, 1, 1.41, 1.62, TRUE, '1-2');
insert into БК_Матчи(ID_БК, ID_Команды, Коэф_на_победу_1, Коэф_на_победу_2, Договорной_матч) values(1, 2, 1.41, 1.62, FALSE);
insert into БК_Матчи(ID_БК, ID_Команды, Коэф_на_победу_1, Коэф_на_победу_2, Договорной_матч, Договорной_исход) values(1, 3, 1.41, 1.62, TRUE , '2-0');
insert into БК_Матчи(ID_БК, ID_Команды, Коэф_на_победу_1, Коэф_на_победу_2, Договорной_матч, Договорной_исход) values(1, 4, 1.41, 1.62, TRUE, '0-2');
insert into БК_Матчи(ID_БК, ID_Команды, Коэф_на_победу_1, Коэф_на_победу_2, Договорной_матч) values(2, 1, 1.41, 1.62, FALSE);
insert into БК_Матчи(ID_БК, ID_Команды, Коэф_на_победу_1, Коэф_на_победу_2, Договорной_матч,Договорной_исход) values(2, 2, 1.41, 1.62, TRUE, '0-2');
insert into БК_Матчи(ID_БК, ID_Команды, Коэф_на_победу_1, Коэф_на_победу_2, Договорной_матч) values(2, 3, 1.41, 1.62, FALSE);
insert into БК_Матчи(ID_БК, ID_Команды, Коэф_на_победу_1, Коэф_на_победу_2, Договорной_матч) values(2, 4, 1.41, 1.62, FALSE);

ALTER TABLE "Пользователи_Ставки"
  ADD Результат decimal;

--Добавим индексирование
create index index_players_nicks
on Игроки using btree (Никнейм);

create index index_players_positions
on Игроки using hash (Позиция);
-----------------------
-- Данные индексы полезны, так как на сайте может быть будет предоставлена статистика игроков и их надо будет искать по позициям никам и командам
-----------------------
create index index_matches_teams
on Матчи using hash (ID_Команды);

create index index_tournier_names
on Турниры using btree (Название);
-----------------------
-- Данные индексы полезны, так как в основной на сайте будет поиск матчей по турнирам и командам
-----------------------
create index index_bk_matches
on БК_Матчи using hash (ID_Команды);
-----------------------
-- Данные индексы полезны, так поиск по командам в БК_Матчи используется в функции divide_prize (tour_id integer)
-----------------------


-- Триггер на проверку ММР
CREATE OR REPLACE FUNCTION check_mmr()
  RETURNS trigger AS
$func$
BEGIN
   IF (NEW.ММР )
    < (4500) THEN
      RAISE EXCEPTION 'Нельзя добавлять слишком слабых игроков';
   END IF;
   RETURN NEW;
END
$func$  LANGUAGE plpgsql;

create trigger check_mmr_trigger before insert or update on Игроки FOR EACH ROW EXECUTE PROCEDURE check_mmr();

-- Триггер проверки есть ли в команде 5 игроков

CREATE OR REPLACE FUNCTION check_5_players()
  RETURNS trigger AS
$func$
BEGIN
   IF (SELECT COUNT (Игроки.ID_Игрока) FROM Игроки WHERE Игроки.ID_Команды = NEW."ID_Команды")
    < (5) THEN
      RAISE EXCEPTION 'Должно быть минимум 5 игроков';
   END IF;
   RETURN NEW;
END
$func$  LANGUAGE plpgsql;

create trigger check_5_players_trigger before insert or update on Турниры_Команды FOR EACH ROW EXECUTE PROCEDURE check_5_players();

--Триггер для проберки может ли матч быть купленным+

CREATE OR REPLACE FUNCTION check_322() RETURNS trigger AS $$ BEGIN
   IF EXISTS (SELECT * FROM БК_Матчи
   WHERE NEW.ID_Команды = БК_Матчи.ID_Команды)
   THEN
      RAISE EXCEPTION 'Данный матч уже куплен другой мафиозной организацией';
END IF;
RETURN NEW;
END
$$  LANGUAGE plpgsql;

    create trigger check_322_trigger before insert or update on Турниры_Команды FOR EACH ROW EXECUTE PROCEDURE check_322();

-- Триггер проверяющий может ли команда позволить себе сотрудника+

CREATE OR REPLACE FUNCTION check_money() RETURNS trigger AS $$ BEGIN
   IF ((SELECT SUM( Контракты.Зарплата_в_долларах::integer ) FROM Контракты
   INNER JOIN Команды ON NEW.ID_Команды = Команды.ID_Команды) + NEW.Зарплата_в_долларах)>(SELECT Команды.Бюджет FROM Команды WHERE Команды.ID_Команды = NEW.ID_Команды)
   THEN
      RAISE EXCEPTION 'У команды не хватает денег на нового игрока';
END IF;
RETURN NEW;
END
$$  LANGUAGE plpgsql;

create trigger check_money_trigger before insert or update on Контракты FOR EACH ROW EXECUTE PROCEDURE check_money();

--Распределить призовые
CREATE OR REPLACE FUNCTION  divide_prize (tour_id integer) returns void as $$
declare
teams_amount integer;
prize_pool integer;
winner_id integer;
other_percent decimal;
begin
select Турниры.Призовой_фонд_дол into prize_pool from Турниры t where t.ID_Турнира = tour_id;
select Турниры.Колво_команд into teams_amount from Турниры t where t.ID_Турнира = tour_id;
select Турниры.Победитель into winner_id from Турниры t where t.ID_Турнира = tour_id;
other_percent = (prize_pool*0.4)/teams_amount;
UPDATE Команды t SET Бюджет = Бюджет + prize_pool*0.5 WHERE t.ID_Команды = winner_id;
UPDATE Команды t SET Бюджет = Бюджет + other_percent;
FROM Команды te
INNER JOIN Турниры_Команды tt
ON tt.ID_Команды = t.ID_Команды
WHERE tt.ID_Турнира = tour_id;
end
$$ LANGUAGE plpgsql;
-----зарегистрировать турнир
CREATE OR REPLACE FUNCTION  make_tour (namet varchar, prizepool integer, startdate date, enddate date, team1 varchar , team2 varchar , team3 varchar , team4 varchar) returns void as $$
declare
team1_id integer;
team2_id integer;
team3_id integer;
team4_id integer;
tid integer;
begin
IF(startdate <= CURRENT_DATE )
THEN
select Команды.ID_Команды into team1_id from Команды t where t.Тег = team1;
select Команды.ID_Команды into team2_id from Команды t where t.Тег = team2;
select Команды.ID_Команды into team3_id from Команды t where t.Тег = team3;
select Команды.ID_Команды into team4_id from Команды t where t.Тег = team4;
select MAX(Турниры.ID_Турнира) into tid from Турниры;
tid = tid + 1;
insert into Турниры_Команды(ID_Турнира, ID_Команды) values (tid, team1_id);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values (tid, team2_id);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values (tid, team3_id);
insert into Турниры_Команды(ID_Турнира, ID_Команды) values (tid, team4_id);

insert into Матчи(ID_Турнира, ID_Команды1, ID_Команды2, Наименование, Статус) values(tid, team1_id, team2_id, 'Semifinal',  'Не начался');
insert into Матчи(ID_Турнира, ID_Команды1, ID_Команды2, Наименование, Статус) values(tid, team3_id, team4_id, 'Semifinal',  'Не начался');
END IF;

IF(startdate > CURRENT_DATE )
THEN
 RAISE EXCEPTION 'Турнир нельзя зарегестрировать в день начала';
END IF;
end
$$ LANGUAGE plpgsql;

------Показать доступную линию ставок
CREATE OR REPLACE FUNCTION  give_line (mafid integer) returns void as $$
declare
begin
SELECT * FROM Матчи m
INNER JOIN БК_Матчи bm ON m.ID_Матча = bm.ID_Команды
INNER JOIN БК b ON b.ID_БК = bm.ID_БК
INNER JOIN Мафия М on b.ID_Мафии = М.ID_Мафии
INNER JOIN Члены_Мафии ЧМ on М.ID_Мафии = ЧМ.ID_Мафии
WHERE ЧМ.ID_Мафии = mafid;
end
$$ LANGUAGE plpgsql;

-------make_coef---
CREATE OR REPLACE FUNCTION make_coef_t1 (matchid integer) returns decimal as $$
declare
team1_b integer ;
team2_b integer ;
team1_coef decimal ;
begin
SELECT Команды.Бюджет into team1_b FROM Команды t
INNER JOIN Матчи m ON t.ID_Команды = m.ID_Команды1
WHERE m.ID_Матча = matchid;
SELECT Команды.Бюджет into team2_b FROM Команды t
INNER JOIN Матчи m ON t.ID_Команды = m.ID_Команды2
WHERE m.ID_Матча = matchid;
team1_coef =((team2_b/team1_b)*0.5)+1;
return team1_coef;
end
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION make_coef_t2 (matchid integer) returns decimal as $$
declare
team1_b integer ;
team2_b integer ;
team2_coef decimal ;
begin
SELECT Команды.Бюджет into team1_b FROM Команды t
INNER JOIN Матчи m ON t.ID_Команды = m.ID_Команды1
WHERE m.ID_Матча = matchid;
SELECT Команды.Бюджет into team2_b FROM Команды t
INNER JOIN Матчи m ON t.ID_Команды = m.ID_Команды2
WHERE m.ID_Матча = matchid;
team2_coef =((team1_b/team2_b)*0.5)+1;
return team2_coef;
end
$$ LANGUAGE plpgsql;
