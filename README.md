
# DecentraREC - A Renewable Energy Community Management Platform

DecentraREC is an attempt to create a fully decentralized currency and energy exchange using DLT for the effect.

Note: This repository is in active development. 
## Smart Contracts

This repository contains the following Solidity smart contracts:

1. **Device.sol**
2. **Market.sol**
3. **MeasurementFactory.sol**
4. **OffersFactory.sol**
5. **Payments.sol**


## Getting Started

### Prerequisites

Make sure you have the following installed before proceeding:

- Solidity Compiler
- Ethereum Development Environment (e.g., Truffle, Hardhat)
- Node.js and npm

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/AnBapDan/DecentraREC.git
    cd DecentraREC
    ```

2. Install dependencies:

    ```bash
    npm install
    ```

### Deployment

**In Development**

### Usage

**In Development**

### Contracts Overview

#### Device Contract

- Description: Devices must be created and allowed by a REC Manager entity. Therefore, this contract serves as an entrypoint for registering and acceptance of a member to a community 

#### Market Contract

- Description: This contract is in Development. It is here that the different asks and bids are grouped at specific timestamps and processed to create *Payments* (a register for grouping consumers, prosumers and their exchanging energy and price).

#### Measurement Contract

- Description: A contract called periodically, by allowed community devices, to create periodic measurements for that timestamp.

#### Offers Contract

- Description: Offers objective consist in creating Asks or Bids depending on the 2 consecutive measurements registered for a specific period, as well as defining the price limits (maximum price per energy consumed // minimum price per energy produced)

#### 5. Payments.sol

- Description: Payments is the contract where the price per energy exchange is created and registered.
## What needs to be developed

- [ ] Simple Market Algorithm
- [ ] Develop Asks and Bids Contract
- [ ] Adopt more Complex Markets
- [ ] Unit Testing
- [ ] Minimize Usage Fees
- [ ] Front-End visualization

