from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Disciplina, Arbitro
from .serializers import DisciplinaSerializer, ArbitroSerializer

# Create your views here.
class DisciplinaAPIView(APIView):
    
    def get(self, request):
        serializer = DisciplinaSerializer(Disciplina.objects.all(), many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)
    
    # Metodos de insercion 

    def post(self, request):
        serializer = DisciplinaSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_201_CREATED, data=serializer.data)
    
    def put(self, request):
        try:
            disciplina = Disciplina.objects.get(iddisciplina=request.data['iddisciplina'])
        except Disciplina.DoesNotExist:
            return Response(
                {"detail": "Disciplina no encontrada."},
                status=status.HTTP_404_NOT_FOUND
            )
        serializer = DisciplinaSerializer(disciplina, data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(
            {"detail": "Disciplina actualizada con éxito.", "data": serializer.data},
            status=status.HTTP_200_OK
        )
    
    def delete(self, request):
        a = Disciplina.objects.filter(iddisciplina=request.data['iddisciplina']).delete()
        return Response(status=status.HTTP_200_OK, data=a)
 
class DisciplinaApiId(APIView):
    def get(self, request):
        iddisciplina = request.query_params.get('iddisciplina')
        if not iddisciplina:
            return Response(
                {"detail": "El parámetro 'iddisciplina' es requerido."},
                status=status.HTTP_400_BAD_REQUEST
            )
        try:
            disciplina = Disciplina.objects.get(iddisciplina=iddisciplina)
        except Disciplina.DoesNotExist:
            return Response(
                {"detail": "Disciplina no encontrada."},
                status=status.HTTP_404_NOT_FOUND
            )
        serializer = DisciplinaSerializer(disciplina)
        return Response(status=status.HTTP_200_OK, data=serializer.data)