// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@zama.ai/fhevm/lib/tfhe.sol"; // Zama FHE 库

contract ConfidentialShareholderVoting is AccessControl {
    using tfhe for *;

    bytes32 public constant BOARD_MEMBER_ROLE = keccak256("BOARD_MEMBER_ROLE");
    bytes32 public constant SHAREHOLDER_ROLE = keccak256("SHAREHOLDER_ROLE");

    struct Proposal {
        string description;
        uint256 deadline;
        bool isActive;
        bool isFinalized;
        mapping(address => bool) hasVoted;
    }

    struct EncryptedVote {
        address voter;
        uint256 proposalId;
        bytes32 encryptedChoice;
        bytes32 encryptedShares;
        bytes zkProof;
        uint256 timestamp;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => EncryptedVote) public encryptedVotes;
    uint256 public proposalCount;
    uint256 public voteId;

    event ProposalCreated(uint256 proposalId, string description, uint256 deadline);
    event EncryptedVoteCast(uint256 proposalId, address voter, bytes32 encryptedChoice);
    event ProposalFinalized(uint256 proposalId, bytes32 finalTallyHash);

    modifier validProposal(uint256 _proposalId) {
        require(_proposalId <= proposalCount, "Invalid proposal ID");
        _;
    }

    modifier onlyVerifiedShareholder() {
        require(hasRole(SHAREHOLDER_ROLE, msg.sender), "Not a verified shareholder");
        _;
    }

    modifier onlyBoardMember() {
        require(hasRole(BOARD_MEMBER_ROLE, msg.sender), "Not a board member");
        _;
    }

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(BOARD_MEMBER_ROLE, msg.sender);
    }

    function createProposal(string memory _description, uint256 _duration) external onlyBoardMember {
        proposalCount++;
        Proposal storage proposal = proposals[proposalCount];
        proposal.description = _description;
        proposal.deadline = block.timestamp + _duration;
        proposal.isActive = true;
        emit ProposalCreated(proposalCount, _description, proposal.deadline);
    }

    function castEncryptedVote(
        uint256 _proposalId,
        bytes32 _encryptedChoice,
        bytes32 _encryptedShares, 
        bytes calldata _zkProof
    ) external onlyVerifiedShareholder validProposal(_proposalId) {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.isActive, "Proposal not active");
        require(block.timestamp < proposal.deadline, "Voting period ended");
        require(!proposal.hasVoted[msg.sender], "Already voted");

        voteId++;
        encryptedVotes[voteId] = EncryptedVote({
            voter: msg.sender,
            proposalId: _proposalId,
            encryptedChoice: _encryptedChoice,
            encryptedShares: _encryptedShares,
            zkProof: _zkProof,
            timestamp: block.timestamp
        });

        proposal.hasVoted[msg.sender] = true;
        emit EncryptedVoteCast(_proposalId, msg.sender, _encryptedChoice);
    }

    function finalizeProposal(uint256 _proposalId, bytes32 _finalTallyHash) 
        external onlyBoardMember validProposal(_proposalId) {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.deadline, "Voting period not ended");
        require(proposal.isActive, "Proposal not active");
        require(!proposal.isFinalized, "Already finalized");

        proposal.isActive = false;
        proposal.isFinalized = true;
        emit ProposalFinalized(_proposalId, _finalTallyHash);
    }

    // 额外函数：验证股东、聚合结果等（使用 FHE 加法聚合）
    function aggregateVotes(uint256 _proposalId) external view onlyBoardMember returns (euint32) {
        // 示例：使用 FHE 聚合（实际需根据需求扩展）
        euint32 total = tfhe.asEuint32(0);
        // 循环添加加密投票（简化示例）
        return total;
    }
}
