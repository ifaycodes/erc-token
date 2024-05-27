// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {RenToken} from "../src/RenToken.sol";
import {DeployRenToken} from "../script/DeployRenToken.s.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract RenTokenTest is Test{
    RenToken public renToken;
    DeployRenToken public deployer;

    address ife = makeAddr("ife");
    address oma = makeAddr("oma");

    uint256 public constant STARTING_BALANCE = 1000;

    function setUp() public {
        deployer = new DeployRenToken();
        renToken = deployer.run();

        vm.prank(address(msg.sender));
        renToken.transfer(ife, STARTING_BALANCE);
    }

    function testIfeBalance() public view {
        assert(STARTING_BALANCE == renToken.balanceOf(ife));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(ife);
        renToken.approve(oma, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(oma);
        renToken.transferFrom(ife, oma, transferAmount);

        assertEq(renToken.balanceOf(oma), transferAmount);
        assertEq(renToken.balanceOf(ife), STARTING_BALANCE - transferAmount);
    }

    function testInitialSupply() public view {
        assertEq(renToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testApprove() public {
        uint256 amount = 1000;
        bool success = renToken.approve(ife, amount);
        assertTrue(success);

        uint256 allowance = renToken.allowance(address(this), ife);
        assertEq(allowance, amount);
    }

    function testTransfer() public {
        uint256 amount = 1000;

        vm.prank(msg.sender);
        renToken.transfer(ife, amount);
        assertEq(renToken.balanceOf(ife) - STARTING_BALANCE, amount);
    }

    function testBalanceAfterTransfer() public {
        uint256 amount = 1000;
        uint256 initialBalance = renToken.balanceOf(msg.sender);
        vm.prank(msg.sender);
        renToken.transfer(ife, amount);
        assertEq(renToken.balanceOf(msg.sender), initialBalance - amount);
    }

    function testTransferFrom() public {
        uint256 amount = 1000;

        vm.prank(msg.sender);
        renToken.approve(address(this), amount);
        renToken.transferFrom((msg.sender), ife, amount);

        uint256 remainingAllowance = renToken.balanceOf(ife) - STARTING_BALANCE;
        assertEq(remainingAllowance, amount);
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(renToken)).mint(address(this), 1);
    }
}