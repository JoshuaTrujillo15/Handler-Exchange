import React, { useState } from 'react'
import { ethers } from 'ethers'

import '../../styles/components/Wallet.css'

const Wallet = () => {
    const [account, setAccount] = useState('')

    const requestAccount = async () => {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
        console.log('access granted')
    }

    const getAddress = async () => {
        if (typeof window.ethereum !== 'undefined') {
            await requestAccount()
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const signer = provider.getSigner()
            const address = await signer.getAddress()
            setAccount(address)
        }
    }

    const status = account === '' ? '🔴 Not Connected' : '🟢 Connected'
    let miniAddress = ''

    if (account !== '') {
        miniAddress = account.substring(0, 24) + '...'
    }

    return (
        <div className='wallet-container'>
            <div className='wallet'>
                <div>
                    <p>Status:</p>
                    <p>{status}</p>
                </div>
                <div>
                    <p>Address:</p>
                    <p>{miniAddress}</p>
                </div>
                <button
                    className={account ? 'button disabled' : 'button'}
                    disabled={account ? true : false}
                    onClick={getAddress}
                >{account ? 'Wallet Connected!' : 'Connect Wallet'}</button>
            </div>

        </div>
    )
}

export default Wallet