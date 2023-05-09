// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    
    /* Declare State variables */
    uint256 contractValue;
    address[] participants;
    mapping(address => uint256) public winners;
    address public immutable admin;

    /* Declare events */
    event WinnerDecided(address indexed winner, uint256 amountWon, uint256 indexed timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not admin");
        _;
    }

    constructor() {
        admin  = msg.sender;
    }

	// Pass some ether to this function and enter the lottery
    function enter() external payable {
        require(msg.value >= 0.1 ether, "Minimum 0.1 ether required to enter the lottery");
        contractValue = contractValue + msg.value;
        participants.push(msg.sender);
    }

    function claimReward() external {
        uint256 amount = winners[msg.sender];
        payable(msg.sender).transfer(amount);
    }
    
    function decideWinner() external onlyAdmin {
        uint winningIndex = random() % participants.length;
        address winnerAddress = participants[winningIndex];
        winners[winnerAddress] = contractValue;
        
        emit WinnerDecided(winnerAddress, contractValue, block.timestamp);
        
        contractValue = 0;
        participants = new address[](0);
    }

    function random() private view returns(uint) {
        // Below function generates pseudorandom uint based on admin and block.timestamp
        return uint(keccak256(abi.encodePacked(admin, block.timestamp)));
    }
}