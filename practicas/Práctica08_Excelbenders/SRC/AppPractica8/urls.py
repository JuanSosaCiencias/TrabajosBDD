from django.urls import path
from .views import *

urlpatterns = [
    path('disciplina/', DisciplinaAPIView.as_view(), name='disciplina'),
    path('disciplinaId/', DisciplinaApiId.as_view(), name='disciplina_id'),
    path('disciplinaId/', DisciplinaApiId.as_view(), name='disciplina_delete'),

    path('arbitro/', ArbitroAPIView.as_view(), name='arbitro'),
    path('arbitroId/', ArbitroApiId.as_view(), name='arbitro_id'),

    path('', home, name='home'),
]