@echo off
setlocal enabledelayedexpansion

REM --- Simulação das variáveis que o script principal criaria ---
set "BRANCH_PRINCIPAL=master"
set "TIMESTAMP=TESTE_DEBUG_12345"

echo.
echo ==========================================================
echo               INICIANDO SCRIPT DE DEBUG DO GIT
echo ==========================================================
echo.
echo --- Passo A: Configurando identidade do Git... ---
git config user.name "silverioCaio (Automated Commit)"
git config user.email "caio.silverio@aditum.com.br"
echo Identidade configurada para "silverioCaio".
echo.
pause

echo --- Passo B: Sincronizando com 'origin %BRANCH_PRINCIPAL%'... ---
git pull origin %BRANCH_PRINCIPAL%
echo Resultado do pull (acima).
echo.
pause

echo --- Passo C: Verificando status ANTES do 'add'... ---
git status
echo.
pause

echo --- Passo D: Adicionando TODOS os arquivos... ---
git add .
echo.
echo Comando 'git add .' executado.
echo.
pause

echo --- Passo E: Verificando status DEPOIS do 'add'... ---
git status
echo Deveriam haver arquivos em verde (Changes to be committed) acima.
echo.
pause

echo --- Passo F: Tentando fazer o commit... ---
git commit -m "Commit de DEBUG do script - %TIMESTAMP%"
echo Comando 'git commit' executado. Se não houve mensagem de 'nothing to commit', deve ter funcionado.
echo.
pause

echo --- Passo G: Tentando fazer o push final... ---
git push origin %BRANCH_PRINCIPAL%
echo Comando 'git push' executado.
echo.
pause

echo ==========================================================
echo                   FIM DO SCRIPT DE DEBUG
echo ==========================================================
echo.

pause