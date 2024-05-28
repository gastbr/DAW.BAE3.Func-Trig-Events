use ebanca;
show tables in ebanca;
select * from cuentas;
select * from movimientos;
describe movimientos;
show create table movimientos;


delimiter $$
drop function if exists insertar_mov$$
create function insertar_mov(cantidad int, codcuenta int, fecham datetime) returns bool not deterministic
begin
	
end$$

CREATE TABLE `movimientos` (
  `dni` decimal(8,0) NOT NULL,
  `fechahora` date NOT NULL,
  `cantidad` double NOT NULL,
  `idmov` int NOT NULL AUTO_INCREMENT,
  `cod_cuenta` int NOT NULL,
  PRIMARY KEY (`idmov`),
  KEY `ccuenta` (`cod_cuenta`)
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=latin1