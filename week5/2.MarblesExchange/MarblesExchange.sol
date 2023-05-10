// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// The contract shall allow the address to open the account with a limited number of marbles. (One-time activity only) (Hint: use the appropriate function to create marbles for yourself.)

// The contract shall allow anybody to check how many marbles a particular address has.

// Update the balance number of marbles after a successful exchange.

// Allow for marbles to be traded between the users without the intermediary exchange and also via any exchange contracts.

contract MarbleToken is ERC20 {
    // open account with limited number of supply
    constructor(uint256 initialSupply) ERC20("Marble Token", "MARB") {
        _mint(msg.sender, initialSupply);
    }

    // balanceOf() -> to check number of tokens an address has
    // transfer() ->  Update the balance number of marbles after a successful exchange.
    // transferFrom() -> Allow for marbles to be traded between the users via any exchange contracts.
    // approve() ->
}

// Write another contract called the Exchange that allows for trade (Use appropriate Standard functions)

// The exchange contract shall allow users to list the number of marbles they would like to sell and at what price.

// The buyer shall be able to select the seller from which he would like to buy the marbles. The exchange shall check if the address with marbles has the required number of marbles and swap the required Ether for marbles.

// Throws an error when the required marbles or Ether is not sent to the contract.

// The exchange shall be able to update the marble balance on a successful Marble Ether exchange and the listing as well.

contract Exchange {
    using SafeMath for uint256;

    MarbleToken private _marbleToken;

    constructor(address marbleTokenAddress) {
        _marbleToken = MarbleToken(marbleTokenAddress);
    }

    // mapping (address -> (balance of mabrbel it wants to stake, conversion rate))
    // buyMarbels (fromAddress) -> update the balance of marbeles in ERC contract and in mapping

    struct MarbleStake {
        uint256 stakedAmount;
        uint256 marbleRateInWei;
    }

    mapping(address => MarbleStake) marbleStakes;

    function buyMarbles(address payable _fromAddress) external payable {
        require(msg.value > 0, "You must send ether to buy marbles.");

        uint256 marbleRate = marbleStakes[_fromAddress].marbleRateInWei;
        uint256 marbleStake = marbleStakes[_fromAddress].stakedAmount;
        uint256 marbleCount = (msg.value).div(marbleRate);
        require(marbleCount <= marbleStake, "Not enough marbles staked.");
        address owner = _fromAddress;
        address spender = address(this);
        require(_marbleToken.allowance(owner, spender) >= marbleCount, "Token allowance too low");
        
        _marbleToken.transferFrom(_fromAddress, msg.sender, marbleCount);

        _fromAddress.transfer(msg.value);

        marbleStakes[_fromAddress].stakedAmount -= marbleCount;

        // 1 ether = 1000000000000000000 wei
        // marbleRateInWei = 10000 wei
        // marbleCount = msg.value / marbleRateInWei

        // send eth along with the address that you want to buy from
        // calculate num of marbles for given msg.value of eth and check if the address has desired num of marbles staked
        // transfer the marbles from given address to msg.sender using transferFrom
        // deduct the marble stake from marblesStakes(address)
    }

    function stakeMarbles(uint256 _amount, uint256 _marbleRateInWei) external {
        require(
            _amount <= _marbleToken.balanceOf(msg.sender),
            "Staked amount should be less than the token balance in wallet."
        );
        address owner = msg.sender;
        address spender = address(this);
        require(_marbleToken.allowance(owner, spender) >= _amount, "Token allowance too low");
        marbleStakes[msg.sender].stakedAmount = _amount;
        marbleStakes[msg.sender].marbleRateInWei = _marbleRateInWei;

        // take amount of marbles and marbleRateInWei and add that to the marbleStakes
        // check if the msg.sender address has that many marbles to stake or not
        // if a stake already exists, replace it with the new stake
    }

    function getStakeByAddress(address _stakerAddress)
        external
        view
        returns (MarbleStake memory)
    {
        MarbleStake memory m = marbleStakes[_stakerAddress];
        return m;
        // accept an address, check if this address has an stake in the contract
        // return the stakedAmount with marbleRateInWei
    }
}

// seller
// ExchangeContract
// buyer

// 1. buyer purchases directly from seller => transfer function
// 2. buyer purchases via ExchangeContract => seller will approve some amount to spender(in this case ExchangeContract),
//    now ExchangeContract can call transferFrom(sellerAddress,
// 3.
