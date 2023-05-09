
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract KiteToken {
    
    string public name;
    string public symbol;
    uint256 public decimal;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf; 
    mapping(address => mapping(address => uint256)) public allowanceData;

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply){
        name = _name;
        symbol = _symbol;
        decimal = 18;

        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;
    }

    function transfer(address _to, uint256 _amount) external{
        require(_to != address(0), "Invalid Reciever");
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance");

        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;
    }

    // OWNER - SPENDER(who gets approved to use Owner's tokens) - Amount of tokens approved

    function approve(address spender, uint256 _approvedAmount) external{
        require(spender != address(0), "Invalid Spender");
        require(balanceOf[msg.sender] >= _approvedAmount, "Insufficient balance");

        allowanceData[msg.sender][spender] = _approvedAmount;  
    }

    function transferFrom(address tokenOwner, address _to, uint256 amount) external{
        address spender = msg.sender;
        // Allowance Check
        require(_to != address(0), "Invalid Reciever");
        require(allowanceData[tokenOwner][spender] >= amount, "Insufficient Allowance");

        balanceOf[tokenOwner] = balanceOf[tokenOwner] -  amount;
        balanceOf[_to] += amount;

        allowanceData[tokenOwner][spender] -= amount;
    }
    
}