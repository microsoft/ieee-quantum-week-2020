from typing import Tuple
import argparse
import logging

_log = logging.getLogger(__name__)
_log.info("Loading Q#...")
import qsharp

from qsharp.chemistry import (
    load_broombridge, 
    load_fermion_hamiltonian, 
    load_input_state, 
    encode
)

from Test.Hydrogen import GetEnergyByTrotterization

def load_jw_encoded_data(filename: str):
    broombridge_data =  load_broombridge(filename)
    problem_description = broombridge_data.problem_description[0]
    ferm_hamiltonian = problem_description.load_fermion_hamiltonian()
    input_state = load_input_state(filename, "UCCSD |G>")
    jw_encoded = encode(ferm_hamiltonian, input_state)

    return jw_encoded

def robust_phase_estimation(
        num_qubits: int,
        hamiltonian_term_list: list,
        input_state_terms: list,
        energy_offset: float,
        num_bits_precision: int = 7,
        trotter_step_size: float = 0.4,
        trotter_order: int = 1
    ) -> Tuple[float, float]:

    jw_encoded = (
        num_qubits, 
        hamiltonian_term_list, 
        input_state_terms, 
        energy_offset
    )

    _log.info("Getting energy by trotterization...")
    phase, energy = GetEnergyByTrotterization.simulate(
        JWEncodedData=jw_encoded,
        nBitsPrecision=num_bits_precision,
        trotterStepSize=trotter_step_size,
        trotterOrder=trotter_order
    )

    _log.info(f"Phase: {phase}, Energy: {energy}")

    return (phase, energy)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="trotterization", 
        description="Use Trotterization for Robust Phase Estimation algorithm"
    )
    parser.add_argument("-n", "--num_iterations", type=int, default=1)
    parser.add_argument("-l", "--log_level", type=str, default=logging.INFO)
    parser.add_argument("-f", "--filename", type=str, default="data/hydrogen_0.2.yaml")

    args = parser.parse_args()
    _log.setLevel(args.log_level)
    num_iterations = args.num_iterations

    _log.info(
        f"Loading JW encoded data from Broombridge file from {args.filename}"
    )

    data = load_jw_encoded_data(args.filename)

    _log.info(
        f"Running Robust Phase Estimation for {num_iterations} iterations"
    )

    results = [
        robust_phase_estimation(*data) for _ in range(num_iterations)
    ]

    print(min(results, key=lambda x: x[1]))
