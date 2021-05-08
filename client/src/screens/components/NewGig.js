import React, { useState } from 'react'
import { ethers } from 'ethers'
import HandlerExchange from '../../artifacts/contracts/HandlerExchange.sol/HandlerExchange.json'
import { handlerExchangeAddress } from '../../constants/addresses'
import '../../styles/components/NewGig.css'


const NewGig = () => {
    const [clientAddress, setClientAddress] = useState('')
    const [handlerAddress, setHandlerAddress] = useState('')
    const [price, setPrice] = useState(0)
    const [initialRelease, setInitialRelease] = useState(0)
    const [clientAddressError, setClientAddressError] = useState('')
    const [handlerAddressError, setHandlerAddressError] = useState('')
    const [priceError, setPriceError] = useState('')
    const [initialReleaseError, setInitialReleaseError] = useState('')

    const releaseValue = price > 0 && initialRelease > 0 && initialRelease < 99 ? 
        Math.floor(price * (initialRelease / 100)) :
        '_'
    
    const requestAccount = async () => {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
        console.log('access granted')
    }

    const submitHandler = async e => {
        e.preventDefault()
        console.log(clientAddress, handlerAddress, initialRelease, price)
        const valid = validateInputs()
        console.log(valid)
        if (valid) {
            if (typeof window.ethereum !== 'undefined') {
                await requestAccount()
                const provider = new ethers.providers.Web3Provider(window.ethereum)
                const signer = provider.getSigner()
                try {
                    const contract = new ethers.Contract(handlerExchangeAddress, HandlerExchange.abi, signer)
                    const createGig = await contract.createGig(clientAddress, handlerAddress, price, initialRelease)
                    await createGig.wait()
                } catch (error) {
                    console.log(error)
                }
                console.log('created gig')

            } else {
                alert('You need a web 3.0 provider to perform this action')
            }
        }
    }

    const validateInputs = () => {

        setClientAddressError('')
        setHandlerAddressError('')
        setPriceError('')
        setInitialReleaseError('')

        // check if empty
        if (!clientAddress) {
            setClientAddressError('Client Address Required')
        }
        if (!handlerAddress) {
            setHandlerAddressError('Handler Address Required')
        }
        if (!price) {
            setPriceError('Price Required')
        }
        if (!initialRelease) {
            setInitialReleaseError('Initial Release Required')
        }

        // check if valid
        if(!ethers.utils.isAddress(clientAddress)) {
            setClientAddressError('Client Address is Invalid')
        }
        if(price <= 0) {
            setPriceError('Price must be greater than 0')
        }
        if(initialRelease < 0 || initialRelease > 99) {
            setClientAddressError('Initial Release must be from 0% to 99%')
        }

        if (!clientAddressError && !handlerAddressError && !priceError && !initialReleaseError) {
            return true
        } else {
            return false
        }
    }

    return (
        <div className='newgig-container'>
            <div className='newgig'>
                <div className='newgig-header'>
                    <h2>Create New Gig</h2>
                </div>
                <form className='newgig-form' autoComplete='off'>
                    <div className='newgig-form-group'>
                        <label htmlFor='client address'>Client Address</label>
                        <input
                            onChange={e => setClientAddress(e.target.value)}
                            name='client address'
                            type='text'
                            className='newgig-input'
                        />
                        <p className='newgig-error'>{clientAddressError}</p>
                    </div>
                    <div className='newgig-form-group'>
                        <label htmlFor='handler address'>Handler Id</label>
                        <input
                            onChange={e => setHandlerAddress(e.target.value)}
                            name='handler address'
                            type='text'
                            className='newgig-input'
                        />
                        <p className='newgig-error'>{handlerAddressError}</p>
                    </div>
                    <div className='newgig-form-group'>
                        <label htmlFor='price'>Price</label>
                        <div className='newgig-input-group'>
                            <input
                                onChange={e => setPrice(parseInt(e.target.value))}
                                name='price'
                                type='number'
                                className='newgig-input number'
                            />
                            <p>- HxT</p>
                        </div>
                        <p className='newgig-error'>{priceError}</p>
                    </div>
                    <div className='newgig-form-group'>
                        <label htmlFor='initial release'>Initial Release</label>
                        <div className='newgig-input-group'>
                            <input
                                onChange={e => setInitialRelease(parseInt(e.target.value))}
                                name='initial release'
                                type='number'
                                className='newgig-input number'
                            />
                            <p>% ({releaseValue} HxT)</p>
                        </div>
                        <p className='newgig-error'>{initialReleaseError}</p>
                    </div>
                    <button
                        className='button'
                        onClick={e => submitHandler(e)}
                    >Create</button>
                </form>
            </div>
        </div>

    )
}

export default NewGig