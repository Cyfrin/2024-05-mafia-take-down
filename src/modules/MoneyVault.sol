// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { CrimeMoney } from "src/CrimeMoney.sol";

import { Kernel, Keycode } from "src/Kernel.sol";

import { Shelf } from "src/modules/Shelf.sol";

// Emergency money vault to store USDC and

contract MoneyVault is Shelf {
    IERC20 private usdc;
    CrimeMoney private crimeMoney;

    constructor(Kernel kernel_, IERC20 _usdc, CrimeMoney _crimeMoney) Shelf(kernel_) {
        usdc = _usdc;
        crimeMoney = _crimeMoney;
    }

    function KEYCODE() public pure override returns (Keycode) {
        return Keycode.wrap("MONEY");
    }

    function depositUSDC(address, address, uint256) external pure {
        revert("MoneyVault: depositUSDC is disabled");
    }

    function withdrawUSDC(address account, address to, uint256 amount) external {
        require(to == kernel.executor(), "MoneyVault: only GodFather can receive USDC");
        withdraw(account, amount);
        crimeMoney.burn(account, amount);
        usdc.transfer(to, amount);
    }
}
