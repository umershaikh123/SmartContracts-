const ethers = require("ethers")
const fs = require("fs-extra")
require("dotenv").config()

async function main() {
   const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL)

   const encryptedJson = fs.readFileSync("./.encryptedKey.json", "utf8")
   let wallet = new ethers.Wallet.fromEncryptedJsonSync(
      encryptedJson,
      process.env.PRIVATE_KEY_PASSWORD
   )
   wallet = wallet.connect(provider)

   const abi = fs.readFileSync("./Storage_sol_userStorage.abi", "utf8")
   const binary = fs.readFileSync("./Storage_sol_userStorage.bin", "utf8")

   const contractFactory = new ethers.ContractFactory(abi, binary, wallet)
   console.log("\n Deploying contract .... \n")
   const contract = await contractFactory.deploy()
   console.log("Contract \n ")
   console.log(contract)

   const setStudent = await contract.setStudent("Ligma", "male", 420)

   const getStudent = await contract.getStudent()
   console.log(`Get Student = ${getStudent.toString()} \n`)

   const id = await contract.getID()
   console.log(`Get Id = ${id.toString()}`)
}

main()
   .then(() => process.exit(0))
   .catch((error) => {
      console.error(error)
      process.exit(1)
   })
