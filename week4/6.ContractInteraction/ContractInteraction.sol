// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Voting {
    mapping(address => bool) public votes;

    function castVote(bool _vote) public {
        votes[msg.sender] = _vote;
    }

    function getVote() public view returns (bool) {
        return votes[msg.sender];
    }
}

contract VotingManager {
    mapping(address => Voting) public votingContracts;

    function createVotingContract() public {
        Voting voting = new Voting();
        votingContracts[msg.sender] = voting;
    }

    function getVotingContract() public view returns (address) {
        return address(votingContracts[msg.sender]);
    }

    function castVote(bool _vote) public {
        Voting voting = votingContracts[msg.sender];
        require(address(voting) != address(0), "No voting contract found for sender");
        voting.castVote(_vote);
    }

    function getMyVote() public view returns (bool) {
        Voting voting = votingContracts[msg.sender];
        require(address(voting) != address(0), "No voting contract found for sender");
        return voting.getVote();
    }
}
