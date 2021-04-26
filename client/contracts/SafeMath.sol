//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function subtract(uint256 a, uint256 b) internal pure returns (uint256) {
        return subtract(a, b, "SafeMath: subtraction overflow");
    }

    function subtract(uint256 a, uint256 b, string memory error_message) internal pure returns (uint256) {
        require(b <= a, error_message);
        uint256 c = a - b;
        return c;
    }

    function multiply(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function divide(uint256 a, uint256 b) internal pure returns (uint256) {
        return divide(a, b, "SafeMath: division by zero");
    }

    function divide(uint256 a, uint256 b, string memory error_message) internal pure returns (uint256) {
        require(b > 0, error_message);
        uint256 c = a / b;
        return c;
    }

    function modulo(uint256 a, uint256 b) internal pure returns (uint256) {
        return modulo(a, b, "SafeMath: modulo by zero");
    }

    function modulo(uint256 a, uint256 b, string memory error_message) internal pure returns (uint256) {
        require(b != 0, error_message);
        return a % b;
    }
}