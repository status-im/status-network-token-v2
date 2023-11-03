// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { MiniMeBase } from "@vacp2p/minime/contracts/MiniMeBase.sol";
import { MiniMeToken } from "@vacp2p/minime/contracts/MiniMeToken.sol";
import { TokenController } from "@vacp2p/minime/contracts/TokenController.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 *  @title SNTTokenController
 *  @author r4bbit <r4bbit@status.im>
 *  @dev Testnet controller contract for SNTV2 token.
 *  It's a no operation contract that allows for generating tokens.
 *  This is useful for test networks.
 */
contract SNTTokenController is TokenController, Ownable2Step {
    error SNTTokenController_NotOpen();

    MiniMeToken public snt;

    bool public open;

    /**
     * @param _snt The address of the SNT token
     */
    constructor(address payable _snt, bool _open) {
        snt = MiniMeToken(_snt);
        open = _open;
    }

    /**
     * @notice The owner of this contract can set the open variable
     * This is useful for test networks.
     * @param _open The new value for the open variable
     */
    function setOpen(bool _open) public onlyOwner {
        open = _open;
    }

    /**
     * @notice The owner of this contract can change the controller of the SNT token
     *  Please, be sure that the owner is a trusted agent or 0x0 address.
     * @param _newController The address of the new controller
     */
    function changeController(address payable _newController) public onlyOwner {
        snt.changeController(_newController);
        emit ControllerChanged(_newController);
    }

    /**
     * @dev proxyPayment set to reject all Ether.
     */
    function proxyPayment(address) public payable override returns (bool) {
        return false;
    }

    /**
     * @dev onTransfer set to accept any transfer
     */
    function onTransfer(address, address, uint256) public pure override returns (bool) {
        return true;
    }

    /**
     * @dev onApprove set to accept any approval
     */
    function onApprove(address, address, uint256) public pure override returns (bool) {
        return true;
    }

    /**
     * @notice Generate tokens for the given address.
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     */
    function generateTokens(address _to, uint256 _amount) public {
        if (!open && msg.sender != owner()) {
            revert SNTTokenController_NotOpen();
        }
        snt.generateTokens(_to, _amount);
    }

    /**
     * @notice Destroy tokens for the given address.
     * @param _from The address that gets token removed.
     * @param _amount The amount of tokens to destroy.
     */
    function destroyTokens(address _from, uint256 _amount) public {
        if (!open && msg.sender != owner()) {
            revert SNTTokenController_NotOpen();
        }
        snt.destroyTokens(_from, _amount);
    }

    /**
     * @notice Send tokens or ether from this contract to owner.
     * @param _token Token contract to recover, 0 to extract ether.
     */
    function claimTokens(MiniMeBase _token) public onlyOwner {
        uint256 balance;
        if (address(_token) == address(0)) {
            balance = address(this).balance;
            payable(msg.sender).transfer(balance);
            return;
        } else {
            balance = _token.balanceOf(address(this));
            _token.transfer(msg.sender, balance);
        }
        emit ClaimedTokens(address(_token), msg.sender, balance);
    }

    event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
    event ControllerChanged(address indexed _newController);
}
