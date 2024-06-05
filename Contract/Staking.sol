// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is Ownable {
    using SafeERC20 for IERC20;
    IERC20 public stakingToken;
    struct Staker {
        uint256 amount;
        uint256 startTime;
        uint256 period;
        uint256 rewardDebt;
    }
    struct APYOption {
        uint256 apy;
        uint256 period;
    }
    uint256 public constant UNSTAKE_FEE = 3; 
    APYOption[] public apyOptions;
    mapping(address => Staker) public stakers;
    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
        apyOptions.push(APYOption({apy: 30, period: 30 days}));
        apyOptions.push(APYOption({apy: 60, period: 60 days}));
        apyOptions.push(APYOption({apy: 90, period: 90 days}));
    }
    function stake(uint256 amount, uint256 period) external {
        require(amount > 0, "Cannot stake 0");
        require(isValidPeriod(period), "Invalid staking period");

        stakingToken.safeTransferFrom(msg.sender, address(this), amount);

        Staker storage staker = stakers[msg.sender];
        staker.rewardDebt = calculateRewards(msg.sender);
        staker.amount += amount;
        staker.startTime = block.timestamp;
        staker.period = period;
    }
    function unstake() external {
        Staker storage staker = stakers[msg.sender];
        require(staker.amount > 0, "No tokens to unstake");

        uint256 fee = (staker.amount * UNSTAKE_FEE) / 100;
        uint256 amountAfterFee = staker.amount - fee;

        stakingToken.safeTransfer(msg.sender, amountAfterFee);
        stakingToken.safeTransfer(owner(), fee);

        staker.rewardDebt = calculateRewards(msg.sender);
        staker.amount = 0;
        staker.startTime = 0;
        staker.period = 0;
    }
    function claimRewards() external {
        Staker storage staker = stakers[msg.sender];
        uint256 rewards = calculateRewards(msg.sender);
        staker.rewardDebt = 0;
        stakingToken.safeTransfer(msg.sender, rewards);
    }
    function calculateRewards(address stakerAddress) public view returns (uint256) {
        Staker storage staker = stakers[stakerAddress];
        if (staker.amount == 0) return 0;

        uint256 stakingDuration = block.timestamp - staker.startTime;
        uint256 apy = getAPYForPeriod(staker.period);

        uint256 rewards = (staker.amount * apy * stakingDuration) / (365 days * 100);
        return rewards + staker.rewardDebt;
    }
    function getStakerInfo(address stakerAddress) external view returns (uint256 amount, uint256 startTime, uint256 rewards) {
        Staker storage staker = stakers[stakerAddress];
        amount = staker.amount;
        startTime = staker.startTime;
        rewards = calculateRewards(stakerAddress);
    }
    function isValidPeriod(uint256 period) internal view returns (bool) {
        for (uint256 i = 0; i < apyOptions.length; i++) {
            if (apyOptions[i].period == period) {
                return true;
            }
        }
        return false;
    }
    function getAPYForPeriod(uint256 period) internal view returns (uint256) {
        for (uint256 i = 0; i < apyOptions.length; i++) {
            if (apyOptions[i].period == period) {
                return apyOptions[i].apy;
            }
        }
        revert("Invalid staking period");
    }
}
