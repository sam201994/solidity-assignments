// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract OwnerControlGame {
    address owner;
    uint256 contractValue;
    uint256 public minThresholdETH = 1 ether;
    
    struct User {
        address userAddress;
        bool isRegistered;
        bool ownerFlag;
        uint256 deposit;
    }

    mapping(address => User) public userRecords;

    event OwnerChanged(address indexed oldOwner, address indexed newOwner, uint256 indexed timestamp);
    event NewUserRegistered(address indexed _user, uint256 indexed timestamp);

    modifier checkUser(address _userAddress){
        require(_userAddress == msg.sender, "Impersonating user - Bad call");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Caller is not Owner");
        _;
    }

    modifier notCurrentOwner() {
        require(msg.sender != owner, "Owner is not allowed to withdraw funds");
        _;
    }

    constructor() payable { 
        // Want to check if ETHER provided is 1 or more than - If not, revert
        require(msg.value >= minThresholdETH, "Invalid Amount Passed");
        // If success - make the deployer as the owner.
        owner = msg.sender;
        // If success - initialize contract's value as whatever value is passed by deployer
        contractValue = msg.value;
        
        User memory newUser;
        newUser.userAddress = owner;
        newUser.isRegistered = true;
        newUser.ownerFlag = true;
        newUser.deposit = msg.value;

        userRecords[owner] = newUser;
        
        
    }

    function getOwnerData() internal view returns(User memory) {
        return userRecords[owner];
    }

    function getOwner() external view returns(address){
        return owner;
    }

    function getContractValue() external view returns(uint256){
        return contractValue;
    }
    
    function setContractValue() external onlyOwner() payable {
        require(msg.value > getOwnerData().deposit, "Invalid amount");
        
        User memory user = userRecords[msg.sender];
        userRecords[msg.sender].deposit = user.deposit + msg.value;

        contractValue += msg.value;
    }

    function register(address _userAddress) external checkUser(_userAddress){
        User memory newUser;
        newUser.userAddress = _userAddress;        
        newUser.isRegistered = true;
        newUser.ownerFlag = false;

        userRecords[msg.sender] = newUser;

        emit NewUserRegistered(msg.sender, block.timestamp);

    }

    function makeMeAdmin() external payable {
        User memory user = userRecords[msg.sender];

        require(user.isRegistered, "User is not registered");
        require(msg.value > getOwnerData().deposit,"Less deposit than prev owner");

        address oldOwner = owner;
        owner = msg.sender;
        contractValue += msg.value;
        userRecords[msg.sender].ownerFlag = true;
        userRecords[msg.sender].deposit = msg.value;

        emit OwnerChanged(oldOwner, msg.sender, block.timestamp);
    }

    function withdrawFunds(uint256 amount) external notCurrentOwner() {
        User memory user = userRecords[msg.sender];
        require(user.isRegistered, "User is not registered");
        require(user.ownerFlag, "User was never an owner");
        require(user.deposit >= amount, "User does not have enough funds to withdraw") ;
        userRecords[msg.sender].deposit = user.deposit - amount;

        if(user.deposit == amount) {
           userRecords[msg.sender].ownerFlag = false;
           userRecords[msg.sender].isRegistered = false;
        }
        contractValue = contractValue - amount;
    }
}

    // Write a function that allows:
    // - Previous owners should be able to withdraw their ETH
    // - Current owner should not even be able to call this function 
    // - Once withdrawan, the contract's value should decrease as well
    // - Once withdrawan, mark the User/caller as NOT REGISTERED.
