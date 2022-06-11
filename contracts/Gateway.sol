// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

struct Invoice {
    string id;
    address payer;
    uint256 amount;
    uint256 date;
}

contract Gateway {
    using SafeERC20 for IERC20;

    IERC20 public currency;
    address public owner;

    mapping(string => Invoice) public invoices;

    event Payment(
        string  id,
        address indexed payer,
        uint256 amount,
        uint256 date
    );

    constructor(address currencyAddress, address owner_) {
        currency = IERC20(currencyAddress);
        owner = owner_;
    }

    function payInvoice(string memory id, uint256 amount) external  {
        require(invoices[id].date == 0 , "Invoice already payed");   

        // Transfer
        currency.safeTransferFrom(msg.sender, owner, amount);  

        // Add invoice to invoices mapping
        invoices[id] = Invoice(id, msg.sender, amount, block.timestamp);

        // Emit payment
        emit Payment(id, msg.sender, amount, block.timestamp);
    }
}