# 🚐 Apex Specialist Superbadge – HowWeRoll Rentals

Projeto desenvolvido como parte da **Superbadge Apex Specialist** do Trailhead, onde o desafio é automatizar e escalar os processos de manutenção e sincronização de estoque da empresa fictícia **HowWeRoll Rentals**, líder mundial em aluguel de trailers e motorhomes.

---

## 🧾 Descrição

Com a crescente demanda por veículos recreativos (RVs), a **HowWeRoll** precisa garantir que sua frota esteja sempre em perfeitas condições e que o estoque de equipamentos esteja sincronizado entre sistemas. Este projeto implementa:

- **Automação programática de manutenção rotineira**
- **Integração com sistema legado via REST API**
- **Execução agendada fora do horário comercial**
- **Cobertura de testes 100% em Apex**

---

## 🧩 Estrutura do Projeto

### 🔁 Automação de Manutenção

- **Objetivo:** Criar automaticamente uma nova solicitação de manutenção rotineira quando uma requisição existente for encerrada.
- **Objetos envolvidos:**
  - `Case` (renomeado como *Maintenance Request*)
  - `Product2` (renomeado como *Equipment*)
  - `Vehicle__c`
  - `Equipment_Maintenance_Item__c`
- **Lógica:**
  - Disparada por trigger `MaintenanceRequest` ao encerrar requisições do tipo "Repair" ou "Routine Maintenance"
  - Calcula a nova data de vencimento com base no menor ciclo de manutenção entre os equipamentos utilizados
  - Cria novos registros de itens de manutenção e vincula-os à nova solicitação

### 🛠️ Classes:
- `MaintenanceRequestHelper`: Lógica de negócio para criar nova manutenção
- `MaintenanceRequestTrigger`: Trigger desacoplada
- `MaintenanceRequestHelperTest`: Cobertura de testes para lógica e trigger

---

### 🔗 Integração com Sistema de Estoque (REST)

- **Objetivo:** Atualizar os dados de equipamentos com base em informações enviadas pelo sistema legado do armazém
- **Processo:**
  - Realiza callout HTTP para endpoint externo
  - Mapeia os seguintes campos:
    - `Replacement_Part__c` → true
    - `Cost__c`
    - `Current_Inventory__c`
    - `Lifespan_Months__c`
    - `Maintenance_Cycle__c`
    - `Warehouse_SKU__c` (usado como External ID para upsert)
- **Classes:**
  - `WarehouseCalloutService`: Lógica principal do callout
  - `WarehouseCalloutServiceMock`: Mock para testes de callout
  - `WarehouseCalloutServiceTest`: Classe de testes com 100% de cobertura

---

### 🕒 Execução Agendada

- **Objetivo:** Executar a sincronização de estoque todos os dias às 01:00 da manhã
- **Classe:**
  - `WarehouseSyncScheduler`: Agendador que executa a chamada à classe de integração
  - `WarehouseSyncSchedulerTest`: Testes para garantir execução e enfileiramento correto do job

---

## ✅ Testes e Cobertura

- **Cobertura de Código:** 100% em todas as classes Apex
- **Testes Incluem:**
  - Criação de registros de manutenção rotineira para 1 e até 300 requisições (bulk test)
  - Validação de relacionamentos e datas
  - Testes positivos e negativos para triggers
  - Testes assíncronos com `Test.startTest()` e `Test.stopTest()`
  - Simulação completa da integração REST

---

## 🔐 Segurança e Boas Práticas

- Lógica desacoplada entre trigger e handler
- Uso de **External ID** para operações de `upsert`
- Callouts testados com mocks seguros
- Estrutura escalável e reutilizável para expansão futura
- Atualizações fora do horário comercial

---

## 🧑‍💻 Autor

**Nedson Vieira do Nascimento**  
Salesforce Developer | Trailhead Ranger  
🔗 [LinkedIn](https://www.linkedin.com/in/nedson-vieira/)  
🐻 [Trailblazer](https://www.salesforce.com/trailblazer/qnc912aeuektcnhbvp)

---

## 📚 Referência

[🔗 Superbadge: Apex Specialist – Trailhead](https://trailhead.salesforce.com/pt-BR/content/learn/superbadges/superbadge_apex)

---