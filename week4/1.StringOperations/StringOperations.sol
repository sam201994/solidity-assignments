// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title StringOperations
 * Contract to perform String Operations
 */

contract StringOperations {

    function findLength(string memory s) public pure returns (uint256) {
         // Convert the string to bytes
        bytes memory stringBytes = bytes(s);

        // Calculate the length
        uint256 length = stringBytes.length;

        return length;
    }

    function findAtIndex(string calldata s, uint256 i) public pure returns (string memory) {
        bytes memory stringByte = bytes(s);
        require(i < stringByte.length, "Index out of bounds");
        bytes memory characterBytes = new bytes(1);

        characterBytes[0] = stringByte[i];
        return string(characterBytes);
    } 

    function findFirstOccurrence(string memory inputString, string memory character) public pure returns (int) {
        require(bytes(character).length == 1, "string must be a single character");
        
        bytes memory inputBytes = bytes(inputString);
        bytes memory characterBytes = bytes(character);
        bytes1 target = characterBytes[0];
        
        for (uint i = 0; i < inputBytes.length; i++) {
            if (inputBytes[i] == target) {
                return int(i);
            }
        }       
        return -1;
    }  

    function replaceAllOccurence(string calldata s, string calldata x, string calldata y ) public pure returns(string memory) {
         
        bytes memory inputBytes = bytes(s);
        bytes memory xByte = bytes(x);
        bytes memory yByte = bytes(y);

        bytes1 xByte1 = xByte[0];
        bytes1 yByte1 = yByte[0];

        for (uint i = 0; i < inputBytes.length; i++) {
            if (inputBytes[i] == xByte1) {
                inputBytes[i] = yByte1;
            }
        } 

        return string(inputBytes);   

    }
}