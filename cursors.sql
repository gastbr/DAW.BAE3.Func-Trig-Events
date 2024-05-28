drop database if exists centro;
create database centro;
use centro;

CREATE TABLE centro.comunidad (
    id INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(30),
    apellido1 VARCHAR(30),
    apellido2 VARCHAR(30),
    fecha_nacimiento DATE,
    tipo ENUM('Profesor', 'Alumno', 'Otros')
);

alter table centro.comunidad
add column edad tinyint unsigned;

delimiter $$
drop function if exists centro.calcular_edad$$
create function centro.calcular_edad(fecha_nacimiento date) returns int not deterministic
begin
    return floor(datediff(now(), fecha_nacimiento) / 365);
end$$	

drop procedure if exists actualizar_columna_edad

delimiter ;
select centro.calcular_edad('1991-02-16');
-- select * from centro.comunidad;
