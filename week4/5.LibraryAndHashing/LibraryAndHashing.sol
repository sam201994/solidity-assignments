// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Auth Library
library Auth {
    function hashPassword(string memory _password) public pure returns (bytes32) {
        return keccak256(bytes(_password));
    }

    function verifyPassword(bytes32 _hashedPassword, string memory _password) public pure returns (bool) {
        return keccak256(bytes(_password)) == _hashedPassword;
    }
}

// UserAuthentication Contract
contract UserAuthentication {
    using Auth for *;

    struct User {
        bytes32 hashedPassword;
        bool isRegistered;
    }

    mapping(address => User) public users;

    function register(string memory _password) public {
        require(!users[msg.sender].isRegistered, "User already registered");
        users[msg.sender].hashedPassword = Auth.hashPassword(_password);
        users[msg.sender].isRegistered = true;
    }

    function login(string memory _password) public view returns (bool) {
        require(users[msg.sender].isRegistered, "User not registered");
        return Auth.verifyPassword(users[msg.sender].hashedPassword, _password);
    }

    function changePassword(string memory _oldPassword, string memory _newPassword) public {
        require(users[msg.sender].isRegistered, "User not registered");
        require(Auth.verifyPassword(users[msg.sender].hashedPassword, _oldPassword), "Invalid password");
        users[msg.sender].hashedPassword = Auth.hashPassword(_newPassword);
    }
}
