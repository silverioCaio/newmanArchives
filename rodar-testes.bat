@echo off
setlocal enabledelayedexpansion

REM --- --- --- --- --- CONFIGURAÇÃO --- --- --- --- ---
set "ARQUIVO_COLLECTION=transacional.postman_collection.json"
set "ARQUIVO_ENVIRONMENT=dev.postman_environment.json"

set "PASTA_RAIZ_RELATORIOS=newman"
REM [ALTERAÇÃO 1] O índice agora é na raiz
set "ARQUIVO_INDICE=index.html"

REM --- INÍCIO DA EXECUÇÃO ---
echo *** Parte 1: Gerando Relatorio... ***
echo.

FOR /F "tokens=1 skip=1" %%A IN ('wmic os get localdatetime') DO (
  SET "timestamp_bruto=%%A"
  goto :timestamp_ok
)
:timestamp_ok
SET "TIMESTAMP=%timestamp_bruto:~0,8%_%timestamp_bruto:~8,6%"
SET "PASTA_RELATORIO_ATUAL=%PASTA_RAIZ_RELATORIOS%\%TIMESTAMP%"

newman run "%ARQUIVO_COLLECTION%" -e "%ARQUIVO_ENVIRONMENT%" -r cli,htmlextra --reporter-htmlextra-export "%PASTA_RELATORIO_ATUAL%/index.html" --reporter-htmlextra-title "Relatorio de %TIMESTAMP%"

if not exist "%PASTA_RELATORIO_ATUAL%\index.html" (
    echo ERRO: O relatorio do Newman nao foi gerado.
    goto :finalizar
)

echo Atualizando o arquivo de indice '%ARQUIVO_INDICE%'...
REM [ALTERAÇÃO 2] O link no href precisa apontar para a pasta newman
(echo ^<a href="./newman/%TIMESTAMP%/index.html"^>Relatorio de Teste - %TIMESTAMP%^</a^>^<br^>) >> "%ARQUIVO_INDICE%"
echo.
echo Relatorio gerado e indice atualizado com sucesso.

:finalizar
echo.
echo *** Script de Geração Finalizado. Execute o script de publicação para enviar ao GitHub. ***
pause