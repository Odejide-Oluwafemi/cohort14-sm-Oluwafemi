// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract GoFundMe {
  event Saved(uint256 amount);
  event Donated(address indexed donator, uint256 amount);

  address immutable i_owner;

  uint256 public minimumSavingAmount;

  uint256 public totalAmountDeposited;
  mapping (address depositor => uint256 amountSaved) public donations;

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

    totalAmountDeposited = totalAmountDeposited + msg.value;

    emit Saved(msg.value);
  }

  function donate() public payable {
    require(msg.sender != i_owner, "Owner cannot donate to himself");
    require(msg.value > 0, "Cannot Donate Zero ETH");

    donations[msg.sender] = msg.value;

    emit Donated(msg.sender, msg.value);
  }

  function withdraw() external onlyOwner {
    (bool success, ) = i_owner.call{value: address(this).balance}("");

    require(success);

    totalAmountDeposited = address(this).balance;
  }

  function getMinimunSavingAmount() external view returns (uint256) {
    return minimumSavingAmount;
  }
  
  function getTotalAmountDeposited() external view returns (uint256) {
    return totalAmountDeposited;
  }
  
  function getDepositorAmount(address donator) external view returns (uint256) {
    return donations[donator];
  }

  receive() external payable {
    donate();
  }

  fallback() external payable {
    donate();
  }
}