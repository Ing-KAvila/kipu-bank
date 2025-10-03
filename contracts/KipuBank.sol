// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KipuBank - Bóveda personal para depósitos y retiros de ETH con límites seguros
contract KipuBank {
    /// @notice Error lanzado cuando el depósito excede el límite global
    error BankCapExceeded();

    /// @notice Error lanzado cuando el retiro excede el umbral permitido
    error WithdrawalLimitExceeded();

    /// @notice Error lanzado cuando el usuario no tiene fondos suficientes
    error InsufficientBalance();

    /// @notice Evento emitido en cada depósito exitoso
    event Deposited(address indexed user, uint256 amount);

    /// @notice Evento emitido en cada retiro exitoso
    event Withdrawn(address indexed user, uint256 amount);

    /// @notice Saldo individual de cada usuario
    mapping(address => uint256) private _vault;

    /// @notice Número total de depósitos realizados
    uint256 public totalDeposits;

    /// @notice Número total de retiros realizados
    uint256 public totalWithdrawals;

    /// @notice Límite global de depósitos permitido
    uint256 public immutable bankCap;

    /// @notice Umbral máximo de retiro por transacción
    uint256 public immutable withdrawalLimit;

    /// @notice Total de ETH depositado en el contrato
    uint256 private _totalBankBalance;

    /// @param _cap Límite global de depósitos
    /// @param _limit Umbral máximo de retiro por transacción
    constructor(uint256 _cap, uint256 _limit) payable {
        bankCap = _cap;
        withdrawalLimit = _limit;
    }

    /// @notice Modificador para validar que el depósito no exceda el límite global
    modifier withinBankCap(uint256 amount) {
        if (_totalBankBalance + amount > bankCap) revert BankCapExceeded();
        _;
    }

    /// @notice Permite a los usuarios depositar ETH en su bóveda personal
    /// @dev Sigue el patrón checks-effects-interactions
    function deposit() external payable withinBankCap(msg.value) {
        _vault[msg.sender] += msg.value;
        _totalBankBalance += msg.value;
        totalDeposits++;
        emit Deposited(msg.sender, msg.value);
    }

    /// @notice Permite retirar hasta el límite establecido
    /// @dev Usa call para transferencias seguras y actualiza el estado antes de interactuar
    function withdraw(uint256 amount) external {
        uint256 userBalance = _vault[msg.sender];
        if (userBalance < amount) revert InsufficientBalance();
        if (amount > withdrawalLimit) revert WithdrawalLimitExceeded();

        _vault[msg.sender] -= amount;
        _totalBankBalance -= amount;
        totalWithdrawals++;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transferencia fallida");

        emit Withdrawn(msg.sender, amount);
    }

    /// @notice Consulta el saldo de la bóveda de un usuario
    /// @param user Dirección del usuario
    /// @return Saldo en ETH
    function getVaultBalance(address user) external view returns (uint256) {
        return _vault[user];
    }

    /// @notice Consulta el saldo total del banco
    /// @return Saldo total en ETH
    function _getTotalBankBalance() private view returns (uint256) {
        return _totalBankBalance;
    }
}
