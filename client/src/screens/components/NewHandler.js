import React, { useEffect, useState } from 'react'
import { ethers } from 'ethers'
import HandlerExchange from '../../artifacts/contracts/HandlerExchange.sol/HandlerExchange.json'
import { handlerExchangeAddress } from '../../constants/addresses'
import '../../styles/components/NewHandler.css'


const NewHandler = () => {
    const [handlerExists, setHandlerExists] = useState()
    // const [handlerData, setHandlerData] = useState()
    const [account, setAccount] = useState('')
    const [fee, setFee] = useState(1)
    const [feeError, setFeeError] = useState('')

    useEffect(() => {
        if (account === '') {
            checkForHandler()
        }
    })

    const checkForHandler = async () => {
        const address = await getAddress()
        const provider = new ethers.providers.Web3Provider(window.ethereum)
        const contract = new ethers.Contract(handlerExchangeAddress, HandlerExchange.abi, provider)
        const handlers = await contract.getHandlerBatch()
        const found = handlers.find(handler => handler.account === address)

        if (found) {
            // const firstHandler = await contract.getHandler(found)
            setHandlerExists(true)
        } else {
            setHandlerExists(false)
        }
    }

    const getAddress = async () => {
        if (typeof window.ethereum !== 'undefined') {
            await requestAccount()
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const signer = provider.getSigner()
            const address = await signer.getAddress()
            setAccount(address)
            return address
        }
    }

    const requestAccount = async () => {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
    }

    const submitHandler = () => {
        setFeeError('')
        if (isNaN(fee)) {
            setFeeError('fee is not a number')
            return
        }
        if (fee < 1 || fee > 100) {
            setFeeError('fee is out of range (1 to 1000)')
            return
        }

        registerHandler()
    }

    const registerHandler = async () => {
        if (typeof window.ethereum !== 'undefined') {
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const signer = provider.getSigner()
            const contract = new ethers.Contract(handlerExchangeAddress, HandlerExchange.abi, signer)
            try {
                const creation = await contract.registerHandler(fee)
                await creation.wait()
            } catch (err) {
                console.log(err)
            }
        }
    }


    let handlerInfo
    if (typeof handlerExists === 'undefined') {
        handlerInfo = (
            <div>
                <h3>Checking if Handler is Registered ...</h3>
            </div>
        )
    } else if (handlerExists === false) {
        handlerInfo = (
            <div>
                <h3>✅ Handler Free To Register!</h3>
            </div>
        )
    } else {
        handlerInfo = (
            <div>
                <h3>🔴 Handler Registered</h3>
            </div>
        )
    }


    const adjustedFee = isNaN(fee) ? 0 : (fee / 10)
    const adjustedFeeColor = isNaN(fee) || fee < 1 || fee > 100 ? '#FF3224' : '#0a84ff'

    return (
        <div className='newhandler-container'>
            <div className='newhandler'>
                <div className='newhandler-header'>
                    <h2>Register New Handler</h2>
                </div>
                <div className='newhandler-group'>

                    {handlerInfo}

                    <p className='newhandler-address'>{account}</p>
                </div>
                <div className='newhandler-input-group'>
                    <label htmlFor='handler fee'>Handler Fee (0.1% to 10%)</label>
                    <div className='newhandler-input-numbers'>
                        <input
                            className='newhandler-input'
                            name='handler address'
                            type='number'
                            autoComplete='off'
                            onChange={e => setFee(e.target.value !== '' ? parseInt(e.target.value) : '')}
                            value={fee}
                        />
                        <p> = <span style={{
                            color: adjustedFeeColor
                        }}>{adjustedFee}%</span></p>

                    </div>
                </div>
                <p className='newhandler-error'>{feeError}</p>
                    <button
                        className='button'
                        onClick={() => submitHandler()}
                    >Register</button>
            </div>
        </div>
    )
}

export default NewHandler