// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title StakeholderTransactionRegistry
 * @dev Demonstrates an enterprise blockchain transaction registry for multi-stakeholder ecosystems.
 */
contract StakeholderTransactionRegistry {
    address public owner;

    struct Stakeholder {
        string name;
        string stakeholderType;
        bool active;
    }

    struct EnterpriseTransaction {
        uint256 id;
        address submittedBy;
        string referenceId;
        string transactionType;
        string metadataHash;
        uint256 timestamp;
    }

    uint256 public transactionCounter;

    mapping(address => Stakeholder) public stakeholders;
    mapping(uint256 => EnterpriseTransaction) public transactions;

    event StakeholderRegistered(address indexed wallet, string name, string stakeholderType);
    event StakeholderStatusUpdated(address indexed wallet, bool active);
    event EnterpriseTransactionRecorded(
        uint256 indexed id,
        address indexed submittedBy,
        string referenceId,
        string transactionType,
        string metadataHash
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyActiveStakeholder() {
        require(stakeholders[msg.sender].active, "Only active stakeholders can submit transactions");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerStakeholder(
        address wallet,
        string memory name,
        string memory stakeholderType
    ) external onlyOwner {
        stakeholders[wallet] = Stakeholder(name, stakeholderType, true);
        emit StakeholderRegistered(wallet, name, stakeholderType);
    }

    function updateStakeholderStatus(address wallet, bool active) external onlyOwner {
        stakeholders[wallet].active = active;
        emit StakeholderStatusUpdated(wallet, active);
    }

    function recordTransaction(
        string memory referenceId,
        string memory transactionType,
        string memory metadataHash
    ) external onlyActiveStakeholder {
        transactionCounter++;

        transactions[transactionCounter] = EnterpriseTransaction(
            transactionCounter,
            msg.sender,
            referenceId,
            transactionType,
            metadataHash,
            block.timestamp
        );

        emit EnterpriseTransactionRecorded(
            transactionCounter,
            msg.sender,
            referenceId,
            transactionType,
            metadataHash
        );
    }

    function getTransaction(uint256 id) external view returns (EnterpriseTransaction memory) {
        return transactions[id];
    }
}
