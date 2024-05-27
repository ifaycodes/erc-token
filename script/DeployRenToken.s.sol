// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {RenToken} from "../src/RenToken.sol";

contract DeployRenToken is Script {
    
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (RenToken) {
        vm.startBroadcast();
        RenToken rt = new RenToken(INITIAL_SUPPLY);
        vm.stopBroadcast();

        return rt;
    }
}
