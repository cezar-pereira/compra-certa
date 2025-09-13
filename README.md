# Compra Certa 💰

Calculadora de investimentos com taxa SELIC para ajudar você a tomar decisões financeiras mais inteligentes.

## 📱 Plataformas Suportadas

- ✅ **Android** - Aplicativo nativo
- ✅ **iOS** - Aplicativo nativo  
- ✅ **Web** - Aplicação web responsiva

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK instalado
- Dart SDK (incluído com Flutter)

### Executando a Versão Web
```bash
# Opção 1: Usando o script facilitado
./run_web.sh

# Opção 2: Comando direto
flutter run -d web-server --web-port 8080
```

Acesse: http://localhost:8080

### Executando no Mobile
```bash
# Android
flutter run -d android

# iOS (apenas no macOS)
flutter run -d ios
```

### Build para Produção
```bash
# Web
flutter build web

# Android
flutter build apk

# iOS
flutter build ios
```

## 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **SharedPreferences** - Armazenamento local
- **Clean Architecture** - Arquitetura limpa

## 📁 Estrutura do Projeto

```
lib/
├── app_widget.dart          # Widget principal da aplicação
├── main.dart                # Ponto de entrada
├── config/                  # Configurações
├── data/                    # Camada de dados
│   ├── model/              # Modelos de dados
│   ├── repositories/        # Repositórios
│   └── services/           # Serviços
├── domain/                  # Camada de domínio
│   ├── entities/           # Entidades
│   ├── models/             # Modelos de domínio
│   └── usecases/           # Casos de uso
├── routing/                 # Roteamento
├── services/                # Serviços gerais
├── ui/                      # Interface do usuário
│   ├── core/               # Componentes base
│   └── pages/              # Páginas
└── utils/                   # Utilitários
```

## 📖 Funcionalidades

- 🧮 Calculadora de investimentos
- 📊 Taxa SELIC atualizada
- 💾 Armazenamento local de dados
- 📱 Interface responsiva
- 🌐 Suporte completo para web

## 🔧 Desenvolvimento

Para contribuir com o projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Faça commit das mudanças
4. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
