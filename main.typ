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

#show figure: set align(left)

#show figure.caption: set align(left)

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

= Функциональное проектирование
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
    columns: 4,
    align: center + horizon,
    // УРОВЕНЬ 1: Category
    table.cell(colspan: 4)[*struct Category*],
    // УРОВЕНЬ 2: Поля Category
    [`char name[30]` \ Название],
    [`int fields_count` \ Кол-во полей],
    [`Type field_types[6]` \ Типы полей],
    [`char field_names[6][30]` \ Имена полей]
  ),
  caption: [Структура данных категории]
) <data-category>

#v(1em)

#figure(
  table(
    columns: 3,
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

= Разработка программных модулей

== Алогритм функции `tree_add_element`

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
