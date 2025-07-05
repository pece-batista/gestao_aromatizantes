# CraftHub 🛠️✨

E aí! 👋 Este é o repositório do **CraftHub**, um aplicativo de gestão para microempresas artesanais, construído com Flutter. O projeto nasceu de uma necessidade real: ajudar minha mãe a organizar o estoque e a produção de sua pequena empresa de aromatizantes.

## Sobre o App 📱

O CraftHub tem como objetivo ser um "hub" central para artesãos gerenciarem seus negócios. A ideia é criar uma ferramenta simples e visual para controlar o fluxo de produção, desde a matéria-prima até o produto final pronto para a venda.

## Funcionalidades Atuais 🚀

O Painel de Controle do CraftHub é dividido em 4 módulos principais:

* **📦 Estoques:**
  * Controle total sobre dois inventários separados: Matéria-Prima e Produtos Acabados.
  * Funcionalidades completas de Adicionar, Editar quantidade (com clique ou digitando) e Remover itens (arrastando para o lado).

* **📖 Gestão de Receitas:**
  * Um sistema para criar e listar receitas detalhadas, definindo o item que ela produz e todos os ingredientes necessários com suas respectivas unidades de medida.

* **⚙️ Registro de Produção (Em desenvolvimento):**
  * A tela para registrar novas produções já foi criada. O próximo passo é implementar a lógica que consome do estoque de matéria-prima e adiciona ao estoque de produtos.

* **💾 Persistência de Dados:**
  * Todas as informações (estoques, receitas, etc.) são salvas localmente no dispositivo, garantindo que nada se perca.

## Como Rodar o Projeto

1. Clone este repositório.
2. No terminal, dentro da pasta do projeto, rode `flutter pub get` para instalar as dependências.
3. Rode `flutter run` para iniciar o app no emulador ou no seu celular.

## Uma Jornada de Aprendizado

Este projeto foi meu campo de aprendizado em Flutter. Cada tela, botão e funcionalidade foi construído passo a passo. O objetivo é que um dia ele se torne um app robusto para controle de estoque e também para ajudar a gerenciar negócios num geral, dando sujestões de precificação de produtos e outros.