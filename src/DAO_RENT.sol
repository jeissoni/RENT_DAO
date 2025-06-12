// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";

contract DAO_RENT {
    error OnlyOwner();
    error NotMember();
    error InsufficientFunds();
    error InsufficientShares();

    event SharesBought(address indexed buyer, uint256 amount);

    address public usdt;
    address public owner;
    uint256 public proposalCount;

    // shares of the DAO
    uint256 public totalShares;
    uint256 public totalSharesBought;
    uint256 public USDTbyShare;

    mapping(address => uint256) public shares;
    mapping(address => bool) public isMember;

    // Proposals of the DAO
    struct Proposal {
        address proposer;
        uint256 proposalId;
        string description;
        uint256 voteCount;
        bool isActive;
    }

    mapping(uint256 => Proposal) public proposals;

    //modifiers
    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    constructor(address _usdt) {
        owner = msg.sender;
        totalShares = 500;
        usdt = _usdt;
        USDTbyShare = 100 * 10 ** 18;
    }

    function createProposal(string memory _description) public onlyOwner {
        Proposal memory newProposal = Proposal({
            proposer: msg.sender,
            proposalId: proposalCount,
            description: _description,
            voteCount: 0,
            isActive: true
        });
        proposals[proposalCount] = newProposal;
        proposalCount++;
    }

    //only members can vote
    function vote(uint256 _proposalId) public {
        if (!isMember[msg.sender]) revert NotMember();
        Proposal storage proposal = proposals[_proposalId];
        proposal.voteCount += shares[msg.sender];
    }

    function getProposal(
        uint256 _proposalId
    ) public view returns (Proposal memory) {
        return proposals[_proposalId];
    }

    function getProposalCount() public view returns (uint256) {
        return proposalCount;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Only owner can transfer ownership");
        owner = newOwner;
    }

    //buy shares with USDT, 100 USDT = 1 share
    function buyShares(uint256 amountShares) public  {
        uint256 amountUSDT = amountShares * USDTbyShare;
        uint256 usdtBalance = IERC20(usdt).balanceOf(msg.sender);
        console.log("usdtBalance", usdtBalance);
        
        if (usdtBalance < amountUSDT) revert InsufficientFunds();
       
        //check if the user has enough USDT to buy the shares
        if (amountUSDT > usdtBalance) revert InsufficientFunds();
       

        //check if the user has enough shares
        if (totalSharesBought + amountShares > totalShares) revert InsufficientShares();
        
        //buy shares
        shares[msg.sender] += amountShares;
        totalSharesBought += amountShares;

        //transfer USDT to the DAO
        IERC20(usdt).transferFrom(msg.sender, address(this), amountUSDT);
        //add the user to the members
        isMember[msg.sender] = true;
        //emit an event
        emit SharesBought(msg.sender, amountShares);
    }

    function sellShares(uint256 amount) public {
        require(shares[msg.sender] >= amount, "Insufficient shares");
        shares[msg.sender] -= amount;
        totalShares -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getShares(address member) public view returns (uint256) {
        return shares[member];
    }
}
