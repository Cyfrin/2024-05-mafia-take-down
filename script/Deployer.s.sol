// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Script, console2 } from "lib/forge-std/src/Script.sol";
import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { HelperConfig } from "script/HelperConfig.s.sol";

import { Kernel, Actions, Role } from "src/Kernel.sol";
import { CrimeMoney } from "src/CrimeMoney.sol";

import { WeaponShelf } from "src/modules/WeaponShelf.sol";
import { MoneyShelf } from "src/modules/MoneyShelf.sol";

import { Laundrette } from "src/policies/Laundrette.sol";

contract Deployer is Script {
    address public godFather;

    function run() public {
        vm.startBroadcast();
        deploy();
        vm.stopBroadcast();
    }

    function deploy() public returns (Kernel, IERC20, CrimeMoney, WeaponShelf, MoneyShelf, Laundrette) {
        godFather = msg.sender;

        // Deploy USDC mock
        HelperConfig helperConfig = new HelperConfig();
        IERC20 usdc = IERC20(helperConfig.getActiveNetworkConfig().usdc);

        Kernel kernel = new Kernel();
        CrimeMoney crimeMoney = new CrimeMoney(kernel);

        WeaponShelf weaponShelf = new WeaponShelf(kernel);
        MoneyShelf moneyShelf = new MoneyShelf(kernel, usdc, crimeMoney);
        Laundrette laundrette = new Laundrette(kernel);

        kernel.grantRole(Role.wrap("moneyshelf"), address(moneyShelf));

        kernel.executeAction(Actions.InstallModule, address(weaponShelf));
        kernel.executeAction(Actions.InstallModule, address(moneyShelf));
        kernel.executeAction(Actions.ActivatePolicy, address(laundrette));

        kernel.executeAction(Actions.ChangeAdmin, address(laundrette));
        kernel.executeAction(Actions.ChangeExecutor, godFather);

        return (kernel, usdc, crimeMoney, weaponShelf, moneyShelf, laundrette);
    }
}
