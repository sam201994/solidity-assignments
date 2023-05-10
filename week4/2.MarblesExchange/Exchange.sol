// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Marbles.sol";
// Write another contract called the Exchange that allows for deals between

// The exchange contract shall allow for exchanges of Ether for marble at a fixed price set in the contract during its creation.

// The exchange shall check if the address with marbles has the required number of marbles and swap the required Ether for marbles.

// Throws an error when the required marbles or Ether is not sent to the contract.

// The exchange and only the exchange shall be able to update the marble balance on a successful Marble_Ether exchange.

contract Exchange {
    Marbles public marblesContract;
    uint256 public etherToMarbleRate;

    constructor(address _marblesContract, uint256 _etherToMarbleRate) {
        marblesContract = Marbles(_marblesContract);
        etherToMarbleRate = _etherToMarbleRate;
    }

    function buyMarbles(address payable _sellerAddress) public payable {
        uint256 marblesToBuy = msg.value * etherToMarbleRate; // 10
        uint256 sellerMarbleBalance = marblesContract.getMarbleBalance(_sellerAddress); // 100
        require(sellerMarbleBalance >= marblesToBuy, "Not enough marbles available");
        _sellerAddress.transfer(msg.value);
        marblesContract.updateMarbleBalance(_sellerAddress, sellerMarbleBalance - marblesToBuy);
        marblesContract.updateMarbleBalance(msg.sender,  marblesContract.getMarbleBalance(msg.sender) + marblesToBuy);
    }
}