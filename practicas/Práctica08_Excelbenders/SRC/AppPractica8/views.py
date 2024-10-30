from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Disciplina, Arbitro
from .serializers import DisciplinaSerializer, ArbitroSerializer

def home(request):
    return render(request, 'home.html')

# Vista basada en clases para manejar las operaciones CRUD de Disciplina
class DisciplinaAPIView(APIView):
    
    # Método GET para obtener todas las disciplinas
    def get(self, request):
        serializer = DisciplinaSerializer(Disciplina.objects.all(), many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)
    
    # Método POST para crear una nueva disciplina
    def post(self, request):
        serializer = DisciplinaSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_201_CREATED, data=serializer.data)
    
    # Método PUT para actualizar una disciplina existente
    def put(self, request):
        disciplinas = Disciplina.objects.filter(iddisciplina=request.data['iddisciplina'])
        if not disciplinas.exists():
            return Response(
                {"detail": "Disciplina no encontrada."},
                status=status.HTTP_404_NOT_FOUND
            )
        disciplina = disciplinas.first()
        serializer = DisciplinaSerializer(disciplina, data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_200_OK, data=serializer.data)
    
    # Método PATCH para actualizar parcialmente una disciplina existente
    def patch(self, request):
        disciplinas = Disciplina.objects.filter(iddisciplina=request.data['iddisciplina'])
        if not disciplinas.exists():
            return Response(
                {"detail": "Disciplina no encontrada."},
                status=status.HTTP_404_NOT_FOUND
            )
        disciplina = disciplinas.first()
        serializer = DisciplinaSerializer(disciplina, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(
            {"detail": "Disciplina actualizada parcialmente, con éxito.", "data": serializer.data},
            status=status.HTTP_200_OK
        )
    
    
    # Método HEAD para obtener los metadatos de la solicitud
    def head(self, request):
        return Response(status=status.HTTP_200_OK)

# Vista basada en clases para manejar la obtención de una disciplina específica por iddisciplina
class DisciplinaApiId(APIView):
    
    # Método GET para obtener una disciplina específica por iddisciplina
    def get(self, request):
        iddisciplina = request.query_params.get('iddisciplina')
        if not iddisciplina:
            return Response(
                {"detail": "El parámetro 'iddisciplina' es requerido."},
                status=status.HTTP_400_BAD_REQUEST
            )
        disciplinas = Disciplina.objects.filter(iddisciplina=iddisciplina)
        if not disciplinas.exists():
            return Response(
                {"detail": "Disciplina no encontrada."},
                status=status.HTTP_404_NOT_FOUND
            )
        disciplina = disciplinas.first()
        serializer = DisciplinaSerializer(disciplina)
        return Response(status=status.HTTP_200_OK, data=serializer.data)
    
    def delete(self, request):
        iddisciplina = request.query_params.get('iddisciplina')
        if not iddisciplina:
            return Response(
                {"detail": "El parámetro 'iddisciplina' es requerido."},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        disciplina = Disciplina.objects.filter(iddisciplina=iddisciplina).first()
        if not disciplina:
            return Response(
                {"detail": "Disciplina no encontrada."},
                status=status.HTTP_404_NOT_FOUND
            )
        
        disciplina.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
    
    

########  ########  ########  ########  ######## Vistas para Arbitro ######## ########  ########  ########  ########

class ArbitroAPIView(APIView):
    def get(self, request):
        serializer = ArbitroSerializer(Arbitro.objects.all(), many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)
    
    def post(self, request):
        serializer = ArbitroSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_201_CREATED, data=serializer.data)
    
    def put(self, request):
        arbitros = Arbitro.objects.filter(idarbitro=request.data['idarbitro'])
        if not arbitros.exists():
            return Response(
                {"detail": "Arbitro no encontrado."},
                status=status.HTTP_404_NOT_FOUND
            )
        arbitro = arbitros.first()
        serializer = ArbitroSerializer(arbitro, data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_200_OK, data=serializer.data)
    
    def patch(self, request):
        arbitros = Arbitro.objects.filter(idarbitro=request.data['idabitro'])
        if not arbitros.exists():
            return Response(
                {"detail": "Arbitro no encontrado."},
                status=status.HTTP_404_NOT_FOUND
            )
        arbitro = arbitros.first()
        serializer = ArbitroSerializer(arbitro, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(
            {"detail": "Arbitro actualizado parcialmente, con éxito.", "data": serializer.data},
            status=status.HTTP_200_OK
        )
    
    # Método DELETE para eliminar una disciplina existente
    
    
    # Método HEAD para obtener los metadatos de la solicitud
    def head(self, request):
        return Response(status=status.HTTP_200_OK)

class ArbitroApiId(APIView):
    
    def get(self, request):
        idarbitro = request.query_params.get('idarbitro')
        if not idarbitro:
            return Response(
                {"detail": "El parámetro 'idarbitro' es requerido."},
                status=status.HTTP_400_BAD_REQUEST
            )
        arbitros = Arbitro.objects.filter(idarbitro=idarbitro)
        if not arbitros.exists():
            return Response(
                {"detail": "Arbitro no encontrado."},
                status=status.HTTP_404_NOT_FOUND
            )
        arbitro = arbitros.first()
        serializer = ArbitroSerializer(arbitro)
        return Response(status=status.HTTP_200_OK, data=serializer.data)