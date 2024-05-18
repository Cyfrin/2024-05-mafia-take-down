// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Kernel, Actions, Role } from "./Kernel.sol";

contract CrimeMoney is ERC20 {
    Kernel public kernel;

    constructor(Kernel _kernel) ERC20("CrimeMoney", "CRIME") {
        kernel = _kernel;
    }

    modifier onlyMoneyShelf() {
        require(kernel.hasRole(msg.sender, Role.wrap("moneyshelf")), "CrimeMoney: only MoneyShelf can mint");
        _;
    }

    function mint(address to, uint256 amount) public onlyMoneyShelf {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public onlyMoneyShelf {
        _burn(from, amount);
    }
}
