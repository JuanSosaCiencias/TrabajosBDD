SELECT	*
FROM	Atleta
WHERE	Atleta.Nombre LIKE 'R%';

SELECT *
FROM Entrenador 
WHERE EXTRACT(MONTH FROM FechaNacimiento) = 6;

SELECT *
FROM Evento
WHERE FechaEvento BETWEEN '2024-01-01' AND '2024-04-14';

SELECT *
FROM Localidad
WHERE Aforo > 400 

SELECT *
FROM Patrocinador
