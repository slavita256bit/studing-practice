#import "dependencies.typ": *

// Настройки шрифтов и формул
#set text(font: "Times New Roman", size: 14pt, lang: "ru")
#show math.equation: set text(font: "STIX Two Math", size: 14pt)

#show: gost.with(
  title-template: custom-title-template.from-module(studing-practice-project-title),
  student: (
    name: "Ермаков В. С.",
    group: "558301"
  ),
  manager: (
    name: "Ковальчук А. М.",
    title: "старший преподаватель"
  ),
  year: none,
  footer: (city: "МИНСК", year: "2026")
)

#show figure.where(kind: image): set figure(
  numbering: n => {
    let section = counter(heading).get().first()
    numbering("1.1", section, n)
  }
)
#show heading.where(level: 1): it => {
  counter(figure.where(kind: image)).update(0)
  it
}

#show figure.where(kind: table): set figure(
  numbering: n => {
    let section = counter(heading).get().first()
    numbering("1.1", section, n)
  }
)

#show figure.where(kind: table): set figure(gap: 0.3em)

#show heading.where(level: 1): it => {
  counter(figure.where(kind: table)).update(0)
  it
}

#show math.equation: it => {
    show ".": ","

  if it.block {
    pad(y: 0.5em, it)
  } else {
    it
  }
}

#set math.equation(numbering: none)
#set par(spacing: 0.8em)

= Введение

Автоматизация процессов купли-продажи и создание удобных каталогов товаров является одной из основных задач современной электронной коммерции. Для обеспечения высокой производительности и оптимального использования системных ресурсов такие программные продукты требуют тщательного проектирования структур данных и алгоритмов обработки информации.

Целью данной работы является разработка консольного приложения на языке программирования C, реализующего базовый функционал маркетплейса с гибкой системой категорий.

Для достижения поставленной цели необходимо решить следующие задачи:
- спроектировать масштабируемые структуры данных для хранения динамических характеристик товаров;
- разработать систему сохранения и загрузки каталога товаров с использованием файлового ввода-вывода;
- реализовать консольный пользовательский интерфейс с отображением товаров;
- реализовать бизнес-логику навигации и поиска по каталогу.

В первом разделе пояснительной записки проводится анализ предметной области, рассматриваются аналогичные программные решения и формируются требования к разрабатываемой системе. Во втором разделе описывается процесс проектирования архитектуры приложения, включая разработку структур данных и схемы алгоритма работы. Третий раздел посвящен описанию программной реализации, тестированию разработанного функционала и анализу полученных результатов.

= Проектирование структур данных

Для хранения информации в разрабатываемом приложении спроектирована иерархическая модель данных. На рисунке (таблице) ниже представлен состав и вложенность структур и объединений, используемых для описания товаров и их динамических характеристик.

#v(1em)
#figure(
  table(
    columns: 4, // Оставляем 4 колонки под уровни вложенности
    align: left + horizon,

    // Шапка таблицы (объединяем на все 4 колонки)
    table.header(
      table.cell(colspan: 4, align: center)[*Структуры*]
    ),

    // --- Структура Product ---
    table.cell(rowspan: 9)[*struct Product*],
    table.cell(colspan: 3)[int image_id],
    table.cell(colspan: 3)[char name[MAX_LEN]],
    table.cell(colspan: 3)[char description[MAX_DESCRIPTION_LEN]],
    table.cell(colspan: 3)[int cost],
    table.cell(colspan: 3)[int rating],

    // Вложенная структура Characteristics (1 своя строка + 3 от union)
    table.cell(rowspan: 4)[*Characteristics cs*],
    table.cell(colspan: 2)[int category_id],

    // Вложенный массив union Field (занимает 3 строки)
    table.cell(rowspan: 3)[*union~Field*~fields[6]],
    [int number],
    [float real],
    [char~str[MAX_LEN]],

    // --- Структура Category ---
    table.cell(rowspan: 2)[*struct Category*],
    table.cell(colspan: 3)[char name[MAX_LEN]],
    table.cell(colspan: 3)[enum Type field_types[6]],

    // --- Перечисление Type ---
    table.cell(rowspan: 3)[*enum Type*],
    table.cell(colspan: 3)[INT (0)],
    table.cell(colspan: 3)[FLOAT (1)],
    table.cell(colspan: 3)[STR (2)]
  ),
  caption: [Иерархия и состав структур данных приложения]
) <data-structures>