drop database if exists centro;
create database centro;
use centro;

CREATE TABLE centro.comunidad (
    id INT UNSIGNED PRIMARY KEY auto_increment,
    nombre VARCHAR(30),
    apellido1 VARCHAR(30),
    apellido2 VARCHAR(30),
    fecha_nacimiento DATE,
    tipo ENUM('Profesor', 'Alumno', 'Otros')
);

alter table centro.comunidad
add column edad tinyint unsigned;

insert into centro.comunidad (nombre, apellido1, apellido2, fecha_nacimiento, tipo) values ('Nombre','Ape','Llido','1991-02-16',1);
insert into centro.comunidad (nombre, apellido1, apellido2, fecha_nacimiento, tipo) values ('Gerardo','Ape','Llidos','1993-12-31',2);
insert into centro.comunidad (nombre, apellido1, apellido2, fecha_nacimiento, tipo) values ('Prueba','Número','Tres','2004-11-13',3);
insert into centro.comunidad (nombre, apellido1, apellido2, fecha_nacimiento, tipo) values ('Otra','Prueba','Distinta','1984-05-29',1);

delimiter $$
drop function if exists centro.calcular_edad$$
create function centro.calcular_edad(fecha_nacimiento date) returns int not deterministic
begin
    return timestampdiff(year, fecha_nacimiento, now());
end$$	

drop procedure if exists centro.actualizar_columna_edad$$
create procedure actualizar_columna_edad ()
begin
	DECLARE fin bool default false;
	declare comunidad_id int;
	declare nacimiento date;
    declare fecha cursor for select id, fecha_nacimiento from comunidad;
    declare continue handler for not found set fin = true;
    open fecha;
    bucle: loop
		fetch fecha into comunidad_id, nacimiento;
		if fin then
			leave bucle;
		end if;
		UPDATE centro.comunidad SET edad = CALCULAR_EDAD(nacimiento) WHERE id = comunidad_id;
    end loop;
    close fecha;
 end$$

delimiter ;


select * from centro.comunidad;
call centro.actualizar_columna_edad;
select * from centro.comunidad;

-- 1.8.8 - 3

delimiter $$

drop function if exists test.eliminar_acentos$$
create function test.eliminar_acentos (cadenain varchar(255)) returns varchar(255) deterministic
begin
	set cadenain = replace(cadenain, "á", "a");
	set cadenain = replace(cadenain, "é", "e");
	set cadenain = replace(cadenain, "í", "i");
	set cadenain = replace(cadenain, "ó", "o");
	set cadenain = replace(cadenain, "ú", "u");
    set cadenain = replace(cadenain, "Á", "a");
	set cadenain = replace(cadenain, "É", "e");
	set cadenain = replace(cadenain, "Í", "i");
	set cadenain = replace(cadenain, "Ó", "o");
	set cadenain = replace(cadenain, "Ú", "u");
    RETURN cadenain;
end$$

drop procedure if exists test.crear_email$$
create procedure test.crear_email (in nombre varchar(50), in apellido1 varchar(50), in apellido2 varchar(50), in dominio varchar(23), out email varchar(30))
begin
	set nombre = left(nombre, 1);
    set apellido1 = left(apellido1, 3);
    set apellido2 = left(apellido2, 3);
    set email = concat(nombre, apellido1, apellido2,'@', dominio);
    set email = lower(email);
    set email = eliminar_acentos(email);
end$$

drop trigger if exists test.trigger_crear_email_before_insert$$
create trigger trigger_crear_email_before_insert
before insert
on alumnos for each row
begin
	if new.email is null then
		call test.crear_email(new.nombre, new.apellido1, new.apellido2, "gobiernodecanarias.org", new.email);
end if;
end$$

delimiter ;

CALL test.crear_email('ÁNGEL', 'ÁFRICA', 'ÍNIGO', 'gobiernodecanarias.org', @salida);
select @salida;

insert into test.alumnos (nombre, apellido1, apellido2, nota) values ('ÁNGEL','ÍNIGO','ÓNIX','5');
select * from test.alumnos;
