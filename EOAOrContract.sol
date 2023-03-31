//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract EOAOrContract {
    function isContract(address _addr) public view returns (bool) { 
        uint256 size;
        assembly { size := extcodesize(_addr) }
        return size > 0;
    }
}
