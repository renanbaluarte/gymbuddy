# GymBuddy 🏋️

## Visão Geral

O GymBuddy é um aplicativo mobile criado para apoiar quem treina na academia com organização, praticidade e foco no resultado. Com ele, você consegue estruturar treinos personalizados, controlar tempos de exercício e descanso, consultar informações de equipamentos via QR Code e tirar dúvidas rápidas em um chat simulado — tudo em um só lugar.

O aplicativo estará disponível na **Google Play Store**. Caso prefira instalar manualmente, também publicamos os APKs na seção de [Releases](https://github.com/renanbaluarte/gymbuddy/releases).

---

## Funcionalidades

- Organização de treinos: crie, edite e salve rotinas personalizadas.
- Cronômetro personalizável: defina tempos de treino e descanso por série.
- Leitor de QR Code: identifique equipamentos e acesse detalhes rapidamente.
- Detalhes de equipamentos: visualize instruções, descrição e exercícios sugeridos.
- Chat simulado: acesse respostas rápidas para dúvidas comuns.

---

## Tecnologias

Construído com **Flutter** e um conjunto enxuto de bibliotecas. Abaixo, as dependências diretas do projeto (conforme `pubspec.yaml`):

Runtime/UI
- `flutter/material.dart`: construção da interface.
- `shared_preferences`: armazenamento local (preferências e dados simples).
- `mobile_scanner`: leitura de QR Codes.
- `audioplayers`: feedback sonoro durante a execução do treino.
- `flutter_spinkit`: componentes de loading/indicadores (presente no projeto; uso opcional).
- `dart:convert`: manipulação de dados JSON.
- `flutter/services.dart`: carregamento de assets (ex.: arquivos JSON e sons).

Ferramentas/Build
- `flutter_launcher_icons`: geração de ícones do aplicativo.
- `cupertino_icons`: conjunto de ícones iOS (opcional em telas que adotem esse estilo).

Desenvolvimento
- `flutter_test`: utilitário para testes de widget.
- `flutter_lints`: conjunto de regras de lint recomendadas.

---

## Instalação e Execução

### Requisitos

- **Flutter SDK** instalado. Consulte o [guia oficial](https://docs.flutter.dev/get-started/install).
- **Android Studio** (ou outro emulador/dispositivo Android) para testes.

### Passos

1) Clonar o repositório
   ```bash
   git clone https://github.com/renanbaluarte/gymbuddy.git
   ```

2) Acessar o diretório do projeto
   ```bash
   cd gymbuddy
   ```

3) Instalar dependências
   ```bash
   flutter pub get
   ```

4) Executar o aplicativo (com um dispositivo/emulador conectado)
   ```bash
   flutter run
   ```

---

## Disponibilidade

O GymBuddy será publicado na **Google Play Store**. Alternativamente, você encontra versões de instalação na seção de [Releases](https://github.com/renanbaluarte/gymbuddy/releases).

---

## Privacidade e Segurança

- Arquivos sensíveis do Android (por exemplo, `key.properties`, `*.jks`, `local.properties`) não são versionados e estão protegidos via `.gitignore`.
- O arquivo `google-services.json` costuma ser versionado por conveniência. Caso prefira não versioná-lo, é possível ajustar o `.gitignore`; avalie o impacto no seu fluxo de build/CI antes de alterar.

---

## Contribuição

Contribuições são bem-vindas. Se tiver sugestões, melhorias ou identificar algum problema, abra uma issue ou envie um pull request. Comentários e discussões construtivas ajudam a evoluir o projeto com qualidade.

---

## Licença

Este projeto é distribuído sob a licença **MIT**. Para mais detalhes, consulte o arquivo [LICENSE](LICENSE).

---


