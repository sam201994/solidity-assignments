// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RToken is ERC20, Ownable {
    constructor(string memory _tokenName, string memory _tokenSymbol)
        ERC20(_tokenName, _tokenSymbol)
    {}

    function mint(address toAddress, uint256 amount) public onlyOwner {
        _mint(toAddress, amount);
    }

    function burn(address a, uint256 amount) public onlyOwner {
        _burn(a, amount);
    }
}

interface IRToken is IERC20 {
    function mint(address a, uint256 amount) external;

    function burn(address a, uint256 amount) external;
}

contract LendingBorrowing is Ownable {
    mapping(address => bool) whitelistTokens;
    mapping(address => address) public rTokenToToken; // rtokenAddress => TokenAddress
    mapping(address => address) public tokenToRToken; // tokenAddress => rTokenAddress

    modifier onlyWhiteListToken(address tokenAddress) {
        require(whitelistTokens[tokenAddress], "This token is not whitelisted");
        _;
    }

    modifier validAddress(address _address) {
        require(_address != address(0), "Token address cannot be 0");
        _;
    }

    event FundsDeposited(address indexed from, address indexed to, address indexed tokenAddress, uint256 amount);
    event FundsWithdrawn(address indexed from, address indexed to, address indexed tokenAddress, uint256 amount);

    function getReceiptTokenMetaData(address tokenAddress)
        private
        view
        validAddress(tokenAddress)
        returns (string memory, string memory)
    {
        IERC20Metadata token = IERC20Metadata(tokenAddress);
        string memory rName = string(
            abi.encodePacked("Receipt_", token.name())
        );
        string memory rSymbol = string(abi.encodePacked("r", token.symbol()));
        return (rName, rSymbol);
    }

    function createReceiptTokens(address tokenAddress) private  validAddress(tokenAddress){
        string memory rName;
        string memory rSymbol;
        (rName, rSymbol) = getReceiptTokenMetaData(tokenAddress);
        RToken rToken = new RToken(rName, rSymbol);
        tokenToRToken[tokenAddress] = address(rToken);
        rTokenToToken[address(rToken)] = tokenAddress;
    }

    function whitelistToken(address tokenAddress) public onlyOwner  validAddress(tokenAddress) {
        whitelistTokens[tokenAddress] = true;
        createReceiptTokens(tokenAddress);
    }

    function approveToken(address _tokenAddress, uint256 _amount) public  validAddress(_tokenAddress) {
        // Ensure that the contract has sufficient allowance to transfer the specified amount
        require(IERC20(_tokenAddress).approve(address(this), _amount), "Approval failed");
    }


    function depositToken(address tokenAddress, uint256 amount)
        public
        validAddress(tokenAddress)
        onlyWhiteListToken(tokenAddress)
    {
        require(amount > 0, "amount should be greater than 0");

        // Get the receipt token address
        address rTokenAddress = tokenToRToken[tokenAddress];
        require(rTokenAddress != address(0), "Receipt token not found");

        // Check if the caller has approved the contract to spend the specified amount of tokens on their behalf
        IERC20 token = IERC20(tokenAddress);
        require(token.allowance(msg.sender, address(this)) >= amount, "Token allowance too low");

        // Transfer tokens from caller to this contract
        require(token.transferFrom(msg.sender, address(this), amount), "Failed to transfer tokens");

        // Mint the equivalent amount of receipt tokens to the caller
        RToken rToken = RToken(rTokenAddress);
        rToken.mint(msg.sender, amount);
        emit FundsDeposited(msg.sender, address(this), tokenAddress, amount);
        
    }

    function withdrawToken(address rTokenAddress, uint256 amount) public validAddress(rTokenAddress) {
        require(amount > 0, "amount should be greater than 0");

        // Get the token address from  receipt  token address
        address tokenAddress = rTokenToToken[rTokenAddress];
        require(tokenAddress != address(0), "token address token not found");

        // Transfer tokens from caller to this contract
        IRToken irToken = IRToken(rTokenAddress);
        irToken.burn(msg.sender, amount);


         // Transfer tokens from contract to msg.sender
        IERC20 ierc20 = IERC20(tokenAddress);
        ierc20.transfer(msg.sender, amount);

         emit FundsWithdrawn(address(this), msg.sender, tokenAddress, amount);
    }
}
