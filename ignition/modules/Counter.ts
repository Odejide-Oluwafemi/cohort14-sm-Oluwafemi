import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from "ethers";

export default buildModule("DeploymentModule", (m) => {
  const contract = m.contract("GoFundMe", [ethers.parseEther("0.01")]);

  return { contract };
});
