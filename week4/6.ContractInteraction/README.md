# Contract Interaction
Create a simple voting system where a main contract interacts with multiple voting contracts.

###  Requirements
1. Create a contract called `Voting` that includes the following:
- A mapping called `votes` that maps an address to a boolean value.
- A function called `castVote(bool _vote)` to allow a user to vote.
- A function called `getVote()` to retrieve the user's vote.

2. Create a contract called `VotingManager` that includes the following:
- A mapping called `votingContracts` that maps an address to a Voting contract.
- A function called `createVotingContract()` to deploy a new `Voting` contract for the sender.
- A function called `getVotingContract()` to retrieve the `Voting` contract address for the sender.
- A function called `castVote(bool _vote)` to call the `castVote` function in the sender's Voting contract.
- A function called `getMyVote()` to call the getVote function in the sender's `Voting` contract.

