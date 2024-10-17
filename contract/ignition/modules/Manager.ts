// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";



const ManagerModule = buildModule("ManagerModule", (m) => {

  const manager = m.contract("FootballManagers");

  return { manager };
});

export default ManagerModule;
