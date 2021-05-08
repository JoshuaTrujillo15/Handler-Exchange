import React from 'react'
import { useHistory } from 'react-router-dom'
import QRCode from 'react-qr-code'
import Contract from './components/Contract'
import '../styles/Profile.css'

const mockData = {
    address: '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266',
    personalName: 'Joshua Trujillo',
    personalTitle: 'UI Designer',
    businessName: 'Byte-Speak',
    emailAddress: 'example@example.com',
    service: 'Build a React Web Application!',
    primary: '#303030',
    secondary: '#0a84ff',
    text: '#FFFFFF'
}

const Profile = () => {
    const history = useHistory()

    return (
        <div className='profile-container'>
            <div className='profile'>
                <div className='profile-header'>
                    <h2>My Profile</h2>
                </div>

                <div className='profile-group address'>
                    <h4>Contractor Address:</h4>
                    <QRCode value={mockData.address} fgColor='#202020' className='profile-qr' />
                    <p>{mockData.address}</p>
                </div>

                <div className='profile-group buttons'>
                    <div className='profile-button-container'>
                        <h3 className='profile-button-container-h3'>Add Offer to the Market</h3>
                        <button
                            className='button'
                            onClick={() => history.push('/new/offer/')}
                        >New Offer</button>
                    </div>
                    <div className='profile-button-container'>
                        <h3 className='profile-button-container-h3'>Create a Gig for a Client</h3>
                        <button
                            className='button'
                            onClick={() => history.push('/new/gig/')}
                        >New Gig</button>
                    </div>
                </div>

                <h3 className='profile-subheader'>Offers</h3>

                <div className='profile-group'>
                    <Contract data={mockData} />
                    <Contract data={mockData} />
                </div>

            </div>
        </div>
    )
}

export default Profile