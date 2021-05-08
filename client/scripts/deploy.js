const hre = require('hardhat');

async function main() {
    const [deployer] = await hre.ethers.getSigners()

    console.log('Deploying contracts with the account: ', deployer.address)

    const HandlerExchange = await hre.ethers.getContractFactory("HandlerExchange")
    const handlerExchange = await HandlerExchange.deploy()

    await handlerExchange.deployed()

    console.log('Handler Exchange deployed to: ', handlerExchange.address)
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.log(error)
        process.exit(1)
    })
