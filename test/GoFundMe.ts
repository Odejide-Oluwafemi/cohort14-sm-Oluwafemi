import { expect } from "chai";
import { network } from "hardhat";

const { ethers } = await network.connect();

describe("Week9 GoFundMe Test", function () {
  it("Should set minimumSavingsAmount", async function () {
    const counter = await ethers.deployContract("Week9");

    await expect(counter.inc()).to.emit(counter, "Increment").withArgs(1n);
  });
});
