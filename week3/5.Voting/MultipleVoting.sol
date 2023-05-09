// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


contract MultipleVoting {

    struct CandidateInfo {
        string name;
        uint votes;
    }

    struct VotingRound {
        bool isOpen;
        address leadingCandidate;
        uint leadingVotes;
    }

    mapping(uint => mapping(address => bool)) public voters;
    mapping(uint => mapping(address => CandidateInfo)) public candidates;

    address immutable public admin;
    VotingRound[] public votingRounds;
    

    event DeclareWinner(address winner, uint voteCount);

    modifier _onlyAdmin() {
        require(msg.sender == admin, "Not an admin");
        _;
    }

    modifier _votingOpen(uint roundNumber) {
        require(votingRounds.length > roundNumber, "Voting round does not exist");
        require(votingRounds[roundNumber].isOpen, "Voting has not started or already ended");
        _;
    }

    modifier _votingClosed(uint roundNumber) {
        require(votingRounds.length > roundNumber, "Voting round does not exist");
        require(!votingRounds[roundNumber].isOpen, "Voting has already started");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerCandidate(uint roundNumber, string calldata _name) _votingClosed(roundNumber) public {
        candidates[roundNumber][msg.sender] = CandidateInfo(_name, 0);
    }

    function registerVotingRound() _onlyAdmin public {
        votingRounds.push(VotingRound(false, address(0), 0));
    }

    function startVoting(uint roundNumber) _onlyAdmin _votingClosed(roundNumber) public {
        VotingRound storage targetRound = votingRounds[roundNumber];
        targetRound.isOpen = true;
    }

    function stopVoting(uint roundNumber) _onlyAdmin _votingOpen(roundNumber) public {
        VotingRound storage targetRound = votingRounds[roundNumber];
        targetRound.isOpen = false;
        emit DeclareWinner(targetRound.leadingCandidate, targetRound.leadingVotes);
    }

    function vote(uint roundNumber, address _to) _votingOpen(roundNumber) public {
        require(voters[roundNumber][msg.sender] == false, "Already voted");
        voters[roundNumber][msg.sender] = true;
        
        CandidateInfo storage candidate = candidates[roundNumber][_to];
        candidate.votes += 1;
        
        VotingRound storage targetRound = votingRounds[roundNumber];

        if (candidate.votes > targetRound.leadingVotes) {
            targetRound.leadingVotes = candidate.votes;
            targetRound.leadingCandidate = _to;
        }
    }
}