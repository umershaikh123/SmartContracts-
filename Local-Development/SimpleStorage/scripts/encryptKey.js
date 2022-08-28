const ethers = require("ethers")
const fs = require("fs-extra")
require("dotenv").config()

async function main() {
   const wallet = new ethers.Wallet(process.env.PRIVATE_KEY)
   const encryptedJsonKey = await wallet.encrypt(
      process.env.PRIVATE_KEY_PASSWORD,
      process.env.PRIVATE_KEY
   )
   console.log(encryptedJsonKey)
   fs.writeFileSync("./.encryptedKey.json", encryptedJsonKey)
}

main()
   .then(() => process.exit(0))
   .catch((error) => {
      console.error(error)
      process.exit(1)
   })

// put private key in env file
// yarn run scripts/encryptedKey.js
// remove private key from env file
// PRIVATE_KEY_PASSWORD=yourPassword yarn run scripts/encryptedKey.js
