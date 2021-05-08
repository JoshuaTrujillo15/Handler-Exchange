import React, { useState, useEffect } from 'react'
import BusinessCard from './BusinessCard'
import { ethers } from 'ethers'
import HandlerExchange from '../../artifacts/contracts/HandlerExchange.sol/HandlerExchange.json'
import { handlerExchangeAddress } from '../../constants/addresses'
import '../../styles/components/NewOffer.css'


const NewOffer = () => {
    const [account, setAccount] = useState('')
    const [name, setName] = useState('Your Name')
    const [title, setTitle] = useState('Your Title')
    const [service, setService] = useState('...')
    const [email, setEmail] = useState('example@email.com')
    const [nameError, setNameError] = useState('')
    const [titleError, setTitleError] = useState('')
    const [serviceError, setServiceError] = useState('')
    const [emailError, setEmailError] = useState('')

    const [primaryColor, setPrimaryColor] = useState('#303030')
    const [secondaryColor, setSecondaryColor] = useState('#0a84ff')
    const [textColor, setTextColor] = useState('#ffffff')

    const data = {
        address: account,
        personalName: name,
        personalTitle: title,
        emailAddress: email,
        service: service,
        primary: primaryColor,
        secondary: secondaryColor,
        text: textColor
    }

    useEffect(() => {
        if (account === '') {
            getAddress()
        }
    })

    const requestAccount = async () => {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
    }

    const getAddress = async () => {
        if (typeof window.ethereum !== 'undefined') {
            await requestAccount()
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const signer = provider.getSigner()
            const address = await signer.getAddress()
            setAccount(address)
        } else {
            setAccount('0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266')
        }
    }

    const createOffer = async () => {
        if (typeof window.ethereum !== 'undefined') {
            await requestAccount()
            const provider = new ethers.providers.Web3Provider(window.ethereum)
            const signer = provider.getSigner()
            const primary = primaryColor.replace('#', '0x') + 'ff'
            const secondary = secondaryColor.replace('#', '0x') + 'ff'
            const contract = new ethers.Contract(handlerExchangeAddress, HandlerExchange.abi, signer)
            const offer = await contract.createOffer(name, title, service, email, primary, secondary)
            await offer.wait()
        } else {
            alert('You need a web 3.0 provider to perform this action')
        }
    }

    const validateInputs = () => {
        setNameError('')
        setTitleError('')
        setServiceError('')
        setEmailError('')

        if (name === '') {
            setNameError('name required')
        }
        if (title === '') {
            setTitleError('title required')
        }
        if (service === '') {
            setServiceError('service required')
        }
        if (email === '') {
            setEmailError('email required')
        }

        // eslint-disable-next-line
        const regex = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i

        if(!regex.test(String(email).toLowerCase())) {
            setEmailError('email invalid')
        }

        if (nameError || titleError || serviceError || emailError) {
            return false
        } else {
            return true
        }
    }

    const submitHandler = e => {
        e.preventDefault()
        const isValid = validateInputs()
        if (isValid) {
            createOffer()
        }
    }


    return (
        <div className='newoffer-container'>
            <div className='newoffer'>
                <div className='newoffer-header'>
                    <h2>Create New Offer</h2>
                </div>
                <BusinessCard data={data}/>
                <p>I will {service}</p>
                <form className='newoffer-form' autoComplete='off'>
                    <div className='newoffer-form-group'>
                        <label htmlFor='name'>Name</label>
                        <input
                            onChange={e => setName(e.target.value)}
                            name='name'
                            type='text'
                            className='newoffer-input'
                        />
                        <p className='newoffer-error'>{nameError}</p>
                    </div>
                    <div className='newoffer-form-group'>
                        <label htmlFor='title'>Title</label>
                        <input
                            onChange={e => setTitle(e.target.value)}
                            name='title'
                            type='text'
                            className='newoffer-input'
                        />
                        <p className='newoffer-error'>{titleError}</p>
                    </div>
                    <div className='newoffer-form-group'>
                        <label htmlFor='service'>Service</label>
                        <input
                            onChange={e => setService(e.target.value)}
                            name='service'
                            type='text'
                            className='newoffer-input'
                        />
                        <p className='newoffer-error'>{serviceError}</p>
                    </div>
                    <div className='newoffer-form-group'>
                        <label htmlFor='email'>Email</label>
                        <input
                            onChange={e => setEmail(e.target.value)}
                            name='email'
                            type='email'
                            className='newoffer-input'
                        />
                        <p className='newoffer-error'>{emailError}</p>
                    </div>
                    <div className='newoffer-form-group colors'>
                        <div className='newoffer-form-group'>
                            <label htmlFor='primary color'>Primary Color</label>
                            <input
                                onChange={e => setPrimaryColor(e.target.value)}
                                name='primary color'
                                type='color'
                                value={primaryColor}
                                className='newoffer-input color'
                            />
                        </div>
                        <div className='newoffer-form-group'>
                            <label htmlFor='secondary color'>Secondary Color</label>
                            <input
                                onChange={e => setSecondaryColor(e.target.value)}
                                name='secondary color'
                                type='color'
                                value={secondaryColor}
                                className='newoffer-input color'
                            />
                        </div>
                        <div className='newoffer-form-group'>
                            <label htmlFor='text color'>Text Color</label>
                            <input
                                onChange={e => setTextColor(e.target.value)}
                                name='text color'
                                type='color'
                                value={textColor}
                                className='newoffer-input color'
                            />
                        </div>
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

export default NewOffer