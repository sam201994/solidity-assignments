// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


contract Crowdfunding {

    // Struct to store details of a project to be funded
    struct Project {
        address creator;
        uint totalAsk;
        uint amountRaised;
        bool fundingCompleted;
        bool fundsWithdrawn;
    }

    // Array to store all projects
    Project[] public projects;
    
    // Mapping to store contributions made by each address to a project
    mapping(uint => mapping(address => uint)) public contributions;

    
    function propose(uint amount) public {
        require(amount > 0, "Amount raised cannot be 0");

        // Create a new project struct and add it to the projects array
        Project memory newProject;
        newProject.creator = msg.sender;
        newProject.totalAsk = amount;
        
        projects.push(newProject);
    }

    function contribute(uint projectIndex) payable public {
        require(projectIndex < projects.length, "project does not exist");
        require(msg.value > 0, "Please pass Ether to contribute");

        // Get the project from the projects array
        Project storage targetProject = projects[projectIndex];
        if (targetProject.amountRaised >= targetProject.totalAsk) {
            revert("Target already achieved");
        }

        // Update the amount raised in the project and the contribution mapping
        targetProject.amountRaised += msg.value;
        contributions[projectIndex][msg.sender] += msg.value;

        // Mark the project as funding completed if the target is achieved
        if (targetProject.amountRaised >= targetProject.totalAsk) {
            targetProject.fundingCompleted = true;
        }
    }

    function withdrawContribution(uint projectIndex) public {
        require(projectIndex < projects.length, "Proposal does not exist");
        
        Project storage targetProject = projects[projectIndex];
        
        // If the project's funding is completed, then the contributor (msg.sender) cannot withdraw the funds
        if (targetProject.fundingCompleted == true) {
            revert("Withdraw not allowed");
        }

        // Get the amount contributed by the sender to the project
        uint withdrawAmount = contributions[projectIndex][msg.sender];
        require(withdrawAmount > 0, "Nothing to withdraw");

        // Update the amount raised in the project and the contribution mapping
        targetProject.amountRaised -= withdrawAmount;
        contributions[projectIndex][msg.sender] = 0;

        // Transfer the amount to the sender
        (bool sent, ) = msg.sender.call{value: withdrawAmount}("");
        require(sent, "Failed to withdraw Ether");
    }

    function withdrawFunds(uint projectIndex) public {
        require(projectIndex < projects.length, "Proposal does not exist");
        Project storage targetProject = projects[projectIndex];

        if (targetProject.fundingCompleted == false) {
            revert("Withdraw not allowed");
        }

        if (targetProject.fundsWithdrawn == true) {
            revert("Already withdrawn");
        }

        targetProject.fundsWithdrawn = true;

        (bool sent, ) = targetProject.creator.call{value: targetProject.amountRaised}("");
        require(sent, "Failed to withdraw Ether");
    }
}