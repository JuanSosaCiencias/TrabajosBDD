
/* Consulta 1: Entrenadores y Atletas, que compartan el apellido y que se encuentren participando en la misma disciplina.
 * Deberan ordenar la información a partir del apellido paterno.
 * 
 * Estrategia: 
 * - Selecciono todo de atlteta
 * - Join con participa para conseguir los iddisciplina
 * - Ya con iddisciplinas de atleta joineamos con entrenadores que entrenen esa disciplina 
 * - Ahora checamos que compartan el primer o segundo apellido
 * - Finalmente ordenamos por el primer apellido
 * */
SELECT 
    atleta.*,
    entrenador.identrenador,
    entrenador.nombre AS entrenador_nombre,
    entrenador.primerapellido AS entrenador_primerapellido,
    entrenador.segundoapellido AS entrenador_segundoapellido,
    entrenador.iddisciplina
FROM 
    atleta
JOIN 
    participa ON atleta.idatleta = participa.idatleta
JOIN 
    entrenador ON entrenador.iddisciplina = participa.iddisciplina
WHERE 
    (entrenador.primerapellido = atleta.primerapellido 
     OR entrenador.segundoapellido = atleta.segundoapellido)
ORDER BY 
    atleta.primerapellido;


/* Consulta 2: Eventos con precio base mayor a 2500, ordenados por precio.
 * 
 * Estrategia:
 * - Usar la tabla Evento como base
 * - Join con Disciplina para obtener nombre de la disciplina
 * - Join con Localidad para obtener información del lugar
 * - Filtrar por precio > 2500
 * - Ordenar por precio de mayor a menor
 * */

 SELECT 
    e.IDEvento,
    e.NombreLocalidad,
    d.NombreDisciplina,
    e.Precio,
    e.DuracionMax as "Duración (minutos)",
    e.FechaEvento,
    e.Fase,
    l.Ciudad,
    l.Pais
FROM 
    Evento e NATURAL JOIN Disciplina d NATURAL JOIN Localidad l 
WHERE 
    e.Precio > 2500
ORDER BY 
    e.Precio DESC;

/* Consulta 3: Atletas que participan en más de una disciplina.
 * 
 * Estrategia:
 * - Usar la tabla Atleta como base
 * - Join con la tabla Participa para obtener las disciplinas
 * - Agrupar por atleta para contar disciplinas distintas
 * - Filtrar solo los que tienen más de una disciplina
 * */

 SELECT 
    a.IDAtleta,
    a.Nombre,
    a.PrimerApellido,
    a.SegundoApellido,
    COUNT(p.IDDisciplina) as NumDisciplinas
FROM 
    Atleta a NATURAL JOIN Participa p
GROUP BY 
    a.IDAtleta, a.Nombre, a.PrimerApellido, a.SegundoApellido
HAVING 
    COUNT(p.IDDisciplina) > 1;
    


/* Consulta 10: La información de todos los atletas que hayan ganado alguna medalla. Asi como un conteo de las medallas
 * de oro, plata y bronce que ganaron. La información debera ser ordenada con respecto a las medallas, es
 * decir primero oro, despues plata y al final bronce.
 * 
 * Estrategia:
 * - Seleccionar la información de los atletas
 * - Hacer un join con medalla para conseguir atletas que tengan medallas
 * - Agrupamos todas las medallas que haya conseguido cada atleta
 * - Diferenciamos entre oro plata y bronce, las contamos y les ponemos nombres
 * - Finalmente ordenamos por el conteo que hicimos arriba de manera descendiente y primero checamos oro luego plata 
 * y al final bronce
 * */
SELECT 
    atleta.*,
    COUNT(CASE WHEN medalla.tipomedalla = 'oro' THEN 1 END) AS conteo_oro,
    COUNT(CASE WHEN medalla.tipomedalla = 'plata' THEN 1 END) AS conteo_plata,
    COUNT(CASE WHEN medalla.tipomedalla = 'bronce' THEN 1 END) AS conteo_bronce
FROM 
    atleta
JOIN 
    medalla ON atleta.idatleta = medalla.idatleta
GROUP BY 
    atleta.idatleta
ORDER BY 
    COUNT(CASE WHEN medalla.tipomedalla = 'oro' THEN 1 END) DESC,
    COUNT(CASE WHEN medalla.tipomedalla = 'plata' THEN 1 END) DESC,
    COUNT(CASE WHEN medalla.tipomedalla = 'bronce' THEN 1 END) DESC;
   


 






   


