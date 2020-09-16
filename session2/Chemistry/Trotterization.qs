namespace Test.Hydrogen {

    open Microsoft.Quantum.Core;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Chemistry;
    open Microsoft.Quantum.Chemistry.JordanWigner;  
	open Microsoft.Quantum.Simulation;	
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    operation GetEnergyByTrotterization (
        // nSpinOrbitals: Int,
        // HamiltonianTerm11: Int[],
        // HamiltonianTerm12: Double[],
        // HamiltonianTerm21: Int[],
        // HamiltonianTerm22: Double[],
        // HamiltonianTerm31: Int[],
        // HamiltonianTerm32: Double[],
        // HamiltonianTerm41: Int[],
        // HamiltonianTerm42: Double[],
        // inputState1: Int,
        // InputState21: Double,
        // InputState22: Double,
        // inputState3: Int[],
        // energyOffset: Double,
        qSharpData: JordanWignerEncodingData,
        nBitsPrecision : Int, 
        trotterStepSize : Double, 
        trotterOrder : Int
    ) : (Double, Double) {

        // let JWInputState = JordanWignerInputState((InputState21, InputState22), inputState3);
        // let inputState = (inputState1, JWInputState);
        // let HamiltonianTerms = JWOptimizedHTerms(
        //     HTerm(HamiltonianTerm11, HamiltonianTerm12),
        //     HTerm(HamiltonianTerm21, HamiltonianTerm22),
        //     HTerm(HamiltonianTerm31, HamiltonianTerm32),
        //     HTerm(HamiltonianTerm41, HamiltonianTerm42)
        // );

        // let qSharpData = JordanWignerEncodingData(
        //     nSpinOrbitals, 
        //     HamiltonianTerms, 
        //     inputState,
        //     energyOffset
        // );

        let (nSpinOrbitals, fermionTermData, inputState, energyOffset) = qSharpData!;
        let (nQubits, (rescaleFactor, oracle)) = TrotterStepOracle(qSharpData, trotterStepSize, trotterOrder);
        let statePrep = PrepareTrialState(inputState, _);
        let phaseEstAlgorithm = RobustPhaseEstimation(nBitsPrecision, _, _);
        let estPhase = EstimateEnergy(nQubits, statePrep, oracle, phaseEstAlgorithm);
        let estEnergy = estPhase * rescaleFactor + energyOffset;
        return (estPhase, estEnergy);
    }
}
