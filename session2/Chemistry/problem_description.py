import numpy as np
from pyscf import gto, scf, fci, ao2mo

from qsharp.chemistry import load_broombridge, load_fermion_hamiltonian, load_input_state, encode


def create_H2_molecule(bond_length):
    # Create molecule object with PySCF
    H2 = [['H',[ 0, 0, 0]], ['H',[0,0, bond_length]]]
    mol = gto.Mole()
    mol.atom = H2
    mol.basis = "sto-3g"
    mol.charge = 0
    mol.spin = 0
    mol.build()
    return mol

def compute_integrals(problem_description, molecule, RHF):
    """
    Compute one and two-electron integrals and output in Broombridge format
    """
    one_electron_integrals = problem_description.hamiltonian['OneElectronIntegrals']['Values']
    two_electron_integrals = problem_description.hamiltonian['TwoElectronIntegrals']['Values']
    
    # Get molecular orbital coefficients
    h_pq = np.around(RHF.mo_coeff.T @ RHF.get_hcore() @ RHF.mo_coeff, decimals=6)
    one_electron_integrals = [([j, i], h_pq[i-1, j-1]) for (j, i), _ in one_electron_integrals]

    # Get interaction terms
    h_pqrs = np.around(ao2mo.restore(1, ao2mo.kernel(molecule, RHF.mo_coeff), 2), 6)
    two_electron_integrals = [([l, k, j, i], h_pqrs[i-1, j-1, k-1, l-1]) for (l, k, j, i), _ in two_electron_integrals]

    return one_electron_integrals, two_electron_integrals

def updated_problem_description(filename, one_electron_integrals, two_electron_integrals, nuclear_repulsion):
    """Update problem description with new one and two-electrom integral and nuclear repulsion terms"""
    broombridge_data = load_broombridge(filename)
    problem_description = broombridge_data.problem_description[0]
    problem_description.hamiltonian['OneElectronIntegrals']['Values'] = one_electron_integrals
    problem_description.hamiltonian['TwoElectronIntegrals']['Values'] = two_electron_integrals
    problem_description.coulomb_repulsion['Value'] = nuclear_repulsion

    return problem_description
