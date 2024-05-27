// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DeToken{
    string public name = "De-Token";
    uint256 public totalSupply = 100000000000;
    uint8 public decimals = 18;

    mapping (address => uint256) private s_balances;

    // function name() public view returns (string memory) {
    //     return "De-Token";
    // }

    // function totalSupply() public pure returns (uint256) {
    //     return 100 ether;
    // }

    // function decimals() public pure returns (uint8) {
    //     return 18;
    // }

    function balanceOf(address account) public view {
        s_balances[account];
    }

    function transfer(address _receiver, uint256 amount) public {
        uint256 senderBalance = s_balances[msg.sender];

        require(senderBalance < amount, "Amount is more than balance!!");

        s_balances[msg.sender] = senderBalance - amount;
        s_balances[_receiver] += amount;
    }

}