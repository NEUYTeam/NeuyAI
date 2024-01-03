# NeuyAI

This repo contain all NeuyAI public code.

Repo includes:

- Sample iOS App using NeuyAI Crypto API
- Neuy ERC20 Solidity Contract
- DefiLlama Neuy Adapter javascript file
- APY 100% and APY 10% Staking Pool Source Code
- Arbitrage Scripts

## Arbitrage Script
- Basic Arbitrage script written in javascript and using the ethers.js library. This code will run locally and make calls to the polygon network DEX's'. The script searches +10 DEX's to find the best arbitrage results. Since script supports 2 paths for all exchanges, there are literally hundreds of thousands of different routes that a token can take. The best time for arbitraging is during market volatility.

- Although getting quotes doesn't require any approval. For any arbitraging to be able to be performed on your behalf, you will first need to approve the tokenin with the arbitrage contract. You can do this by using the NEUY swapping tool and only approve the amount of select token you want to arbitrage.

#### Link - Swapping tool used for approval

https://finance.neuy.io/swap/polygon/swap.aspx

#### Link - More details about Arbitrage end points

https://neuy.io/creating-a-crypto-arbitrage-and-trading-bot


## Staking Pools 

- This web source code written in javascript can be run on your local computer, but does require a wallet such as Metamask installed in your browser.

## Sample App

- The iOS sample app written in Swift and SwiftUI will require an API key which you can get for free when logging into NeuyAI. 

#### Link

https://nodes.neuy.io

![alt text](https://github.com/NEUYTeam/NeuyAI/blob/main/NeuyDeFi/Screen%20Shot%202022-06-09%20at%2011.42.47%20AM.png)
