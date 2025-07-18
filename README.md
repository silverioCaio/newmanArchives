# Projeto de Testes Automatizados - [NOME DA API]

Este repositório contém a collection Postman e o ambiente para executar testes automatizados na API [NOME DA API].

## Pré-requisitos

Para executar os testes, você precisará ter:

1.  [Node.js](https://nodejs.org/) (que inclui o npm)
2.  Newman e o repórter htmlextra instalados globalmente:
    ```bash
    npm install -g newman newman-reporter-htmlextra
    ```

## Como Executar os Testes

1.  Clone este repositório:
    ```bash
    git clone [URL_DO_SEU_REPOSITÓRIO_GIT]
    cd [NOME_DA_PASTA_DO_PROJETO]
    ```

2.  Execute o comando do Newman:
    ```bash
    newman run "transacional.postman_collection.json" -e "dev.postman_environment.json" -r cli,htmlextra --reporter-htmlextra-export "newman/Relatorio_Transacoes.html" --reporter-htmlextra-title "Relatório Detalhado de Transações"
    ```

Após a execução, um relatório detalhado será gerado no caminho `newman/Relatorio_Transacoes.html`. Abra este arquivo no seu navegador para ver o dossiê das transações.