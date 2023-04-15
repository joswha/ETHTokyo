# dApp/Contract Verifier

This project implements a missing link of trust in the web3 ecosystem: a decentralized mechanism for users to verify that they are interacting with the correct smart contracts and dApp for the protocol they intend.
It is implemented in two components: a dApp/contract registry for protocols, and a MetaMask snap that checks potential transactions against the registry. 

The registry is a smart contract that allows protocols to announce their web2 dApp domains and confirm ownership while also indicating which smart contract addresses belong to the dApp.
This public indication on the blockchain where users can interact with their protocol is intended to be part of a larger entity verification mechanism, where protocols can announce their legitimate points of contact for both web2 and web3 (dApp domains, smart contract addresses for each chain, Twitter, discord, etc) and confirm ownership of each, like a decentralized keybase.io for web3 entities.

The other main component of this project is a Metamask snap that allows users to query the registry for each transaction, verifying that the dApp domain is registered and that the smart contract addresses match the domain.
A fully-realized implementation of this scheme would prevent users from interacting with lookalike scam websites (because the registry would confirm ownership of multiple identity references) and could even stop front-end hacks (because the attacker would need to co-opt the domain, demonstrate ownership, and publicly update the trusted contract addresses in the registry).
In the future this mechanism could be implemented as part of every wallet to provide an indication of trust similar to the familiar green checkbox in the URL bar for browsers.

The ultimate vision of this project is a verification mechanism that can work on any blockchain and gives users the confidence that they're interacting with the actual protocol, much the same way that the certificate authorities provide users confidence for web2, but in a decentralized manner.

## Polygon Requirements

* Polygon PoS Mumbai Testnet: https://mumbai.polygonscan.com/address/0x12974e9bf72c651cec7b716812c119ae0a5916b8
* Tweet: TODO

## Scroll Requirements

* Scroll Alpha Testnet: https://blockscout.scroll.io/address/0x12974E9bF72c651CEc7B716812c119aE0a5916b8

## Mantle Requirements

* Mantle Testnet: https://explorer.testnet.mantle.xyz/address/0x12974E9bF72c651CEc7B716812c119aE0a5916b8

## Linea Requirements

* Linea Testnet: https://explorer.prealpha.zkevm.consensys.net/address/0x12974E9bF72c651CEc7B716812c119aE0a5916b8
* See tokyo.txt

## Celo Requirements

* Celo Alfajores Testnet: https://alfajores.celoscan.io/address/0x12974E9bF72c651CEc7B716812c119aE0a5916b8
