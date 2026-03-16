// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract GoFundMe {
  event Saved(uint256 amount);
  event Donated(address indexed donator, uint256 amount);

  address immutable i_owner;

  uint256 minimumSavingAmount;

  uint256 public amountOfTimesSaved;
  uint256 public amountOfTimesDonated;

  mapping (uint256 id  => mapping (uint256 amountSaved => uint256 timeDeposited)) public savings;
  mapping (uint256 id  => mapping (uint256 amountSaved => uint256 timeDeposited)) public donations;

  constructor(uint256 _minimumSavingAmount) {
    i_owner = msg.sender;

    minimumSavingAmount = _minimumSavingAmount;
  }

  modifier onlyOwner() {
    require(msg.sender == i_owner, "Only Owner can call this");

    _;
  }

  function setMinimumSavingAmount(uint256 _minimumSavingAmount) external onlyOwner {
    minimumSavingAmount = _minimumSavingAmount;
  }

  function save() external payable onlyOwner {
    require(msg.value >= minimumSavingAmount, "Deposit too low");

    amountOfTimesSaved = amountOfTimesSaved + 1;

    savings[amountOfTimesSaved][msg.value] = block.timestamp;

    emit Saved(msg.value);
  }

  function donate() public payable {
    require(msg.sender != i_owner, "Owner cannot donate to himself");
    require(msg.value > 0, "Cannot Donate Zero ETH");

    amountOfTimesDonated = amountOfTimesDonated + 1;
    donations[amountOfTimesDonated][msg.value] = block.timestamp;

    emit Donated(msg.sender, msg.value);
  }

  receive() external payable {
    donate();
  }

  fallback() external payable {
    donate();
  }
}