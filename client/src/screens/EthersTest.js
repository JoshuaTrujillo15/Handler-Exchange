import React, { useState } from 'react'

import { ethers } from 'ethers'
import HandlerXToken from '../artifacts/contracts/HandlerXToken.sol/HandlerXToken.json'

const handlerXTokenAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3'

const EthersTest = () => {
    const [testData, setTestData] = useState()
    const [testAccount, setTestAccount] = useState('')
    const [amount, setAmount] = useState(0)

    const firstAccount = '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266'
    const secondAccount = '0x8BfFB8B98a97166E14833eDCE3a2AdC0DcA9AfB2'

    const requestAccount = async () => {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
        console.log('access granted: ', window.ethereum)
    }

    const fetchBalance = async () => {
        if (typeof window.ethereum !== 'undefined') {
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const contract = new ethers.Contract(handlerXTokenAddress, HandlerXToken.abi, provider)
            try {
                const data = await contract.balanceOf()
                // setTestData(data)
                setTestData(String(data))
            } catch (error) {
                console.log('Error: ', error)
            }
        }
    }

    const transfer = async () => {
        if (typeof window.ethereum !== 'undefined') {
            await requestAccount()
            const decimals = await getDecimals()
            const bigAmount = ethers.BigNumber.from(amount)
            const bigTen = ethers.BigNumber.from(10)
            const bigDecimals = ethers.BigNumber.from(decimals)
            const bigPrecision = bigTen.pow(bigDecimals)
            const bigFull = bigAmount.mul(bigPrecision)

            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const signer = provider.getSigner()
            const contract = new ethers.Contract(handlerXTokenAddress, HandlerXToken.abi, signer)
            const transaction = await contract.transfer(testAccount, bigFull)
            await transaction.wait()
            console.log(`${amount} HXT sent to ${testAccount}`)
        }
    }

    const getDecimals = async () => {
        if (typeof window.ethereum !== 'undefined') {
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const contract = new ethers.Contract(handlerXTokenAddress, HandlerXToken.abi, provider)
            try {
                const data = await contract.decimals()
                return data
            } catch (error) {
                console.log(error)
            }
        }
    }

    const getBlockNumber = async () => {
        if (typeof window.ethereum !== 'undefined') {
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const data = await provider._getBlock()
            console.log(data.number)
        }
    }

    return (
        <div className='screen'>
            <main>
                <div className='testBox'>
                    <h2>Testing Ethers Stuff</h2>
                    <p>testType: {typeof testData}</p>
                    <p>testData: {testData}</p>
                    <p>firstAccount: {firstAccount}</p>
                    <p>secondAccount:</p>
                    <input onChange={e => setTestAccount(e.target.value)} />
                    <p>amount:</p>
                    <input onChange={e => setAmount(Number(e.target.value))} />
                    <button
                        className='button'
                        onClick={getBlockNumber}
                    >test</button>
                </div>
            </main>
        </div>
    )
}

export default EthersTest