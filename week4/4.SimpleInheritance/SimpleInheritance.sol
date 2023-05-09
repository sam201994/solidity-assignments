// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Interface defining the methods that should be present in each employee contract
interface IEmployee {
    function getName() external view returns (string memory);
    function getRole() external view returns (string memory);
    function getSalary() external view returns (uint);
    function calculateBonus() external view returns (uint);
}

// Base contract that implements the IEmployee interface
contract Employee is IEmployee {
    using SafeMath for uint;

    string  name;
    string  role;
    uint  salary;
    uint  bonusPercentage;
    
    constructor(string memory _name, string memory _role, uint _salary, uint _bonusPercentage) {
        name = _name;
        role = _role;
        salary = _salary;
        bonusPercentage = _bonusPercentage;
    }
    
    function getName() public view override returns (string memory) {
        return name;
    }
    
    function getRole() external view override returns (string memory) {
        return role;
    }
    
    function getSalary() external view override returns (uint) {
        return salary;
    }
    
    function calculateBonus() public view virtual override returns (uint) {
        uint bonus = salary.mul(bonusPercentage).div(100);
        return bonus;
    }
}

// Derived contract for managers
contract Manager is Employee {
    using SafeMath for uint;

    constructor(string memory _name, uint _salary) Employee(_name, "Manager", _salary, 10) {
        // Bonus percentage for managers is 10%
    }
    
    function calculateBonus() public view override returns (uint) {
        uint bonus = super.calculateBonus().add(20000);
        return bonus;
    }

}

contract Developer is Employee {
    using SafeMath for uint;
    constructor(string memory _name, uint _salary) Employee(_name, "Developer", _salary, 5) {}
    
    function calculateBonus() public view override returns (uint) {
        uint bonus = super.calculateBonus().add(10000);
        return bonus;
    }
}

contract Intern is Employee {
    constructor(string memory _name, uint _salary) Employee(_name, "Intern", _salary, 2) {}
    
    function calculateBonus() public pure override returns (uint) {
        return 0;
    }
}
