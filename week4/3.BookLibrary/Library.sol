// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./BookRepository.sol";

contract Library {
    uint256 private constant FEE_AMOUNT = 5 ether;
    uint256 private constant MAX_BORROW_COUNT = 2;
    uint256 private constant LATE_FINE_AMOUNT_1 = 1 ether;
    uint256 private constant LATE_FINE_AMOUNT_2 = 5 ether;
    uint256 private constant LATE_FINE_TIME_1 = 1 minutes;
    // uint256 constant private LATE_FINE_TIME_2 = 3 minutes;

    struct Member {
        bool exist;
        uint256 balance;
        mapping(uint256 => bool) borrowedBooks;
        uint256 borrowedCount;
    }

    mapping(address => Member) private members;

    BookRepository private bookRepo;

    modifier onlyMembers() {
        require(
            members[msg.sender].exist,
            "You are not a member of the library"
        );
        _;
    }

    constructor(address _bookRepo) {
        bookRepo = BookRepository(_bookRepo);
    }

    function getMemberDetails(address memberAddress)
        public
        view
        returns (
            bool,
            uint256,
            uint256
        )
    {
        require(members[memberAddress].exist, "Member does not exist");

        bool exist = members[memberAddress].exist;
        uint256 balance = members[memberAddress].balance;
        uint256 borrowedCount = members[memberAddress].borrowedCount;

        return (exist, balance, borrowedCount);
    }

    function becomeMember() public payable {
        require(msg.value == FEE_AMOUNT, "Incorrect fee amount");
        require(!members[msg.sender].exist, "Already a member");
        members[msg.sender].exist = true;
        members[msg.sender].balance = FEE_AMOUNT;
    }

    function calculateFine(uint256 _bookId) private view returns (uint256) {
        uint256 dueDate = bookRepo.getBookDetails(_bookId).dueDate;
        if (block.timestamp <= dueDate) {
            return 0;
        }
        if (
            block.timestamp > dueDate &&
            block.timestamp <= dueDate + LATE_FINE_TIME_1
        ) {
            return LATE_FINE_AMOUNT_1;
        } else {
            return LATE_FINE_AMOUNT_2;
        }
    }

    function borrowBook(uint256 _bookId) public onlyMembers {
        require(
            members[msg.sender].balance > 1 ether,
            "Minimum balance required to borrow a book is 1ETH"
        );
        require(
            members[msg.sender].borrowedCount < MAX_BORROW_COUNT,
            "Max borrow count reached"
        );
        require(
            !bookRepo.getBookDetails(_bookId).borrowed,
            "Book already borrowed"
        );
        members[msg.sender].borrowedBooks[_bookId] = true;
        members[msg.sender].borrowedCount++;
        bookRepo.borrowBook(_bookId, msg.sender);
    }

    function addFunds() public payable {
        members[msg.sender].balance += msg.value;
    }

    function returnBook(uint256 _bookId) public onlyMembers {
        require(bookRepo.getBookDetails(_bookId).borrowed, "Book not borrowed");
        require(
            members[msg.sender].borrowedBooks[_bookId],
            "Book not found in member's borrowed list"
        );

        uint256 fine = calculateFine(_bookId);
        require(
            members[msg.sender].balance >= fine,
            "You do not have enough funds to return the book"
        );

        if (fine > 0) {
            members[msg.sender].balance -= fine;
            if (fine == LATE_FINE_AMOUNT_2) {
                members[msg.sender].exist = false;
            }
        }

        bookRepo.returnBook(_bookId, msg.sender);
        delete members[msg.sender].borrowedBooks[_bookId];
        members[msg.sender].borrowedCount--;
    }

    function cancelMembership() public onlyMembers {
        require(
            members[msg.sender].borrowedCount == 0,
            "Return all borrowed books first"
        );
        uint256 balance = members[msg.sender].balance;
        members[msg.sender].exist = false;
        members[msg.sender].balance = 0;
        payable(msg.sender).transfer(balance);
    }
}
