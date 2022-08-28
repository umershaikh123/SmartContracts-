const { expect, assert } = require("chai")
const hre = require("hardhat")
// describe("SimpleStorage", () => {})
describe("SimpleStorage", function () {
   let simpleStorageFactory, simpleStorage
   beforeEach(async function () {
      simpleStorageFactory = await hre.ethers.getContractFactory(
         "SimpleStorage"
      )
      simpleStorage = await simpleStorageFactory.deploy()
   })

   it("Age should ot be greater tha 256", async function () {
      const currentValue = await simpleStorage.getStudentAge()
      const expectedValue = "100"
      assert.equal(currentValue.toString(), expectedValue)
      assert.lengthOf(currentValue.toString(), 2, "")
   })
})
