// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interfaces/IERC1620.sol";

contract ERC1620 is IERC1620 {

    struct StreamIndex {
        Stream stream;
        uint256 streamId;
    }

    mapping(address => uint256) balances;
    Stream[] streamDatabase;
    address handlerToken;

    modifier streamActive(uint256 _streamId) {
        require(streamDatabase.length > _streamId, "Error: Inactive Stream");
        _;
    }

    constructor() { }

    function balaceOf(
        uint256 _streamId,
        address _addr
    ) 
        public
        view
        returns (uint256)
    {
        
    }

    function getStream(
        uint256 _streamId
    )
        public
        view
        override
        streamActive(_streamId)
        returns 
    (
        address sender,
        address recipient,
        address tokenAddress,
        uint256 balance,
        uint256 startBlock,
        uint256 stopBlock,
        uint256 payment,
        uint256 interval
    )
    {
        Stream memory queriedStream = streamDatabase[_streamId];
        return (
            queriedStream.sender,
            queriedStream.recipient,
            queriedStream.tokenAddress,
            queriedStream.balance,
            queriedStream.start,
            queriedStream.stop,
            queriedStream.payment,
            queriedStream.interval
        );
    }

    function create(
        address _recipient,
        address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
        public
        override
    {
        require(_tokenAddress == handlerToken, "incompatible token");
        require(_recipient != address(0x00), "recipient is a zero address");
        require(_recipient != address(this), "recipient is this contract");
        require(_recipient != msg.sender, "recpient is the sender");
        require(_payment > 0, "payment cannot be zero");
        require(_startBlock >= block.number, "startBlock must be a future block");
        require(_stopBlock >= _startBlock, "stopBlock must be after startBlock");
        require(_interval > 0, "interval must be greater than 0");

        Stream memory stream;
        StreamIndex memory streamIndex;

        stream.sender = msg.sender;
        stream.recipient = _recipient;
        stream.tokenAddress = _tokenAddress;
        stream.balance = 0;
        stream.start = _startBlock;
        stream.stop = _stopBlock;
        stream.payment = _payment;
        stream.interval = _interval;

        streamIndex.stream = stream;
        streamIndex.streamId = streamDatabase.length;

        emit LogCreate(
            streamDatabase.length,
            msg.sender,
            _recipient,
            _tokenAddress,
            _startBlock,
            _stopBlock,
            _payment,
            _interval
        );

    }

    function withdraw(
        uint256 _streamId,
        uint256 _funds
    )
        public
        override
        streamActive(_streamId)
    {

    }

    function preciseDivision(uint256 _a, uint256 _b, uint256 _precision) public view returns (uint256) {
        return _a * (10 ** _precision) / _b;
    }
}