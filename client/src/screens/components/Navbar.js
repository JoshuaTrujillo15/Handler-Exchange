import React from 'react'
import { Link } from 'react-router-dom'
import Logo from '../../assets/logo.svg'

import '../../styles/components/Navbar.css'

const Navbar = () => {
    return (
        <header className='navbar'>
            <Link to='/' className='navbar-brand'>
                <img src={Logo} alt='logo' className='navbar-logo' />
                <h2>Handler X</h2>
            </Link>
            <ul className='navbar-ul'>
                <li>
                    <Link to='/profile' className='navbar-link'>Profile</Link>
                </li>
            </ul>
        </header>
    )
}

export default Navbar