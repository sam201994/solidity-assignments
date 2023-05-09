# Marbles for Chocolates (M/L)

This exercise builds on top of the exercise from week 4. But this time we are taking our learnings from this week to implement the requirements. Request all to start this with fresh files/projects.

If you paid attention during the week you would have noticed that the Marbles contract from the week 4 exercise is actually an effort towards an initial version of the ERC20 contract. However, the Marbles contract we wrote has a lot of shortcomings when compared to ERC20. 
 

###  Requirements
1. Spend some time to understand the differences and how ERC20 can overcome the shortcomings. Understand the usage of approve function and use it when required.
2. Write a contract that maintains the account of the number of marbles an address has. This time use the appropriate standard.
- The contract shall allow the address to open the account with a limited number of marbles. (One-time activity only) (Hint: use the appropriate function to create marbles for yourself.)
- The contract shall allow anybody to check how many marbles a particular address has.
- Update the balance number of marbles after a successful exchange.
- Allow for marbles to be traded between the users without the intermediary exchange and also via any exchange contracts.

3. Write another contract called the Exchange that allows for trade (Use appropriate Standard functions)
- The exchange contract shall allow users to list the number of marbles they would like to sell and at what price.
- The buyer shall be able to select the seller from which he would like to buy the marbles. The exchange shall check if the address with marbles has the required number of marbles and swap the required Ether for marbles.
- Throws an error when the required marbles or Ether is not sent to the contract.
- The exchange shall be able to update the marble balance on a successful Marble Ether exchange and the listing as well.
