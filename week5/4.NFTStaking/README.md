# Deposits and Withdrawals (L)

**What is staking?**

Staking refers to the process of holding a cryptocurrency in a wallet/protocol to support the operations of a blockchain network. In return for staking, holders receive rewards in the form of additional cryptocurrency. Staking is often used as a way to incentivize network participation and to help secure the network against malicious actors. Staking is commonly used in Proof of Stake (PoS) networks, as opposed to Proof of Work (PoW) networks where miners compete to solve complex mathematical problems to validate transactions and receive rewards.

We are going to use NFT Staking slightly differently in a simple way.
 

###  Requirements

1. Create your own collection of NFT using the ERC721 standard

2. Create an ERC20 reward token which is redeemable by the users on staking the NFT.

3. Create a Staking contract that shall have the below functionality

4. It allows users to stake the NFTs from the collection above

5. It allows users to unstake the staked NFTs from the contract.

6. It shall allow the users to earn stake rewards in the form of reward tokens. As a sample let's say the protocol gives about 0.5 reward tokens for every 10 mins the NFT is staked. And allows for these rewards to be withdrawn by the user.

7. The reward accumulation shall stop once the user NFT is unstacked.

8. Create 2 versions of the contracts one with regular functions and one with safe functions

9. Understand and contemplate the usage of safe functions.

10. Understand the usage of callback functions. They are a must to get the safe functions working
