#UrjaSetu ⚡

### Peer-to-Peer Energy Trading Platform

**Team Name:** Laminar Flow

**Team Members:**

* Parth Sonawane
* Kanishk Salunkhe
* Dhruv Patil
* Alok Bhadage

---

# Overview

**UrjaSetu** is a prototype peer-to-peer (P2P) energy trading platform designed for decentralized microgrids. The system allows households with rooftop solar panels to **sell surplus electricity directly to nearby homes**, reducing reliance on centralized power grids.

Instead of sending excess energy back to the utility grid, UrjaSetu creates a **local energy marketplace** where energy can be traded between homes in real time.

The project demonstrates a working simulation of a microgrid energy economy, including:

* Energy generation and consumption simulation
* Automated energy marketplace matching
* Battery storage simulation
* Trade execution
* Transaction ledger with SHA-256 verification
* AI-based trading recommendations
* Mobile application interface for monitoring and trading energy

---

# Problem Statement

In traditional power grids, households generating solar power often have limited options for selling surplus energy. Excess electricity is usually sent back to the central grid at low feed-in tariffs, which discourages distributed renewable generation.

UrjaSetu addresses this challenge by enabling **localized peer-to-peer electricity trading**, allowing households to:

* Sell excess solar energy
* Buy electricity directly from neighbors
* Participate in a decentralized energy market

---

# Solution Architecture

The system consists of a **mobile application**, a **FastAPI backend**, and an **energy trading simulation engine**.

```
Mobile App (Flutter)
        ↓
FastAPI Backend (Python)
        ↓
Energy Market Engine
        ↓
Battery Simulation
        ↓
Trade Ledger (SHA-256 verification)
```

---

# System Components

## Mobile Application

The mobile application allows users to interact with the energy trading platform.

Features include:

* Login authentication
* Energy dashboard
* Marketplace browsing
* Energy trade execution
* Transaction history
* Blockchain transaction verification

The application is built using:

* Flutter
* Dart
* Provider state management

---

## Backend Server

The backend is built using **FastAPI** and handles all application logic including:

* authentication
* market simulation
* trade matching
* battery updates
* ledger generation
* AI recommendations

Technologies used:

* Python
* FastAPI
* Pandas
* Uvicorn

---

## Energy Market Engine

The trading engine simulates an hourly energy marketplace where buyers and sellers are automatically matched.

The system evaluates:

* energy surplus
* energy demand
* battery levels
* market prices

Trades are then executed and recorded.

---

## Battery Simulation

Each house in the microgrid contains a simulated battery system.

Battery data is updated every trading cycle and stored in:

```
battery_log.csv
```

This allows the system to track:

* charge levels
* energy storage
* energy discharge

---

## Transaction Ledger

All energy trades are stored in a transaction ledger.

Each trade includes a **SHA-256 cryptographic hash** to simulate blockchain-style verification.

Transaction data includes:

* seller house
* buyer house
* energy traded
* price per kWh
* timestamp
* transaction hash

The ledger is stored in:

```
trade_log.csv
```

---

# Microgrid Simulation

For demonstration purposes, the system simulates a **local microgrid with multiple houses**.

Example participants include:

* House 1 – Buyer
* House 3 – Buyer
* House 7 – Mixed user
* House 9 – Heavy seller
* House 11 – Heavy seller
* House 15 – Moderate seller

Each house has predefined login credentials and energy generation patterns.

---

# API Endpoints

The backend exposes the following endpoints.

### Authentication

```
POST /login
GET /me
```

---

### Simulation

```
POST /run-market
```

Runs the energy trading engine and generates market trades.

---

### User Features

```
GET /dashboard/{house_id}
GET /marketplace
POST /trade
GET /transactions/{house_id}
```

These endpoints power the mobile application.

---

### Developer Utilities

```
GET /dataset
GET /trade-log
GET /recommendations
GET /battery-status
```

These endpoints allow inspection of the simulation data.

---

# Mobile Application Features

## Dashboard

Displays:

* energy sold
* energy bought
* revenue earned
* battery level
* AI trade recommendation
* energy production for the day

---

## Marketplace

Users can view available sellers and purchase electricity directly from them.

---

## Trade Execution

Users select the energy amount and execute a trade.

The system records the transaction and generates a **verification hash**.

---

## Transaction History

Users can view past trades and verify the associated transaction hashes.

Short hashes are displayed in lists while full hashes are available in transaction details.

---

# Technologies Used

Frontend:

* Flutter
* Dart
* Provider

Backend:

* FastAPI
* Python
* Pandas

Other Components:

* SHA-256 hashing
* CSV-based data storage
* Simulation engine

---

# Project Structure

Backend

```
backend/
   api/
   simulation/
   trading_engine/
   ml_model/
```

Frontend

```
lib/
   core/
   models/
   services/
   providers/
   features/
```

---

# How to Run the Project

## Backend Setup

Install dependencies:

```
pip install fastapi uvicorn pandas
```

Run the server:

```
uvicorn backend.api.main:app --host 0.0.0.0 --port 8000 --reload
```

API documentation will be available at:

```
http://127.0.0.1:8000/docs
```

---

## Mobile App Setup

Install dependencies:

```
flutter pub get
```

Run the application:

```
flutter run
```

For Android emulator, the backend base URL should be:

```
http://10.0.2.2:8000
```

---

# Hackathon Demo Flow

The demo showcases the following workflow:

```
Energy generation
        ↓
Marketplace listing
        ↓
Trade execution
        ↓
Transaction hash verification
        ↓
Updated seller revenue
```

This demonstrates the feasibility of **decentralized energy markets in microgrid environments**.

---

# Future Improvements

Possible extensions for the system include:

* real smart meter integration
* blockchain-based ledger
* dynamic pricing algorithms
* IoT device integration
* real-time grid monitoring

---

# License

This project was developed as part of a hackathon prototype and is intended for educational and research purposes.

---

# Acknowledgment

Developed by **Team Laminar Flow** as an experimental prototype to explore decentralized energy trading systems and microgrid energy markets.

