pragma solidity ^0.8.0;

contract MyNFT {
    
    uint256 public tokenCount;
    
    mapping(uint256 => address) public tokenOwners;
    mapping(address => uint256) public ownerTokenCounts;
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    
    struct Token {
        string name;
        string symbol;
        uint256 id;
        address owner;
    }
    
    Token[] public tokens;
    
    function createToken(string memory _name, string memory _symbol) public returns (uint256) {
        Token memory newToken = Token({
            name: _name,
            symbol: _symbol,
            id: tokenCount,
            owner: msg.sender
        });
        tokens.push(newToken);
        tokenOwners[tokenCount] = msg.sender;
        ownerTokenCounts[msg.sender]++;
        emit Transfer(address(0), msg.sender, tokenCount);
        tokenCount++;
        return tokenCount - 1;
    }
    
    function transfer(address _to, uint256 _tokenId) public {
        require(tokenOwners[_tokenId] == msg.sender);
        require(_to != address(0));
        tokenOwners[_tokenId] = _to;
        ownerTokenCounts[msg.sender]--;
        ownerTokenCounts[_to]++;
        emit Transfer(msg.sender, _to, _tokenId);
    }
    
}
