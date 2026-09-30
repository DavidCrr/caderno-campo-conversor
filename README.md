# Caderno de Campo do Vale — Conversor de Unidades da Roça

Trabalho prático da disciplina de Programação para Dispositivos Móveis (2026/2)
Bacharelado em Sistemas de Informação — IF Goiano Campus Ceres
Docente: Prof. Dr. Paulo César Ferreira Melo

====================================================================
1. Identificação do Aluno e Papéis Acumulados
====================================================================

Nota: Devido à ausência na aula de divisão de grupos, o projeto foi desenvolvido de forma individual, acumulando e cobrindo os três papéis previstos no regulamento.

Aluno: David Correa Duarte

Papéis Desempenhados:
1. Construtor: Implementação de toda a lógica de negócio, conversão de grandezas agrícolas, gerenciamento de estado reativo com setState e tratamento de erros e validações.
2. Designer de Interface: Estruturação visual com Material 3, definição do tema verde agro (#1E5631), hierarquia visual limpa e garantia das decisões de usabilidade para o campo.
3. Relator: Elaboração deste README detalhado, documentação das regras regionais e roteiro para a demonstração ao vivo para a turma.

====================================================================
2. Sobre a Funcionalidade (Opção B)
====================================================================

O Conversor de Unidades da Roça é uma ferramenta direta para produtores, técnicos e agrônomos do Vale de São Patrício (GO). O aplicativo permite alternar facilmente entre medidas de Área e Safra/Peso, calculando o resultado instantaneamente conforme o usuário digita (onChanged).

Unidades Regionais Suportadas:

Área:
- Hectares (ha) — Padrão internacional (10.000 m²).
- Alqueires Goianos (alq) — Unidade tradicional goiana (1 Alqueire Goiano = 4,84 ha = 48.400 m²).
- Metros Quadrados (m²).

Safra / Peso:
- Sacas de 60 kg (sc) — Unidade padrão de comercialização de soja e milho.
- Arrobas (@) — 15 kg (1 saca = 4 arrobas).
- Toneladas (t) — 1.000 kg (~16,66 sacas).
- Quilos (kg).

====================================================================
3. As Duas Decisões de Interface para o Campo
====================================================================

1. Alto Contraste e Leitura Sob Sol Forte:
O aplicativo utiliza fundo claro (#F8F9FA) com tipografia escura e um cartão de destaque com verde escuro de alto contraste (#1E5631) e texto branco grande (36px). Isso permite ler os resultados mesmo sob luz solar direta sem reflexos prejudiciais.

2. Alvos de Toque Ampliados (Touch Targets >= 48dp):
No ambiente rural, o produtor frequentemente manuseia o aparelho com luvas, mãos sujas ou em veículos em movimento (trator/caminhonete). Todos os botões, seletores (DropdownButton) e campos de texto (TextField) possuem altura mínima de 48dp e espaçamentos largos para evitar toques acidentais.

====================================================================
4. Atendimento aos Requisitos Mínimos
====================================================================

[x] 1. Rodar sem erros: Código validado com flutter analyze e flutter test.
[x] 2. Widgets de layout e formulário: Uso de Scaffold, Column, Row, Container, Padding, TextField e DropdownButton.
[x] 3. Estado gerenciado com setState: Atualização dinâmica de variáveis a cada interação.
[x] 4. Evento além do toque: Tratamento contínuo com onChanged no TextField e troca imediata no DropdownButton.
[x] 5. Validação de dados: Recusa strings inválidas, vírgulas múltiplas, valores nulos e números menores ou iguais a zero com mensagem de erro clara.
[x] 6. Contexto regional: Fatores específicos do Vale de São Patrício (Alqueire Goiano de 4,84 ha e saca de 60 kg).
[x] 7. README completo: Documentação e papéis descritos.

====================================================================
5. Como Rodar o Projeto
====================================================================

1. Abra o terminal na pasta do projeto:
   cd caderno_campo_conversor

2. Obtenha as dependências:
   flutter pub get

3. Execute no emulador ou navegador:
   flutter run

====================================================================
6. Roteiro Sugerido para Apresentação ao Vivo (3 Minutos)
====================================================================

1. Abertura (Papel: Relator - 45s):
Apresentar o problema (a diferença comum entre alqueire goiano e hectare na nossa região e conversão de sacas/arrobas) e contextualizar que o app foi feito para o Caderno de Campo do Vale.

2. Demonstração da Interface (Papel: Designer - 45s):
Mostrar a tela e citar as duas decisões de campo (contraste ao ar livre e botões de no mínimo 48dp para fácil toque).

3. Lógica e Validação (Papel: Construtor - 1min 30s):
Digitar valores, demonstrar o cálculo instantâneo com onChanged, o botão de inverter unidades e simular um erro (valor negativo ou texto inválido) mostrando a mensagem de aviso.
