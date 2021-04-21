import React, { useState, useEffect } from 'react'
import { useWeb3React } from '@web3-react/core'
import { InjectedConnector } from '@web3-react/injected-connector'

import '../../styles/components/Wallet.css'

const injectedConnector = new InjectedConnector({
    supportedChainIds: [
        1,  // Mainet
        3,  // Ropsten
        4,  // Rinkeby
        5,  // Goerli
        42  // Kovan
    ]
})

const chainNames = [
    {
        id: 1,
        name: 'Ethereum'
    },
    {
        id: 3,
        name: 'Ropsten'
    },
    {
        id: 4,
        name: 'Rinkeby'
    },
    {
        id: 5,
        name: 'Goerli'
    },
    {
        id: 42,
        name: 'Kovan'
    },
]

const Wallet = () => {
    const [chainName, setChainName] = useState('Unknown')
    const { chainId, account, activate, active } = useWeb3React()

    useEffect(() => {
        if (chainId) {
            const chainName = chainNames.find(element => element.id === chainId)
            if (chainName !== undefined) {
                 setChainName(chainName.name)
            } else {
                console.log(`Chain Name not found by Chain Id ${chainId}`)
            }
        }
    }, [chainId])

    return (
        <div className='wallet-container'>
            <div className='wallet'>
                <p>Chain:</p>
                <p className='wallet-data'>{chainName} Network</p>
                <p>Account:</p>
                <p className='wallet-data'>{account ? account : 'Unknown'}</p>
                {
                    active ? (
                        <div>🟢 Active</div>
                    ) : (
                        <button
                            className='button'
                            onClick={() => activate(injectedConnector)}
                        >Connect Wallet</button>
                    )
                }
            </div>

        </div>
    )
}

export default Wallet