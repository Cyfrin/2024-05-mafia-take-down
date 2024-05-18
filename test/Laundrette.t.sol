// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { BaseTest, console } from "test/Base.t.sol";
import { Role } from "src/Kernel.sol";

contract LaundretteTest is BaseTest {
    function test_joinAndQuitGang() public {
        joinGang(address(this));
        assertEq(kernel.hasRole(address(this), Role.wrap("gangmember")), true);
        laundrette.quitTheGang(address(this));
        assertEq(kernel.hasRole(address(this), Role.wrap("gangmember")), false);
    }

    function test_depositAndWithdrawUSDC() public {
        vm.prank(godFather);
        usdc.transfer(address(this), 100e6);
        usdc.approve(address(moneyShelf), 100e6);
        laundrette.depositTheCrimeMoneyInATM(address(this), address(this), 100e6);
        assertEq(usdc.balanceOf(address(this)), 0);
        assertEq(usdc.balanceOf(address(moneyShelf)), 100e6);
        assertEq(crimeMoney.balanceOf(address(this)), 100e6);

        joinGang(address(this));
        laundrette.withdrawMoney(address(this), address(this), 100e6);
        assertEq(usdc.balanceOf(address(this)), 100e6);
        assertEq(usdc.balanceOf(address(moneyShelf)), 0);
        assertEq(crimeMoney.balanceOf(address(this)), 0);
    }

    function test_depositAndWithdrawWeapon() public {
        vm.prank(godFather);
        laundrette.putGunsInTheSuspendedCeiling(address(this), 3);
        assertEq(weaponShelf.getAccountAmount(address(this)), 3);

        joinGang(address(this));
        laundrette.takeGuns(address(this), 3);
        assertEq(weaponShelf.getAccountAmount(address(this)), 0);
    }
}
