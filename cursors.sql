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