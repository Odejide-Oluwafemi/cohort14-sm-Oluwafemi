import { expect } from "chai";
import hre from "hardhat";

const { ethers, networkHelpers } = await hre.network.connect();

describe("Week9 GoFundMe Test", function () {
  async function fixture() {
    const [signer, signer2] = await ethers.getSigners();

    const minimumSavingsAmount = ethers.parseEther("0.01");

    const Contract = await ethers.getContractFactory("GoFundMe", signer);
    const contract = await Contract.connect(signer).deploy(minimumSavingsAmount);
    await contract.waitForDeployment();

    return { signer, signer2, contract, minimumSavingsAmount};
  }

  it("Should set minimumSavingsAmount", async function () {
    const { contract, minimumSavingsAmount } = await networkHelpers.loadFixture(fixture);

    expect(await contract.getMinimunSavingAmount()).to.equals(minimumSavingsAmount);
  });

  it("Should save", async function () {
    const { signer, contract, minimumSavingsAmount } = await networkHelpers.loadFixture(fixture);

    const saveAmount = ethers.parseEther("1");

    await contract.save({value: saveAmount});

    expect(await ethers.provider.getBalance(contract)).to.equal(saveAmount);
  });
});
