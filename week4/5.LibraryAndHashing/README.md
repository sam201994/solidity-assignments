# Library and Hashing
Create a library and use it in a smart contract to manage user authentication using hashes.

###  Requirements
1. Create a library called `Auth` that includes the following functions:
- `hashPassword(string memory _password) public pure returns (bytes32)`
- `verifyPassword(bytes32 _hashedPassword, string memory _password) public pure returns (bool)`
2. Create a smart contract called `UserAuthentication` that includes the following:
- A mapping called `users` that maps an address to a struct called `User`.
- A `User` struct that includes the user's hashed password and a boolean flag to indicate if the user is registered.
3. Implement the following functions in the `UserAuthentication` contract:
- `register(string memory _password)`
- `login(string memory _password)`
- `changePassword(string memory _oldPassword, string memory _newPassword)`


