pragma solidity ^0.8.0;

contract MyDAO {
    
    struct Proposal {
        uint256 id;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
        mapping(address => bool) hasVoted;
    }
    
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    
    uint256 public totalTokens;
    mapping(address => uint256) public tokenBalances;
    
    event ProposalCreated(uint256 indexed id, string description);
    event Voted(uint256 indexed id, address indexed voter, bool vote);
    event ProposalExecuted(uint256 indexed id);
    
    function createProposal(string memory _description) public {
        Proposal memory newProposal = Proposal({
            id: proposalCount,
            description: _description,
            yesVotes: 0,
            noVotes: 0,
            executed: false
        });
        proposals[proposalCount] = newProposal;
        proposalCount++;
        emit ProposalCreated(newProposal.id, newProposal.description);
    }
    
    function vote(uint256 _id, bool _vote) public {
        require(!proposals[_id].hasVoted[msg.sender]);
        require(tokenBalances[msg.sender] > 0);
        if (_vote) {
            proposals[_id].yesVotes += tokenBalances[msg.sender];
        } else {
            proposals[_id].noVotes += tokenBalances[msg.sender];
        }
        proposals[_id].hasVoted[msg.sender] = true;
        emit Voted(_id, msg.sender, _vote);
    }
    
    function executeProposal(uint256 _id) public {
        require(!proposals[_id].executed);
        require(proposals[_id].yesVotes > proposals[_id].noVotes);
        proposals[_id].executed = true;
        emit ProposalExecuted(_id);
    }
    
    function mintTokens(address _to, uint256 _amount) public {
        totalTokens += _amount;
        tokenBalances[_to] += _amount;
    }
    
    function burnTokens(address _from, uint256 _amount) public {
        require(tokenBalances[_from] >= _amount);
        totalTokens -= _amount;
        tokenBalances[_from] -= _amount;
    }
    
}
