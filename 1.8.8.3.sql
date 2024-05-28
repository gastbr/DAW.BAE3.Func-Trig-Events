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

