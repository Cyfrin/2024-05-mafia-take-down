// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Test, console } from "lib/forge-std/src/Test.sol";
import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import { CrimeMoney } from "src/CrimeMoney.sol";
import { Kernel, Role } from "src/Kernel.sol";
import { WeaponShelf } from "src/modules/WeaponShelf.sol";
import { MoneyShelf } from "src/modules/MoneyShelf.sol";
import { Laundrette } from "src/policies/Laundrette.sol";

import { Deployer } from "script/Deployer.s.sol";

contract BaseTest is Test {
    Deployer public deployer;

    IERC20 public usdc;

    Kernel public kernel;
    CrimeMoney public crimeMoney;

    WeaponShelf public weaponShelf;
    MoneyShelf public moneyShelf;
    Laundrette public laundrette;

    address godFather = makeAddr("God Father");

    function setUp() public {
        deployer = new Deployer();
        vm.prank(godFather);
        (kernel, usdc, crimeMoney, weaponShelf, moneyShelf, laundrette) = deployer.deploy();
    }

    function joinGang(address account) internal {
        vm.prank(kernel.admin());
        kernel.grantRole(Role.wrap("gangmember"), godFather);
        vm.prank(godFather);
        laundrette.addToTheGang(account);
    }
}
