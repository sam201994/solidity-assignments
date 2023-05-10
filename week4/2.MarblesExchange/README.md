# Marbles for Chocolates (M/L)

While we were kids at school it was a very popular culture to trade for small things among ourselves. Like, I had hundreds of marbles that were passed on to me by my elder brothers (free inheritance), and would love to exchange them for chocolates from another kid at school. Let’s code it.

Except that in our program, there shall be no physical marbles or chocolates but only a digital ledger of exchange between marbles and of course Ether(from Remix).
 

###  Requirements
1.	Write a contract that maintains the account of the number of marbles an address has.
		- The contract shall allow the address to open the account with a limited number of 	marbles. (One-time activity only)
		- The contract shall allow anybody to check how many marbles a particular address has.
		- Update the balance number of marbles after a successful exchange. Only allowed by the Exchange contract.
		
2.  Write another contract called the `Exchange` that allows for deals between
		- The exchange contract shall allow for exchanges of Ether for marble at a fixed price set in the contract during its creation.
		- The exchange shall check if the address with marbles has the required number of marbles and swap the required Ether for marbles.
		- Throws an error when the required marbles or Ether is not sent to the contract.
		- The exchange and only the exchange shall be able to update the marble balance on a successful Marble\_Ether exchange.

3. 	This is an optional requirement. Update the exchange contract to create an exchange between Marbles and Chocolates. So there will be three contracts one for Marbles and a similar one for Chocolates. And an exchange that will validate the balances, facilitate the exchanges, and updates the balances of the marbles and chocolates between the addresses.

4.	Deploy the contracts to the Polygon’s Mumbai Testnet and execute the transaction sections there.

5.	Verify your contracts on the Mumbai Testnet
