# leaf

Leaf é o nome do Evidence Design System. Contém todos os componentes, tokens, assets necessários para se construir uma tela.

## Estratégia

Componentes são divididos em `core` e `feature`, de modo que os primeiros são totalmente livres de regras de negócio enquanto os segundos podem conter semânticas mais avançadas para os casos de uso existentes. Componentes feature podem acessar propriedades do domínio para definirem seus contratos. Ambos os tipos de componentes estão neste mesmo pacote, de modo que o reuso seja máximo e detalhes de implementação como tokens e assets estejam o mais isolados possível do restante da aplicação.