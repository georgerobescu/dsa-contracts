pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


interface ListInterface {
    function accountID(address) external view returns (uint64);
}


contract InstaEvent {

    address public constant instaList = 0x0000000000000000000000000000000000000000;

    event LogCast(uint64 _smartAccount, uint96 _msgValue, address _msgSender, address _origin, bytes _targets);
    event LogConnector(bytes4 _function, bytes _eventData);

    function squeeze(address[] memory _targets) internal pure returns(bytes memory _packed) {
        bytes memory _packing;
        uint _length = _targets.length;
        _length == 1 ? _packing = abi.encodePacked(_targets[0]) :
        _length == 2 ? _packing = abi.encodePacked(_targets[0], _targets[1]) :
        _length == 3 ? _packing = abi.encodePacked(_targets[0], _targets[1], _targets[2]) :
        _length == 4 ? _packing = abi.encodePacked(_targets[0], _targets[1], _targets[2], _targets[3]) :
        _length == 5 ? _packing = abi.encodePacked(_targets[0], _targets[1], _targets[2], _targets[3], _targets[4]) :
        _length == 6 ? _packing = abi.encodePacked(_targets[0], _targets[1], _targets[2], _targets[3], _targets[4], _targets[5]) :
        _length == 7 ? _packing = abi.encodePacked(_targets[0], _targets[1], _targets[2], _targets[3], _targets[4], _targets[5], _targets[6]) :
        _length == 8 ? _packing = abi.encodePacked(_targets[0], _targets[1], _targets[2], _targets[3], _targets[4], _targets[5], _targets[6], _targets[7]) :
        _length == 9 ? _packing = abi.encodePacked(_targets[0], _targets[1], _targets[2], _targets[3], _targets[4], _targets[5], _targets[6], _targets[7], _targets[8]) :
        _packing = abi.encodePacked(_targets[0], _targets[1], _targets[2], _targets[3], _targets[4], _targets[5], _targets[6], _targets[7], _targets[8], _targets[9]);
        if (_length < 11) {
            _packed = _packing;
        } else {
            uint _newLength = _length - 10;
            address[] memory _newArr = new address[](_newLength);
            for (uint i = 0; i < _newLength; i++) {
                _newArr[i] = _targets[i + 10];
                bytes memory _extraPacking = squeeze(_newArr);
                _packed = abi.encodePacked(_packing, _extraPacking);
            }
        }
    }

    function castEvent(
        address _origin,
        address _msgSender,
        uint96 _msgValue,
        address[] calldata _targets
    ) external {
        uint64 _ID = ListInterface(instaList).accountID(msg.sender);
        require(_ID != 0, "not-SA");
        emit LogCast(_ID, _msgValue, _msgSender, _origin, squeeze(_targets));
    }

    function connectorEvent(bytes4 _function, bytes calldata _eventData) external {
        require(ListInterface(instaList).accountID(msg.sender) != 0, "not-SA");
        emit LogConnector(_function, _eventData);
    }

}