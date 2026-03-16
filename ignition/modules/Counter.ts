import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("DeploymentModule", (m) => {
  const contract = m.contract("GoFundMe");

  return { counter };
});
