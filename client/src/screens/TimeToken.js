import React, { useState } from 'react'
import { ethers } from 'ethers'
import TimeToken from '../artifacts/contracts/TimeToken.sol/TimeToken.json'

const TimeTokenTest = () => {
    const [testData, setTestData] = useState()
    const [accountAllowed, setAccountAllowed] = useState(false)
    const [address, setAddress] = useState()

    const timeTokenAddress = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512'
    
    const requestAccount = async () => {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
        console.log('access granted: ', window.ethereum)
        setAccountAllowed(true)
    }

    const fetchBalance = async () => {
        if (typeof window.ethereum !== 'undefined') {
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const contract = new ethers.Contract(timeTokenAddress, TimeToken.abi, provider)
            try {
                const data = await contract.balanceOf()
                setTestData(String(data))
            } catch (error) {
                console.log(error)
            }
        }
    }

    const getAddress = async () => {
        if (typeof window.ethereum !== 'undefined') {
            await requestAccount()
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const signer = provider.getSigner()
            const address = await signer.getAddress()
            console.log(address)
            console.log(typeof address)
        }
    }

    return (
        <main>
            <div className='testBox'>
                <p>{testData}</p>
                <button className='button' onClick={requestAccount}>
                    Request Account
                </button>
                <button className='button' onClick={getAddress}>
                    Get Address
                </button>
            </div>
        </main>
    )
}

export default TimeTokenTest