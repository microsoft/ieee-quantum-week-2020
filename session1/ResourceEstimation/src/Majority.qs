namespace ResourceEstimation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Synthesis;

    operation ApplyMajorityUsingInts(x1 : Qubit, x2 : Qubit, x3 : Qubit, y : Qubit)
    : Unit is Adj + Ctl {
        for (i in [3, 5, 6, 7]) {
            let ValueControlledX = ControlledOnInt(i, X);
            ValueControlledX([x1, x2, x3], y);
        }
    }

    operation ApplyMajorityUsingCCNOTs(x1 : Qubit, x2 : Qubit, x3 : Qubit, y : Qubit)
    : Unit is Adj + Ctl {
        CCNOT(x1, x2, y);
        CCNOT(x1, x3, y);
        CCNOT(x2, x3, y);
    }

    operation ApplyMajorityUsingTruthTable(x1 : Qubit, x2 : Qubit, x3 : Qubit, y : Qubit)
    : Unit is Adj + Ctl {
        ApplyXControlledOnTruthTable(IntAsBigInt(0b11101000), [x1, x2, x3], y);        
    }

    operation ApplyMajorityUsingCNOTTransformation(x1 : Qubit, x2 : Qubit, x3 : Qubit, y : Qubit)
    : Unit is Adj + Ctl {
        within {
            CNOT(x2, x1);
            CNOT(x2, x3);
        } apply {
            CCNOT(x1, x3, y);
            CNOT(x2, y);
        }
    }
}
