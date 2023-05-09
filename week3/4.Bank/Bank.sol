// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract OwnerControlGame {

    mapping(address => uint256) public userRecords;
   
    event FundsWithdrawn(address indexed _user, uint256 amount, uint256 indexed timestamp);
    event FundsTransfer(address indexed _user, address indexed _transferTo, uint256 amount, uint256 indexed timestamp);

  
    function getMyBalance() external  view returns(uint256) {
        return userRecords[msg.sender];
    }

    function depositFunds() external payable  {
        uint256 currentBalance = userRecords[msg.sender];
        userRecords[msg.sender] = currentBalance + msg.value;
    }

    function transferFunds(uint256 amount, address transferTo) external  {
        require(userRecords[msg.sender] >= amount, "User does not have enough funds to tansfer") ;
        userRecords[msg.sender] = userRecords[msg.sender] - amount;
        userRecords[transferTo] = userRecords[transferTo] + amount;
        emit FundsTransfer(msg.sender, transferTo, amount, block.timestamp);
    }

    function withdrawFunds(uint256 amount) external  {
        require(userRecords[msg.sender] >= amount, "User does not have enough funds to withdraw") ;
        userRecords[msg.sender] = userRecords[msg.sender] - amount;
        payable(msg.sender).transfer(amount);
        emit FundsWithdrawn(msg.sender, amount, block.timestamp);
    }

}