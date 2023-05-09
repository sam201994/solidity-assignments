# Simple Inheritance and interfaces
Create a simple inheritance structure using Solidity contracts that represent a basic hierarchy of employees in a company. You will also need to implement an interface to define the methods that should be present in each employee contract.


###  Requirements
1. Create an `IEmployee` interface that includes the following functions:
- `getName()`
- `getRole()`
- `getSalary()`
- `calculateBonus()`

2. Create a base contract called Employee that implements the IEmployee interface. The contract should have the following state variables:
- `name` (string)
- `role` (string)
- `salary` (uint)
- `bonusPercentage` (uint)
3. Create three derived contracts, `Manager`, `Developer`, and `Intern` that inherit from the `Employee` base contract. Each of these contracts should have their own implementation of the `calculateBonus()` function based on their role-specific bonus percentage.