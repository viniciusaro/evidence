# leaf

Leaf é o nome do Evidence Design System. Contém todos os componentes, tokens, assets necessários para se construir uma tela.

## Estratégia

A estratégia de construção atual busca incluir semântica de negócio dentro dos componentes. Propriedades configuracionais podem ser utilizadas para alterar atributos como cores e estilos, mas, normalmente, as cores e estilos não são configuráveis diretamente.

### Prós
- Tokens mais isolados, facilitando manutenção e futuras evoluções de tokens.
- Dependências isoladas, features não se preocupam com importar assets ou outros tipos de recursos para utilizar os componentes.
- Futuras implementações com SDUI se beneficiam pois menos atributos precisam ser configurados

### Contras
- Menor reuso. Casos de uso que fujam da semântica previamente codificada podem impedir que um componente seja reutilizado em um novo contexto.
