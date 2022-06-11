// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./Gateway.sol";

import "hardhat/console.sol";

struct GatewayContract {
    address owner;
    address contractAddress;
    address currencyAddress;
    uint256 createdAt;
}

contract GatewayFactory {
    using SafeERC20 for IERC20;

    GatewayContract[] public gateways;

    event GatewayCreated(
        address indexed owner,
        address contractAddress,
        address currencyAddress,
        uint256 date
    );

    function createGateway(address currencyAddress, address owner_)
        external
        returns (address gatewayAddress)
    {

        bytes32 salt = keccak256(
            abi.encodePacked(block.timestamp, currencyAddress, owner_)
        );

        Gateway gateway = (new Gateway){salt: salt}(currencyAddress, owner_);
        gatewayAddress = address(gateway);

        // Add gateway to gateway array
        gateways.push(
            GatewayContract(
                owner_,
                gatewayAddress,
                currencyAddress,
                block.timestamp
            )
        );

        // Emit Gateway created
        emit GatewayCreated(
            owner_,
            gatewayAddress,
            currencyAddress,
            block.timestamp
        );
    }

    function gateswaysLength() external view returns (uint256) {
        return gateways.length;
    }
}