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
    const { contract } = await networkHelpers.loadFixture(fixture);

    const saveAmount = ethers.parseEther("1");

    await contract.save({value: saveAmount});

    expect(await ethers.provider.getBalance(contract)).to.equal(saveAmount);
  });

  it("Should deposit from external account", async function () {
    const { signer2, contract } = await networkHelpers.loadFixture(fixture);

    const donateAmount = ethers.parseEther("1");

    await contract.connect(signer2).donate({value: donateAmount});

    expect(await ethers.provider.getBalance(contract)).to.equal(donateAmount);
    expect(await contract.getDepositorAmount(signer2.address)).to.equals(donateAmount);
  });
});
