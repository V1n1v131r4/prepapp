# PrepApp — Play Store Build

![Flutter](https://img.shields.io/badge/Flutter-3.24.3-blue) ![Java](https://img.shields.io/badge/Java-17-red) ![License: MIT](https://img.shields.io/badge/License-MIT-yellow) ![Build](https://img.shields.io/badge/Build-Passing-brightgreen)    

O **PrepApp** é um aplicativo de sobrevivência e preparação para emergências, desenvolvido em **Flutter** e distribuído também pela loja **Play Store**.  
Ele fornece informações críticas para situações de crise e catástrofes, com foco em acessibilidade offline e utilidade prática.

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png"
     alt="Get it on F-Droid"
     height="80">](https://f-droid.org/packages/com.bunqr.prepapp.fdroid/)
[<img src="https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png"
     alt="Get it on Google Play"
     height="80">](https://play.google.com/store/apps/details?id=com.bunqr.prepapp)

Or download the latest APK from the [Releases Section](https://github.com/V1n1v131r4/prepapp/releases).

---

## 🎯 Objetivo do App
O PrepApp foi criado para ajudar pessoas a se prepararem e reagirem em situações de emergência.  
Seja em desastres naturais, acidentes ou cenários de sobrevivência, o app reúne **guias práticos, informações críticas e ferramentas offline** que aumentam suas chances de resiliência e segurança.

Principais objetivos:
- Apoiar a **tomada de decisão em situações críticas**.  
- Centralizar informações úteis em um **único app offline**.  
- Auxiliar na **preparação preventiva** com cálculos, guias e checklists.  
- Disponibilizar recursos de **comunicação e alerta em tempo real**.  
- Unir **sobrevivência física e digital** através de orientações práticas.  

---

## 📱 Principais Telas
- **Guias de Sobrevivência** – Diversos temas práticos para situações de emergência.  
- **Guia de Primeiros-Socorros** – Orientações rápidas e opção de salvar sua ficha de saúde pessoal.  
- **Locais Próximos** – Baseado em uma lista de necessidades para sobrevivência (mercados, farmácias, hospitais, etc.).  
- **Repetidoras de Rádioamador** – Lista de repetidoras por região para comunicação alternativa.  
- **Mapa Offline** – Com a opção de salvar regiões para acesso sem internet.  
- **Guia de OPSEC e Sobrevivência Digital** – Boas práticas de privacidade e segurança da informação.  
- **Calculadora de Alimentos** – Estimativa de consumo e estoque para preparação.  
- **Alertas Climáticos** – Dados oficiais da Defesa Civil com notificações em tempo real.  
- **Informações sobre Marés** – Dados da NOAA para atividades costeiras e segurança no mar.  
- **Chamadas de Emergência** – Acesso rápido aos principais serviços de apoio, saúde e segurança.
- **Check lists** - Ferramentas de checklist para preparação de kits de emergência.  

---

## 🛠️ Requisitos para Build
- Flutter **3.24.3**  
- Android SDK com **NDK 27.0.12077973**  
- Java **17**  

---

## ⚙️ Build Local
Para gerar o APK de release:

```
flutter clean
flutter pub get
cd android
./gradlew clean
./gradlew :app:assembleRelease -x lint
```

### O APK será gerado na pasta:

```
android/app/build/outputs/apk/release/
```

## 📦 Distribuição

Esta branch (main) contém apenas os arquivos necessários para o build e publicação na **Play Store**.

A versão do F-droid está disponível na branch **fdroid**.

## 🔒 Permissões

O PrepApp utiliza permissões para:

- Localização – Exibir clima, trânsito, marés e locais próximos.

- Telefone – Realizar chamadas rápidas para números de emergência.

- Armazenamento – Salvar mapas offline e ficha de saúde.

## 🧭 Roadmap Futuro

- Integração com mais fontes de alertas internacionais.

- Expansão dos recursos de comunicação offline (rádio + mesh Bluetooth).

- Novos guias de sobrevivência e primeiros-socorros.

- Mais conteúdos sobre OPSEC e práticas de sobrevivência digital.
