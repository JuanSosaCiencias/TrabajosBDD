-- Iniciamos creando todas las tablas para que no mande errores

CREATE TABLE IF NOT EXISTS Pais(
    NombrePais varchar(50) -- PK
);

COMMENT ON TABLE Pais IS 'Tabla que contiene los países participantes en los eventos.';
COMMENT ON COLUMN Pais.NombrePais IS 'Nombre del país que actúa como clave primaria.';

CREATE TABLE IF NOT EXISTS Medallero(
    IDMedallero serial, -- PK
    NombrePais varchar(50) -- FK
);

COMMENT ON TABLE Medallero IS 'Tabla que registra las medallas obtenidas por cada país.';
COMMENT ON COLUMN Medallero.IDMedallero IS 'ID único del medallero (PK).';
COMMENT ON COLUMN Medallero.NombrePais IS 'Nombre del país, FK de la tabla Pais.';

CREATE TABLE IF NOT EXISTS Concursa(
    IDAtleta int, -- FK
    IDEvento int -- FK
);

COMMENT ON TABLE Concursa IS 'Tabla que relaciona atletas con eventos en los que participan.';
COMMENT ON COLUMN Concursa.IDAtleta IS 'ID del atleta, FK de la tabla Atleta.';
COMMENT ON COLUMN Concursa.IDEvento IS 'ID del evento, FK de la tabla Evento.';

CREATE TABLE IF NOT EXISTS TelefonoAtleta(
    IDTelefono varchar(15), -- PK Compuesta
    IDAtleta int -- FK (PK Compuesta)
);

COMMENT ON TABLE TelefonoAtleta IS 'Almacena los números de teléfono de los atletas.';
COMMENT ON COLUMN TelefonoAtleta.IDTelefono IS 'Número de teléfono del atleta.';
COMMENT ON COLUMN TelefonoAtleta.IDAtleta IS 'ID del atleta y FK por parte de la tabla Atleta.';

CREATE TABLE IF NOT EXISTS CorreoAtleta(
    IDCorreo varchar(50), -- PK Compuesta
    IDAtleta int -- FK (PK Compuesta)
);

COMMENT ON TABLE CorreoAtleta IS 'Almacena los correos electrónicos de los atletas.';
COMMENT ON COLUMN CorreoAtleta.IDCorreo IS 'Dirección de correo electrónico del atleta.';
COMMENT ON COLUMN CorreoAtleta.IDAtleta IS 'ID del atleta, FK por parte de la tabla Atleta.';

CREATE TABLE IF NOT EXISTS Atleta(
    IDAtleta serial, -- PK
    NombrePais varchar(50), -- FK
    IDEntrenador int, -- FK
    Temporada date, 
    Nombre varchar(50),
    PrimerApellido varchar(50),
    SegundoApellido varchar(50),
    FechaNacimiento date,
    Nacionalidad varchar(50),
    Genero char(1) 
);

COMMENT ON TABLE Atleta IS 'Contiene la información de los atletas.';
COMMENT ON COLUMN Atleta.IDAtleta IS 'ID único del atleta (PK).';
COMMENT ON COLUMN Atleta.NombrePais IS 'Nombre del país, FK de la tabla Pais.';
COMMENT ON COLUMN Atleta.IDEntrenador IS 'ID del entrenador, FK de la tabla Entrenador.';
COMMENT ON COLUMN Atleta.Temporada IS 'Fecha de inicio de la temporada.';
COMMENT ON COLUMN Atleta.Nombre IS 'Nombre del atleta.';
COMMENT ON COLUMN Atleta.PrimerApellido IS 'Primer apellido del atleta.';
COMMENT ON COLUMN Atleta.SegundoApellido IS 'Segundo apellido del atleta.';
COMMENT ON COLUMN Atleta.FechaNacimiento IS 'Fecha de nacimiento del atleta.';
COMMENT ON COLUMN Atleta.Nacionalidad IS 'Nacionalidad del atleta.';
COMMENT ON COLUMN Atleta.Genero IS 'Género del atleta (M/F).';

CREATE TABLE IF NOT EXISTS Participa(
    IDAtleta int , -- FK
    IDDisciplina int  -- FK
);

COMMENT ON TABLE Participa IS 'Tabla que relaciona a los atletas con las disciplinas en las que participan.';
COMMENT ON COLUMN Participa.IDAtleta IS 'ID del atleta, por lo cual es FK por parte de la tabla Atleta.';
COMMENT ON COLUMN Participa.IDDisciplina IS 'ID de la disciplina, que tambien es FK pero por parte de la tabla Disciplina.';

CREATE TABLE IF NOT EXISTS Medalla(
    TipoMedalla varchar(10), -- PK Compuesta
    IDDisciplina int,  -- FK (PK Compuesta)
    IDAtleta int -- FK
);

COMMENT ON TABLE Medalla IS 'Tabla que registra las medallas ganadas por los atletas.';
COMMENT ON COLUMN Medalla.TipoMedalla IS 'Tipos de medalla (Oro, Plata, Bronce).';
COMMENT ON COLUMN Medalla.IDDisciplina IS 'ID de la disciplina, FK de la tabla Disciplina.';
COMMENT ON COLUMN Medalla.IDAtleta IS 'ID del atleta, FK por parte de la tabla Atleta.';

CREATE TABLE IF NOT EXISTS Evento(
    IDEvento serial, -- PK
    NombreLocalidad varchar(50), -- FK Compuesta
    IDDisciplina int, -- FK Compuesta
    DuracionMax int ,
    Precio int ,
    FechaEvento date,
    Fase int
);

COMMENT ON TABLE Evento IS 'Tabla que contiene información sobre los eventos deportivos.';
COMMENT ON COLUMN Evento.IDEvento IS 'ID único del evento (PK).';
COMMENT ON COLUMN Evento.NombreLocalidad IS 'Nombre de la localidad donde se realiza el evento, FK de la tabla Localidad.';
COMMENT ON COLUMN Evento.IDDisciplina IS 'ID de la disciplina, FK de la tabla Disciplina.';
COMMENT ON COLUMN Evento.DuracionMax IS 'Duración máxima del evento en minutos.';
COMMENT ON COLUMN Evento.Precio IS 'Precio de las entradas para el evento.';
COMMENT ON COLUMN Evento.FechaEvento IS 'Fecha en que se celebra el evento.';
COMMENT ON COLUMN Evento.Fase IS 'Fase del evento.';

CREATE TABLE IF NOT EXISTS TelefonoEntrenador(
    IDTelefono varchar(15), -- PK Compuesta
    IDEntrenador int -- FK (PK Compuesta)
);

COMMENT ON TABLE TelefonoEntrenador IS 'Almacena los números de teléfono de los entrenadores.';
COMMENT ON COLUMN TelefonoEntrenador.IDTelefono IS 'Número de teléfono del entrenador.';
COMMENT ON COLUMN TelefonoEntrenador.IDEntrenador IS 'ID del entrenador, FK por parte de la tabla Entrenador.';

CREATE TABLE IF NOT EXISTS Disciplina(
    IDDisciplina serial, -- PK
    NombreDisciplina varchar(50),  
    Categoria varchar(50)
);

COMMENT ON TABLE Disciplina IS 'Tabla que contiene las disciplinas deportivas disponibles.';
COMMENT ON COLUMN Disciplina.IDDisciplina IS 'ID único de la disciplina (PK).';
COMMENT ON COLUMN Disciplina.NombreDisciplina IS 'Nombre de la disciplina.';
COMMENT ON COLUMN Disciplina.Categoria IS 'Categoría de la disciplina (ej. individual, equipo).';

CREATE TABLE IF NOT EXISTS Localidad(
    NombreLocalidad varchar(50), -- PK Compuesta
    IDDisciplina int, -- FK (PK Compuesta)
    Calle varchar(50), 
    Numero int,
    Ciudad varchar(50),
    Pais varchar(50),
    Aforo int,
    Tipo int
);

COMMENT ON TABLE Localidad IS 'Tabla que contiene información sobre las localidades donde se celebran eventos.';
COMMENT ON COLUMN Localidad.NombreLocalidad IS 'Nombre de la localidad, que actúa como clave primaria.';
COMMENT ON COLUMN Localidad.IDDisciplina IS 'ID de la disciplina, FK de la tabla Disciplina.';
COMMENT ON COLUMN Localidad.Calle IS 'Nombre de la calle donde se encuentra la localidad.';
COMMENT ON COLUMN Localidad.Numero IS 'Número de la dirección de la localidad.';
COMMENT ON COLUMN Localidad.Ciudad IS 'Nombre de la ciudad donde se encuentra la localidad.';
COMMENT ON COLUMN Localidad.Pais IS 'Nombre del país donde se encuentra la localidad.';
COMMENT ON COLUMN Localidad.Aforo IS 'Capacidad máxima de personas en la localidad.';
COMMENT ON COLUMN Localidad.Tipo IS 'Tipo de localidad.';

CREATE TABLE IF NOT EXISTS CompraEntrada(
    IDCliente int, -- FK
    IDEvento int -- FK
);

COMMENT ON TABLE CompraEntrada IS 'Tabla que registra las compras de entradas por parte de los clientes.';
COMMENT ON COLUMN CompraEntrada.IDCliente IS 'ID del cliente, FK de la tabla Cliente.';
COMMENT ON COLUMN CompraEntrada.IDEvento IS 'ID del evento, FK de la tabla Evento.';

CREATE TABLE IF NOT EXISTS Cliente(
    IDCliente serial -- PK
);

COMMENT ON TABLE Cliente IS 'Tabla que contiene la información de los clientes que compran entradas.';
COMMENT ON COLUMN Cliente.IDCliente IS 'ID único del cliente (PK).';

CREATE TABLE IF NOT EXISTS CorreoEntrenador(
    IDCorreo varchar(50), -- PK Compuesta
    IDEntrenador int -- FK (PK Compuesta)
);

COMMENT ON TABLE CorreoEntrenador IS 'Tabla que almacena los correos electrónicos de los entrenadores.';
COMMENT ON COLUMN CorreoEntrenador.IDCorreo IS 'Dirección de correo electrónico del entrenador.';
COMMENT ON COLUMN CorreoEntrenador.IDEntrenador IS 'ID del entrenador, siendo FK por parte de la tabla Entrenador.';

CREATE TABLE IF NOT EXISTS Entrenador(
    IDEntrenador serial, -- PK
    IDDisciplina int, -- FK
    Nombre varchar(50),
    PrimerApellido varchar(50),
    SegundoApellido varchar(50),
    FechaNacimiento date,
    Nacionalidad varchar(50),
    Genero char(1)
);

COMMENT ON TABLE Entrenador IS 'Tabla que contiene la información de los entrenadores.';
COMMENT ON COLUMN Entrenador.IDEntrenador IS 'ID único del entrenador (PK).';
COMMENT ON COLUMN Entrenador.IDDisciplina IS 'ID de la disciplina, FK de la tabla Disciplina.';
COMMENT ON COLUMN Entrenador.Nombre IS 'Nombre del entrenador.';
COMMENT ON COLUMN Entrenador.PrimerApellido IS 'Primer apellido del entrenador.';
COMMENT ON COLUMN Entrenador.SegundoApellido IS 'Segundo apellido del entrenador.';
COMMENT ON COLUMN Entrenador.FechaNacimiento IS 'Fecha de nacimiento del entrenador.';
COMMENT ON COLUMN Entrenador.Nacionalidad IS 'Nacionalidad del entrenador.';
COMMENT ON COLUMN Entrenador.Genero IS 'Género del entrenador (M/F).';

CREATE TABLE IF NOT EXISTS TelefonoArbitro(
    IDTelefono varchar(15), -- PK Compuesta
    IDArbitro int -- FK (PK Compuesta)
);

COMMENT ON TABLE TelefonoArbitro IS 'Tabla para almacenar los teléfonos de los árbitros.';
COMMENT ON COLUMN TelefonoArbitro.IDTelefono IS 'Número de teléfono del árbitro.';
COMMENT ON COLUMN TelefonoArbitro.IDArbitro IS 'ID del árbitro asociado.';

CREATE TABLE IF NOT EXISTS Patrocina(
    NombrePatrocinador varchar(50), -- FK 
    IDDisciplina int -- FK
);

COMMENT ON TABLE Patrocina IS 'Tabla que relaciona patrocinadores con disciplinas.';
COMMENT ON COLUMN Patrocina.NombrePatrocinador IS 'Nombre del patrocinador.';
COMMENT ON COLUMN Patrocina.IDDisciplina IS 'ID de la disciplina patrocinada.';

CREATE TABLE IF NOT EXISTS Arbitro(
    IDArbitro serial, -- PK
    IDDisciplina int, -- FK
    Nombre varchar(50),
    PrimerApellido varchar(50),
    SegundoApellido varchar(50),
    FechaNacimiento date,
    Nacionalidad varchar(50),
    Genero char(1)
);

COMMENT ON TABLE Arbitro IS 'Tabla para almacenar la información de los árbitros.';
COMMENT ON COLUMN Arbitro.IDArbitro IS 'ID único del árbitro (PK).';
COMMENT ON COLUMN Arbitro.IDDisciplina IS 'ID de la disciplina en la que participa el árbitro.';
COMMENT ON COLUMN Arbitro.Nombre IS 'Nombre del árbitro.';
COMMENT ON COLUMN Arbitro.PrimerApellido IS 'Primer apellido del árbitro.';
COMMENT ON COLUMN Arbitro.SegundoApellido IS 'Segundo apellido del árbitro.';
COMMENT ON COLUMN Arbitro.FechaNacimiento IS 'Fecha de nacimiento del árbitro.';
COMMENT ON COLUMN Arbitro.Nacionalidad IS 'Nacionalidad del árbitro.';
COMMENT ON COLUMN Arbitro.Genero IS 'Género del árbitro (M/F).';

CREATE TABLE IF NOT EXISTS CorreoArbitro(
    IDCorreo varchar(50), -- PK Compuesta
    IDArbitro int -- FK (PK Compuesta)
);

COMMENT ON TABLE CorreoArbitro IS 'Almacena los correos electrónicos de los árbitros.';
COMMENT ON COLUMN CorreoArbitro.IDCorreo IS 'Correo electrónico del árbitro.';
COMMENT ON COLUMN CorreoArbitro.IDArbitro IS 'ID del árbitro asociado.';

CREATE TABLE IF NOT EXISTS Patrocinador(
    NombrePatrocinador varchar(50) -- PK
);

COMMENT ON TABLE Patrocinador IS 'Tabla para almacenar información de patrocinadores.';
COMMENT ON COLUMN Patrocinador.NombrePatrocinador IS 'Nombre del patrocinador (PK).';

-- Agregar reestricciones Primarias y otras (no foraneas)

alter table Pais
	add primary key (NombrePais);

COMMENT ON COLUMN Pais.NombrePais IS 'Es la llave primaria para identificar de manera única cada país';

ALTER TABLE Atleta
	ADD PRIMARY KEY (IDAtleta),
    ALTER COLUMN Temporada SET DEFAULT now(),
    ALTER COLUMN Nombre SET NOT NULL,
    ALTER COLUMN PrimerApellido SET DEFAULT 'No proporcionado',
    ALTER COLUMN SegundoApellido SET DEFAULT 'No proporcionado',
    ALTER COLUMN FechaNacimiento SET NOT NULL,
    ALTER COLUMN Nacionalidad SET DEFAULT 'No proporcionado',
    ALTER COLUMN Genero SET DEFAULT 0;

COMMENT ON COLUMN Atleta.IDAtleta IS 'PK del atleta'; 
COMMENT ON COLUMN Atleta.Temporada IS 'Se pone la fecha por defecto al crear un nuevo atleta en la temporada'; 
COMMENT ON COLUMN Atleta.Nombre IS 'Se pone que el nombre del atleta no pueda ser nulo';
COMMENT ON COLUMN Atleta.PrimerApellido IS 'El primer apellido por defecto sera "No proporcionado" si no se especifica el primer apellido';
COMMENT ON COLUMN Atleta.SegundoApellido IS 'El segundo apellido por defecto sera "No proporcionado" si no se especifica el segundo apellido';
COMMENT ON COLUMN Atleta.FechaNacimiento IS 'Fecha de nacimiento del atleta se pone como campo obligatorio';
COMMENT ON COLUMN Atleta.Nacionalidad IS 'La Nacionalidad del atleta es por defecto "No proporcionado"';
COMMENT ON COLUMN Atleta.Genero IS 'Género del atleta, restricción con valor por defecto 0 (sin especificar)';

alter table Evento 
	add primary key(IDEvento),
	alter column DuracionMax set not null,
	alter column Precio set not null,
	alter column FechaEvento set not null,
	alter column Fase set default 0;

COMMENT ON COLUMN Evento.IDEvento IS 'La PK del evento';
COMMENT ON COLUMN Evento.DuracionMax IS 'Duración máxima del evento, como campo obligatorio a manera de restriccion';
COMMENT ON COLUMN Evento.Precio IS 'Precio del evento, como campo obligatorio en forma de restriccion';
COMMENT ON COLUMN Evento.FechaEvento IS 'Fecha del evento, como campo obligatorio tambien';
COMMENT ON COLUMN Evento.Fase IS 'Fase del evento, valor por defecto es 0 (fase inicial)';

alter table Disciplina 
	add primary key (IDDisciplina),
	alter column NombreDisciplina set not null,
	alter column Categoria set not null;

COMMENT ON COLUMN Disciplina.IDDisciplina IS 'La PK de la disciplina';
COMMENT ON COLUMN Disciplina.NombreDisciplina IS 'Ponemos que el nombre de la disciplina no puede ser nulo';
COMMENT ON COLUMN Disciplina.Categoria IS 'La categoría de la disciplina no puede ser nula';

alter table Cliente 
	add primary key (IDCliente);

COMMENT ON COLUMN Cliente.IDCliente IS 'PK del cliente';

alter table Entrenador 
	add primary key (IDEntrenador),
	alter column Nombre set not null,
	alter column PrimerApellido set default 'No proporcionado',
	alter column SegundoApellido set default 'No proporcionado',
	alter column FechaNacimiento set not null,
	alter column Nacionalidad set default 'No proporcionado',
	alter column Genero set default 0;

COMMENT ON COLUMN Entrenador.IDEntrenador IS 'PK del entrenador';
COMMENT ON COLUMN Entrenador.Nombre IS 'Asignamos que el nombre del entrenador no puede ser nulo';
COMMENT ON COLUMN Entrenador.PrimerApellido IS 'Por defecto "No proporcionado" si no se especifica el primer apellido';
COMMENT ON COLUMN Entrenador.SegundoApellido IS 'Por defecto "No proporcionado" si no se especifica el segundo apellido';
COMMENT ON COLUMN Entrenador.FechaNacimiento IS 'Fecha de nacimiento del entrenador, la ponemos como campo obligatorio';
COMMENT ON COLUMN Entrenador.Nacionalidad IS 'La Nacionalidad del entrenador, por defecto "No proporcionado"';
COMMENT ON COLUMN Entrenador.Genero IS 'Género del entrenador, con valor por defecto 0 (sin especificar)';

alter table Arbitro 
	add primary key (IDArbitro),
	alter column Nombre set not null,
	alter column PrimerApellido set default 'No proporcionado',
	alter column SegundoApellido set default 'No proporcionado',
	alter column FechaNacimiento set not null,
	alter column Nacionalidad set default 'No proporcionado',
	alter column Genero set default 0;

COMMENT ON COLUMN Arbitro.IDArbitro IS 'PK del árbitro';
COMMENT ON COLUMN Arbitro.Nombre IS 'Definimos que el nombre del árbitro no puede ser nulo';
COMMENT ON COLUMN Arbitro.PrimerApellido IS 'Por defecto sera "No proporcionado" si no se especifica el primer apellido';
COMMENT ON COLUMN Arbitro.SegundoApellido IS 'Por defecto sera "No proporcionado" si no se especifica el segundo apellido';
COMMENT ON COLUMN Arbitro.FechaNacimiento IS 'Fecha de nacimiento del árbitro, campo obligatorio';
COMMENT ON COLUMN Arbitro.Nacionalidad IS 'Nacionalidad del árbitro, por defecto "No proporcionado"';
COMMENT ON COLUMN Arbitro.Genero IS 'Género del árbitro, con valor por defecto 0 (sin especificar)';

alter table Patrocinador 
	add primary key (NombrePatrocinador);

COMMENT ON COLUMN Patrocinador.NombrePatrocinador IS 'PK del patrocinador';

-- Definir llaves primarias compuestas

alter table Localidad 
	add primary key (NombreLocalidad), 
	alter column Calle set not null,
	alter column Numero set not null,
	alter column Ciudad set not null,
	alter column Pais set not null,
	alter column Aforo set not null,
	alter column Tipo set not null;

COMMENT ON COLUMN Localidad.NombreLocalidad IS 'PK de la localidad';
COMMENT ON COLUMN Localidad.Calle IS 'Calle de la localidad, como restricción de campo obligatorio';
COMMENT ON COLUMN Localidad.Numero IS 'Número de la localidad, como campo obligatorio';
COMMENT ON COLUMN Localidad.Ciudad IS 'Ciudad donde se encuentra la localidad, tambien como restricción de campo obligatorio';
COMMENT ON COLUMN Localidad.Pais IS 'País de la localidad, tambien campo obligatorio';
COMMENT ON COLUMN Localidad.Aforo IS 'Aforo máximo de la localidad, como campo obligatorio';
COMMENT ON COLUMN Localidad.Tipo IS 'Tipo de la localidad, tambien como campo obligatorio';

alter table Medallero
	add primary key (IDMedallero, NombrePais);

COMMENT ON COLUMN Medallero.IDMedallero IS 'PK del medallero';
COMMENT ON COLUMN Medallero.NombrePais IS 'País asociado al medallero forma parte de la llave primaria';

alter table TelefonoAtleta
	add primary key (IDTelefono, IDAtleta);

COMMENT ON COLUMN TelefonoAtleta.IDTelefono IS 'PK del teléfono del atleta';
COMMENT ON COLUMN TelefonoAtleta.IDAtleta IS 'Llave primaria del atleta, parte de la llave compuesta';

alter table CorreoAtleta 
	add primary key (IDCorreo, IDAtleta);

COMMENT ON COLUMN CorreoAtleta.IDCorreo IS 'Llave primaria del correo del atleta';
COMMENT ON COLUMN CorreoAtleta.IDAtleta IS 'PK del atleta, parte de la llave compuesta';

alter table Medalla 
	add primary key (TipoMedalla, IDDisciplina);

COMMENT ON COLUMN Medalla.TipoMedalla IS 'EL Tipo de medalla, forma parte de la llave primaria compuesta';
COMMENT ON COLUMN Medalla.IDDisciplina IS 'PK de la disciplina, parte de la llave compuesta';

alter table CorreoArbitro
	add primary key (IDCorreo, IDArbitro);

COMMENT ON COLUMN CorreoArbitro.IDCorreo IS 'Llave primaria del correo del árbitro';
COMMENT ON COLUMN CorreoArbitro.IDArbitro IS 'Llave primaria del árbitro, parte de la llave compuesta';

alter table TelefonoEntrenador 
	add primary key(IDTelefono, IDEntrenador);

COMMENT ON COLUMN TelefonoEntrenador.IDTelefono IS 'Llave primaria del teléfono del entrenador';
COMMENT ON COLUMN TelefonoEntrenador.IDEntrenador IS 'Llave primaria del entrenador forma parte de la llave compuesta';

alter table TelefonoArbitro 
	add primary key (IDTelefono, IDArbitro);

COMMENT ON COLUMN TelefonoArbitro.IDTelefono IS 'PK del teléfono del árbitro';
COMMENT ON COLUMN TelefonoArbitro.IDArbitro IS 'PK del árbitro forma parte de la llave compuesta';

alter table CorreoEntrenador 
	add primary key (IDCorreo, IDEntrenador);

COMMENT ON COLUMN CorreoEntrenador.IDCorreo IS 'PK del correo del entrenador';
COMMENT ON COLUMN CorreoEntrenador.IDEntrenador IS 'Llave primaria del entrenador formando parte de la llave compuesta';

-- Definir llaves foraneas que incluyan llaves primarias compuestas

ALTER TABLE Evento
ADD CONSTRAINT FK_Evento_Localidad_Disciplina 
FOREIGN KEY (IDDisciplina, NombreLocalidad) REFERENCES Localidad(IDDisciplina, NombreLocalidad) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Evento_Localidad_Disciplina ON Evento IS 'Llave foránea que relaciona eventos con localidades y disciplinas';

-- Definir llaves foráneas

ALTER TABLE Medallero
ADD CONSTRAINT FK_Medallero_Pais 
FOREIGN KEY (NombrePais) REFERENCES Pais(NombrePais) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Medallero_Pais ON Medallero IS 'Llave foránea que relaciona medalleros con países';

ALTER TABLE Concursa
ADD CONSTRAINT FK_Concursa_Atleta 
FOREIGN KEY (IDAtleta) REFERENCES Atleta(IDAtleta) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Concursa_Evento 
FOREIGN KEY (IDEvento) REFERENCES Evento(IDEvento) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Concursa_Atleta ON Concursa IS 'FK que referencia a Atleta(IDAtleta) para identificar al atleta.';
COMMENT ON CONSTRAINT FK_Concursa_Evento ON Concursa IS 'FK que referencia a Evento(IDEvento) para identificar el evento.';

ALTER TABLE TelefonoAtleta
ADD CONSTRAINT FK_TelefonoAtleta_Atleta 
FOREIGN KEY (IDAtleta) REFERENCES Atleta(IDAtleta) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_TelefonoAtleta_Atleta ON TelefonoAtleta IS 'FK que referencia a Atleta(IDAtleta) para los registros telefónicos del atleta.';

ALTER TABLE CorreoAtleta
ADD CONSTRAINT FK_CorreoAtleta_Atleta 
FOREIGN KEY (IDAtleta) REFERENCES Atleta(IDAtleta) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_CorreoAtleta_Atleta ON CorreoAtleta IS 'FK que referencia a Atleta(IDAtleta) para los registros de correo electrónico del atleta.';

ALTER TABLE Atleta
ADD CONSTRAINT FK_Atleta_Pais 
FOREIGN KEY (NombrePais) REFERENCES Pais(NombrePais) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Atleta_Entrenador 
FOREIGN KEY (IDEntrenador) REFERENCES Entrenador(IDEntrenador) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Atleta_Pais ON Atleta IS 'FK que referencia a Pais(NombrePais) para el país de origen del atleta.';
COMMENT ON CONSTRAINT FK_Atleta_Entrenador ON Atleta IS 'FK que referencia a Entrenador(IDEntrenador) para el entrenador del atleta.';

ALTER TABLE Participa
ADD CONSTRAINT FK_Participa_Atleta 
FOREIGN KEY (IDAtleta) REFERENCES Atleta(IDAtleta) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Participa_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Participa_Atleta ON Participa IS 'FK que referencia a Atleta(IDAtleta) para la participación del atleta.';
COMMENT ON CONSTRAINT FK_Participa_Disciplina ON Participa IS 'FK que referencia a Disciplina(IDDisciplina) para la disciplina en la que participa el atleta.';

ALTER TABLE Medalla
ADD CONSTRAINT FK_Medalla_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;
ADD CONSTRAINT FK_Medalla_Atleta 
FOREIGN KEY (IDAtleta) REFERENCES Atleta(IDAtleta) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Medalla_Disciplina ON Medalla IS 'FK que referencia a Disciplina(IDDisciplina) para la disciplina asociada con la medalla.';
COMMENT ON CONSTRAINT FK_Medalla_Atleta ON Medalla IS 'FK que referencia a Atleta(IDAtleta) para el atleta que recibe la medalla.';

ALTER TABLE TelefonoEntrenador
ADD CONSTRAINT FK_TelefonoEntrenador_Entrenador 
FOREIGN KEY (IDEntrenador) REFERENCES Entrenador(IDEntrenador) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_TelefonoEntrenador_Entrenador ON TelefonoEntrenador IS 'FK que referencia a Entrenador(IDEntrenador) para los registros telefónicos del entrenador.';

ALTER TABLE Localidad
ADD CONSTRAINT FK_Localidad_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Localidad_Disciplina ON Localidad IS 'FK que referencia a Disciplina(IDDisciplina) para la disciplina asociada con la localidad.';

ALTER TABLE CompraEntrada
ADD CONSTRAINT FK_CompraEntrada_Cliente 
FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_CompraEntrada_Evento 
FOREIGN KEY (IDEvento) REFERENCES Evento(IDEvento) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_CompraEntrada_Cliente ON CompraEntrada IS 'FK que referencia a Cliente(IDCliente) para las compras realizadas por el cliente.';
COMMENT ON CONSTRAINT FK_CompraEntrada_Evento ON CompraEntrada IS 'FK que referencia a Evento(IDEvento) para los eventos comprados por el cliente.';

ALTER TABLE CorreoEntrenador
ADD CONSTRAINT FK_CorreoEntrenador_Entrenador 
FOREIGN KEY (IDEntrenador) REFERENCES Entrenador(IDEntrenador) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_CorreoEntrenador_Entrenador ON CorreoEntrenador IS 'FK que referencia a Entrenador(IDEntrenador) para los registros de correo electrónico del entrenador.';

ALTER TABLE Entrenador
ADD CONSTRAINT FK_Entrenador_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Entrenador_Disciplina ON Entrenador IS 'FK que referencia a Disciplina(IDDisciplina) para la disciplina en la que se especializa el entrenador.';

ALTER TABLE TelefonoArbitro
ADD CONSTRAINT FK_TelefonoArbitro_Arbitro 
FOREIGN KEY (IDArbitro) REFERENCES Arbitro(IDArbitro) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_TelefonoArbitro_Arbitro ON TelefonoArbitro IS 'FK que referencia a Arbitro(IDArbitro) para los registros telefónicos del árbitro.';

ALTER TABLE Patrocina
ADD CONSTRAINT FK_Patrocina_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Patrocina_Patrocinador 
FOREIGN KEY (NombrePatrocinador) REFERENCES Patrocinador(NombrePatrocinador) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Patrocina_Disciplina ON Patrocina IS 'FK que referencia a Disciplina(IDDisciplina) para la disciplina patrocinada.';
COMMENT ON CONSTRAINT FK_Patrocina_Patrocinador ON Patrocina IS 'FK que referencia a Patrocinador(NombrePatrocinador) para el patrocinador de la disciplina.';

ALTER TABLE Arbitro
ADD CONSTRAINT FK_Arbitro_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_Arbitro_Disciplina ON Arbitro IS 'FK que referencia a Disciplina(IDDisciplina) para la disciplina asociada con el árbitro.';

ALTER TABLE CorreoArbitro
ADD CONSTRAINT FK_CorreoArbitro_Arbitro 
FOREIGN KEY (IDArbitro) REFERENCES Arbitro(IDArbitro) 
ON DELETE CASCADE ON UPDATE CASCADE;

COMMENT ON CONSTRAINT FK_CorreoArbitro_Arbitro ON CorreoArbitro IS 'FK que referencia a Arbitro(IDArbitro) para los registros de correo electrónico del árbitro.';