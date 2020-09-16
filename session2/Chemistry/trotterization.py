import qsharp
qsharp.packages.add("Microsoft.Quantum.Chemistry")
qsharp.reload()
from qsharp.chemistry import (
    load_broombridge, 
    load_fermion_hamiltonian, 
    load_input_state, 
    encode
)

filename = 'data/hydrogen_0.2.yaml'
broombridge_data =  load_broombridge(filename)
problem_description = broombridge_data.problem_description[0]
ferm_hamiltonian = problem_description.load_fermion_hamiltonian()
input_state = load_input_state(filename, "UCCSD |G>")
(
    num_qubits, 
    hamiltonian_term_list, 
    input_state_terms, 
    energy_offset
) = encode(ferm_hamiltonian, input_state)

print(
    (
        num_qubits, 
        hamiltonian_term_list, 
        input_state_terms, 
        energy_offset
    )
)

from Test.Hydrogen import GetEnergyByTrotterization