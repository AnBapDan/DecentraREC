import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks:{
    hardhat:{},
  },
  solidity: "0.8.20",
  paths: {
    artifacts:"./artifacts",
    cache:"./cache",
    sources:"./contracts",
    tests:"./test",
  }
};

export default config;
