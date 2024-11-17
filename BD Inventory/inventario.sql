drop table if exists categorias
create table categorias (
	codigo_cat serial not null,
	nombre varchar(100) not null,
	categoria_padre int,
	constraint codigo_cat_PK primary key(codigo_cat),
	constraint categoria_fk foreign key (categoria_padre)
	references categorias(codigo_cat)
)

select * from categorias

insert into categorias (nombre, categoria_padre)
values('Materia Prima', null)
insert into categorias (nombre, categoria_padre)
values('Proteina', 1);
insert into categorias (nombre, categoria_padre)
values('Salsa', 1);
insert into categorias (nombre, categoria_padre)
values('Punto de venta', null);
insert into categorias (nombre, categoria_padre)
values('Bebidas', 4);
insert into categorias (nombre, categoria_padre)
values('Con Alcohol', 5);
insert into categorias (nombre, categoria_padre)
values('Sin Alcohol', 5);

drop table categoria_unidad_medida
--tabla Categoria Unidad de medida
create table categoria_unidad_medida (
codigo_cudm char(1) not null,
nombre varchar(100) not null,
constraint codigo_cudm_pk primary key(codigo_cudm)
)
select * from categoria_unidad_medida

insert into categoria_unidad_medida (codigo_cudm, nombre)
values('U', 'Unidades');
insert into categoria_unidad_medida (codigo_cudm, nombre)
values('V', 'Volumne');
insert into categoria_unidad_medida (codigo_cudm, nombre)
values('P', 'Peso')


--Tabla unidad medida
create table unidad_medida(
codigo_udm char(2) not null,
descripcion varchar(100) not null,
categoria_cudm char(1),
constraint codigo_udm_pk primary key (codigo_udm),
constraint unidad_medida_categoria_fk foreign key(categoria_cudm)
references categoria_unidad_medida(codigo_cudm)
)

insert into unidad_medida(codigo_udm, descripcion, categoria_cudm)
values ('ml', 'mililitros', 'V');
insert into unidad_medida(codigo_udm, descripcion, categoria_cudm)
values ('l', 'litros', 'V');
insert into unidad_medida(codigo_udm, descripcion, categoria_cudm)
values ('u', 'unidad', 'U');
insert into unidad_medida(codigo_udm, descripcion, categoria_cudm)
values ('d', 'docena', 'U');
insert into unidad_medida(codigo_udm, descripcion, categoria_cudm)
values ('g', 'gramos', 'P');
insert into unidad_medida(codigo_udm, descripcion, categoria_cudm)
values ('kg', 'kilogramos', 'P');
insert into unidad_medida(codigo_udm, descripcion, categoria_cudm)
values ('lb', 'libras', 'P');

select* from unidad_medida

drop table productos
create table productos (
codigo_prod serial not null,
nombre varchar(100) not null,
udm char(2) not null,
precio_venta money not null,
tiene_iva boolean not null,
costo money not null,
categoria int not null,
stock int not null,
constraint codigo_prod_pk primary key (codigo_prod),
constraint unidad_medida_productos_fk foreign key (udm)
references unidad_medida(codigo_udm),
constraint categorias_productos_fk
foreign key (categoria) references categorias (codigo_cat)
)

select * from productos

insert into productos (nombre, udm,precio_venta,tiene_iva, costo, categoria, stock)
values('coca-cola pequeña', 'u', 0.58, True, 0.3729, '7', 105);
insert into productos (nombre, udm,precio_venta,tiene_iva, costo, categoria, stock)
values('Salsa de Tomate', 'kg', 0.95, True, 0.8736, '3', 0);
insert into productos (nombre, udm,precio_venta,tiene_iva, costo, categoria, stock)
values('Mayonesa', 'kg', 1.10, True, 0.90, '3', 0);
insert into productos (nombre, udm,precio_venta,tiene_iva, costo, categoria, stock)
values('Fuze tea', 'u', 0.8, True, 0.7, '7', 49);

drop table tipo_proveedores
--tabla tipo documento
create table tipo_documento(
codigo char(1) not null,
descripcion varchar(50) not null,
constraint codigo_pk primary key (codigo)
)
select* from tipo_documento
insert into tipo_documento (codigo, descripcion)
values('C', 'Cedula');
insert into tipo_documento (codigo, descripcion)
values('R', 'RUC');

--tabla proveedores
create table proveedores(
identificador varchar(13) not null,
tipo_documento char(1) not null,
nombre varchar(20) not null,
telefono varchar(10) not null,
correo varchar(50) not null,
direccion varchar(100) not null,
constraint identificador_pk primary key(identificador),
constraint proveedores_tipo_documento_fk
foreign key(tipo_documento) references tipo_documento(codigo)
)

insert into proveedores (identificador, tipo_documento, nombre, telefono, correo, direccion)
values('4172601098798', 'R', 'Juan Torres', '0998890987', 'juantorres@gmail.com', 'Guajalo');
insert into proveedores (identificador, tipo_documento, nombre, telefono, correo, direccion)
values('098765432', 'C', 'Maria Galarza', '0987657898', 'mariamar@gmail.com', 'Ambato');

select * from proveedores


--tabla estado_pedido
create table estado_pedido(
codigo char(1) not null,
descripcion varchar(50) not null,
constraint estado_pedido_codigo_pk primary key (codigo)
)

select * from estado_pedido

insert into estado_pedido (codigo, descripcion)
values('S', 'Solicitado');
insert into estado_pedido (codigo, descripcion)
values('R', 'Recibido')

drop table cabecera_pedido
---tabla cabecera pedido
create table cabecera_pedido(
numero serial not null,
proveedor varchar(15) not null,
fecha timestamp WITHOUT TIME zone  not null,
estado_pedido char(1),
constraint numero_cabecera_pk primary key(numero),
constraint proveedor_cabecera_fk foreign key (proveedor)
references proveedores(identificador),
constraint estado_pedido_cabecera_fk foreign key (estado_pedido)
references estado_pedido(codigo)
)

select * from cabecera_pedido

insert into cabecera_pedido(proveedor, fecha, estado_pedido)
values('4172601098798', '30/11/2024 19:10:09', 'R');
insert into cabecera_pedido(proveedor, fecha, estado_pedido)
values('4172601098798', '30/12/2024 22:19:09', 'R');

--Tabla detalle pedido
create table detalle_pedido(
codigo serial not null,
cabecera_pedido serial not null,
producto serial not null,
cantidad int not null,
subtotal money not null,
catidad_recibida int not null,
constraint detalle_pedido_pk primary key (codigo),
constraint cabecera_pedido_detalle_fk foreign key (cabecera_pedido)
references cabecera_pedido(numero),
constraint producto_detalle_fk foreign key (producto)
references productos(codigo_prod)
)

select * from detalle_pedido

insert into detalle_pedido (cabecera_pedido,producto,cantidad,subtotal,catidad_recibida)
values('1', '1', 100, 37.29, 100);
insert into detalle_pedido (cabecera_pedido,producto,cantidad,subtotal,catidad_recibida)
values('1', '4', 50, 11.8, 50);
insert into detalle_pedido (cabecera_pedido,producto,cantidad,subtotal,catidad_recibida)
values('2', '1', 10, 3.73, 10);


--tabala historial de stock
create table historial_stock(
codigo serial not null,
fecha timestamp without time zone not null,
referencia varchar(10) not null,
producto serial not null,
cantidad int not null,
constraint historial_stock_codigo_pk primary key (codigo),
constraint productos_historial_fk foreign key (producto)
references productos(codigo_prod)
)

select * from historial_stock
insert into historial_stock(fecha,referencia, producto,cantidad)
values('11/11/2024 19:09:54', 'pedido 1', 1, 100);
insert into historial_stock(fecha,referencia, producto,cantidad)
values('11/11/2024 19:09:54', 'pedido 1', 4, 50);
insert into historial_stock(fecha,referencia, producto,cantidad)
values('11/11/2024 20:09:54', 'pedido 2', 1, 10);
insert into historial_stock(fecha,referencia, producto,cantidad)
values('11/12/2024 13:09:54', 'venta 1', 1, -5);
insert into historial_stock(fecha,referencia, producto,cantidad)
values('11/12/2024 13:09:54', 'venta 1', 4, -1);


--cabecera_ventas
create table cabecera_ventas(
codigo serial not null,
fecha timestamp without time zone not null,
total_sin_iva money not null,
iva money not null,
total money not null,
constraint cabecera_venta_codigo_pk primary key (codigo)
)

select * from cabecera_ventas
insert into cabecera_ventas (fecha, total_sin_iva, iva, total)
values('11/11/2024 20:09:54', 3.26, 0.39, 3.65)


--detalle ventas
create table detalle_ventas(
codigo serial not null,
cabecera_ventas serial not null,
producto serial not null,
cantidad int not null,
precio_venta money not null,
subtotal money not null,
total_iva money not null,
constraint detalle_venta_codigo_pk primary key(codigo),
constraint cabecera_ventas_detalle_ventas_fk
foreign key (cabecera_ventas)
references cabecera_ventas(codigo),
constraint productos_detalle_ventas_fk
foreign key (producto)
references productos (codigo_prod)
)
select * from detalle_ventas

insert into detalle_ventas(cabecera_ventas, producto, cantidad, precio_venta, subtotal, total_iva)
values(1, 1, 5,0.58, 2.9, 3.25);
insert into detalle_ventas(cabecera_ventas, producto, cantidad, precio_venta, subtotal, total_iva)
values(1, 4, 1, 0.36,0.36, 0.4)