@echo off
setlocal enabledelayedexpansion

REM --- --- --- --- --- CONFIGURAÇÃO --- --- --- --- ---
set "ARQUIVO_COLLECTION=transacional.postman_collection.json"
set "ARQUIVO_ENVIRONMENT=dev.postman_environment.json"

set "PASTA_RAIZ_RELATORIOS=newman"
set "ARQUIVO_INDICE=%PASTA_RAIZ_RELATORIOS%\index.html"

REM AJUSTE AQUI para o nome do seu branch principal: 'master' ou 'main'
set "BRANCH_PRINCIPAL=master"

REM --- INÍCIO DA EXECUÇÃO ---
echo *** Iniciando Script de Geração e Publicação de Relatório ***
echo.

REM --- Captura de Timestamp ---
FOR /F "tokens=1 skip=1" %%A IN ('wmic os get localdatetime') DO (
  SET "timestamp_bruto=%%A"
  goto :timestamp_ok
)
:timestamp_ok
SET "TIMESTAMP=%timestamp_bruto:~0,8%_%timestamp_bruto:~8,6%"
SET "PASTA_RELATORIO_ATUAL=%PASTA_RAIZ_RELATORIOS%\%TIMESTAMP%"

REM --- PASSO 1: Execução do Newman ---
echo Gerando relatorio na pasta: %PASTA_RELATORIO_ATUAL%
newman run "%ARQUIVO_COLLECTION%" -e "%ARQUIVO_ENVIRONMENT%" -r cli,htmlextra --reporter-htmlextra-export "%PASTA_RELATORIO_ATUAL%/index.html" --reporter-htmlextra-title "Relatorio de %TIMESTAMP%"

if not exist "%PASTA_RELATORIO_ATUAL%\index.html" (
    echo ERRO: O relatorio do Newman nao foi gerado.
    goto :finalizar
)

REM --- PASSO 2: Atualização do Índice de Relatórios ---
echo Atualizando o arquivo de indice: %ARQUIVO_INDICE%
(
    echo ^<a href="./newman/%TIMESTAMP%/index.html"^>Relatorio de %TIMESTAMP%^</a^>^<br^>
) >> "%ARQUIVO_INDICE%"

echo.
echo Relatorio gerado e indice atualizado com sucesso.

REM --- PASSO 3: Publicação Automática no GitHub ---
echo.
echo Iniciando publicacao no GitHub...

REM --- Configurando identidade do Git ---
REM Este email DEVE ser o mesmo associado à sua conta do GitHub
git config user.name "silverioCaio"
git config user.email "caio.silverio@aditum.com.br"

REM --- Sincronizando e publicando ---
echo.
echo Sincronizando com o repositorio remoto...
git pull origin %BRANCH_PRINCIPAL%

echo Adicionando todos os arquivos...
git add .

echo Fazendo o commit...
git commit -m "Publica relatorio de teste gerado em %TIMESTAMP%"

echo Enviando para o GitHub (%BRANCH_PRINCIPAL%)...
git push origin %BRANCH_PRINCIPAL%


if !errorlevel! neq 0 (
    echo.
    echo =================================================================
    echo !! ERRO !! Falha ao publicar no GitHub. Verifique as mensagens de erro acima.
    echo =================================================================
) else (
    echo.
    echo =================================================================
    echo SUCESSO! O relatorio foi publicado.
    echo A atualizacao do site pode levar de 1 a 2 minutos.
    echo Acesse: https://silverioCaio.github.io/newmanArchives/newman/
    echo =================================================================
)

:finalizar
echo.
echo *** Script Finalizado ***
pause