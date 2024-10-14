-- Iniciamos creando todas las tablas para que no mande errores

CREATE TABLE IF NOT EXISTS Pais(
    NombrePais varchar(50)
);

CREATE TABLE IF NOT EXISTS Medallero(
    IDMedallero serial,
    NombrePais varchar(50) -- FK
);

CREATE TABLE IF NOT EXISTS Gana(
    NombrePais varchar(50), -- FK
    TipoMedalla varchar(10), -- FK
    IDDisciplina int -- FK
);

CREATE TABLE IF NOT EXISTS Concursa(
    IDAtleta int, -- FK
    IDEvento int -- FK
);

CREATE TABLE IF NOT EXISTS TelefonoAtleta(
    IDTelefono varchar(15),
    IDAtleta int -- FK
);

CREATE TABLE IF NOT EXISTS CorreoAtleta(
    IDCorreo varchar(50),
    IDAtleta int -- FK
);

CREATE TABLE IF NOT EXISTS Atleta(
    IDAtleta serial,
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

CREATE TABLE IF NOT EXISTS Participa(
    IDAtleta int , -- FK
    IDDisciplina int  -- FK
);

CREATE TABLE IF NOT EXISTS Medalla(
    TipoMedalla varchar(10),
    IDDisciplina int  -- FK
);

CREATE TABLE IF NOT EXISTS Evento(
    IDEvento serial,
    NombreLocalidad varchar(50), -- FK
    IDDisciplina int, -- FK
    DuracionMax int ,
    Precio int ,
    FechaEvento date,
    Fase int
);

CREATE TABLE IF NOT EXISTS TelefonoEntrenador(
    IDTelefono varchar(15),
    IDEntrenador int -- FK
);

CREATE TABLE IF NOT EXISTS Disciplina(
    IDDisciplina serial,
    NombreDisciplina varchar(50), 
    Categoria varchar(50)
);

CREATE TABLE IF NOT EXISTS Localidad(
    NombreLocalidad varchar(50),
    IDDisciplina int, -- FK
    Calle varchar(50), 
    Numero int,
    Ciudad varchar(50),
    Pais varchar(50),
    Aforo int,
    Tipo int
);

CREATE TABLE IF NOT EXISTS CompraEntrada(
    IDCliente int, -- FK
    IDEvento int -- FK
);

CREATE TABLE IF NOT EXISTS Cliente(
    IDCliente serial
);

CREATE TABLE IF NOT EXISTS CorreoEntrenador(
    IDCorreo varchar(50),
    IDEntrenador int -- FK
);

CREATE TABLE IF NOT EXISTS Entrenador(
    IDEntrenador serial,
    IDDisciplina int, -- FK
    Nombre varchar(50),
    PrimerApellido varchar(50),
    SegundoApellido varchar(50),
    FechaNacimiento date,
    Nacionalidad varchar(50),
    Genero char(1)
);

CREATE TABLE IF NOT EXISTS TelefonoArbitro(
    IDTelefono varchar(15),
    IDArbitro int -- FK
);

CREATE TABLE IF NOT EXISTS Patrocina(
    NombrePatrocinador varchar(50), -- FK
    IDDisciplina int -- FK
);

CREATE TABLE IF NOT EXISTS Arbitro(
    IDArbitro serial,
    IDDisciplina int, -- FK
    Nombre varchar(50),
    PrimerApellido varchar(50),
    SegundoApellido varchar(50),
    FechaNacimiento date,
    Nacionalidad varchar(50),
    Genero char(1)
);

CREATE TABLE IF NOT EXISTS CorreoArbitro(
    IDCorreo varchar(50),
    IDArbitro int -- FK
);

CREATE TABLE IF NOT EXISTS Patrocinador(
    NombrePatrocinador varchar(50)
);

-- Agregar reestricciones Primarias y otras (no foraneas)

alter table Pais
	add primary key (NombrePais);

ALTER TABLE Atleta
	ADD PRIMARY KEY (IDAtleta),
    ALTER COLUMN Temporada SET DEFAULT now(),
    ALTER COLUMN Nombre SET NOT NULL,
    ALTER COLUMN PrimerApellido SET DEFAULT 'No proporcionado',
    ALTER COLUMN SegundoApellido SET DEFAULT 'No proporcionado',
    ALTER COLUMN FechaNacimiento SET NOT NULL,
    ALTER COLUMN Nacionalidad SET DEFAULT 'No proporcionado',
    ALTER COLUMN Genero SET DEFAULT 0;

alter table Evento 
	add primary key(IDEvento),
	alter column DuracionMax set not null,
	alter column Precio set not null,
	alter column FechaEvento set not null,
	alter column Fase set default 0;

alter table Disciplina 
	add primary key (IDDisciplina),
	alter column NombreDisciplina set not null,
	alter column Categoria set not null;
	
alter table Localidad 
	add primary key (NombreLocalidad, IDDisciplina), -- Tecnicamente compuesta pero la dejo aca
	alter column Calle set not null,
	alter column Numero set not null,
	alter column Ciudad set not null,
	alter column Pais set not null,
	alter column Aforo set not null,
	alter column Tipo set not null;

alter table Cliente 
	add primary key (IDCliente);

alter table Entrenador 
	add primary key (IDEntrenador),
	alter column Nombre set not null,
	alter column PrimerApellido set default 'No proporcionado',
	alter column SegundoApellido set default 'No proporcionado',
	alter column FechaNacimiento set not null,
	alter column Nacionalidad set default 'No proporcionado',
	alter column Genero set default 0;

alter table Arbitro 
	add primary key (IDArbitro),
	alter column Nombre set not null,
	alter column PrimerApellido set default 'No proporcionado',
	alter column SegundoApellido set default 'No proporcionado',
	alter column FechaNacimiento set not null,
	alter column Nacionalidad set default 'No proporcionado',
	alter column Genero set default 0;

alter table Patrocinador 
	add primary key (NombrePatrocinador);

-- Definir llaves primarias compuestas

alter table Medallero
	add primary key (IDMedallero, NombrePais);

alter table TelefonoAtleta
	add primary key (IDTelefono, IDAtleta);

alter table CorreoAtleta 
	add primary key (IDCorreo, IDAtleta);

alter table Medalla 
	add primary key (TipoMedalla, IDDisciplina);

alter table CorreoArbitro
	add primary key (IDCorreo, IDArbitro);

alter table TelefonoEntrenador 
	add primary key(IDTelefono, IDEntrenador);

alter table TelefonoArbitro 
	add primary key (IDTelefono, IDArbitro);

alter table CorreoEntrenador 
	add primary key (IDCorreo, IDEntrenador);

-- Definir llaves foraneas que incluyan llaves primarias compuestas

ALTER TABLE Gana
ADD CONSTRAINT FK_Gana_Pais 
FOREIGN KEY (NombrePais) REFERENCES Pais(NombrePais) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Gana_Medalla 
FOREIGN KEY (TipoMedalla, IDDisciplina) REFERENCES Medalla(TipoMedalla, IDDisciplina)  -- Esta es la llave compuesta
ON DELETE ON UPDATE CASCADE;

ALTER TABLE Evento
ADD CONSTRAINT FK_Evento_Localidad_Disciplina 
FOREIGN KEY (IDDisciplina, NombreLocalidad) REFERENCES Localidad(IDDisciplina, NombreLocalidad) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- Definir llaves foráneas

ALTER TABLE Medallero
ADD CONSTRAINT FK_Medallero_Pais 
FOREIGN KEY (NombrePais) REFERENCES Pais(NombrePais) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Concursa
ADD CONSTRAINT FK_Concursa_Atleta 
FOREIGN KEY (IDAtleta) REFERENCES Atleta(IDAtleta) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Concursa_Evento 
FOREIGN KEY (IDEvento) REFERENCES Evento(IDEvento) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE TelefonoAtleta
ADD CONSTRAINT FK_TelefonoAtleta_Atleta 
FOREIGN KEY (IDAtleta) REFERENCES Atleta(IDAtleta) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE CorreoAtleta
ADD CONSTRAINT FK_CorreoAtleta_Atleta 
FOREIGN KEY (IDAtleta) REFERENCES Atleta(IDAtleta) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Atleta
ADD CONSTRAINT FK_Atleta_Pais 
FOREIGN KEY (NombrePais) REFERENCES Pais(NombrePais) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Atleta_Entrenador 
FOREIGN KEY (IDEntrenador) REFERENCES Entrenador(IDEntrenador) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Participa
ADD CONSTRAINT FK_Participa_Atleta 
FOREIGN KEY (IDAtleta) REFERENCES Atleta(IDAtleta) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Participa_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Medalla
ADD CONSTRAINT FK_Medalla_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE TelefonoEntrenador
ADD CONSTRAINT FK_TelefonoEntrenador_Entrenador 
FOREIGN KEY (IDEntrenador) REFERENCES Entrenador(IDEntrenador) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Localidad
ADD CONSTRAINT FK_Localidad_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE CompraEntrada
ADD CONSTRAINT FK_CompraEntrada_Cliente 
FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_CompraEntrada_Evento 
FOREIGN KEY (IDEvento) REFERENCES Evento(IDEvento) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE CorreoEntrenador
ADD CONSTRAINT FK_CorreoEntrenador_Entrenador 
FOREIGN KEY (IDEntrenador) REFERENCES Entrenador(IDEntrenador) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Entrenador
ADD CONSTRAINT FK_Entrenador_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE TelefonoArbitro
ADD CONSTRAINT FK_TelefonoArbitro_Arbitro 
FOREIGN KEY (IDArbitro) REFERENCES Arbitro(IDArbitro) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Patrocina
ADD CONSTRAINT FK_Patrocina_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Patrocina_Patrocinador 
FOREIGN KEY (NombrePatrocinador) REFERENCES Patrocinador(NombrePatrocinador) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Arbitro
ADD CONSTRAINT FK_Arbitro_Disciplina 
FOREIGN KEY (IDDisciplina) REFERENCES Disciplina(IDDisciplina) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE CorreoArbitro
ADD CONSTRAINT FK_CorreoArbitro_Arbitro 
FOREIGN KEY (IDArbitro) REFERENCES Arbitro(IDArbitro) 
ON DELETE CASCADE ON UPDATE CASCADE;
