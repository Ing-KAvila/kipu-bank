 // actualizacion de prueba 13.30hs.

contract MyContract {
    uint public publicVar = 10;
    uint internal internalVar = 20;
    uint private privateVar = 30;

    function accessVariables() public view returns (uint, uint, uint) {
        // Él puede acceder a todas las variables, ya que están dentro del mismo contrato.
        return (publicVar, internalVar, privateVar);
    }
}

contract DerivedContract is MyContract {
    function accessInheritedVariables() public view returns (uint, uint) {
        // Puede acceder a la publicVar y a la internalVar, pero no a la privateVar.
        return (publicVar, internalVar);
    }
}
