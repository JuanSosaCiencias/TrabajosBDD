from django.urls import path
from .views import DisciplinaAPIView, DisciplinaApiId, ArbitroAPIView, ArbitroApiId

urlpatterns = [
    path('disciplina/', DisciplinaAPIView.as_view()),
    path('disciplinaId/', DisciplinaApiId.as_view()),

    path('arbitro/', ArbitroAPIView.as_view()),
    path('arbitroId/', ArbitroApiId.as_view()),
]