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

#show "<<": "«"
#show ">>": "»"

#show figure.where(kind: image): set figure(
  numbering: n => {
    let section = counter(heading).get().first()
    numbering("1.1", section, n)
  }
)

#show figure.where(kind: table): set figure(
  numbering: n => {
    let section = counter(heading).get().first()
    numbering("1.1", section, n)
  }
)

#show figure.where(kind: table): set figure(gap: 0.3em)

#show heading.where(level: 1): it => {
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: image)).update(0)
  upper(it)
}

#show math.equation: it => {
  show ".": ","

  if it.block {
    pad(y: 0.5em, it)
  } else {
    it
  }
}

#show outline.entry: it => {
  show linebreak: []
  let clean_body = {
    show "(Обязательное) ": ""
    show "(Справочное) ": ""
    show v: []
    it.body()
  }

  set block(spacing: 0.65em)

  if state("appendixes", false).at(it.element.location()) {
    link(it.element.location(), it.indented(
      none,
      [ПРИЛОЖЕНИЕ #it.prefix() #clean_body]
        + sym.space
        + box(width: 1fr, it.fill)
        + sym.space
        + sym.wj
        + it.page()
    ))
  } else {
    it
  }
}

#set math.equation(numbering: none)
#set par(spacing: 0.8em)

#show heading: it => {
  if it.numbering == none {
    set align(center)
    it
  } else {
    it
  }
}

#show figure.where(kind: table): set align(left)

#show figure.caption.where(kind: table): set align(left)

#set table(align: left + horizon)

#set enum(
  indent: 1.25cm,
  body-indent: 0.5em,
  spacing: 0.65em,
  numbering: "1"
)

#set list(
  indent: 1.25cm,
  body-indent: 0.5em,
  spacing: 0.65em,
  marker: [--]
)

#show figure: fig => {
  if fig.kind == table {
    fig
  } else {
    move(dx: -7.5mm, fig)
  }
}

#show figure.where(kind: image): set figure(gap: 1.5em)
#show figure.where(kind: image): set block(above: 2em, below: 1em)

#heading(numbering: none, outlined: false)[СОДЕРЖАНИЕ]
#outline(title: none, depth: 2, indent: auto)

= Введение

Автоматизация процессов купли-продажи и создание удобных каталогов товаров является одной из основных задач современной электронной коммерции. Для обеспечения высокой производительности и оптимального использования системных ресурсов такие программные продукты требуют тщательного проектирования структур данных и алгоритмов обработки информации.

Целью данной работы является разработка консольного приложения на языке программирования C, реализующего базовый функционал маркетплейса с гибкой системой категорий.

Для достижения поставленной цели необходимо решить следующие задачи:
- спроектировать масштабируемые структуры данных для хранения динамических характеристик товаров;
- разработать систему сохранения и загрузки каталога товаров с использованием файлов;
- реализовать консольный пользовательский интерфейс с отображением товаров;
- реализовать логику навигации и поиска по каталогу, добавления товаров и категорий.

= Проектирование и разработка
== Проектирование структур данных

В таблице @data-structures-products представлена иерархия структур данных, описывающих товары. Структуры расположены сверху и объединяют свои внутренние поля, находящиеся на уровнях ниже. Для размещения широкой таблицы на странице применен физический поворот всей фигуры вместе с заголовком. Независимые структуры и перечисления вынесены в таблицы @data-category и @data-type.

#v(2em)
#unbreakable[
// Поворачиваем всю фигуру (таблицу + подпись)
#rotate(-90deg, reflow: true)[
  #figure(
    table(
      // 11 колонок для всех вложенных полей листьев
      columns: 11,
      align: center + horizon,

      // УРОВЕНЬ 1: TreeNode
      table.cell(colspan: 11)[*struct TreeNode*],

      // УРОВЕНЬ 2: Поля TreeNode и структура Product
      table.cell(rowspan: 4)[`TreeNode*`\ `left` \ Левый \ потомок],
      table.cell(rowspan: 4)[`TreeNode*`\ `right` \ Правый \ потомок],
      table.cell(colspan: 9)[*struct Product* `item`],

      // УРОВЕНЬ 3: Поля Product и структура Characteristics
      table.cell(rowspan: 3)[`int`\ `id`\ Иденти-фикатор товара],
      table.cell(rowspan: 3)[`char`\ `name[30]` \ Название],
      table.cell(rowspan: 3)[`char`\ `desc[50]` \ Описание],
      table.cell(rowspan: 3)[`int`\ `cost` \ Цена],
      table.cell(rowspan: 3)[`int`\ `rating` \ Рейтинг],
      table.cell(colspan: 4)[*struct Characteristics* `cs`],

      // УРОВЕНЬ 4: Поля Characteristics и union Field
      table.cell(rowspan: 2)[`int`\ `category_id` \ Иденти-фикатор \ категории],
      table.cell(colspan: 3)[*union Field* `fields[6]`],

      // УРОВЕНЬ 5: Поля union Field
      [`int` \ `number` \ Целое],
      [`float` \ `real` \ Дробное],
      [`char` \ `str[30]` \ Строка]
    ),
    caption: [Иерархия и состав структур данных каталога товаров]
  ) <data-structures-products>
]
]
#v(2em)

#figure(
  table(
    columns: (auto, auto, 7em, 12em),
    align: center + horizon,
    // УРОВЕНЬ 1: Category
    table.cell(colspan: 4)[*struct Category*],
    // УРОВЕНЬ 2: Поля Category
    [`char name[30]` \ Название],
    [`int fields_count` \ Кол-во полей],
    [`Type`\ `field_types[6]` \ Типы полей],
    [`char field_names[6][30]` \ Имена полей]
  ),
  caption: [Структура данных категории]
) <data-category>

#v(1em)

#figure(
  table(
    columns: (1fr, 1fr, 1fr),
    align: center + horizon,
    // УРОВЕНЬ 1: Enum Type
    table.cell(colspan: 3)[*enum Type*],
    // УРОВЕНЬ 2: Значения
    [`INT (0)` \ Целое],
    [`FLOAT (1)` \ Дробное],
    [`STR (2)` \ Строка]
  ),
  caption: [Перечисление типов данных характеристик]
) <data-type>


== Алгоритм функции `tree_add_element`

Функция добавления нового товара в бинарное дерево поиска игнорируя дубликаты по идентификатору.

*Вх:* `current` -- адрес адреса текущего узла дерева, тип `TreeNode**` \
#h(4.5em) `x` -- структура данных товара, тип `Product`.

+ Начало.
+ Цикл по элементам дерева пока адрес `*current` не равен `NULL`.
+ Если `x.id` равно `(*current)->item.id`, перейти к шагу 7.
+ Присвоить переменной `current` результат выполнения функции `tree_get_next` для перехода к следующей вершине.
+ Конец цикла по элементам дерева.
+ Присвоить переменной `*current` результат выполнения функции `tree_create_node` для выделения памяти под новую вершину.
+ Конец.

== Алгоритм функции `tree_save_direct`

Функция рекурсивно выполняет прямой обход бинарного дерева поиска и сохраняет данные каждого товара в бинарный файл.

*Вх:* `current` -- адрес текущего узела дерева, тип `TreeNode*`\
#h(4.5em) `file` -- указатель на открытый файловый поток, тип `FILE*`.\

+ Начало.
+ Если текущая вершина `current` равна `NULL`, перейти к шагу 6.
+ Вызвать функцию `fwrite` для записи товара `current->item` в бинарный файл.
+ Вызвать функцию `tree_save_direct` для рекурсивной записи в файл левого поддерева.
+ Вызвать функцию `tree_save_direct` для рекурсивной записи в файл правого поддерева.
+ Конец.

= Тестирование и отладка

== Результаты работы программы

Тестирование разработанного программного обеспечения проводилось методом функционального тестирования. В ходе тестирования проверялась корректность работы алгоритмов считывания, добавления, фильтрации и сохранения данных.

На рисунке @screen-menu представлено главное меню разработанного консольного приложения.

#figure(
  image("screen1.png", width: 70%),
  caption: [Главное меню программы]
) <screen-menu>

Процесс динамического формирования новой категории товаров с заданием пользовательских полей и их типов данных продемонстрирован на рисунке @screen-category.

#figure(
  image("screen2.png", width: 60%),
  caption: [Добавление новой категории товаров]
) <screen-category>

Ввод информации о новом товаре на основе ранее сформированной структуры категории показан на рисунке @screen-product. Программа успешно запрашивает специфичные поля.

#figure(
  image("screen3.png", width: 60%),
  caption: [Добавление нового товара в каталог]
) <screen-product>

На рисунке @screen-list представлен вывод каталога товаров в виде форматированной таблицы с применением фильтрации по категории и сортировки на основе бинарного дерева поиска.

#figure(
  image("screen4.png", width: 80%),
  caption: [Просмотр каталога товаров]
) <screen-list>

Детальная информация о выбранном товаре (карточка товара), включая его цветной рейтинг и дополнительные характеристики, представлена на рисунке @screen-details.

#figure(
  image("screen5.png", width: 80%),
  caption: [Детальный просмотр карточки товара]
) <screen-details>

#heading(numbering: none, outlined: true)[ЗАКЛЮЧЕНИЕ]

В ходе ознакомительной практики разработано консольное приложение на языке C для управления каталогом товаров.

В рамках индивидуального задания решены следующие задачи:
- спроектированы структуры данных для описания категорий и товаров с поддержкой настраиваемых характеристик;
- реализованы алгоритмы добавления и поиска элементов на основе бинарного дерева поиска;
- организован файловый ввод-вывод для сохранения состояния каталога;
- создан консольный интерфейс для взаимодействия с пользователем.

В результате выполнения работы закреплены практические навыки использования динамической памяти, указателей и работы с файлами в C. Разработанная программа успешно отлажена.

#pagebreak()

#heading(numbering: none, outlined: true)[СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ]

[1] СТП 01–2024. Дипломные проекты (работы). Общие требования. – Минск : БГУИР, 2024. – 122 с.

[2] Основы алгоритмизации и программирования : лаб. практикум для студ. спец. 1-40 02 01 «Вычислительные машины, системы и сети» всех форм обуч. В 2 ч. Ч. 2 / сост. Ю. А. Луцик [и др.]. – Минск : БГУИР, 2010. – 36 с. : ил.

[3] Бхаргава, А. Грокаем алгоритмы. Иллюстрированное пособие для программистов и любопытствующих / А. Бхаргава. – СПб. : Питер, 2017. – 288~с.

[4] Справочник по языку C [Электронный ресурс]. – Режим доступа: https://ru.cppreference.com/w/c. – Дата доступа: 15.05.2024.

[5] Документация Microsoft C/C++ и языка C [Электронный ресурс] / Microsoft Learn. – Режим доступа: https://learn.microsoft.com/ru-ru/cpp/c-language/. – Дата доступа: 16.05.2024.


#show: appendixes

#let appendix-heading(status, level: 1, body) = {
  heading(level: level)[(#status)\ #v(1em) #body]
}

#let get-numbering-alphabet(number) = {
  // excluded "З"
  let alphabet = ("а", "б", "в", "г", "д", "е", "ж", "и", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "э", "ю", "я",)
  let result = ""

  while number > 0 {
    result = alphabet.at(calc.rem(number - 1, 28)) + result
    number = calc.floor(number / 28)
  }

  return result
}

#let heading-numbering(..nums) = {
  nums = nums.pos()
  let letter = upper(get-numbering-alphabet(nums.first()))
  let rest = nums.slice(1).map(elem => str(elem))
  if rest != none {
    return (letter, rest).flatten().join(".")
  }
  return letter
}

#set heading(numbering: heading-numbering, hanging-indent: 0pt)

#appendix-heading("Обязательное")[Схема алгоритма функции `main`] <main-scheme>

#eskd-scheme(
  title: "Схема алгоритима функции\nmain",
  doc-code: "ГУИР.6-05-0611-05.114 ПД1",
  dev-name: "Ермаков",
  prov-name: "Ковальчук",
  group-name: "ЭВМ, гр. 558301",
  paper-format: "a4",
  vertical: true
)[
    #move(dy: -1em, dx: 2em, align(center + horizon)[
      #image("scheme1.svg", height: 100%, fit: "contain")
    ])
]

#appendix-heading("Обязательное")[Схема алгоритма функции `tree_add_element`] <tree_add_element-scheme>

#eskd-scheme(
  title: "Схема алгоритима функции\ntree_add_element",
  doc-code: "ГУИР.6-05-0611-05.114 ПД2",
  dev-name: "Ермаков",
  prov-name: "Ковальчук",
  group-name: "ЭВМ, гр. 558301",
  paper-format: "a4",
  vertical: true
)[
  #block(width: 110%, height: 100%)[
    #align(center + horizon)[
      #image("scheme2.svg", height: 80%, fit: "contain")
    ]
  ]
]

#appendix-heading("Обязательное")[Код программы] <code-appendix>


#show raw.where(block: true): it => block(
  width: 100%,
  breakable: true,
  text(
    font: "Consolas",
    size: 12pt,
    it
  )
)

// 1. Создаем список с путями к вашим файлам
#let files = (
  "marketplace_in_c/main.c",

  "marketplace_in_c/product.h",
  "marketplace_in_c/categories.h",
  "marketplace_in_c/tree.h",
  "marketplace_in_c/interaction.h",
  "marketplace_in_c/io.h",
  "marketplace_in_c/settings.h",

  "marketplace_in_c/product.c",
  "marketplace_in_c/categories.c",
  "marketplace_in_c/tree.c",
  "marketplace_in_c/interaction.c",
  "marketplace_in_c/io.c",
)

#let clean-code(content) = {
  content.replace(regex(" {2,}//"), " //")
//   let processed = content.replace("    ", "  ")
//   processed.replace(regex("\u{A0}"), " ").replace(regex(" {2,}//"), " //")
}

#set par(leading: 0.5em)
#for file in files [
  #let filename = file.split("/").last()

  #align(center)[*Код файла #filename*]

  #raw(clean-code(read(file)), lang: "c", block: true)
]

#appendix-heading("Обязательное")[Ведомость документов] <vedomost>

#[
  #show: eskd-vedomost.with(
    title: "Ведомость документов",
    doc-code: "ГУИР.6-05-0611-05.141 Д1",
    dev-name: "Ермаков",
    prov-name: "Ковальчук",
    group-name: "ЭВМ, гр. 558301"
  )
  #set text(font: "GOST Type B")

  #set text(style: "normal")
  #let er = ([], [], []) // Пустая строка для отступов

  #place(top + left, dx: -5mm, dy: -20mm, block(
    width: 185mm,
    height: 242mm,
    table(
      columns: (60mm, 95mm, 30mm),
      rows: (10mm, ..(8mm,) * 29), // 30 строк, ровно 242мм высоты до штампа
      inset: (x: 2mm, y: 0pt),
      stroke: 0.5mm + black, // Толщина совпадает с толщиной рамки ГОСТ
      align: (x, y) => if y == 0 or x == 2 { center + horizon } else { left + horizon },

      // Строка 1
      table.cell(align: center)[Обозначение], table.cell(align: center)[Наименование], table.cell(align: center)[Примечание],
      ..er, // 2
      [], table.cell(align: center)[#underline[Графические документы]], [], // 3
      ..er, // 4

      // Строки 5-6
      [ГУИР.6-05-0611-05.141 ПД1], [Схема алгоритма функции main], [А4],
      ..er, // 7

      // Строки 8-10
      [ГУИР.6-05-0611-05.141 ПД2], [Схема алгоритма функции tree_add_element], [А4],

       // 11
      ..er, // 12

      // Строки 13-14
      [], table.cell(align: center)[#underline[Текстовые документы]], [],
      ..er,

      // Строки 15-17
      [БГУИР.6-05-0611-05.141 ПЗ], [Отчет по учебной (ознакомительной) практике], [#context [ #counter(page).final().first() с. ]],
      [], [], [],
      [], [], [],

      // Добиваем пустые строки до 30 (использовано 17 строк, нужно еще 13)
      ..er, ..er, ..er, ..er, ..er, ..er, ..er,
      ..er, ..er, ..er, ..er, ..er, ..er
       )
  ))
]