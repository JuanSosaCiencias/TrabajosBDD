
/* Consulta 1: Entrenadores y Atletas, que compartan el apellido y que se encuentren participando en la misma disciplina.
Deberan ordenar la información a partir del apellido paterno.
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
 






   


