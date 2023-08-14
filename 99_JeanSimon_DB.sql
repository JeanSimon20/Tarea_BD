/* Crear Base de Datos */
CREATE DATABASE db_SalesClothes;
use db_SalesClothes;

/* Crear tabla client */
CREATE TABLE client
(
	id int, 
	type_document char(3),
	number_document char(15),
	names varchar(60),
	last_name varchar(90),
	email varchar(80),
	cell_phone char(9),
	birthdate date,
	active bit
	CONSTRAINT client_pk PRIMARY KEY (id)
);

/* Ver estructura de tabla client */
EXEC sp_columns @table_name = 'client';

/* Crear tabla sale */
CREATE TABLE sale
(
	id int, 
	date_time datetime,
	client_id int,
	seller_id int,
	active bit
	CONSTRAINT sale_pk PRIMARY KEY (id)
);

/* Ver estructura de tabla sale */
EXEC sp_columns @table_name = 'sale';

/* Crear tabla sale_detail */
CREATE TABLE sale_detail
(
	id int, 
	sale_id int,
	clothes_id int,
	amount int
	CONSTRAINT sale_detail_pk PRIMARY KEY (id)
);
/* Ver estructura de tabla sale_detail */
EXEC sp_columns @table_name = 'sale_detail';

/* Crear tabla seller */
CREATE TABLE seller
(
	id int, 
	type_document char(3),
	number_document char(15),
	names varchar(60),
	last_name varchar(90),
	salary decimal(8,2),
	cell_phone char(9),
	email varchar(80),
	active bit
	CONSTRAINT seller_pk PRIMARY KEY (id)
);

/* Ver estructura de tabla seller */
EXEC sp_columns @table_name = 'seller';

/* Crear tabla clothes */
CREATE TABLE clothes
(
	id int, 
	description varchar(60),
	brand varchar(60),
	amount int,
	size varchar(10),
	price decimal(8,2),
	active bit
	CONSTRAINT clothes_pk PRIMARY KEY (id)
);

/* Ver estructura de tabla clothes */
EXEC sp_columns @table_name = 'clothes';

/* Relacionar tabla sale con tabla client */
ALTER TABLE sale
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
	REFERENCES client (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

/* Relacionar tabla saller con tabla sale */
ALTER TABLE sale
	ADD CONSTRAINT sale_seller FOREIGN KEY (seller_id)
	REFERENCES seller (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

/* Relacionar tabla sale con tabla sale_detail */
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_sale FOREIGN KEY (sale_id)
	REFERENCES sale (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

/* Relacionar tabla clothes con tabla sale_detail */
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_clothes FOREIGN KEY (clothes_id)
	REFERENCES clothes (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

/* Ver relaciones creadas entre las tablas de la base de datos */

SELECT 
    fk.name [Constraint],
    OBJECT_NAME(fk.parent_object_id) [Tabla],
    COL_NAME(fc.parent_object_id,fc.parent_column_id) [Columna FK],
    OBJECT_NAME (fk.referenced_object_id) AS [Tabla base],
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS [Columna PK]
FROM 
    sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fc ON (fk.OBJECT_ID = fc.constraint_object_id)
GO
