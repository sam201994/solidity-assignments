# Book Library
As a Solidity Smart Contract Developer, you were asked to design smart contracts for the management of a library. Let’s code the smart contracts.


###  Requirements
1. A contract called `Book Repository` has the complete list of Books. Below are its functionalities
- Given the ID get the Book details
- Each Book has the following details
    - Name
    - Author
    - Borrowed vs available. 
    - If borrowed by whom.
    - Due Date if borrowed
    - Book Id
    
- Only a librarian is allowed to add fresh copies to the repo or burn it from the repo
- Show the list of books

2. A contract called `Library` allows only the members of the library to borrow books via the library contract.
- One can become a member after paying a small fee of 5 ETH.
- One address can borrow only 2 books
- Any late returns beyond a certain time (5-10 mins or so as per your comfort) are fined at 1 ETH, that shall be deducted from the member balance
- Any late returns beyond a certain time (30 mins or so as per your comfort) are fined 5 ETH and barred from borrowing
- A member can cancel the member ship and reclaim his remaining balance after returning the books.