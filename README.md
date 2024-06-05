# Token Staking Contract

This Solidity smart contract implements a token staking mechanism where users can stake tokens for a certain period of time and earn rewards based on the staking duration and annual percentage yield (APY) options provided.

## Overview

The contract provides the following functionality:

- **Staking**: Users can stake tokens for a specified period of time.
- **Unstaking**: Users can unstake their tokens after the staking period ends. A small unstake fee is applied.
- **Claiming Rewards**: Users can claim their earned rewards at any time.
- **APY Options**: The contract supports multiple APY options with different staking periods.

## Getting Started

### Requirements

- **Solidity Compiler**: Make sure you have a Solidity compiler compatible with version ^0.8.0.
- **OpenZeppelin Contracts**: This project uses OpenZeppelin for ERC20 token interactions and safe math operations.

### Installation

1. Clone the repository:

```bash
git clone https://github.com/ramykatour/Token-Staking.git
```
2. Install dependencies:
```bash
cd Token-Staking/Contract
```
3. Install dependencies:
```bash
npm install @openzeppelin/contracts
```
##  Usage

1. Deploy the contract, passing the address of the ERC20 token to be staked.
2. Users can stake tokens using the stake function, specifying the amount and staking period.
3. After the staking period, users can call the unstake function to retrieve their tokens, subject to an unstake fee.
4. Users can claim their rewards at any time using the claimRewards function.

## Contract Details

### Constants

- **UNSTAKE_FEE**: The percentage fee charged upon unstaking.

### Structs

- **Staker**: Contains information about a staker, including staked amount, start time, staking period, and reward debt.
- **APYOption**: Represents an APY option with a specified APY and staking period.

### Functions

- **stake(uint256 amount, uint256 period)**: Allows users to stake tokens for a specified period.
- **unstake()**: Allows users to unstake their tokens after the staking period ends.
- **claimRewards()**: Allows users to claim their earned rewards.
- **calculateRewards(address stakerAddress)**: Calculates the rewards earned by a staker.
- **getStakerInfo(address stakerAddress)**: Returns information about a specific staker, including staked amount, start time, and rewards.
- **isValidPeriod(uint256 period)**: Checks if a given staking period is valid.
- **getAPYForPeriod(uint256 period)**: Returns the APY for a specified staking period.

## License

[MIT](https://choosealicense.com/licenses/mit/)

