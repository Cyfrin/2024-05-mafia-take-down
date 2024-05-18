// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Script, console2 } from "lib/forge-std/src/Script.sol";
import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import { Kernel, Actions } from "src/Kernel.sol";

import { CrimeMoney } from "src/CrimeMoney.sol";

import { MoneyVault } from "src/modules/MoneyVault.sol";

contract EmergencyMigration is Script {
    address public godFather;

    function run() public {
        // To set at the deployment, no leak of addresses before.
        Kernel kernel = Kernel(address(0));
        IERC20 usdc = IERC20(address(0));
        CrimeMoney crimeMoney = CrimeMoney(address(0));

        migrate(kernel, usdc, crimeMoney);
    }

    // In case of any issue, the GodFather call this function to migrate the money shelf to a contract that only him
    // can manage the money.
    // This function has to success in any case to protect the money.
    function migrate(Kernel kernel, IERC20 usdc, CrimeMoney crimeMoney) public returns (MoneyVault) {
        vm.startBroadcast(kernel.executor());
        MoneyVault moneyVault = new MoneyVault(kernel, usdc, crimeMoney);
        kernel.executeAction(Actions.UpgradeModule, address(moneyVault));
        vm.stopBroadcast();

        // Once the problem is solved, GodFather migrate to a new contract and redistribute manually
        // all the money to gang members thanks to event monitoring and his accountant.

        return moneyVault;
    }
}
