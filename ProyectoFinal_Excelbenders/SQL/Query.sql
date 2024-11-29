/* Consulta 1: Cantidad de atletas registrados por disciplina.
 * 
 * Esta consulta obtiene el número de atletas que participan en cada disciplina.
 * 
 * - Selecciona el nombre de la disciplina y cuenta el número de atletas que participan en ella.
 * - Agrupa los resultados por el nombre de la disciplina.
 * - Ordena los resultados por la cantidad de atletas en orden descendente.
 */
SELECT 
    d.NombreDisciplina,
    COUNT(p.IDAtleta) AS CantidadAtletas
FROM 
    Disciplina d
JOIN 
    Participa p ON d.IDDisciplina = p.IDDisciplina
GROUP BY 
    d.NombreDisciplina
ORDER BY 
    CantidadAtletas DESC;

/* Consulta 2: Cantidad de asistentes y ganancias por disciplina y localidad.
 * 
 * Esta consulta obtiene la cantidad de asistentes y las ganancias totales por disciplina y localidad.
 * 
 * - Selecciona el nombre de la disciplina, el nombre de la localidad, la suma de los precios de las entradas y la cantidad de asistentes.
 * - Agrupa los resultados por el nombre de la disciplina y el nombre de la localidad.
 * - Ordena los resultados por la cantidad de asistentes en orden descendente.
 */
SELECT 
    d.NombreDisciplina,
    l.NombreLocalidad,
    SUM(e.Precio) AS GananciasTotales,
    COUNT(ce.IDCliente) AS CantidadAsistentes
FROM 
    Evento e
JOIN 
    Disciplina d ON e.IDDisciplina = d.IDDisciplina
JOIN 
    Localidad l ON e.NombreLocalidad = l.NombreLocalidad AND e.IDDisciplina = l.IDDisciplina
JOIN 
    CompraEntrada ce ON e.IDEvento = ce.IDEvento
GROUP BY 
    d.NombreDisciplina, l.NombreLocalidad
ORDER BY 
    CantidadAsistentes DESC;

/* Consulta 3: Atletas que ganaron más medallas por disciplina y tipo de medalla.
 * 
 * Esta consulta obtiene los atletas que han ganado más medallas, desglosadas por disciplina y tipo de medalla.
 * 
 * - Selecciona la información del atleta, el nombre de la disciplina, el tipo de medalla y la cantidad de medallas ganadas.
 * - Agrupa los resultados por el atleta, la disciplina y el tipo de medalla.
 * - Ordena los resultados por el tipo de medalla (Oro, Plata, Bronce) y la cantidad de medallas en orden descendente.
 */
SELECT 
    a.IDAtleta,
    a.Nombre,
    a.PrimerApellido,
    a.SegundoApellido,
    d.NombreDisciplina,
    m.TipoMedalla,
    COUNT(m.TipoMedalla) AS CantidadMedallas
FROM 
    Medalla m
JOIN 
    Atleta a ON m.IDAtleta = a.IDAtleta
JOIN 
    Disciplina d ON m.IDDisciplina = d.IDDisciplina
GROUP BY 
    a.IDAtleta, a.Nombre, a.PrimerApellido, a.SegundoApellido, d.NombreDisciplina, m.TipoMedalla
ORDER BY 
    CASE 
        WHEN m.TipoMedalla = 'Oro' THEN 1
        WHEN m.TipoMedalla = 'Plata' THEN 2
        WHEN m.TipoMedalla = 'Bronce' THEN 3
    END,
    CantidadMedallas DESC;

/* Consulta 4: Países que han ganado más medallas por disciplina.
 * 
 * Esta consulta obtiene los países que han ganado más medallas, desglosadas por disciplina.
 * 
 * - Selecciona el nombre del país, el nombre de la disciplina y la cantidad de medallas ganadas.
 * - Agrupa los resultados por el país y la disciplina.
 * - Ordena los resultados por la cantidad de medallas en orden descendente.
 */
SELECT 
    p.NombrePais,
    d.NombreDisciplina,
    COUNT(m.TipoMedalla) AS CantidadMedallas
FROM 
    Medalla m
JOIN 
    Atleta a ON m.IDAtleta = a.IDAtleta
JOIN 
    Disciplina d ON m.IDDisciplina = d.IDDisciplina
JOIN 
    Pais p ON a.NombrePais = p.NombrePais
GROUP BY 
    p.NombrePais, d.NombreDisciplina
ORDER BY 
    CantidadMedallas DESC;

/* Consulta 5: Atletas que tienen a su cargo cada entrenador.
 * 
 * Esta consulta obtiene la cantidad de atletas que tiene a su cargo cada entrenador.
 * 
 * - Selecciona la información del entrenador y cuenta la cantidad de atletas que tiene a su cargo.
 * - Agrupa los resultados por el entrenador.
 * - Ordena los resultados por la cantidad de atletas en orden descendente.
 */
SELECT 
    e.IDEntrenador,
    e.Nombre AS NombreEntrenador,
    e.PrimerApellido AS PrimerApellidoEntrenador,
    e.SegundoApellido AS SegundoApellidoEntrenador,
    COUNT(a.IDAtleta) AS CantidadAtletas
FROM 
    Entrenador e
JOIN 
    Atleta a ON e.IDEntrenador = a.IDEntrenador
GROUP BY 
    e.IDEntrenador, e.Nombre, e.PrimerApellido, e.SegundoApellido
ORDER BY 
    CantidadAtletas DESC;

/* Consulta 6: Ganancias totales por cada competencia celebrada.
 * 
 * Esta consulta obtiene las ganancias totales por cada competencia celebrada.
 * 
 * - Selecciona el ID del evento, el nombre de la localidad, el ID de la disciplina y la suma de los precios de las entradas.
 * - Agrupa los resultados por el ID del evento, el nombre de la localidad y el ID de la disciplina.
 * - Ordena los resultados por las ganancias totales en orden descendente.
 */
SELECT 
    e.IDEvento,
    e.NombreLocalidad,
    e.IDDisciplina,
    SUM(e.Precio) AS GananciasTotales
FROM 
    Evento e
JOIN 
    CompraEntrada ce ON e.IDEvento = ce.IDEvento
GROUP BY 
    e.IDEvento, e.NombreLocalidad, e.IDDisciplina
ORDER BY 
    GananciasTotales DESC;

/* Consulta 7: Cantidad de medallas ganadas por cada país.
 * 
 * Esta consulta obtiene la cantidad de medallas ganadas por cada país, desglosadas por tipo de medalla.
 * 
 * - Selecciona el nombre del país, el tipo de medalla y cuenta la cantidad de medallas ganadas.
 * - Agrupa los resultados por el país y el tipo de medalla.
 * - Ordena los resultados por el nombre del país y el tipo de medalla.
 */
   
SELECT 
    p.NombrePais,
    m.TipoMedalla,
    COUNT(m.TipoMedalla) AS CantidadMedallas
FROM 
    Medalla m
JOIN 
    Atleta a ON m.IDAtleta = a.IDAtleta
JOIN 
    Pais p ON a.NombrePais = p.NombrePais
GROUP BY 
    p.NombrePais, m.TipoMedalla
ORDER BY 
    p.NombrePais, m.TipoMedalla;

/* Consulta 8: Países que han ganado más medallas.
 * 
 * Esta consulta obtiene los países que han ganado más medallas, ordenados de mayor a menor.
 * 
 * - Selecciona el nombre del país y cuenta la cantidad de medallas ganadas.
 * - Agrupa los resultados por el país.
 * - Ordena los resultados por la cantidad de medallas en orden descendente.
 * - IMPORTANTE: No confundir el país con más medallas ganadas con el país Medallero.
 */
SELECT 
    p.NombrePais,
    COUNT(m.TipoMedalla) AS CantidadMedallas
FROM 
    Medalla m
JOIN 
    Atleta a ON m.IDAtleta = a.IDAtleta
JOIN 
    Pais p ON a.NombrePais = p.NombrePais
GROUP BY 
    p.NombrePais
ORDER BY 
    CantidadMedallas DESC;
   
/* Consulta 9: Porcentaje de aforo utilizado en las localidades
 * 
 * Esta consulta muestra las entradas vendidas por evento  y calcula su porcentaje de aforo utilizado con respecto a ese dato y el aforo de
 * la localidad donde se realizó el evento.
 * 
 * - Une las tablas `Evento`, `CompraEntrada` y `Localidad` para relacionar los eventos con las localidades y las entradas vendidas.
 * - Calcula el porcentaje de aforo utilizado en cada localidad dividiendo el total de entradas vendidas entre el aforo de la localidad.
 * - Ordena los resultados de mayor a menor porcentaje de aforo utilizado.
 */
SELECT 
    Localidad.NombreLocalidad, 
    Localidad.Aforo, 
    COUNT(CompraEntrada.IDEvento) AS EntradasVendidas,
    ROUND((COUNT(CompraEntrada.IDEvento) * 100.0 / Localidad.Aforo), 2) AS PorcentajeAforoUtilizado
FROM 
    Evento
JOIN 
    Localidad ON Evento.NombreLocalidad = Localidad.NombreLocalidad
JOIN 
    CompraEntrada ON Evento.IDEvento = CompraEntrada.IDEvento
GROUP BY 
    Localidad.NombreLocalidad, 
    Localidad.Aforo
ORDER BY 
    PorcentajeAforoUtilizado DESC;

   
/* Consulta 10: Patrocinadores más activos. 
 * 
 * Esta consulta lista los patrocinadores que están asociados con más disciplinas.
 * 
 * - Agrupa los registros de la tabla `Patrocina` por el nombre del patrocinador.
 * - Cuenta cuántas disciplinas ha patrocinado cada patrocinador.
 * - Ordena los resultados de mayor a menor cantidad de disciplinas patrocinadas.
 */
SELECT 
    Patrocina.NombrePatrocinador, 
    COUNT(*) AS DisciplinasPatrocinadas
FROM 
    Patrocina
GROUP BY 
    Patrocina.NombrePatrocinador
ORDER BY 
    DisciplinasPatrocinadas DESC;
   
    
/* Consulta 11: Promedio de edad por disciplina.
 * 
 * Esta consulta calcula el promedio de edad de los atletas por cada disciplina, ordenados alfabéticamente.
 * 
 * - Selecciona el nombre de la disciplina y calcula el promedio de la edad de los atletas.
 * - Agrupa los resultados por disciplina.
 * - Ordena los resultados alfabéticamente por el nombre de la disciplina.
 */
SELECT 
    d.NombreDisciplina,
    AVG(extract(year from evento.fechaevento) - extract(year from a.FechaNacimiento)) AS PromedioEdad
FROM 
     Evento, Disciplina d
JOIN 
    Participa p ON d.IDDisciplina = p.IDDisciplina
JOIN 
    Atleta a ON p.IDAtleta = a.IDAtleta
GROUP BY 
    d.NombreDisciplina
ORDER BY 
    d.NombreDisciplina;
   

/* Consulta 12: Árbitros asignados por disciplina y su nacionalidad.
 * 
 * Esta consulta muestra los árbitros que están asignados a cada disciplina junto con su nacionalidad.
 * 
 * - Selecciona el nombre de la disciplina, el nombre completo del árbitro y su nacionalidad.
 * - Agrupa los resultados por disciplina y árbitro.
 * - Ordena los resultados por disciplina y nacionalidad.
 */
SELECT 
    d.NombreDisciplina,
    ar.Nombre AS NombreArbitro,
    ar.PrimerApellido,
    ar.segundoapellido,
    ar.Nacionalidad
FROM 
    Disciplina d
JOIN 
    Arbitro ar ON d.IDDisciplina = ar.IDDisciplina
ORDER BY 
    d.NombreDisciplina, ar.Nacionalidad;

   
/* Consulta 13: Entradas vendidas por disciplina en un rango de fechas.
 * 
 * Esta consulta calcula cuántas entradas se han vendido por disciplina en un rango específico de fechas.
 * 
 * - Selecciona el nombre de la disciplina y la cantidad de entradas vendidas.
 * - Filtra los eventos por la fecha en que ocurrieron.
 * - Agrupa los resultados por disciplina.
 * - Ordena los resultados por la cantidad de entradas vendidas.
 */
SELECT 
    d.NombreDisciplina,
    COUNT(ce.idcliente) AS EntradasVendidas
FROM 
    Evento e
JOIN 
    CompraEntrada ce ON e.IDEvento = ce.IDEvento
JOIN 
    Disciplina d ON e.IDDisciplina = d.IDDisciplina
WHERE 
    e.FechaEvento BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
    d.NombreDisciplina
ORDER BY 
    EntradasVendidas DESC;
   
   
/* Consulta 14: Relación entre atletas y sus países de origen.
 * 
 * Esta consulta obtiene la cantidad de atletas de cada país que participan en cada disciplina.
 * 
 * - Selecciona el nombre del país, el nombre de la disciplina y la cantidad de atletas.
 * - Agrupa los resultados por país y disciplina.
 * - Ordena los resultados por país y disciplina.
 */
SELECT 
    p.NombrePais,
    d.NombreDisciplina,
    COUNT(a.IDAtleta) AS CantidadAtletas
FROM 
    Atleta a
JOIN 
    Pais p ON a.NombrePais = p.NombrePais
JOIN 
    Participa pa ON a.IDAtleta = pa.IDAtleta
JOIN 
    Disciplina d ON pa.IDDisciplina = d.IDDisciplina
GROUP BY 
    p.NombrePais, d.NombreDisciplina
ORDER BY 
    p.NombrePais, d.NombreDisciplina;
   
/* Consulta 15: Número de atletas por cada país.
 * 
 * Esta consulta obtiene el número de atletas registrados por cada país.
 * 
 * - Selecciona el nombre del país y cuenta la cantidad de atletas registrados en ese país.
 * - Agrupa los resultados por el nombre del país.
 * - Ordena los resultados por la cantidad de atletas en orden descendente.
 */
SELECT 
    p.NombrePais,
    COUNT(a.IDAtleta) AS NumeroAtletas
FROM 
    Pais p
JOIN 
    Atleta a ON p.NombrePais = a.NombrePais
GROUP BY 
    p.NombrePais
ORDER BY 
    NumeroAtletas DESC;



/* Consulta Extra:
*
* Esta consulta es para cumplir el requerimiento del Caso de Uso para saber el medallero 
* de los Juegos Olímpicos. 
*
* Esta consulta NO genera los 30 resultados.
*
* La consulta agrupa los resultados por el país (a.NombrePais), calculando la cantidad de 
* medallas de cada tipo (oro, plata, bronce).
* Se ordena primero por el número de medallas de oro en orden descendente.
* En caso de empate, se usa el número de medallas de plata.
* Si aún hay empate, se considera el número de medallas de bronce.
*/
SELECT 
    a.NombrePais AS Pais,
    COALESCE(SUM(CASE WHEN m.TipoMedalla = 'Oro' THEN 1 ELSE 0 END), 0) AS MedallasOro,
    COALESCE(SUM(CASE WHEN m.TipoMedalla = 'Plata' THEN 1 ELSE 0 END), 0) AS MedallasPlata,
    COALESCE(SUM(CASE WHEN m.TipoMedalla = 'Bronce' THEN 1 ELSE 0 END), 0) AS MedallasBronce,
    COALESCE(SUM(CASE WHEN m.TipoMedalla IN ('Oro', 'Plata', 'Bronce') THEN 1 ELSE 0 END), 0) AS TotalMedallas
FROM 
    Atleta a
LEFT JOIN 
    Medalla m ON a.IDAtleta = m.IDAtleta
GROUP BY 
    a.NombrePais
ORDER BY 
    MedallasOro DESC, 
    MedallasPlata DESC, 
    MedallasBronce DESC
LIMIT 1;
