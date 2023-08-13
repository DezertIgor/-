-- ЗАДАНИЕ 1

-- 1. Составьте запрос, который выведет имя вида с наименьшим id. Результат будет соответствовать букве «М».

select species_name from species where species_id=(select min(species_id) from species);

/* 2. Составьте запрос, который выведет имя вида с количеством представителей более 1800.
Результат будет соответствовать букве «Б».*/

select species_name from species where species_amount>1800;

/* 3. Составьте запрос, который выведет имя вида, начинающегося на «п» и относящегося к типу с type_id = 5.
Результат будет соответствовать букве «О». */

select species_name from species where type_id = 5 and species_name like 'п%';

/* 4. Составьте запрос, который выведет имя вида, заканчивающегося на «са» или количество представителей которого равно 5.
Результат будет соответствовать букве В.*/

select species_name from species where species_amount=5 or species_name='%са';

-- ЗАДАНИЕ 2

-- 1. Составьте запрос, который выведет имя вида, появившегося на учете в 2023 году. Результат будет соответствовать букве «Ы».

-- "Кривой" способ (из подсказки ДЗ) + ответ возвращает поле "to_char" 🤮

select species_name, to_char(date_start, 'YYYY')
from species
where to_char(date_start, 'YYYY') ='2023';

-- Адекватный способ 

select species_name
from species
where EXTRACT(YEAR from date_start) = 2023;

/* 2. Составьте запрос, который выведет название отсутствующего (status = absent) вида, расположенного вместе с place_id = 3.
Результат будет соответствовать букве «С».*/

select s.species_name
from species as s join species_in_places as p
on s.species_id = p.species_id
where s.species_status='absent' and p.place_id=3;

/* 3.Составьте запрос, который выведет название вида, расположенного в доме и появившегося в мае,
а также и количество представителей вида. Название вида будет соответствовать букве «П».*/

select s.species_name, s.species_amount
from species as s join (places as p join species_in_places as sip on p.place_id = sip.place_id) as x
on s.species_id=x.species_id
where x.place_name='дом' and extract(MONTH from s.date_start) =5;

/* 4. Составьте запрос, который выведет название вида, состоящего из двух слов (содержит пробел).
Результат будет соответствовать знаку !. */

select species_name
from species
where species_name like '% %';

-- ЗАДАНИЕ 3

-- 1. Составьте запрос, который выведет имя вида, появившегося с малышом в один день. Результат будет соответствовать букве «Ч».

select species_name
from species
where species_name !='малыш' and date_start=(select date_start from species where species_name='малыш');

/* 2. Составьте запрос, который выведет название вида, расположенного в здании с наибольшей площадью.
Результат будет соответствовать букве «Ж».*/

select species_name
from species as s join (places as p join species_in_places as sip on p.place_id = sip.place_id) as x
on s.species_id=x.species_id
where x.place_size= (select max(place_size) from places
					 where places.place_name not in ('река', 'лес', 'сад')) and x.place_name not in ('река', 'лес', 'сад');

/* 3. Составьте запрос/запросы, которые найдут название вида, относящегося к 5-й по численности группе проживающей дома.
Результат будет соответствовать букве «Ш».

 Одним запросом справился */

select species_name
from species as s join (places as p join species_in_places as sip on p.place_id = sip.place_id) as x
on s.species_id=x.species_id
where x.place_name='дом'
order by s.species_amount desc
limit 1
offset 4;

/* 4. Составьте запрос, который выведет сказочный вид (статус fairy), не расположенный ни в одном месте.
Результат будет соответствовать букве «Т».*/

select species_name
from species as s LEFT join (places as p join species_in_places as sip on p.place_id = sip.place_id) as x
on s.species_id=x.species_id
where s.species_status ='fairy' and x.place_name IS NULL;
