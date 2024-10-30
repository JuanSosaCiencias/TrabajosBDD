from django.db import models

class Disciplina(models.Model):
    """
    Modelo que representa una disciplina.

    Attributes:
        iddisciplina (AutoField): El identificador único de la disciplina.
        nombredisciplina (CharField): El nombre de la disciplina.
        categoria (CharField): La categoría de la disciplina.
    """
    iddisciplina = models.AutoField(primary_key=True)
    nombredisciplina = models.CharField(max_length=50)
    categoria = models.CharField(max_length=50)

    class Meta:
        db_table = 'disciplina'
        ordering = ['nombredisciplina']

    def __str__(self):
        """
        Devuelve una representación en cadena del objeto Disciplina.

        Returns:
            str: Una cadena que representa la disciplina.
        """
        return f"{self.iddisciplina} - {self.nombredisciplina}" 

class Arbitro(models.Model):
    """
    Modelo que representa un árbitro.

    Attributes:
        idarbitro (AutoField): El identificador único del árbitro.
        iddisciplina (ForeignKey): La disciplina a la que pertenece el árbitro.
        nombre (CharField): El nombre del árbitro.
        primerapellido (CharField): El primer apellido del árbitro.
        segundoapellido (CharField): El segundo apellido del árbitro.
        fechanacimiento (DateField): La fecha de nacimiento del árbitro.
        nacionalidad (CharField): La nacionalidad del árbitro.
        genero (CharField): El género del árbitro.
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
        """
        Devuelve una representación en cadena del objeto Arbitro.

        Returns:
            str: Una cadena que representa el árbitro.
        """
        return f"{self.idarbitro} - {self.nombre}"