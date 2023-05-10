// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Write a contract that maintains the account of the number of marbles an address has.

// The contract shall allow the address to open the account with a limited number of marbles. (One-time activity only)

// The contract shall allow anybody to check how many marbles a particular address has.

// Update the balance number of marbles after a successful exchange. Only allowed by the Exchange contract.

contract Marbles {
    mapping(address => uint256) balances;
    address exchange;
    
    constructor(address _exchange) {
        exchange = _exchange;
    }

    function openAccount(uint256 marbles) public {
        require(balances[msg.sender] == 0, "Account already opened");
        require(marbles > 0, "Must deposit at least one marble");
        balances[msg.sender] = marbles;
    }

    function getMarbleBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    function updateMarbleBalance(address user, uint256 newBalance) external {
        require(msg.sender == address(exchange), "Only Exchange contract can update the balance");
        balances[user] = newBalance;
    }
    
    function setExchangeContract(address _exchangeContract) external {
        require(exchange== address(0), "Exchange contract already set");
        exchange = _exchangeContract;
    }
}


