# Lottery Smart contract
### Requirement
1. Create a Lottery smart contract that allows multiple players to participate by sending ether to the contract (say 0.1 ETH)
2. The contract should choose a random player as the winner of the lottery and send the total money held by the contract to the winner
3. Only owner of the contract should be able to pick winner randlomly
4. Emit WinnerDecided event when the winner is chosen
5. Once the winner is decided by the contract, only winner of the lottery should be able to withdraw the money.
6. The contract should be able to display the list of all participants.
7. Once the winner is decided, owner should be able to reset the lottery and restart the game.

### How to generate random number to select winner?
We use the following function:
```
function random() private view returns(uint) {
    // Below function generates pseudorandom uint based on admin and block.timestamp
    return uint(keccak256(abi.encodePacked(admin, block.timestamp)));
}
```
The function keccak256 takes an input and returns a 256-bit hash. In this case, the input is the concatenation of two values: admin, which is an address type variable, and block.timestamp, which is a uint256 variable representing the timestamp of the current block.

The abi.encodePacked function takes any number of arguments and returns a tightly packed byte array with the values of those arguments. In this case, it packs the admin address and the block.timestamp uint256 value together.

The uint function is used to convert the resulting hash to an unsigned integer type.

Overall, the purpose of this function is to generate a pseudorandom number based on the current timestamp and the address of an admin, which can be used for various purposes such as generating a unique identifier or determining the order of execution in a queue.

### How to run?
Compile and run this code though Remix IDE. Deploy it on preferred network and run different transactions and check balances of different accounts.