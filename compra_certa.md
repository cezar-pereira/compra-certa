
# 📊 Comparador: Compra à Vista vs Parcelada com Análise de Investimento (Selic)

## 🎯 Objetivo

Este projeto tem como objetivo comparar duas formas de pagamento:

- **À vista com desconto**
- **Parcelado com valor cheio**

A análise considera que o valor que seria pago à vista será investido com rendimento baseado na **taxa Selic anual definida pelo usuário**. A partir disso, simula-se se o rendimento do investimento é superior à economia gerada pelo desconto à vista.

---

## 🧾 Entradas do Usuário

| Campo                  | Tipo       |Descrição                                                           |
|----------------------------------------------------------------------------------------------------------|
| `valorAVista`          | decimal    | Valor com desconto pago àvista.                                    |
| `valorCheio`           | decimal    | Valor total parcelado (semdesconto).                               |
| `quantidadeParcelas`   | inteiro    | Número de parcelas (mínimo 2, máximo 18).                          |
| `taxaSelicAnual`       | percentual | Taxa de juros anual (Selic) definida pelo usuário. Persistida.     |

---

## 🔄 Lógica de Cálculo

### 📌 Simulação
1. O valor cheio é considerado como se fosse investido no mês 0.
2. A cada mês, é retirada uma parcela do valor para o pagamento.
3. O restante continua investido e rendendo.
4. Ao final do período, o valor restante é comparado com a economia do pagamento à vista.

---

### 📐 Fórmulas Utilizadas

**Cálculo da taxa mensal:**
```
taxaMensal = (1 + taxaSelicAnual)^(1/12) - 1
```

**Simulação mês a mês:**
```pseudo
saldoInvestido = valorCheio

para i de 1 até quantidadeParcelas:
    saldoInvestido *= (1 + taxaMensal)
    saldoInvestido -= valorCheio / quantidadeParcelas
```

---

## 🧠 Exemplo

```plaintext
Entrada:
  valorAVista: R$ 900,00
  valorCheio: R$ 1000,00
  quantidadeParcelas: 10
  taxaSelicAnual: 10%

Cálculo:
  taxaMensal ≈ 0.7974%

  Mês 1: R$ 1000.00 → +0.7974% → R$ 1007.97 → -R$ 100.00 → R$ 907.97
  Mês 2: R$ 907.97 → +0.7974% → R$ 915.21 → -R$ 100.00 → R$ 815.21
  ...
  Mês 10: saldo final ≈ R$ 47,69

Comparação:
  Economia ao pagar à vista: R$ 100.00
  Rendimento total do investimento: R$ 47,69

✅ Resultado: Vale mais a pena pagar **à vista**.
```

---

## ✅ Critério de Decisão

| Resultado                     | Condição                                                      |
|-------------------------------|---------------------------------------------------------------|
| **À vista é mais vantajoso**  | Economia à vista > Ganho do investimento                      |
| **Parcelado é mais vantajoso**| Ganho do investimento > Economia gerada no pagamento à vista  |

---

## 💾 Persistência

A **taxa Selic** definida pelo usuário deve ser salva localmente.
Exemplos:
- **Flutter/Dart**: `SharedPreferences`

---

## ⚙️ Regras de Negócio

- Parcelas entre **2 e 18**.
- `valorCheio` **deve ser maior** que `valorAVista`.
- `taxaSelicAnual` deve ser um **valor positivo**.

---

## 💬 Frase de Retorno (UX)

> 💡 "Ao investir o valor da compra parcelada, você teria um ganho de R$ XX,XX. Como a economia pagando à vista seria de R$ YY,YY, **vale mais a pena pagar [à vista / parcelado]**."

---


## ⚙️ Arquitetura

Projeto deve conceitos do Clean code e do SOLID, adicione testes unitários para as principais funções e que seja reutilizaveis.



├── main.dart                    // Ponto de entrada da aplicação
├── config/                      // Configurações do app (URLs, constantes)
├── utils/                       // Utilitários e helpers
├── routing/                     // Configuração de rotas
├── ui/                          // Camada de apresentação (UI)
│   ├── core/                    // Componentes compartilhados
│   │   ├── ui/                  // Widgets reutilizáveis
│   │   │   └── shared_widgets/  // Ex: custom_button.dart, loading_widget.dart
│   │   └── themes/              // Temas e estilos do app
├── domain/                      // Camada de negócio (entidades e regras)
│   └── models/                  // Modelos de domínio (entidades de negócio)
│       └── <name_model>.dart    // Ex: xpto_mode.dart
│   └── usecases/                // Modelos de domínio (entidades de negócio)
│       └── <name_usecase>.dart  // Ex: calculate_investment_usecase.dart
├── data/                        // Camada de dados (acesso a dados externos)
│   ├── repositories/            // Implementação dos repositórios
│   │   └── <repository>.dart    // Ex: selic_storage_repository.dart
│   ├── services/                // Serviços (API, database, storage)
│   │   └── <service>.dart       // Ex: selic_database_service.dart
│   └── model/                   // Modelos de dados (DTOs, JSON models)
│       └── <api_model>.dart     // Ex: XTPO.dart
