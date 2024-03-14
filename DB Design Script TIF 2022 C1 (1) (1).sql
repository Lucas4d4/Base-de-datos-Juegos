USE [master]
GO
IF EXISTS(select NAME from sys.databases where name = 'TIF2022_LAB') DROP DATABASE [TIF2022_LAB]
CREATE DATABASE [TIF2022_LAB]
GO

USE [TIF2022_LAB]
GO


CREATE TABLE Desarrolladores
(
	CodDesarrollador char(3) NOT NULL,
	NombreDesarrollador varchar(50) NOT NULL,
	SitioWeb varchar(100) NOT NULL,
	UbicacionDeSede varchar(100) NOT NULL,
	Historia varchar(100) NOT NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_Desarrolladores PRIMARY KEY (CodDesarrollador)
)
GO
	
CREATE TABLE Usuarios
(
	IdUsuario int IDENTITY(1,1) NOT NULL,
	Username varchar(30) NOT NULL,
	Contrasena varchar(50) NOT NULL,
	Email varchar(50) NOT NULL,
	Administrador bit NOT NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_Usuarios PRIMARY KEY (IdUsuario)
)
GO


CREATE TABLE Plataformas
(
	CodPlataforma char(3) NOT NULL,
	Descripcion varchar(30) NOT NULL,
	RutaImagen varchar(50) NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_Plataformas PRIMARY KEY (CodPlataforma)
)
GO

CREATE TABLE Categorias
(
	CodCategoria char(3) NOT NULL,
	Descripcion varchar(30) NOT NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_Categorias PRIMARY KEY (CodCategoria)
)
GO


CREATE TABLE Tiendas
(
	CodTienda char(3) NOT NULL,
	Descripcion varchar(30) NOT NULL,
	RutaImagen varchar(50) NULL,
	SitioWeb varchar(100) NOT NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_Tiendas PRIMARY KEY (CodTienda)
)
GO


CREATE TABLE Juegos
(
	CodDesarrollador char(3) NOT NULL,
	CodJuego char(3) NOT NULL,
	NombreJuego varchar(50) NOT NULL,
	Descripcion varchar(MAX) NOT NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_Juegos PRIMARY KEY (CodDesarrollador,CodJuego),
	CONSTRAINT FK_Juegos_Desarrolladores 
		FOREIGN KEY (CodDesarrollador) REFERENCES Desarrolladores(CodDesarrollador)
)
GO


CREATE TABLE Opiniones
(
	CodDesarrollador char(3) NOT NULL,
	CodJuego char(3) NOT NULL,
	IdUsuario int NOT NULL,
	Calificacion tinyint NOT NULL CHECK (Calificacion BETWEEN 1 AND 5),
	Comentario varchar(300) NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_Opiniones PRIMARY KEY (CodDesarrollador,CodJuego,IdUsuario),
	CONSTRAINT FK_Opiniones_Juegos
		FOREIGN KEY (CodDesarrollador,CodJuego) REFERENCES Juegos(CodDesarrollador,CodJuego),
	CONSTRAINT FK_Opiniones_Usuarios
		FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario),
)
GO


CREATE TABLE ImagenesTipos
(
	CodTipoImagen char(3) NOT NULL,
	Descripcion varchar(50) NOT NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_ImagenesTipos PRIMARY KEY (CodTipoImagen)
)
GO


CREATE TABLE JuegosImagenes
(
	CodDesarrollador char(3) NOT NULL,
	CodJuego char(3) NOT NULL,
	CodTipoImagen char(3) NOT NULL,
	Orden int NOT NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_JuegosImagenes PRIMARY KEY (CodDesarrollador,CodJuego, CodTipoImagen),
	CONSTRAINT FK_JuegosImagenes_Juegos
		FOREIGN KEY (CodDesarrollador,CodJuego) REFERENCES Juegos(CodDesarrollador,CodJuego),
	CONSTRAINT FK_JuegosImagenes_ImagenesTipos
		FOREIGN KEY (CodTipoImagen) REFERENCES ImagenesTipos(CodTipoImagen)
)
GO


CREATE TABLE JuegosXPlataformas
(
	CodDesarrollador char(3) NOT NULL,
	CodJuego char(3) NOT NULL,
	CodPlataforma char(3) NOT NULL,
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_JuegosXPlataformas PRIMARY KEY (CodDesarrollador,CodJuego,CodPlataforma),
	CONSTRAINT FK_JuegosXPlataformas_Juegos
		FOREIGN KEY (CodDesarrollador,CodJuego) REFERENCES Juegos(CodDesarrollador,CodJuego),
	CONSTRAINT FK_JuegosXPlataformas_Plataformas
		FOREIGN KEY (CodPlataforma) REFERENCES Plataformas (CodPlataforma)
)
GO


CREATE TABLE JuegosXCategorias
(
	CodDesarrollador char(3) NOT NULL,
	CodJuego char(3) NOT NULL,
	CodCategoria char(3) NOT NULL,
	CONSTRAINT PK_JuegosXCategorias PRIMARY KEY (CodDesarrollador,CodJuego,CodCategoria), 
	CONSTRAINT FK_JuegosXCategorias_Juegos
		FOREIGN KEY (CodDesarrollador,CodJuego) REFERENCES Juegos(CodDesarrollador,CodJuego),
	CONSTRAINT FK_JuegosXCategorias_Categorias
		FOREIGN KEY (CodCategoria) REFERENCES Categorias(CodCategoria)
)
GO


CREATE TABLE JuegosXTiendas
(
	CodDesarrollador char(3) NOT NULL,
	CodJuego char(3) NOT NULL,
	CodTienda char(3) NOT NULL,
	SitioWeb varchar(100) NOT NULL,
	Precio float NOT NULL CHECK (Precio>=0),
	PrecioRebajado float NULL CHECK (ISNULL(PrecioRebajado,0)>=0),
	Activo bit NOT NULL DEFAULT 1,
	CONSTRAINT PK_JuegosXTiendas PRIMARY KEY (CodDesarrollador,CodJuego,CodTienda),
	CONSTRAINT FK_JuegosXTiendas_Juegos
		FOREIGN KEY (CodDesarrollador,CodJuego) REFERENCES Juegos(CodDesarrollador,CodJuego),
	CONSTRAINT FK_JuegosXTiendas_Tiendas
		FOREIGN KEY (CodTienda) REFERENCES Tiendas(CodTienda)
)
GO

CREATE TABLE Deseados
(
	CodDesarrollador char(3) NOT NULL,
	CodJuego char(3) NOT NULL,
	IdUsuario int NOT NULL,
	CONSTRAINT PK_Deseados PRIMARY KEY (CodDesarrollador,CodJuego,IdUsuario),
	CONSTRAINT FK_Deseados_Juegos
		FOREIGN KEY (CodDesarrollador,CodJuego) REFERENCES Juegos(CodDesarrollador,CodJuego),
	CONSTRAINT FK_Deseados_Usuarios
		FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario)
)
GO

CREATE PROCEDURE SP_Usuarios_Agregar
(
@Usuario varchar(30),
@Contrasena varchar(50),
@Email varchar(50),
@Admin bit,
@Activo bit
)
AS
IF EXISTS(SELECT 1 FROM Usuarios WHERE @Usuario = Username)
BEGIN
PRINT 'Error. Ya existe el Usuario'
END
ELSE IF EXISTS(SELECT 1 FROM Usuarios WHERE @Email = Email)
BEGIN
PRINT 'Error. Ya existe el Email'
END
ELSE
BEGIN
INSERT INTO Usuarios
(
Username,
Contrasena,
Email,
Administrador,
Activo
)
VALUES(@Usuario, @Contrasena, @Email, @Admin, @Activo)
END
GO

CREATE PROCEDURE SP_Usuarios_Modificar
(
@Usuario varchar(30),
@NuevoUsuario varchar(30),
@Contrasena varchar(50),
@Email varchar(50),
@Admin bit,
@Activo bit
)
AS
IF EXISTS(SELECT 1 FROM Usuarios WHERE @NuevoUsuario = Username AND @NuevoUsuario <> @Usuario)
BEGIN
PRINT 'Error. Ya existe el Usuario'
END
ELSE IF EXISTS(SELECT 1 FROM Usuarios WHERE @Email = Email)
BEGIN
PRINT 'Error. Ya existe el Email'
END
ELSE
BEGIN
UPDATE Usuarios
SET 
Username=@NuevoUsuario,
Contrasena=@Contrasena,
Email=@Email,
Administrador=@Admin,
Activo=@Activo
END
GO


CREATE PROCEDURE SP_Plataforma_MostrarJuegos
(
@CodPlataforma char(3)
)
AS
BEGIN
SELECT Plataformas.CodPlataforma, Plataformas.Descripcion, Juegos.CodJuego, Juegos.NombreJuego FROM Juegos INNER JOIN JuegosXPlataformas
ON Juegos.CodJuego=JuegosXPlataformas.CodJuego
INNER JOIN Plataformas
ON JuegosXPlataformas.CodPlataforma=Plataformas.CodPlataforma
WHERE @CodPlataforma=Plataformas.CodPlataforma
END
GO


CREATE PROCEDURE SP_Opiniones_Usuario
(
@IdUsuario int
)
AS
BEGIN
SELECT Usuarios.IdUsuario, Usuarios.Username, Juegos.NombreJuego, Calificacion, Comentario FROM Usuarios INNER JOIN Opiniones
ON Usuarios.IdUsuario=Opiniones.IdUsuario
INNER JOIN Juegos
ON Opiniones.CodJuego=Juegos.CodJuego
WHERE Usuarios.IdUsuario=@IdUsuario
END
GO



CREATE PROCEDURE SP_Opiniones_Calificacion_Usuario
(
@Calificacion tinyint
)
AS
BEGIN
SELECT Usuarios.Username, Juegos.NombreJuego, Calificacion FROM Usuarios INNER JOIN Opiniones
ON Usuarios.IdUsuario=Opiniones.IdUsuario
INNER JOIN Juegos
ON Opiniones.CodJuego=Juegos.CodJuego
WHERE Opiniones.Calificacion=@Calificacion
END
GO


CREATE PROCEDURE SP_Categorias_Agregar
(
@Codcategoria char(3),
@Descripcion varchar(30),
@Activo bit
)
AS
BEGIN
INSERT INTO Categorias
(
CodCategoria,
Descripcion,
Activo
)
VALUES(@Codcategoria, @Descripcion, @Activo)
END
GO

EXEC SP_Categorias_Agregar 'C01','Accion', 1
GO

EXEC SP_Categorias_Agregar 'C02','Aventura', 1
GO

CREATE PROCEDURE SP_Juegos_BajaLogica
(
@CodJuego char(3)
)
AS
BEGIN
UPDATE Juegos
SET Activo=0
WHERE @CodJuego=CodJuego
END
GO


SELECT * FROM Juegos
WHERE Activo=1
GO

ALTER TRIGGER TR_Opiniones_Deseados
ON Usuarios AFTER UPDATE AS
IF ( UPDATE (Activo) )
BEGIN
SET NOCOUNT ON;
UPDATE Opiniones SET Activo=(SELECT Activo FROM inserted )
WHERE Opiniones.IdUsuario=(SELECT IdUsuario FROM inserted)
END
GO

CREATE TRIGGER TR_DELETE_JUEGO
ON Juegos AFTER DELETE AS
BEGIN
RAISERROR ('No está permitida la baja fisica para juegos!' , 16, 1) 
ROLLBACK TRANSACTION
END
GO

/*otra opcion*/
CREATE TRIGGER TR_DELETE_JUEGO2
ON Juegos INSTEAD OF DELETE AS
BEGIN
SET NOCOUNT ON;
UPDATE Juegos
 SET Activo = 0 WHERE CodJuego = (SELECT CodJuego FROM DELETED)
END
GO

CREATE PROCEDURE SP_Usuarios_Administrador
(
@Admin bit
)
AS
BEGIN
SELECT IdUsuario, Username, Administrador FROM Usuarios
WHERE Administrador=@Admin
END
GO

EXEC SP_Usuarios_Administrador 1
GO

EXEC SP_Usuarios_Administrador 0
GO

CREATE PROCEDURE SP_Usuarios_Activos
(
@Activo bit
)
AS
BEGIN
SELECT IdUsuario, Username, Activo FROM Usuarios
WHERE Activo=@Activo
END
GO

EXEC SP_Usuarios_Activos 1
GO

EXEC SP_Usuarios_Activos 0
GO

CREATE PROCEDURE SP_Usuarios_Administrador_Activo
(
@Admin bit,
@Activo bit
)
AS 
BEGIN
SELECT IdUsuario, Username, Administrador, Activo FROM Usuarios
WHERE Administrador=@Admin AND Activo=@Activo
END
GO

EXEC SP_Usuarios_Administrador_Activo 1,1
GO

EXEC SP_Usuarios_Administrador_Activo 1,0
GO

EXEC SP_Usuarios_Administrador_Activo 0,1
GO

EXEC SP_Usuarios_Administrador_Activo 0,0
GO

CREATE PROCEDURE SP_Categorias_Juegos
AS
BEGIN
SELECT Categorias.Descripcion, Juegos.NombreJuego, Desarrolladores.NombreDesarrollador FROM Categorias INNER JOIN JuegosXCategorias
ON Categorias.CodCategoria=JuegosXCategorias.CodCategoria
INNER JOIN Juegos
ON JuegosXCategorias.CodJuego=Juegos.CodJuego
INNER JOIN Desarrolladores
ON Juegos.CodDesarrollador=Desarrolladores.CodDesarrollador
ORDER BY Categorias.Descripcion
END
GO

EXEC SP_Categorias_Juegos
GO

CREATE PROCEDURE SP_Tiendas_BusquedaPrecio
(
@Precio float
)
AS
BEGIN
SELECT Precio, Juegos.NombreJuego, Tiendas.Descripcion, Tiendas.SitioWeb FROM Tiendas INNER JOIN JuegosXTiendas
ON Tiendas.CodTienda=JuegosXTiendas.CodTienda
INNER JOIN Juegos
ON JuegosXTiendas.CodJuego=Juegos.CodJuego
WHERE Precio<=@Precio
END
GO

CREATE TRIGGER TR_Plataforma_JuegosXPlataformas_Activo
ON Plataformas AFTER UPDATE AS
IF(UPDATE(Activo))
BEGIN
SET NOCOUNT ON;
UPDATE JuegosXPlataformas SET Activo=(SELECT Activo FROM inserted)
WHERE JuegosXPlataformas.CodPlataforma=(SELECT CodPlataforma FROM inserted)
END
GO