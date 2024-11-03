// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./aUSDToken.sol";
import "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IAToken} from "@aave/core-v3/contracts/interfaces/IAToken.sol";

contract aUSDManager is Ownable, ReentrancyGuard {
    ERC20PermitOwnable public aUSDTokenContract;
    IERC20 public immutable USDCToken;
    IAToken public immutable aUSDCToken;

    address public constant EDEN_POOL_PROXY =
        0x0EB0E45d670e23Cd1E1A94eFDD26D93aFcA2CdFe;
    uint16 constant POOL_REFERRAL_CODE = 32944;

    mapping(address => uint) public deposits;

    event Deposited(
        address indexed user,
        uint256 usdcAmount,
        uint256 aUSDMinted,
        uint256 timestamp
    );

    event Withdrawn(
        address indexed user,
        uint256 usdcAmount,
        uint256 aUSDBurned,
        uint256 timestamp
    );

    constructor(
        address _aUSDToken,
        address _usdcToken,
        address _aUSDCToken
    ) Ownable(msg.sender) {
        require(_aUSDToken != address(0), "Invalid aUSD token address");
        require(_usdcToken != address(0), "Invalid USDC token address");
        require(_aUSDCToken != address(0), "Invalid aUSDC token address");

        aUSDTokenContract = ERC20PermitOwnable(_aUSDToken);
        USDCToken = IERC20(_usdcToken);
        aUSDCToken = IAToken(_aUSDCToken);
    }

    /**
     * @dev Mint aUSD by depositing equivalent USDC
     * @param amount USDC amount to mint equivalent aUSD
     */
    function deposit(uint256 amount) external nonReentrant {
        require(amount > 0, "amount must be a positive number");

        uint256 allowance = USDCToken.allowance(msg.sender, address(this));
        require(allowance >= amount, "insufficient allowance.");

        bool sent = USDCToken.transferFrom(msg.sender, address(this), amount);
        require(sent, "transaction failed");

        uint256 initialATokenBalance = aUSDCToken.balanceOf(address(this));

        USDCToken.approve(EDEN_POOL_PROXY, amount);

        try
            IPool(EDEN_POOL_PROXY).supply(
                address(USDCToken),
                amount,
                address(this),
                POOL_REFERRAL_CODE
            )
        {
            // Verify we received the correct amount of aTokens
            require(
                aUSDCToken.balanceOf(address(this)) >=
                    initialATokenBalance + amount,
                "aToken minting failed"
            );

            aUSDTokenContract.mint(msg.sender, amount);
            deposits[msg.sender] += amount;

            emit Deposited(msg.sender, amount, amount, block.timestamp);
        } catch {
            revert("Pool supply failed");
        }
    }

    /**
     * @dev Withdraw USDC by burning aUSD
     * @param amount Amount of aUSD to burn
     */
    function withdraw(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be positive");
        require(deposits[msg.sender] >= amount, "Insufficient deposit");

        require(
            aUSDCToken.balanceOf(address(this)) >= amount,
            "Insufficient aToken balance"
        );

        uint256 allowance = aUSDTokenContract.allowance(
            msg.sender,
            address(this)
        );
        require(allowance >= amount, "Not enough allowance to burn tokens");

        aUSDTokenContract.burnFrom(msg.sender, amount);

        require(
            aUSDCToken.approve(EDEN_POOL_PROXY, amount),
            "Pool approval failed"
        );

        try
            IPool(EDEN_POOL_PROXY).withdraw(
                address(USDCToken),
                amount,
                address(this)
            )
        {
            require(
                USDCToken.transfer(msg.sender, amount),
                "USDC transfer failed"
            );

            deposits[msg.sender] -= amount;

            emit Withdrawn(msg.sender, amount, amount, block.timestamp);
        } catch {
            revert("Pool withdrawal failed");
        }
    }
}
