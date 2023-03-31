//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Calculator {
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function subtract(uint256 a, uint256 b) public pure returns (int256) {
        require(a >= b, "Error: First argument should be greater than the second argument");
        return a-b;
    }

    function multiply(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b;
    }

    function divide(uint256 a, uint256 b) public pure returns (uint256) {
        require(b != 0, "Error: Cannot divide by zero.");
        return a / b;
    }

    function modulo(uint256 a, uint256 b) public pure returns (uint256) {
        require(b != 0, "Error: Cannot find remainder of division by zero.");
        return a % b;
    }
}
