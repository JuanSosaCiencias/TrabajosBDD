from django.urls import path
from .views import DisciplinaAPIView, DisciplinaApiId

urlpatterns = [
    path('disciplina/', DisciplinaAPIView.as_view()),
    path('disciplinaId/', DisciplinaApiId.as_view()),
]