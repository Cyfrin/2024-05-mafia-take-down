// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Kernel, Policy, Permissions, Keycode, Role, Actions } from "src/Kernel.sol";
import { toKeycode } from "src/utils/KernelUtils.sol";

import { WeaponShelf } from "src/modules/WeaponShelf.sol";
import { MoneyShelf } from "src/modules/MoneyShelf.sol";

contract Laundrette is Policy {
    /////////////////////////////////////////////////////////////////////////////////
    //                         Kernel Policy Configuration                         //
    /////////////////////////////////////////////////////////////////////////////////

    MoneyShelf private moneyShelf;
    WeaponShelf private weaponShelf;

    constructor(Kernel kernel_) Policy(kernel_) { }

    function configureDependencies() external override onlyKernel returns (Keycode[] memory dependencies) {
        dependencies = new Keycode[](2);

        dependencies[0] = toKeycode("MONEY");
        moneyShelf = MoneyShelf(getModuleAddress(toKeycode("MONEY")));

        dependencies[0] = toKeycode("WEAPN");
        weaponShelf = WeaponShelf(getModuleAddress(toKeycode("WEAPN")));
    }

    function requestPermissions() external view override onlyKernel returns (Permissions[] memory requests) {
        requests = new Permissions[](4);

        requests[0] = Permissions(toKeycode("MONEY"), moneyShelf.depositUSDC.selector);
        requests[1] = Permissions(toKeycode("MONEY"), moneyShelf.withdrawUSDC.selector);

        requests[2] = Permissions(toKeycode("WEAPN"), weaponShelf.deposit.selector);
        requests[3] = Permissions(toKeycode("WEAPN"), weaponShelf.withdraw.selector);
    }

    /////////////////////////////////////////////////////////////////////////////////
    //                                Policy Functions                             //
    /////////////////////////////////////////////////////////////////////////////////

    modifier isAuthorizedOrRevert(address account) {
        // Only the account or the godfather
        if (!(account == msg.sender || kernel.executor() == msg.sender)) {
            revert("Laundrette: you are not authorized to call this function");
        }
        _;
    }

    modifier isGodFather() {
        require(kernel.executor() == msg.sender, "Laundrette: you are not the godfather");
        _;
    }

    // Deposit from anyone is allowed, any help is appreciated for the organisation is appreciated.
    // Moreover that's convenient for ransom money.

    function depositTheCrimeMoneyInATM(address account, address to, uint256 amount) external {
        moneyShelf.depositUSDC(account, to, amount);
    }

    function putGunsInTheSuspendedCeiling(address account, uint256 amount) external isGodFather {
        weaponShelf.deposit(account, amount);
    }

    function withdrawMoney(
        address account,
        address to,
        uint256 amount
    )
        external
        onlyRole("gangmember")
        isAuthorizedOrRevert(account)
    {
        moneyShelf.withdrawUSDC(account, to, amount);
    }

    function takeGuns(address account, uint256 amount) external onlyRole("gangmember") isAuthorizedOrRevert(account) {
        weaponShelf.withdraw(account, amount);
    }

    function addToTheGang(address account) external onlyRole("gangmember") isGodFather {
        kernel.grantRole(Role.wrap("gangmember"), account);
    }

    function quitTheGang(address account) external onlyRole("gangmember") {
        kernel.revokeRole(Role.wrap("gangmember"), account);
    }

    function retrieveAdmin() external {
        kernel.executeAction(Actions.ChangeAdmin, kernel.executor());
    }
}
