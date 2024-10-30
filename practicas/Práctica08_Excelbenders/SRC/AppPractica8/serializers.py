from rest_framework import serializers
from .models import Disciplina, Arbitro

class DisciplinaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Disciplina
        fields = '__all__' # modidficar para agregar validaciones

class ArbitroSerializer(serializers.ModelSerializer):
    class Meta:
        model = Arbitro
        fields = '__all__' # modidficar para agregar validaciones

