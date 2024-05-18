// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { BaseTest, console } from "test/Base.t.sol";

contract DeployTest is BaseTest {
    function test_deploy() public view {
        console.log("kernel", address(kernel));
        console.log("usdc", address(usdc));
        console.log("crimeMoney", address(crimeMoney));
        console.log("weaponShelf", address(weaponShelf));
        console.log("moneyShelf", address(moneyShelf));
        console.log("laundrette", address(laundrette));
    }
}
