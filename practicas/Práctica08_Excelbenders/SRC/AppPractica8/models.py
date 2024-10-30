from django.db import models

class Disciplina(models.Model):
    """
    Modelo para representar una disciplina deportiva.

    Atributos:
        iddisciplina (AutoField): Clave primaria de la disciplina.
        nombredisciplina (CharField): Nombre de la disciplina.
        categoria (CharField): Categoría de la disciplina.
    """
    iddisciplina = models.AutoField(primary_key=True)
    nombredisciplina = models.CharField(max_length=50)
    categoria = models.CharField(max_length=50)

    class Meta:
        db_table = 'disciplina'
        ordering = ['nombredisciplina']

    def __str__(self):
        """
        Representación en cadena del modelo Disciplina.
        
        :return: Cadena con el id y nombre de la disciplina.
        """
        return f"{self.iddisciplina} - {self.nombredisciplina}" 

class Arbitro(models.Model):
    """
    Modelo que representa un árbitro.

    Atributos:
        idarbitro (AutoField): Clave primaria del árbitro.
        iddisciplina (ForeignKey): Relación con la disciplina a la que pertenece el árbitro.
        nombre (CharField): Nombre del árbitro.
        primerapellido (CharField): Primer apellido del árbitro.
        segundoapellido (CharField): Segundo apellido del árbitro.
        fechanacimiento (DateField): Fecha de nacimiento del árbitro.
        nacionalidad (CharField): Nacionalidad del árbitro.
        genero (CharField): Género del árbitro ('M' para masculino, 'F' para femenino, etc.).
    """
    idarbitro = models.AutoField(primary_key=True)
    iddisciplina = models.ForeignKey(Disciplina, on_delete=models.CASCADE, related_name='arbitros', db_column='iddisciplina')
    nombre = models.CharField(max_length=50)
    primerapellido = models.CharField(max_length=50)
    segundoapellido = models.CharField(max_length=50)
    fechanacimiento = models.DateField()
    nacionalidad = models.CharField(max_length=50)
    genero = models.CharField(max_length=1)
    
    class Meta:
        db_table = 'arbitro'
        ordering = ['nombre']


    def __str__(self):
        return f"{self.idarbitro} - {self.nombre}"