// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

struct Invoice {
    uint256 id;
    address payer;
    uint256 amount;
    uint256 date;
}

contract Gateway {
    using SafeERC20 for IERC20;

    IERC20 public currency;

    address public owner;
    address public factory;

    mapping(uint256 => Invoice) public invoices;

    event Payment(
        uint256 indexed id,
        address indexed payer,
        uint256 amount,
        uint256 date
    );

    constructor(address currencyAddress, address owner_) {
        factory = msg.sender;
        currency = IERC20(currencyAddress);
        owner = owner_;
    }

    function payInvoice(uint256 id, uint256 amount) external {
        require(invoices[id].id == 0, "Invoice already payed");

        // Transfer
        currency.safeTransferFrom(msg.sender, owner, amount);

        // Add invoice to invoices mapping
        invoices[id] = Invoice(id, msg.sender, amount, block.timestamp);

        // Emit payment
        emit Payment(id, msg.sender, amount, block.timestamp);
    }
}
