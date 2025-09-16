# Política de Privacidade — PrepApp (versão F-Droid)

**Última atualização:** 2025-09-16  
**Contato do responsável:** contact@bunqrlabs.com  <!-- TODO: ajuste se necessário -->

O PrepApp é um app de sobrevivência que fornece informações de clima, mares, trânsito e opções de comunicação offline. Esta política descreve **o que o app faz com seus dados** na **versão F-Droid** (sem Google Play Services, sem Firebase/Analytics e sem anúncios).

## Resumo
- **Não coletamos dados pessoais** para servidores próprios.
- **Não usamos SDKs de rastreamento, anúncios ou analytics proprietários.**
- A **localização** pode ser usada **no dispositivo** para recursos de clima, mares e mapa.
- As **requisições de rede** fazem chamadas apenas a **fontes públicas** (ver lista abaixo).
- Você pode usar o app sem conceder localização; algumas funções podem ficar limitadas.

## Dados tratados

### 1) Localização do dispositivo
- **Finalidade:** obter previsões/alertas climáticos na sua área e posicionar o mapa.
- **Base legal:** consentimento do usuário (Android solicitará permissão).
- **Escopo:** precisão configurável (aproximada/precisa).  
- **Armazenamento:** **não enviamos sua localização a servidores próprios**. O valor é usado localmente para montar consultas a provedores públicos (por exemplo, área/lat-long).
- **Background:** a versão F-Droid **não** realiza coleta em segundo plano por padrão. Se no futuro um recurso exigir **localização em segundo plano**, isso será claramente informado na UI e nesta política antes da ativação.

### 2) Dados de diagnóstico locais
- **Finalidade:** facilitar suporte quando você abre um issue manualmente.
- **Escopo:** logs locais do app (erros e eventos técnicos).  
- **Envio:** só são compartilhados se você optar voluntariamente (ex.: colando logs em um issue no GitHub).

### 3) Comunicação offline (Bluetooth / Wi-Fi Direct)
- **Finalidade:** permitir scanner de rádio (futuro), pareamento local e chat P2P entre dispositivos próximos.
- **Escopo:** nomes dos dispositivos próximos e metadados técnicos **apenas para descoberta local**.  
- **Envio:** nenhum dado sai do seu dispositivo, exceto para o **dispositivo vizinho** com quem você interage explicitamente.

## Provedores/Endpoints de terceiros (rede)

O PrepApp consulta **somente** serviços públicos ou abertos. Exemplos (podem variar por versão/região):

| Serviço/host | Uso | Observações |
|---|---|---|
| **INMET** (api publicamente disponível) | Dados/alertas climáticos do Brasil | Apenas solicitações de leitura; sem identificação pessoal. <!-- TODO: confirme a URL final usada no app --> |
| **OpenStreetMap / Tile servers compatíveis** | Mapas/base cartográfica | Requisições de tiles podem registrar IP e UA do cliente (padrão da web). Considere usar um tile server próprio se desejar. |
| **(Opcional) INPE/CEMADEN ou outros órgãos públicos** | Camadas/alertas meteorológicos | Apenas leitura. <!-- TODO: incluir/ajustar se usar --> |

> **Dica de privacidade:** se quiser máxima privacidade, utilize o app com **rede própria de tiles** (self-host) e fontes oficiais via HTTPS.

## Permissões Android

- `ACCESS_FINE_LOCATION` — para recursos de localização (clima/mares/mapa). Solicitada **somente** quando você usa o recurso.
- `BLUETOOTH` / `NEARBY_DEVICES` (varia por versão do Android) — para comunicação offline entre dispositivos, quando você abrir essa função.
- `ACCESS_BACKGROUND_LOCATION` — **NÃO utilizada por padrão**. Se algum recurso futuro exigir, haverá uma tela de explicação e o pedido explícito.

## Armazenamento e retenção

- Dados de preferências/configurações são salvos **localmente** no dispositivo (ex.: SharedPreferences/arquivos locais).  
- Não há retenção em servidores do desenvolvedor para a versão F-Droid.

## Compartilhamento

- Não compartilhamos seus dados com terceiros para fins de marketing ou analytics.
- Logs só são compartilhados **se você optar** por anexá-los em um issue.

## Segurança

- O tráfego a provedores públicos é via **HTTPS** quando disponível.  
- Recomendamos manter seu sistema operacional atualizado e usar redes confiáveis.

## Contato

Dúvidas de privacidade? **contact@bunqrlabs.com**  
Relatos técnicos: https://github.com/V1n1v131r4/prepapp/issues

## Mudanças nesta política

Podemos atualizar este documento conforme o app evoluir. Quando houver mudanças relevantes, atualizaremos a data no topo e a seção de “Novidades” do app (se aplicável).

