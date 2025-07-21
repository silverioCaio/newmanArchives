@echo off
setlocal enabledelayedexpansion

REM --- --- --- --- --- CONFIGURAÇÃO --- --- --- --- ---
set "ARQUIVO_COLLECTION=transacional.postman_collection.json"
set "ARQUIVO_ENVIRONMENT=dev.postman_environment.json"

REM Mova o índice para a raiz para que seja a página principal
set "PASTA_RAIZ_RELATORIOS=newman"
set "ARQUIVO_INDICE=index.html"
set "BRANCH_PRINCIPAL=master"

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
(echo ^<a href="./newman/%TIMESTAMP%/index.html"^>Relatorio de %TIMESTAMP%^</a^>^<br^>) >> "%ARQUIVO_INDICE%"

echo.
echo *** Parte 2: Publicando no GitHub... ***
echo.

git config user.name "silverioCaio (Automated Commit)"
git config user.email "caio.silverio@aditum.com.br"

echo Sincronizando com o repositorio remoto...
git pull origin %BRANCH_PRINCIPAL%

echo Adicionando todos os arquivos...
git add .

echo Fazendo o commit...
git commit -m "Publica relatorio de teste gerado em %TIMESTAMP%"

echo Enviando para o GitHub...
git push origin %BRANCH_PRINCIPAL%

if !errorlevel! neq 0 (
    echo.
    echo !! ERRO !! Falha ao publicar no GitHub.
) else (
    echo.
    echo SUCESSO! Publicacao enviada. Acesse: https://silverioCaio.github.io/newmanArchives/ em alguns minutos.
)

:finalizar
echo.
echo *** Script Finalizado ***
pause