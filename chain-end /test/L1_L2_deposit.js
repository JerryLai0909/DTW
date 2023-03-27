


(async () => {
    const { ethers } = require("hardhat")
    Greeter = await ethers.getContractFactory("Greeter")
    greeter = await Greeter.attach("0xE8B462EEF7Cbd4C855Ea4B65De65a5c5Bab650A9")
    await greeter.greet()
})()
