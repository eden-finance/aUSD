// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract aUSDToken is ERC20, ERC20Permit, Ownable {
    constructor()
        ERC20("Assetchain USD Yield-Bearing Token", "aUSD")
        ERC20Permit("aUSD")
        Ownable(msg.sender)
    {
        // Initial setup if needed
    }

    /**
     * @notice Mint new tokens to an address
     * @dev Only callable by the owner
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @notice Burn tokens from an address
     * @dev Only callable by the owner
     */
    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }
}
