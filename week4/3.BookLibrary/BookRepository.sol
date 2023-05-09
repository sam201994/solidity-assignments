// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BookRepository {
    address public librarian;

    uint256 private constant DUE_DAYS = 2 minutes;

    struct Book {
        string name;
        string author;
        bool borrowed;
        address borrower;
        uint256 dueDate;
        uint256 bookId;
    }

    mapping(uint256 => Book) public books;
    uint256 public bookIdCounter;
    uint256 public totalBooks;

    constructor() {
        librarian = msg.sender;
    }

    modifier onlyLibrarian() {
        require(
            msg.sender == librarian,
            "Only librarian can perform this action"
        );
        _;
    }

    modifier invalidBook(uint256 _bookId) {
        require(books[_bookId].bookId != 0, "Invalid book ID");
        _;
    }

    function addBook(string memory _name, string memory _author)
        public
        onlyLibrarian
    {
        bookIdCounter++;
        totalBooks++;
        books[bookIdCounter] = Book(
            _name,
            _author,
            false,
            address(0),
            0,
            bookIdCounter
        );
    }

    function burnBook(uint256 _bookId)
        public
        onlyLibrarian
        invalidBook(_bookId)
    {
        delete books[_bookId];
        totalBooks--;
    }

    function getBookDetails(uint256 _bookId)
        public
        view
        invalidBook(_bookId)
        returns (Book memory)
    {
        Book memory b = books[_bookId];
        return b;
    }

    function getAllBooks() public view returns (Book[] memory) {
        Book[] memory result = new Book[](totalBooks);
        uint256 index = 0;
        for (uint256 i = 1; i <= bookIdCounter; i++) {
            if (books[i].bookId != 0) {
                result[index] = books[i];
                index++;
            }
        }
        return result;
    }

    function borrowBook(uint256 _bookId, address borrowerAddress)
        public
        invalidBook(_bookId)
    {
        require(
            !books[_bookId].borrowed,
            "Book is not available for borrowing"
        );
        books[_bookId].borrowed = true;
        books[_bookId].borrower = borrowerAddress;
        books[_bookId].dueDate = block.timestamp + DUE_DAYS;
    }

    function returnBook(uint256 _bookId, address borrowerAddress)
        public
        invalidBook(_bookId)
    {
        require(books[_bookId].borrowed, "Book is not borrowed");
        require(
            books[_bookId].borrower == borrowerAddress,
            "Only the borrower can return the book"
        );
        books[_bookId].borrowed = false;
        books[_bookId].borrower = address(0);
        books[_bookId].dueDate = 0;
    }

    function returnTotalBooks() public view returns (uint256) {
        return totalBooks;
    }
}
