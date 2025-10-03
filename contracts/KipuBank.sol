// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title KipuBank - Bóveda personal para depósitos y retiros de ETH con límites seguros
/// @author Ok
/// @notice Este contrato permite a los usuarios depositar y retirar ETH con límites definidos
/// @dev Sigue buenas prácticas como errores personalizados, patrón checks-effects-interactions y uso de eventos

contract KipuBank {
    // --- Errores personalizados ---

    /// @notice Se lanza si el depósito excede el límite global del banco
    error BankCapExceeded();

    /// @notice Se lanza si el retiro excede el umbral permitido por transacción
    error WithdrawalLimitExceeded();

    /// @notice Se lanza si el usuario intenta retirar más de lo que tiene
    error InsufficientBalance();

    // --- Eventos ---

    /// @notice Se emite cuando un usuario realiza un depósito exitoso
    /// @param user Dirección del usuario que depositó
    /// @param amount Monto depositado en wei
    event Deposited(address indexed user, uint256 amount);

    /// @notice Se emite cuando un usuario realiza un retiro exitoso
    /// @param user Dirección del usuario que retiró
    /// @param amount Monto retirado en wei
    event Withdrawn(address indexed user, uint256 amount);

    // --- Variables de estado ---

    /// @notice Saldo individual de cada usuario en su bóveda
    mapping(address => uint256) private _vault;

    /// @notice Número total de depósitos realizados en el contrato
    uint256 public totalDeposits;

    /// @notice Número total de retiros realizados en el contrato
    uint256 public totalWithdrawals;

    /// @notice Límite global de ETH que puede contener el contrato
    /// @dev Se define una sola vez en el constructor
    uint256 public immutable bankCap;

    /// @notice Límite máximo de retiro por transacción
    /// @dev Se define una sola vez en el constructor
    uint256 public immutable withdrawalLimit;

    /// @notice ETH total depositado en el contrato
    uint256 private _totalBankBalance;

    // --- Constructor ---

    /// @param _cap Límite global de depósitos en wei
    /// @param _limit Límite máximo de retiro por transacción en wei
    constructor(uint256 _cap, uint256 _limit) payable {
        bankCap = _cap;
        withdrawalLimit = _limit;
    }

    // --- Modificadores ---

    /// @notice Verifica que el depósito no exceda el límite global del banco
    /// @param amount Monto que se desea depositar
    modifier withinBankCap(uint256 amount) {
        if (_totalBankBalance + amount > bankCap) revert BankCapExceeded();
        _;
    }

    // --- Funciones públicas y externas ---

    /// @notice Permite a los usuarios depositar ETH en su bóveda personal
    /// @dev Sigue el patrón checks-effects-interactions y emite un evento
    function deposit() external payable withinBankCap(msg.value) {
        _vault[msg.sender] += msg.value;
        _totalBankBalance += msg.value;
        totalDeposits++;
        emit Deposited(msg.sender, msg.value);
    }

    /// @notice Permite a los usuarios retirar ETH de su bóveda, respetando el límite por transacción
    /// @param amount Monto a retirar en wei
    /// @dev Verifica condiciones, actualiza estado y realiza la transferencia segura
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
    /// @return Saldo en wei
    function getVaultBalance(address user) external view returns (uint256) {
        return _vault[user];
    }

    // --- Funciones privadas ---

    /// @notice Consulta el saldo total del banco
    /// @dev Función privada usada internamente
    /// @return Saldo total en wei
    function _getTotalBankBalance() private view returns (uint256) {
        return _totalBankBalance;
    }
}
