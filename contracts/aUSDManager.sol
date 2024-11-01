// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./aUSDToken.sol";
import "@aave/core-v3/contracts/interfaces/IPool.sol";

contract aUSDManager is Ownable, ReentrancyGuard {
    ERC20PermitOwnable public aUSDTokenContract;
    IERC20 public USDCToken;

    address public constant EDEN_POOL_PROXY =
        0x0EB0E45d670e23Cd1E1A94eFDD26D93aFcA2CdFe;
    uint16 constant POOL_REFERRAL_CODE = 32944;

    mapping(address => uint) public deposits;

    event Deposited(
        address indexed user,
        uint256 usdcAmount,
        uint256 aUSDMinted
    );

    constructor(address _aUSDToken, address _usdcToken) Ownable(msg.sender) {
        aUSDTokenContract = ERC20PermitOwnable(_aUSDToken);
        USDCToken = IERC20(_usdcToken);
    }

    /**
     * @dev Mint aUSD by depositing equivalent USDC
     * @param amount USDC amount to mint equivalent aUSD
     */
    function deposit(uint256 amount) external nonReentrant {
        require(amount > 0, "amount must be a positive number");

        // check allowance
        uint256 allowance = USDCToken.allowance(msg.sender, address(this));
        require(allowance >= amount, "insufficient allowance.");

        // transfer USDC from msg.sender to address(this)
        bool sent = USDCToken.transferFrom(msg.sender, address(this), amount);
        require(sent, "transaction failed");

        // allow IPool to spend USDC
        USDCToken.approve(EDEN_POOL_PROXY, amount);

        IPool(EDEN_POOL_PROXY).supply(
            address(USDCToken),
            amount,
            address(this),
            POOL_REFERRAL_CODE
        );

        // supply USDC to IPool
        aUSDTokenContract.mint(msg.sender, amount);
        deposits[msg.sender] += amount;

        emit Deposited(msg.sender, amount, amount);
    }
}
