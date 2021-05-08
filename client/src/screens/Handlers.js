import React, { useState, useEffect } from 'react'
import { ethers } from 'ethers'
import HandlerExchange from '../artifacts/contracts/HandlerExchange.sol/HandlerExchange.json'
import { handlerExchangeAddress } from '../constants/addresses'
import '../styles/Handlers.css'

const Handlers = () => {
    const [clipboard, setClipboard] = useState('')
    const [handlerArray, setHandlerArray] = useState()

    useEffect(() => {
        if (typeof handlerArray === 'undefined') {
            getHandlers()
        }
    })

    const getHandlers = async () => {
        if (typeof window.ethereum !== 'undefined') {
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const contract = new ethers.Contract(handlerExchangeAddress, HandlerExchange.abi, provider)
            const handlers = await contract.getHandlerBatch()
            setHandlerArray(handlers.map((handler, index) => {
                const data = {
                    id: index,
                    address: handler.account,
                    fee: handler.fee.toNumber(),
                    contractsHandled: handler.transactions.toNumber(),
                    issues: handler.issues.toNumber(),
                }
                return data
            }))
        }
    }

    const copyHandler = (address) => {
        navigator.clipboard.writeText(address)
        setClipboard(address)
    }

    const handlerList = typeof handlerArray === 'undefined' ? <div/> : handlerArray.map(handler => {

        const miniAddress = handler.address.substr(0,32) + '...'

        return (
            <div className='handlers-details' key={handler.id}>
                <h3 className='handlers-username'>Handler #{handler.id}</h3>
                <ul className='handlers-ul'>
                    <li className='handlers-li'>
                        Contracts Handled:
                        <br/>
                        <span className='handlers-highlight'>{handler.contractsHandled}</span>
                    </li>
                    <li className='handlers-li'>
                        Issues:
                        <br/>
                        <span className='handlers-highlight'>{handler.issues}</span>
                    </li>
                    <li className='handlers-li'>
                        Fee:
                        <br/>
                        <span className='handlers-highlight'>{handler.fee}%</span>
                    </li>
                    <li className='handlers-li'>
                        Escrow Address:
                        <br/>
                        <span className='handlers-highlight'>{miniAddress}</span>
                    </li>
                </ul>
                <button
                    className='button handlers-copier'
                    onClick={() => copyHandler(handler.id)}
                >{clipboard === handler.address ? 'Copied!': 'Copy to Clipboard'}</button>
            </div>
        )
    })


    return (
        <div className='handlers-container'>
            <div className='handlers'>
                <h2 className='handlers-title'>Handlers List</h2>
                {handlerList}
            </div>
        </div>
    )
}

export default Handlers