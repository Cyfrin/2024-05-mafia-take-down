// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { BaseTest, console } from "test/Base.t.sol";
import { Role, Keycode } from "src/Kernel.sol";

import { EmergencyMigration } from "script/EmergencyMigration.s.sol";
import { MoneyShelf } from "src/modules/MoneyShelf.sol";
import { MoneyVault } from "src/modules/MoneyVault.sol";

contract EmergencyMigrationTest is BaseTest {
    function test_migrate() public {
        assertEq(address(kernel.getModuleForKeycode(Keycode.wrap("MONEY"))), address(moneyShelf));

        EmergencyMigration migration = new EmergencyMigration();
        MoneyVault moneyVault = migration.migrate(kernel, usdc, crimeMoney);

        assertNotEq(address(moneyShelf), address(moneyVault));
        assertEq(address(kernel.getModuleForKeycode(Keycode.wrap("MONEY"))), address(moneyVault));
    }
}
