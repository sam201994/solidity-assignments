# Owner Control Game
An Owner Controlled smart contract that allows the contract’s owner to set the contract’s actual value (an integer).Owners can also be changed based on specific rules.


###  Requirements

**Phase 1 - Initial Set-Up**
1. At any given time, the contract can have only 1 owner/admin
2. Deployer must deposit at least 1 ETH in order to deploy the contract and become the ADMIN
3. `Getter Functions`:
		- A getter function to get the Current Admin Address.
		- A getter function to get the Current Total Value of the contract.
4. `Setter Functions`:
		- A function to set the total value of the contract.


**Phase 2 - Admin Changing Rules.** Contract Can allow anyone to become an Admin if they follow the following rules

1. User must call `Register Function` to register themselves in the contract. They must provide:
	- Name
	- UID
	- isRegistered (bool)

2. Then they can call `makeMeAdmin()` function - But there’s are following RULES
	- Caller must be a registered user.
	- Caller must deposit more ETH than previous owner
	- If caller provides more ETH than previous owner:
		- Record his/her deposited ETH Value
		- Make him/her ADMIN
3. Add necessary Require statements to handle errors


**Phase 3 - Firing Events.** Contract must fire an event for the following instances:
1. When Admin is changed
2. When total value is changed
3. When a new user is registered


**Phase 4 - Include Fund Transfers**
1. Users who are not owners currently should be able to Claim their ETH Back from the Contract.
2. Current owner should be never be able to claim ETH back.
