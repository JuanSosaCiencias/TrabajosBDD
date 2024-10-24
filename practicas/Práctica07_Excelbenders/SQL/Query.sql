SELECT	Atleta.Nombre
FROM	Atleta
WHERE	Atleta.Nombre LIKE 'R%';

SELECT Entrenador.FechaNacimiento 
FROM Entrenador 
WHERE EXTRACT(MONTH FROM fecha_nacimiento) = 6;

SELECT Evento.FechaEvento
FROM Evento
WHERE BETWEEN '2024-01-01' AND '2024-04-14';

SELECT Localidad.NombreLocalidad
FROM Localidad
WHERE Localidad.Aforo > 400 