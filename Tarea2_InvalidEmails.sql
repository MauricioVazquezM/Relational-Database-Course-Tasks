--Tarea 2: Invalid Emails

create table emails (
id_hero numeric(4,0) constraint pk_hero primary key,
nombres varchar(50) not null,
email varchar(100) not null
);
----
CREATE SEQUENCE hero_id_hero_seq START 1 INCREMENT 1 ;
ALTER TABLE emails ALTER COLUMN id_hero SET DEFAULT nextval('hero_id_hero_seq');
----
----
insert into "Avengers".emails 
(nombres,email)
values
('Wanda Maximoff','wanda.maximoff@avengers.org'),
('Pietro Maximoff','pietro@mail.sokovia.ru'),
('Erik Lensherr','fuck_you_charles@brotherhood.of.evil.mutants.space'),
('Charles Xavier','i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.'),
('Anthony Edward Stark','iamironman@avengers.gov'),
('Steve Rogers','americas_ass@anti_avengers'),
('The Vision','vis@westview.sword.gov'),
('Clint Barton','bul@lse.ye'),
('Natasja Romanov','blackwidow@kgb.ru'),
('Thor','god_of_thunder-^_^@royalty.asgard.gov'),
('Logan','wolverine@cyclops_is_a_jerk.com'),
('Ororo Monroe','ororo@weather.co'),
('Scott Summers','o@x'),
('Nathan Summers','cable@xfact.or'),
('Groot','iamgroot@asgardiansofthegalaxyledbythor.quillsux'),
('Nebula','idonthaveelektras@complex.thanos'),
('Gamora','thefiercestwomaninthegalaxy@thanos.'),
('Rocket','shhhhhhhh@darknet.ru');

----TAREA 2: QUERY QUE REGRESE LOS EMAILS INVALIDOS

--NOTA: El email de Thor pareciera que es invalido en la tarea es valido.e hizo la prueba de mandar correo y la direccion en el sistema de gmail lo detecto como direccion valida. 
--Por ese motivo no sale en el query

--RESTRICCIONES PARA QUE UN EMAIL SEA VALIDO:
--mayúsculas y minúsculas letras latinas A a Z y a a z,
--dígitos 0 a 9,
--caracteres especiales !#$%&'*+-/=?^_`{|}~,
--punto ., siempre que no sea el primer o el último carácter a menos que se indique, y también que no aparezca consecutivamente a menos que se indique (por ejemplo, John..Doe@example.com no está permitido pero "John..Doe"@example.com está permitido),
--los caracteres de espacio y "(),:;<>@[\] están permitidos con restricciones (solo se permiten dentro de una cadena entrecomillada, como se describe en el párrafo a continuación, y además, una barra invertida o una comilla doble deben ir precedidas por una barra invertida),
--los comentarios se permiten con paréntesis en cualquiera de los extremos de la parte local; p.ej. john.smith(comment)@example.com y (comment)john.smith@example.com son equivalentes a john.smith@example.com.

select * from emails e;

select nombres,email
from emails e 
where email like '%@%_.' or email not like '%@%.%' or email like '%@.%' or email like '&@%..%' or email like '-_%@%_-' or email not like '%@%' or email like '%,%' or email like '@_%_@' or email like '%@@%' or email like '%;%' email like '%:%'
order by nombres asc;

