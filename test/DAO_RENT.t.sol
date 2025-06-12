// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DAO_RENT} from "../src/DAO_RENT.sol";
import {MockUSDT} from "./MockUSDT.sol";
import {console} from "forge-std/console.sol";

contract DAO_RENT_Test is Test {
    DAO_RENT public dao;
    address public user;
    address public user2;
    address public owner;
    MockUSDT public USDT;

    function setUp() public {
        user = makeAddr("user");
        user2 = makeAddr("user2");
        owner = makeAddr("owner");
        vm.deal(user, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(owner, 100 ether);

        vm.startPrank(owner);
        USDT = new MockUSDT();
        dao = new DAO_RENT(address(USDT));
        createProposal("Test Proposal");
        vm.stopPrank();
        sendUSDT(user, 100 * 10 ** 18);
    }

    function test_faile_createProposal() public {
        vm.prank(user);
        vm.expectRevert(DAO_RENT.OnlyOwner.selector);
        dao.createProposal("Test Proposal");
    }

    function test_createProposal() public {
        vm.prank(owner);
        dao.createProposal("Test Proposal");
    }

    function test_fail_vote() public {
        vm.prank(user);
        vm.expectRevert(DAO_RENT.NotMember.selector);
        dao.vote(0);
    }

    function test_faile_buyShare_InsufficientFunds() public {
        vm.startPrank(user);        

        vm.expectRevert(DAO_RENT.InsufficientFunds.selector);
        dao.buyShares(10);
        vm.stopPrank();
    }

    function test_buyShare() public {
        vm.startPrank(user);
        USDT.approve(address(dao), 100 * 10 ** 18);
        dao.buyShares(1);
        vm.stopPrank();

        assertEq(dao.shares(user), 1);
        assertEq(dao.totalSharesBought(), 1);
        assertEq(dao.isMember(user), true);
        //assertEq(dao.getProposal(0).voteCount, 1);
        //assertEq(dao.getProposal(0).description, "Test Proposal");     
    }

    function sendUSDT(address _to, uint256 _amount) public {
        vm.prank(owner);
        USDT.transfer(_to, _amount);
    }

    function createProposal(string memory _description) public {
        dao.createProposal(_description);
    }
}
