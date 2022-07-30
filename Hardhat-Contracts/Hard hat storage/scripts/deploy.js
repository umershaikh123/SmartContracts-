// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
// const { hre, run, network } = require("hardhat");
const hre = require("hardhat")
const { run, network } = require("hardhat")

async function main() {
   const StorageFactory = await hre.ethers.getContractFactory("Storage")
   console.log("\n Deploying contract... \n")
   const storage = await StorageFactory.deploy()
   await storage.deployed()
   console.log(`Deployed contract to: ${storage.address}`)

   if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
      console.log("Waiting for block confirmations...")
      await storage.deployTransaction.wait(6)
      await verify(storage.address, [])
   }

   const setStudent = await storage.setStudent("Sigma", "male", 420)

   const getStudent = await storage.getStudent()
   console.log(`Get Student = ${getStudent.toString()} \n`)

   const id = await storage.getID()
   console.log(`Get Id = ${id.toString()}`)
}

const verify = async (contractAddress, args) => {
   console.log("\n Verifying contract... \n")

   try {
      await run("verify:verify", {
         address: contractAddress,
         constructorArguments: args,
      })
   } catch (e) {
      if (e.message.toLowerCase().includes("already verified")) {
         console.log("Already Verified!")
      } else {
         console.log(e)
      }
   }
}

main()
   .then(() => process.exit(0))
   .catch((error) => {
      console.error(error)
      process.exit(1)
   })
