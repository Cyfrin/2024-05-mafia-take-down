
# First Flight #16: Mafia Take Down

# Table of Contents

- [Contest Details](#contest-details)
    - [Prize Pool](#prize-pool)
    - [Stats](#stats)
    - [Disclaimer](#disclaimer)
- [Table of Contents](#table-of-contents)
- [About](#about)
  - [Policies](#policies)
  - [Modules](#modules)
    - [WeaponShelf](#weaponshelf)
    - [MoneyShelf](#moneyshelf)
    - [MoneyVault](#moneyvault)
  - [CrimeMoney](#crimemoney)
  - [Scripts](#scripts)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
- [Audit Scope Details](#audit-scope-details)
  - [Compatibilities](#compatibilities)
  - [Roles](#roles)
  - [Known Issues](#known-issues)

[//]: # (contest-details-open)

# Contest Details

_A special thanks to n0kto for contributing this Community First Flight!_

Learn more about n0kto!
- [GitHub](https://github.com/n0kto)
- [Twitter](https://x.com/n0kto)
- [LinkedIn](https://www.linkedin.com/in/axel-leloup-659a15155/)

### Prize Pool

- High - 100xp
- Medium - 20xp
- Low - 2xp

- Starts: May 23, 2024 Noon UTC
- Ends: May 30, 2024 Noon UTC

### Stats

- nSLOC: 205
- Complexity Scope: 284

### Disclaimer

_This code was created for Codehawks as the first flight. It is made with bugs and flaws on purpose._
_Don't use any part of this code without reviewing it and audit it._

# About

An undercover AMA agent (anti-mafia agency) discovered a protocol used by the Mafia. In several days, a raid will be conducted by the police and we need as much information as possible about this protocol to prevent any problems. But the AMA doesn’t have any web3 experts on their team.

Hawkers, they need your help!

Find flaws in this protocol and send us your findings.

_This project uses the Default framework: https://github.com/fullyallocated/Default_

## Policies

Policies are external-facing contracts that receive inbound calls to the protocol, and route all the necessary updates to data models via Modules. Access control and input validation are performed in these contracts.

### Laundrette

The AMA intervention will be held in a Laundrette, the headquarters of the mafia. It seems they named the interface contract the same as their shell company.

Anyone can deposit USDC to get CrimeMoney but only gang members and godfather can withdraw USDC. As the French say : giving is giving, taking back is stealing.

Users have to approve the MoneyShelf contract before calling the function to deposit.

Currently, the mafia does not have any way to control the incoming weapons so only the god father can account for them in real world and assign them to any gang members. Gang members has to withdraw them in the contract before taking them in real life. Since they don't want to lose a finger, they never forget to do it that way.

This contract is the admin of `Kernel.sol` to grant and revoke roles.
A function permit the godfather to retrieve the admin role when needed.

## Modules

Modules are internal-facing contracts that store shared state across the protocol.
Except for view functions, all functions can only be called by an authorized policies (which asked permissions from the kernel).

### WeaponShelf

This contract keeps count for the available weapons per member.

### MoneyShelf

This contract in charge of keeping USDC and minting/burning the CrimeMoney.
Users have to approve this contract before calling the Laundrette function to deposit.

### MoneyVault

In case of any issue (on-chain or off-chain), MoneyShelf is updated to this contract to protect the money from the justice system or any other gang.

Only the GodFather can withdraw and no one can deposit in this contract.

## CrimeMoney

A stablecoin pegged to USDC deposited in MoneyShelf.

## Scripts

- `Deploy.s.sol` deploys the whole protocol.
- `EmergencyMigration.s.sol` migrates MoneyShelf to MoneyVault in case of an emergency.

## Roles

- GodFather: Owner, has all the rights.
- GangMember:
  - Deposit USDC and withdraw USDC in exchange for CrimeMoney
  - Transfer CrimeMoney between members and godfather.
  - Take weapons that GodFather assigned to the member.
- External users: can only call view functions and deposit USDC.

[//]: # (contest-details-close)

[//]: # (getting-started-open)

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`
  <!-- Additional requirements here -->

## Installation

```bash
git clone https://github.com/Cyfrin/2024-05-mafia-take-down
cd 2024-05-mafia-take-down
make
```

## Quickstart

```bash
make test
```

[//]: # (getting-started-close)

[//]: # (scope-open)

# Audit Scope Details

- Commit Hash: XXX
- Files in scope:

```
├── script
│   ├── Deployer.s.sol
│   ├── EmergencyMigration.s.sol
├── src
│   ├── CrimeMoney.sol
│   ├── modules
│   │   ├── MoneyShelf.sol
│   │   ├── MoneyVault.sol
│   │   ├── Shelf.sol
│   │   └── WeaponShelf.sol
│   ├── policies
│   │   └── Laundrette.sol
```

## Compatibilities

- Solc Version: 0.8.24
- Chain(s) to deploy to:
  - Polygon
- ERC20 Token Compatibilities:
  - USDC
  - CrimeMoney

[//]: # (scope-close)

[//]: # (known-issues-open)

## Known Issues

- Missing events.
- The Mafia knows that nothing is private on blockchains, view functions will reveal what the mafia owns.
- Users can deposit on any account, not only gang member's accounts.

[//]: # (known-issues-close)
