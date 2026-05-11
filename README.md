# 🏥 Medical Appointment Manager

🌎 [Read in English](#-english) | 🇧🇷 [Leia em Português](#-português)

---

# 🇺🇸 English

## 📌 About

This project is a **medical appointment management system** developed in **2025** using the **Gleam programming language** and functional programming principles.

The system models a healthcare scheduling environment, allowing the creation, validation, filtering, updating, and analysis of medical appointments.

The project was designed to explore:

* Functional programming concepts
* Immutable data structures
* Recursive list manipulation
* Result-based validation and error handling
* Type-safe domain modeling

---

## ⚙️ Features

* Create and validate appointments
* Search appointments by ID
* Update appointment status
* Filter appointments by status
* Remove completed appointments
* Count appointments by status
* Calculate completion percentage
* Strong validation system for:

  * IDs
  * Dates
  * Text fields
  * Status values

---

## 🧠 Concepts Covered

* Functional Programming
* Algebraic Data Types
* Recursion
* Pattern Matching
* Immutable Lists
* Error Handling with `Result`
* Type Safety
* Data Validation
* Domain Modeling

---

## 🏗️ System Structure

Each appointment contains:

* **ID**
* **Patient Name**
* **Description**
* **Date**
* **Status**

Available status types:

* Pending
* In Progress
* Completed

---

## 🧪 Testing

The project includes several example-based tests using:

```gleam
check.eq(...)
```

These tests validate:

* Appointment creation
* Input validation
* Search operations
* Filtering logic
* Statistical functions

---

## ▶️ Technologies

* Gleam
* Functional Programming
* sgleam/check

---

⚠️ **Note:**
This project reflects my knowledge in 2025 and was developed for educational purposes, focusing on functional programming and data modeling concepts.

---

# 🇧🇷 Português

## 📌 Sobre

Este projeto é um **sistema de gerenciamento de consultas médicas** desenvolvido em **2025** utilizando a linguagem **Gleam** e conceitos de programação funcional.

O sistema modela um ambiente de agendamento clínico, permitindo criar, validar, filtrar, atualizar e analisar consultas médicas.

O projeto foi desenvolvido com foco em:

* Programação funcional
* Estruturas de dados imutáveis
* Manipulação recursiva de listas
* Tratamento de erros utilizando `Result`
* Modelagem tipada de domínio

---

## ⚙️ Funcionalidades

* Criar e validar consultas
* Buscar consultas por ID
* Atualizar status de consultas
* Filtrar consultas por status
* Remover consultas concluídas
* Contar consultas por status
* Calcular percentual de consultas concluídas
* Sistema de validação para:

  * IDs
  * Datas
  * Campos de texto
  * Status

---

## 🧠 Conceitos Utilizados

* Programação Funcional
* Tipos Algébricos
* Recursão
* Pattern Matching
* Listas Imutáveis
* Tratamento de Erros com `Result`
* Segurança de Tipagem
* Validação de Dados
* Modelagem de Domínio

---

## 🏗️ Estrutura do Sistema

Cada consulta possui:

* **ID**
* **Nome do paciente**
* **Descrição**
* **Data**
* **Status**

Tipos de status disponíveis:

* Pendente
* Em andamento
* Concluída

---

## 🧪 Testes

O projeto inclui diversos testes utilizando:

```gleam
check.eq(...)
```

Os testes validam:

* Criação de consultas
* Validações de entrada
* Operações de busca
* Filtragem
* Funções estatísticas

---

## ▶️ Tecnologias

* Gleam
* Programação Funcional
* sgleam/check

---

⚠️ **Nota:**
Este projeto reflete meu nível de conhecimento em 2025 e foi desenvolvido com fins educacionais, com foco em programação funcional e modelagem de dados.
