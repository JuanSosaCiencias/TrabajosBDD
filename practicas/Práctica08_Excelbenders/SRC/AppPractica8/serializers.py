from rest_framework import serializers
from .models import Disciplina, Arbitro

class DisciplinaSerializer(serializers.ModelSerializer):
    """
    Serializador para el modelo Disciplina.

    Este serializador convierte instancias del modelo Disciplina en representaciones JSON y viceversa.
    También se puede utilizar para validar los datos entrantes cuando se crean o actualizan instancias de Disciplina.
    """

    class Meta:
        model = Disciplina
        fields = '__all__' # Incluye todos los campos del modelo en la serialización.

class ArbitroSerializer(serializers.ModelSerializer):
    """
    Serializador para el modelo Arbitro.

    Este serializador convierte instancias del modelo Arbitro en representaciones JSON y viceversa.
    También se puede utilizar para validar los datos entrantes cuando se crean o actualizan instancias de Arbitro.
    """
    class Meta:
        model = Arbitro
        fields = '__all__' 

