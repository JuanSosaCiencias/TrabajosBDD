
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Disciplina, Arbitro
from .serializers import DisciplinaSerializer, ArbitroSerializer

def home(request):
    """
    Renderiza la página de inicio.

    Args:
        request (HttpRequest): La solicitud HTTP.

    Returns:
        HttpResponse: La respuesta HTTP con el contenido de la página de inicio.
    """
    return render(request, 'home.html')
    

class DisciplinaAPIView(APIView):
    """
    Vista basada en clases para manejar las operaciones CRUD de Disciplina.
    """

    def get(self, request):

        """
        Método GET para obtener todas las disciplinas.

        Args:
            request (Request): La solicitud HTTP.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos de las disciplinas.
        """

        serializer = DisciplinaSerializer(Disciplina.objects.all(), many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)
    
    def post(self, request):

        """
        Método POST para crear una nueva disciplina.

        Args:
            request (Request): La solicitud HTTP con los datos de la nueva disciplina.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos de la disciplina creada.
        """

        serializer = DisciplinaSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_201_CREATED, data=serializer.data)
    
    def put(self, request):

        """
        Método PUT para actualizar una disciplina existente.

        Args:
            request (Request): La solicitud HTTP con los datos actualizados de la disciplina.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos de la disciplina actualizada.
        """

        disciplinas = Disciplina.objects.filter(iddisciplina=request.data.get('iddisciplina'))

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
    
    def patch(self, request):
        
        """
        Método PATCH para actualizar parcialmente una disciplina existente.

        Args:
            request (Request): La solicitud HTTP con los datos parcialmente actualizados de la disciplina.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos de la disciplina actualizada parcialmente.
        """

        disciplinas = Disciplina.objects.filter(iddisciplina=request.data.get('iddisciplina'))

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
    
    
    def head(self, request):
        """
        Método HEAD para obtener los metadatos de la solicitud.

        Args:
            request (Request): La solicitud HTTP.

        Returns:
            Response: Una respuesta HTTP con el estado de la solicitud.
        """
        return Response(status=status.HTTP_200_OK)

class DisciplinaApiId(APIView):

    """
    Vista basada en clases para manejar la obtención de una disciplina específica por iddisciplina.
    """
    
    def get(self, request):
        """
        Método GET para obtener una disciplina específica por iddisciplina.

        Args:
            request (Request): La solicitud HTTP con el id de la disciplina en los parámetros de consulta.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos de la disciplina.
        """
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
        """
        Método DELETE para eliminar una disciplina específica por iddisciplina.

        Args:
            request (Request): La solicitud HTTP con el id de la disciplina en los parámetros de consulta.

        Returns:
            Response: Una respuesta HTTP con el estado de la eliminación.
        """
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
    
    

class ArbitroAPIView(APIView):
    """
    Vista basada en clases para manejar las operaciones CRUD de Arbitro.
    """
    def get(self, request):
        """
        Método GET para obtener todos los árbitros.

        Args:
            request (Request): La solicitud HTTP.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos de los árbitros.
        """
        serializer = ArbitroSerializer(Arbitro.objects.all(), many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)
    
    def post(self, request):
        
        """
        Método POST para crear un nuevo árbitro.

        Args:
            request (Request): La solicitud HTTP con los datos del nuevo árbitro.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos del árbitro creado.
        """

        serializer = ArbitroSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_201_CREATED, data=serializer.data)
    
    def put(self, request):

        """
        Método PUT para actualizar un árbitro existente.

        Args:
            request (Request): La solicitud HTTP con los datos actualizados del árbitro.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos del árbitro actualizado.
        """

        arbitros = Arbitro.objects.filter(idarbitro=request.data.get['idarbitro'])
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

        """
        Método PATCH para actualizar parcialmente un árbitro existente.

        Args:
            request (Request): La solicitud HTTP con los datos parcialmente actualizados del árbitro.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos del árbitro actualizado parcialmente.
        """
        
        idarbitro = request.data.get('idarbitro')
        arbitros = Arbitro.objects.filter(idarbitro=idarbitro)
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
            {"detail": "Arbitro actualizado parcialmente con éxito.", "data": serializer.data},
            status=status.HTTP_200_OK
        )
    
    # Método DELETE para eliminar una disciplina existente
    
    
    
    def head(self, request):
        """
        Método HEAD para obtener los metadatos de la solicitud.

        Args:
            request (Request): La solicitud HTTP.

        Returns:
            Response: Una respuesta HTTP con el estado de la solicitud.
        """
        return Response(status=status.HTTP_200_OK)

class ArbitroApiId(APIView):
    
    """
    Vista basada en clases para manejar la obtención de un árbitro específico por idarbitro.
    """
    
    def get(self, request):

        """
        Método GET para obtener un árbitro específico por idarbitro.

        Args:
            request (Request): La solicitud HTTP con el id del árbitro en los parámetros de consulta.

        Returns:
            Response: Una respuesta HTTP con el estado y los datos del árbitro.
        """

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
    
    def delete(self, request):

        """
        Método DELETE para eliminar un árbitro específico por idarbitro.

        Args:
            request (Request): La solicitud HTTP con el id del árbitro en los parámetros de consulta.

        Returns:
            Response: Una respuesta HTTP con el estado de la eliminación.
        """
        
        idarbitro = request.query_params.get('idarbitro')
        if not idarbitro:
            return Response(
                {"detail": "El parámetro 'idarbitro' es requerido."},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        arbitro = Arbitro.objects.filter(idarbitro=idarbitro).first()
        if not arbitro:
            return Response(
                {"detail": "Disciplina no encontrada."},
                status=status.HTTP_404_NOT_FOUND
            )
        
        arbitro.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
