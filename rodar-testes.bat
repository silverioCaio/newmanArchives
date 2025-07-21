@echo off
setlocal enabledelayedexpansion

REM --- Configuração ---
set "ARQUIVO_COLLECTION=transacional.postman_collection.json"
set "ARQUIVO_ENVIRONMENT=dev.postman_environment.json"

set "PASTA_RAIZ_RELATORIOS=newman"
REM >>>>> [MUDANÇA ESSENCIAL 1] <<<<<
REM O índice agora será criado na raiz do projeto, não dentro de 'newman'
set "ARQUIVO_INDICE=index.html"

REM --- Início ---
echo *** Gerando Relatorio de Teste ***

FOR /F "tokens=1 skip=1" %%A IN ('wmic os get localdatetime') DO (
  SET "timestamp_bruto=%%A"
  goto :timestamp_ok
)
:timestamp_ok
SET "TIMESTAMP=%timestamp_bruto:~0,8%_%timestamp_bruto:~8,6%"
SET "PASTA_RELATORIO_ATUAL=%PASTA_RAIZ_RELATORIOS%\%TIMESTAMP%"

newman run "%ARQUIVO_COLLECTION%" -e "%ARQUIVO_ENVIRONMENT%" -r cli,htmlextra --reporter-htmlextra-export "%PASTA_RELATORIO_ATUAL%/index.html" --reporter-htmlextra-title "Relatorio de %TIMESTAMP%"
if not exist "%PASTA_RELATORIO_ATUAL%/index.html" (
    echo ERRO: O relatorio nao foi gerado.
    goto :finalizar
)

echo Atualizando o arquivo de indice '%ARQUIVO_INDICE%'...
REM >>>>> [MUDANÇA ESSENCIAL 2] <<<<<
REM O link (href) agora precisa incluir o caminho 'newman/'
(echo ^<h3^> ^<a href="./newman/%TIMESTAMP%/index.html" target="_blank"^>Relatorio de Teste - %TIMESTAMP%^</a^> ^</h3^>) >> "%ARQUIVO_INDICE%"
echo Relatorio gerado e indice atualizado.

:finalizar
echo.
echo *** Script de Geração Finalizado. Execute o script de publicação. ***
pause