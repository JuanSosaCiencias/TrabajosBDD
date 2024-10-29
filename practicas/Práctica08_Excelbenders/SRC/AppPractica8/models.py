from django.db import models

class Disciplina(models.Model):
    iddisciplina = models.AutoField(primary_key=True)
    nombredisciplina = models.CharField(max_length=50)
    categoria = models.CharField(max_length=50)

    class Meta:
        db_table = 'disciplina'
        ordering = ['nombredisciplina']

    def __str__(self):
        return f"{self.iddisciplina} - {self.nombredisciplina}" 

class Arbitro(models.Model):
    idarbitro = models.AutoField(primary_key=True)
    iddisciplina = models.ForeignKey(Disciplina, on_delete=models.CASCADE, related_name='arbitros')
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