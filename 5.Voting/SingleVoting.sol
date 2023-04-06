// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SingleVoting { 

    struct Candidate {
        string name;
        uint votes;
        bool isRegistered;
    }

    mapping(address => Candidate) public candidates;
    mapping(address => bool) public voters;

    address public immutable admin;
    bool votingOpen;
    uint16 votingEnded = 0; // 0 => init State, 1 => voting ended
    
    address public leadingCandidate;
    uint public leadingVotes;

    event DeclareWinner(address winner, uint votes);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not admin");
        _;
    }

    modifier votingStarted() {
        if(votingEnded == 1)
            require(votingOpen, "Voting has permanently ended");
        else
            require(votingOpen, "Voting has not yet started");
        _;
    }

    
    constructor() {
        admin = msg.sender;
    }
    

    function toggleVoting() external onlyAdmin {
        require(votingEnded == 0, "Voting has ended");
        votingOpen = !votingOpen;
        if(!votingOpen) {
            votingEnded = 1;
            emit DeclareWinner(leadingCandidate, leadingVotes);
        }
    }


    function registerCandidate(string calldata name) external votingStarted {
        candidates[msg.sender] = Candidate(name, 0, true);
    }


    function vote(address toAddress) external  votingStarted {
        require(candidates[toAddress].isRegistered, "The contestant you are sending votes to is not registered");
        require(!voters[msg.sender], "Already voted");
        
        Candidate memory c = candidates[toAddress];
        c.votes = c.votes + 1;
        voters[msg.sender] = true;
       
        if (c.votes > leadingVotes) {
            leadingVotes = c.votes;
            leadingCandidate = toAddress;
        }
    }

}